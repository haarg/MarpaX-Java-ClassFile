use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ClassFile;
use Moo;

# ABSTRACT: Parsing of a ClassFile

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/bnf/;
use Types::Standard qw/ArrayRef Str/;
use Types::Common::Numeric qw/PositiveOrZeroInt/;
use MarpaX::Java::ClassFile::Struct::_Types qw/ConstantPoolArray/;
use MarpaX::Java::ClassFile::Util::ProductionMode qw/prod_isa/;
use Scalar::Util qw/blessed/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::ClassFile;
require MarpaX::Java::ClassFile::BNF::ConstantPoolArray;
require MarpaX::Java::ClassFile::BNF::InterfacesArray;
require MarpaX::Java::ClassFile::BNF::FieldsArray;
require MarpaX::Java::ClassFile::BNF::MethodsArray;
require MarpaX::Java::ClassFile::BNF::AttributesArray;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
          #
          # Size of constant pool array is constant_pool_count - 1 as per the spec.
          # Implicitely from the spec, indices in constant pool start at 1:
          # - The final action on Constant pool will insert a fake undef entry at position 0
          #
          'constant_pool_count$' => sub {
            $_[0]->constant_pool_count($_[0]->literalU2('constant_pool_count'));
            my $constant_pool = $_[0]->inner('ConstantPoolArray', size => $_[0]->constant_pool_count - 1);
            $_[0]->constant_pool($constant_pool);
            #
            # Make sure all constant pool items that require a cross-reference to this array
            # have the correct value
            #
            foreach ($constant_pool->elements) {
              $_->_constant_pool($constant_pool) if (blessed($_) && ($_->can('_constant_pool')))
            }
          },
          'interfaces_count$'    => sub { $_[0]->inner('InterfacesArray', size => $_[0]->literalU2('interfaces_count')) },
          'fields_count$'        => sub { $_[0]->inner('FieldsArray',     size => $_[0]->literalU2('fields_count')) },
          'methods_count$'       => sub { $_[0]->inner('MethodsArray',    size => $_[0]->literalU2('methods_count')) },
          'attributes_count$'    => sub { $_[0]->inner('AttributesArray', size => $_[0]->literalU2('attributes_count')) }
         }
}

# ---------------
# Grammar actions
# ---------------
sub _ClassFile {
  my ($self,
      $magic,
      $minor_version,
      $major_version,
      $constant_pool_count,
      $constant_pool,
      $access_flags,
      $this_class,
      $super_class,
      $interfaces_count,
      $interfaces,
      $fields_count,
      $fields,
      $methods_count,
      $methods,
      $attributes_count,
      $attributes) = @_;

  MarpaX::Java::ClassFile::Struct::ClassFile->new(
                                                  magic               => $magic,
                                                  minor_version       => $minor_version,
                                                  major_version       => $major_version,
                                                  constant_pool_count => $constant_pool_count,
                                                  constant_pool       => $constant_pool,
                                                  access_flags        => $access_flags,
                                                  this_class          => $this_class,
                                                  super_class         => $super_class,
                                                  interfaces_count    => $interfaces_count,
                                                  interfaces          => $interfaces,
                                                  fields_count        => $fields_count,
                                                  fields              => $fields,
                                                  methods_count       => $methods_count,
                                                  methods             => $methods,
                                                  attributes_count    => $attributes_count,
                                                  attributes          => $attributes
                                                 )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

#
# We want to say that exhaustion is definitely fatal
#
has '+exhaustion' => (default => sub { 'fatal' });
#
# We want to take control over constant_pool count and content in this class (and only here btw)
#
has '+constant_pool_count' => ( is => 'rw' );
has '+constant_pool'       => ( is => 'rw' );

1;

__DATA__
__[ bnf ]__
:default ::= action => ::first
event 'constant_pool_count$' = completed constant_pool_count
event 'interfaces_count$'    = completed interfaces_count
event 'fields_count$'        = completed fields_count
event 'methods_count$'       = completed methods_count
event 'attributes_count$'    = completed attributes_count
ClassFile ::=
             magic
             minor_version
             major_version
             constant_pool_count
             constant_pool
             access_flags
             this_class
             super_class
             interfaces_count
             interfaces
             fields_count
             fields
             methods_count
             methods
             attributes_count
             attributes
  action => _ClassFile

magic                ::= U4          action => u4
minor_version        ::= U2          action => u2
major_version        ::= U2          action => u2
constant_pool_count  ::= U2          action => u2
constant_pool        ::= MANAGED     action => ::first
access_flags         ::= U2          action => u2
this_class           ::= U2          action => u2
super_class          ::= U2          action => u2
interfaces_count     ::= U2          action => u2
interfaces           ::= MANAGED     action => ::first
fields_count         ::= U2          action => u2
fields               ::= MANAGED     action => ::first
methods_count        ::= U2          action => u2
methods              ::= MANAGED     action => ::first
attributes_count     ::= U2          action => u2
attributes           ::= MANAGED     action => ::first
