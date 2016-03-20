use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::TypePath;
use Moo;

# ABSTRACT: Parsing of a type_path

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::TypePath;
require MarpaX::Java::ClassFile::BNF::PathArray;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------------
# What role MarpaX::Java::ClassFile::Role::Parser requires
# --------------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks { return {
                        "'exhausted"   => sub { $_[0]->exhausted },
                        'path_length$' => sub {
                          my $path_length = $_[0]->literalU1('path_length');
                          $_[0]->inner('PathArray', size => $path_length)
                        }
                       }
              }

# ---------------
# Grammar actions
# ---------------
sub _typePath {
  # my ($self, $path_length, $path) = @_;

  MarpaX::Java::ClassFile::Struct::TypePath->new(
                                                 path_length => $_[1],
                                                 path        => $_[2]
                                                )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
event 'path_length$' = completed path_length
typePath    ::= path_length path action => _typePath
path_length ::= U1               action => u1
path        ::= MANAGED          action => ::first
