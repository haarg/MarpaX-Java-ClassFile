use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::LocalVariableTableAttribute;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: Exceptions_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 LocalVariable/;
use Types::Standard qw/ArrayRef/;

has attribute_name_index        => ( is => 'ro', required => 1, isa => U2 );
has attribute_length            => ( is => 'ro', required => 1, isa => U4 );
has local_variable_table_length => ( is => 'ro', required => 1, isa => U2 );
has local_variable_table        => ( is => 'ro', required => 1, isa => ArrayRef[LocalVariable] );

1;
