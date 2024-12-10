package DiskFile;

use parent 'DiskItem';  # Declare inheritance

sub new {
    my ($class, $size, $id) = @_;
    my $self = $class->SUPER::new($size);  # Call the parent constructor
    $self->{id} = $id;
    bless $self, $class;
    return $self;
}

sub to_array {
    my $self = shift;
    return ($self->{id}) x $self->{size};  # Repeat $id $size times as a list
}

1;  # Return true
