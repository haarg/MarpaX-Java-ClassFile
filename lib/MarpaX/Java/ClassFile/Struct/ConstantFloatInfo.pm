use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantFloatInfo;
use Moo;

# ABSTRACT: CONSTANT_Float_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Encodings qw/Bytes/;
use Types::Standard -all;

has tag          => ( is => 'ro', required => 1, isa => U1 );
has bytes        => ( is => 'ro', required => 1, isa => Bytes );
has _value       => ( is => 'ro', required => 1, isa => InstanceOf['Math::BigFloat'] );

1;