use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::LineNumberTableAttribute;
use Moo;

# ABSTRACT: Parsing of a LineNumberTable_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::LineNumberTableAttribute;
require MarpaX::Java::ClassFile::BNF::LineNumberArray;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"                => sub { $_[0]->exhausted },
                        'line_number_table_length$' => sub { $_[0]->inner('LineNumberArray', size => $_[0]->literalU2('line_number_table_length')) }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _LineNumberTable_attribute {
  # my ($self, $attribute_name_index, $attribute_length, $line_number_table_length, $line_number_table) = @_;

  MarpaX::Java::ClassFile::Struct::LineNumberTableAttribute->new(
                                                                 attribute_name_index     => $_[1],
                                                                 attribute_length         => $_[2],
                                                                 line_number_table_length => $_[3],
                                                                 line_number_table        => $_[4]
                                                             )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
event 'line_number_table_length$' = completed line_number_table_length

LineNumberTable_attribute ::= attribute_name_index attribute_length line_number_table_length line_number_table action => _LineNumberTable_attribute
attribute_name_index      ::= U2                                                              action => u2
attribute_length          ::= U4                                                              action => u4
line_number_table_length  ::= U2                                                              action => u2
line_number_table         ::= MANAGED                                                         action => ::first
