use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::FloatVariableInfo;
use Moo;

# ABSTRACT: Float_variable_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;

has tag => ( is => 'ro', required => 1, isa => U1 );

1;
