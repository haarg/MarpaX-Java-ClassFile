use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::CatchTarget;
use Moo;

# ABSTRACT: Parsing of a supertype_target

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::CatchTarget;

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
sub _CatchTarget {
  # my ($self, $exception_table_index) = @_;

  MarpaX::Java::ClassFile::Struct::CatchTarget->new(
                                                    exception_table_index => $_[1]
                                                   )
}

with 'MarpaX::Java::ClassFile::Role::Parser';

1;

__DATA__
__[ bnf ]__
catchTarget           ::= exception_table_index action => _CatchTarget
exception_table_index ::= U2                    action => u2
