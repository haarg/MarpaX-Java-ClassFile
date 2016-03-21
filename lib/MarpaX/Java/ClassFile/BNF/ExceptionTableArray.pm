use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::BNF::ExceptionTableArray;
use Moo;

# ABSTRACT: Parsing an array of exception_table

# VERSION

# AUTHORITY

use Data::Section -setup;
use MarpaX::Java::ClassFile::Util::BNF qw/:all/;
#
# require because we do not import ANYTHING from these module, just require they are loaded
#
require Marpa::R2;
require MarpaX::Java::ClassFile::Struct::ExceptionTable;

my $_data      = ${ __PACKAGE__->section_data('bnf') };
my $_grammar   = Marpa::R2::Scanless::G->new( { source => \__PACKAGE__->bnf($_data) } );

# --------------------------------------------------
# What role MarpaX::Java::ClassFile::Common requires
# --------------------------------------------------
sub grammar   { $_grammar    }
sub callbacks {
  return {
           "'exhausted"      => sub { $_[0]->exhausted },
          'exception_table$' => sub { $_[0]->inc_nbDone }
         }
}

sub _exception_table {
  # my ($self, $start_pc, $end_pc, $handler_pc, $catch_type) = @_;

  MarpaX::Java::ClassFile::Struct::ExceptionTable->new(
                                                       _constant_pool => $_[0]->constant_pool,
                                                       start_pc       => $_[1],
                                                       end_pc         => $_[2],
                                                       handler_pc     => $_[3],
                                                       catch_type     => $_[4]
                                                      )
}

with qw/MarpaX::Java::ClassFile::Role::Parser::InnerGrammar/;

1;

__DATA__
__[ bnf ]__
:default ::= action => [values]
event 'exception_table$' = completed exception_table

exceptionTableArray ::= exception_table*
exception_table ::= start_pc end_pc handler_pc catch_type action => _exception_table
start_pc        ::= U2                                    action => u2
end_pc          ::= U2                                    action => u2
handler_pc      ::= U2                                    action => u2
catch_type      ::= U2                                    action => u2
