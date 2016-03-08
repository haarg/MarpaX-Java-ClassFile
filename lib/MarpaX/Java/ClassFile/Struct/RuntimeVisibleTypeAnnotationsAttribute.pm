use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::RuntimeVisibleTypeAnnotationsAttribute;
use Moo;

# ABSTRACT: RuntimeVisibleTypeAnnotations_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types -all;
use Types::Standard -all;

has attribute_name_index  => ( is => 'ro', isa => U2 );
has attribute_length      => ( is => 'ro', isa => U4 );
has num_annotations       => ( is => 'ro', isa => U1 );
has annotations           => ( is => 'ro', isa => ArrayRef[TypeAnnotation] );

1;
