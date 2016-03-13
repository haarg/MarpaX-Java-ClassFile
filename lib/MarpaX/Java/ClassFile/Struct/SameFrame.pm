use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::SameFrame;
use Moo;

# ABSTRACT: same_frame

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U1/;

has frame_type => ( is => 'ro', required => 1, isa => U1 );

1;
