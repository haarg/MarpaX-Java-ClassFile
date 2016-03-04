use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Common::InnerGrammar;

# ABSTRACT: Parsing engine role for .class file parsing - inner grammar

# VERSION

# AUTHORITY

use Moo::Role;

use Types::Common::Numeric -all;
use Types::Standard -all;

has size   => (is => 'ro', isa => PositiveOrZeroInt, required => 1);
has nbDone => (is => 'rw', isa => PositiveOrZeroInt, default => sub { 0 });

with qw/MarpaX::Java::ClassFile::Common/;

# ------------------
# Role modifications
# ------------------

around BUILD => sub {
  my ($orig, $self) = @_;

  $self->$orig() if ($self->size)

};

around whoami => sub {
  my ($orig, $self, @args) = @_;

  my $whoami = $self->$orig(@args);
  my $size   = $self->size;
  my $i      = $self->nbDone;

  ++$i if ($i < $size);
  #
  # Append the array indice
  #
  "${whoami}[${i}/${size}]"
};

1;
