use strict;
use warnings FATAL => 'all';

package MarpaX::Java::ClassFile::Struct::Class;
use MarpaX::Java::ClassFile::Util::AccessFlagsStringification qw/accessFlagsStringificator/;
use MarpaX::Java::ClassFile::Struct::_Base
  -tiny => [qw/_constant_pool inner_class_info_index outer_class_info_index inner_name_index inner_class_access_flags/],
  '""' => [
           [ sub { 'Inner class info#' . $_[0]->inner_class_info_index } => sub { $_[0]->_constant_pool->[$_[0]->inner_class_info_index] } ],
           #
           # outer_class_info_index can be zero
           #
           [ sub { 'Outer class Info#' . $_[0]->outer_class_info_index } => sub { ($_[0]->outer_class_info_index > 0) ? $_[0]->_constant_pool->[$_[0]->outer_class_info_index] : '' } ],
           #
           # inner_name_index can be zero
           #
           [ sub { 'Inner name#' . $_[0]->inner_name_index             } => sub { ($_[0]->inner_name_index > 0) ? $_[0]->_constant_pool->[$_[0]->inner_name_index] : '' } ],
           [ sub { 'Inner class access flags'                          } => sub { $_[0]->accessFlagsStringificator($_[0]->inner_class_access_flags) } ]
          ];

# ABSTRACT: classes

# VERSION

# AUTHORITY

use MarpaX::Java::ClassFile::Struct::_Types qw/U2/;
use Types::Standard qw/ArrayRef/;

has _constant_pool           => ( is => 'rw', required => 1, isa => ArrayRef);
has inner_class_info_index   => ( is => 'ro', required => 1, isa => U2 );
has outer_class_info_index   => ( is => 'ro', required => 1, isa => U2 );
has inner_name_index         => ( is => 'ro', required => 1, isa => U2 );
has inner_class_access_flags => ( is => 'ro', required => 1, isa => U2 );

1;
