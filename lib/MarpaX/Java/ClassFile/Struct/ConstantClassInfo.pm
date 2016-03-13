use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantClassInfo;
use Moo;

# ABSTRACT: CONSTANT_Class_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;

has tag        => ( is => 'ro', required => 1, isa => U1 );
has name_index => ( is => 'ro', required => 1, isa => U2 );

1;
