use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::RuntimeInvisibleAnnotationsAttribute;
use Moo;

# ABSTRACT: Parsing of a RuntimeInvisibleAnnotations_attribute

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::RuntimeInvisibleAnnotationsAttribute;
require MarpaX::Java::ClassFile::BNF::AnnotationArray;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"       => sub { $_[0]->exhausted },
                        'num_annotations$' => sub { $_[0]->inner('AnnotationArray', size => $_[0]->literalU2('num_annotations')) }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _RuntimeInvisibleAnnotations_attribute {
  # my ($self, $attribute_name_index, $attribute_length, $num_annotations, $annotations) = @_;

  MarpaX::Java::ClassFile::Struct::RuntimeInvisibleAnnotationsAttribute->new(
                                                                             _constant_pool       => $_[0]->constant_pool,
                                                                             attribute_name_index => $_[1],
                                                                             attribute_length     => $_[2],
                                                                             num_annotations      => $_[3],
                                                                             annotations          => $_[4]
                                                                          )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
event 'num_annotations$' = completed num_annotations

RuntimeInvisibleAnnotations_attribute ::= attribute_name_index attribute_length num_annotations annotations action => _RuntimeInvisibleAnnotations_attribute
attribute_name_index   ::= U2                                                                               action => u2
attribute_length       ::= U4                                                                               action => u4
num_annotations        ::= U2                                                                               action => u2
annotations            ::= MANAGED                                                                          action => ::first
