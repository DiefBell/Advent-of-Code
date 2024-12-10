package EmptySpace;

use parent 'DiskItem';  # Declare inheritance

sub new {
    my ($class, $size) = @_;
    my $self = $class->SUPER::new($size);  # Call the parent constructor
    bless $self, $class;
    return $self;
}

sub to_array {
    my $self = shift;
    return (undef) x $self->{size};  # Repeat undef $size times as a list
}

1;  # Return true
