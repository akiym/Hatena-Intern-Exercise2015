package Log;
use strict;
use warnings;
use Time::Piece ();
use URI;

sub new {
    my ($class, %args) = @_;
    my $self = bless \%args, $class;
    return $self;
}

sub protocol {
    my ($self) = @_;
    return (split /\s+/, $self->{req}, 3)[2];
}

sub method {
    my ($self) = @_;
    return (split /\s+/, $self->{req}, 3)[0];
}

sub path {
    my ($self) = @_;
    return (split /\s+/, $self->{req}, 3)[1];
}

sub uri {
    my ($self) = @_;
    my $uri = URI->new($self->path);
    $uri->scheme('http');
    $uri->host($self->{host});
    return $uri->as_string;
}

sub time {
    my ($self) = @_;
    my $t = Time::Piece->gmtime($self->{epoch});
    return $t->datetime;
}

sub to_hash {
    my ($self) = @_;
    my %res = (
        time   => $self->time,
        uri    => $self->uri,
        method => $self->method,
    );
    for my $key (qw/status size user referer/) {
        if (exists $self->{$key}) {
            $res{$key} = $self->{$key};
        }
    }
    return \%res;
}

1;
