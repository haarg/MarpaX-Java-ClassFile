use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::RuntimeVisibleParameterAnnotationsAttribute;
use Moo;

# ABSTRACT: RuntimeVisibleParameterAnnotations_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has attribute_name_index  => ( is => 'ro', isa => U2 );
has attribute_length      => ( is => 'ro', isa => U4 );
has num_parameters        => ( is => 'ro', isa => U1 );
has parameter_annotations => ( is => 'ro', isa => ArrayRef[ParameterAnnotation] );

1;