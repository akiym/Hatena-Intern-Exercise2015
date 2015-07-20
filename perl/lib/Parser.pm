package Parser;
use strict;
use warnings;
use Carp ();
use Log;

sub new {
    my ($class, %args) = @_;
    unless (defined $args{filename}) {
        Carp::croak('Missing filename parameter');
    }
    return bless \%args, $class;
}

sub parse {
    my ($self) = @_;
    my @logs;
    open my $fh, '<', $self->{filename} or die $!;
    while (defined(my $line = <$fh>)) {
        chomp $line;
        my %parsed = map { @$_ } grep { $_->[1] ne '-' } map { [split /:/, $_, 2] } split /\t/, $line;
        push @logs, Log->new(%parsed);
    }
    return \@logs;
}

1;
