use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::BootstrapMethodsAttribute;
use MarpaX::Java::ClassFile::Util::ArrayStringification qw/arrayStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  '""' => [
           [ sub { '#' . $_[0]->attribute_name_index } => sub { $_[0]->_constant_pool->[$_[0]->attribute_name_index] } ],
           [ sub { 'Bootstrap Methods Count'         } => sub { $_[0]->num_bootstrap_methods } ],
           [ sub { 'Bootstrap Methods      '         } => sub { $_[0]->arrayStringificator($_[0]->bootstrap_methods) } ]
          ];

# ABSTRACT: BootstrapMethods_attribute

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2 U4 BootstrapMethod/;
use Types::Standard qw/ArrayRef/;

has _constant_pool        => ( is => 'rw', required => 1, isa => ArrayRef);
has attribute_name_index  => ( is => 'ro', required => 1, isa => U2 );
has attribute_length      => ( is => 'ro', required => 1, isa => U4 );
has num_bootstrap_methods => ( is => 'ro', required => 1, isa => U2 );
has bootstrap_methods     => ( is => 'ro', required => 1, isa => ArrayRef[BootstrapMethod] );

1;
