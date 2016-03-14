use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::ConstantFieldrefInfo;
use MarpaX::Java::ClassFile::Struct::_Base;

# ABSTRACT: CONSTANT_Fieldref_info

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1 U2/;

has tag                 => ( is => 'ro', required => 1, isa => U1 );
has class_index         => ( is => 'ro', required => 1, isa => U2 );
has name_and_type_index => ( is => 'ro', required => 1, isa => U2 );

1;
