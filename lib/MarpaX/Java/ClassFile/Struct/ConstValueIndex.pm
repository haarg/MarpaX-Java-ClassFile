use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstValueIndex;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: constant value

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;

has const_value_index => ( is => 'ro', required => 1, isa => U2 );

1;
