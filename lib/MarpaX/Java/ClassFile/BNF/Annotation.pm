use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::Annotation;
use Moo;

# ABSTRACT: Parsing of an annotation

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/bnf/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::Annotation;
require MarpaX::Java::ClassFile::BNF::ElementValuePairArray;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted"              => sub { $_[0]->exhausted },
          'num_element_value_pairs$' => sub { $_[0]->inner('ElementValuePairArray', size => $_[0]->literalU2('num_element_value_pairs')) }
         }
}

sub _annotation {
  # my ($self, $type_index, $num_element_value_pairs, $element_value_pairs) = @_;

  MarpaX::Java::ClassFile::Struct::Annotation->new(
                                                   _constant_pool          => $_[0]->constant_pool,
                                                   type_index              => $_[1],
                                                   num_element_value_pairs => $_[2],
                                                   element_value_pairs     => $_[3]
                                                  )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
event 'num_element_value_pairs$' = completed num_element_value_pairs

annotation ::= type_index num_element_value_pairs element_value_pairs action => _annotation
type_index              ::= U2           action => u2
num_element_value_pairs ::= U2           action => u2
element_value_pairs     ::= MANAGED      action => ::first
