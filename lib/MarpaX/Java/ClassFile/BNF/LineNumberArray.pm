use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::LineNumberArray;
use Moo;

# ABSTRACT: Parsing an array of class

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::LineNumber;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted"  => sub { $_[0]->exhausted },
          'line_number$' => sub { $_[0]->inc_nbDone }
         }
}

sub _lineNumber {
  # my ($self, $start_pc, $line_number) = @_;

  MarpaX::Java::ClassFile::Struct::LineNumber->new(
                                                   start_pc    => $_[1],
                                                   line_number => $_[2]
                                                  )
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
event 'line_number$' = completed line_number

lineNumberArray ::= lineNumber*
lineNumber      ::= start_pc line_number action => _lineNumber
start_pc        ::= U2                   action => u2
line_number     ::= U2                   action => u2
