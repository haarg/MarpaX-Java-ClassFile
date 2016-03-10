use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ConstantMethodHandleInfo;
use Moo;

# ABSTRACT: Parsing of a CONSTANT_MethodHandle_info

# VERSION

# AUTHORITY

use Data::Section -setup;
use Marpa::R2;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
use MarpaX::Java::ClassFile::Struct::ConstantMethodHandleInfo;
use Types::Standard -all;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return { "'exhausted" => sub { $_[0]->exhausted } } }

# ---------------
# Grammar actions
# ---------------
sub _ConstantMethodHandleInfo {
  # my ($self, $tag, $reference_kind, $reference_index) = @_;

  MarpaX::Java::ClassFile::Struct::ConstantMethodHandleInfo->new(
                                                                 tag             => $_[1],
                                                                 reference_kind  => $_[2],
                                                                 reference_index => $_[3]
                                                             )
}

with qw/MarpaX::Java::ClassFile::Role::Parser/;

has '+exhaustion' => (is => 'ro',  isa => Str, default => sub { 'event' });

1;

__DATA__
__[ bnf ]__
ConstantMethodHandleInfo ::= tag reference_kind reference_index action => _ConstantMethodHandleInfo
tag                      ::= [\x{0f}]                           action => u1
reference_kind           ::= U1                                 action => u1
reference_index          ::= U2                                 action => u2