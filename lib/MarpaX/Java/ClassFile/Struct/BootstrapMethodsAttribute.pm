use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::BootstrapMethodsAttribute;
use Moo;

# ABSTRACT: BootstrapMethods_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 BootstrapMethod/;
use Types::Standard qw/ArrayRef/;

has attribute_name_index  => ( is => 'ro', isa => U2 );
has attribute_length      => ( is => 'ro', isa => U4 );
has num_bootstrap_methods => ( is => 'ro', isa => U2 );
has bootstrap_methods     => ( is => 'ro', isa => ArrayRef[BootstrapMethod] );

1;
