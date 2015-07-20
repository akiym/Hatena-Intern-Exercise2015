package LogCounter;
use strict;
use warnings;

sub new {
    my ($class, $logs) = @_;
    return bless { logs => $logs }, $class;
}

sub group_by_user {
    my ($self) = @_;
    my %users;
    for my $log (@{$self->{logs}}) {
        my $user = $log->{user} // 'guest';
        push @{$users{$user}}, \%$log;
    }
    return \%users;
}

sub count_error {
    my ($self) = @_;
    my $count = 0;
    for my $log (@{$self->{logs}}) {
        if (exists $log->{status} && $log->{status} =~ /^5/) {
            $count++;
        }
    }
    return $count;
}

1;
