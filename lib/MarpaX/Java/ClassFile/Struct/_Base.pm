use strict;
use warnings FATAL => 'all';

#
# MarpaX::Java::ClassFile is doing a LOT of new().
# In development/author phases it is ok to do type checkings,
# but in production mode, this is too expensive, so we go
# back to the old style. In addition, I want objects to
# "look like" a C structure and ALWAYS READ-ONLY.
#
# This module, when running in production mode, creates
# an object that, when inspected via dumper modules, will
# truely look like an array with read-only accessors.
#
# We se a trick specific to our implementation: SCALAR references
# never exist in input to new(). We fake a SCALAR reference when needed,
# just to have something pretty in dumper modules.
#

package MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: Base class for all structure - optimized to a very basic array-based object in production mode

# VERSION

# AUTHORITY

use Carp qw/croak/;
use Import::Into;
use Class::Method::Modifiers qw/install_modifier/;
use Scalar::Util qw/reftype blessed/;
require Moo;
require Class::XSAccessor;

my %_HAS_TRACKED = ();
my @_GETTER = ();

sub import {
  my ($class, %args) = @_;

  my $target = caller;

  if ($ENV{AUTHOR_TESTING}) {
    #
    # Import Moo into caller
    #
    Moo->import::into($target)
  } else {
    #
    # In tiny mode, we inject Class::XSAccessor, based on the same logic than Object::Tiny::XS
    #
    if ($args{-tiny} || $args{-tiny_rw}) {
      #
      # Caller has to make sure -tiny => [qw/.../] and -tiny_rw => [qw/.../] and
      #
      # Almost the same thingy as is Object::Tiny::XS
      # but using eventually accessors
      #
      $args{-tiny}    //= [];
      $args{-tiny_rw} //= [];
      #
      # Okay, we /know/ that members starting with a '_' are internal and should be
      # read-write
      #
      my @forced_tiny_rw = ();
      my @ok_tiny_ro = ();
      foreach (@{$args{-tiny}}) {
        if (/^_/) {
          push(@forced_tiny_rw, $_)
        } else {
          push(@ok_tiny_ro, $_)
        }
      }
      $args{-tiny} = \@ok_tiny_ro;
      foreach my $forced_rw (@forced_tiny_rw) {
        push(@{$args{-tiny_rw}}, $forced_rw) unless (grep { $_ eq $forced_rw } @{$args{-tiny_rw}})
      }

      my $innerGettersAsString = join(", ",
                                      map { "'$_' => '$_'" }
                                      grep { defined and ! ref and /^[^\W\d]\w*$/s }
                                      @{$args{-tiny}}
                                     );
      my $innerAccessorsAsString = join(", ",
                                        map { "'$_' => '$_'" }
                                        grep { defined and ! ref and /^[^\W\d]\w*$/s }
                                        @{$args{-tiny_rw}}
                                       );
      no strict 'refs';
      my $hashRefGetters   = eval " { $innerGettersAsString } "   || croak $@;
      my $hashRefAccessors = eval " { $innerAccessorsAsString } " || croak $@;
      Class::XSAccessor->import::into($target,
                                      constructor => 'new',
                                      getters => $hashRefGetters,
                                      accessors => $hashRefAccessors);
      #
      # 'has' is then dummy routine
      #
      install_modifier($target, 'fresh', has => sub { })
    } else {
      #
      # Our version of 'has'. We support only that.
      #
      install_modifier($target, 'fresh', has => sub { _has($target, @_) } );
      #
      # And our version of 'new'.
      #
      install_modifier($target, 'fresh', new => sub { _new($target, @_) } )
    }
  }
  #
  # We provide a default stringification which always obey to the following:
  #
  # Any object always expand to:
  #
  # NAME [
  #   DESCRIPTION
  # ]
  #
  # NAME        default is the last blessed name component. Can be overwriten with $args{name}.
  # DESCRIPTION default is the stringified list of members in the following format:
  #
  # WHAT [",\n" WHAT [",\n" WHAT]]
  #
  # The list of members is always empty. Can be overwiten with $arg{'""'} = [LIST_OF_MEMBERS_TO_STRINGIFY].
  #
  # LIST_OF_MEMBERS_TO_STRINGIFY impacts WHAT:
  # - an arrayref [ x     ]  Stringified as "$self->x". x must be a CODE reference.
  # - an arrayref [ x,  y ]  Stringified as "$self->x => $self->y". x and y must be CODE references.
  #
  # Any output is always automatically indented by adding two spaces '  ' to any stringified members if there
  # is more than once member, or left on a single line if there at maximum one member.
  # Indent can be overwriten with $arg{indent}
  #
  # Please note that there is type-checking on %args values.
  #
  my $name   = $args{name}   // (split(/::/, $target))[-1];
  my $list   = $args{'""'}   // [];
  my $indent = $args{indent} // '  ';

  my $stub = sub {
    #
    # There is no way to pass private arguments in the '""' overload
    # this is why we use this localized variable
    #
    my $currentLevel = $MarpaX::Java::ClassFile::Struct::STRINGIFICATION_LEVEL // 0;
    #
    # Current recursivity level represent a forced indentation
    # when we deply a multiline output
    #
    my $forceIndent = $indent x $currentLevel;
    my $localIndent = $#{$list} ? $forceIndent . $indent : '';
    #
    # We have to localize again, in case stringification happens
    # implicitely INSIDE the callbacks, not explicitely
    #
    local $MarpaX::Java::ClassFile::Struct::STRINGIFICATION_LEVEL = ++$currentLevel;
    #
    # For pretty printing, align the 'x'
    #
    my (@x, @y);
    my $xMaxSize = 0;
    foreach (@{$list}) {
      my ($x, $y) = @{$_};
      push(@x, $_[0]->$x);
      my $lengthX = length($x[-1]);
      $xMaxSize = $lengthX if ($lengthX > $xMaxSize);
      push(@y, $y ? $_[0]->$y : undef)
    }
    my $iDescription = 0;
    $xMaxSize = -$xMaxSize;   # Left aligned x => y
    my @description = map {
      my ($x, $y) = @{$list->[$_]};
      my $xDescription = sprintf('%*s', $xMaxSize, $x[$_]);
      $localIndent . ($y ? join(' => ', $xDescription, $y[$_]) : $x[$_])
    } (0..$#x);
    my $description = join(",\n", @description);
    #
    # More than one item ? Force newline.
    #
    ($#{$list} > 0) ? "${name} [\n${description}\n$forceIndent]" : "${name} [${description}]"
  };
  #
  # Inject overload
  #
  overload->import::into($target, '""' => $stub)
}

sub _has {
  my $target = shift;
  my $name = shift;
  my @proto = ((reftype($name) //'') eq 'ARRAY') ? @{$name} : $name;
  #
  # No check, will carp naturally if this does not expand to a hash
  #
  my %spec = @_;
  #
  # Keep track of members as the 'has' appears
  #
  my $has_tracked = $_HAS_TRACKED{$target} //= {};
  foreach my $proto (@proto) {
    next if (exists($has_tracked->{$proto}));
    #
    # Member not yet registered
    #
    my $proto_indice = scalar(keys %{$has_tracked});
    $has_tracked->{$proto} = $proto_indice;
    #
    # We do NO CHECK whatever on 'is', 'isa', etc...
    # Everything is assumed to be a mutator eventually initalized at new() time.
    # There is NO type checking - full point.
    #
    # Oh, our new() ensures everything is a reference, so reftype() always return a non-null value.
    #
    $_GETTER[$proto_indice] //= eval "sub { \$_[0]->[$proto_indice] = \$_[1] if (\$#_); my \$value = \$_[0]->[$proto_indice]; (Scalar::Util::reftype(\$value) eq 'SCALAR') ? \${\$value} : \$value }" || croak $@;
    install_modifier($target, 'fresh', $proto => $_GETTER[$proto_indice])
  }
}

sub _new {
  my ($target, $class, %args) = @_;

  my $has_tracked = $_HAS_TRACKED{$target};
  my @array = ();
  foreach my $proto (keys %{$has_tracked}) {
    my $value = $args{$proto};
    my $indice = $has_tracked->{$proto};
    #
    # NO type checking nor safety checking
    #
    if (blessed($value)) {
      $array[$indice] = $args{$proto}
    } else {
      #
      # scalars are explicitely stored as a reference (i.e. ref() will return 'SCALAR'
      #
      if (ref($value)) {
        $array[$indice] = bless($value, $proto)
      } else {
        $array[$indice] = bless(\$value, $proto)
      }
    }
  }
  #
  # In conclusion...: reftype() will never return a null value
  #
  bless(\@array, $class)
}

1;
