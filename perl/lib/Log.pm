package Log;
use strict;
use warnings;
use Time::Piece ();
use URI;

sub new {
    my ($class, %args) = @_;
    my $self = bless \%args, $class;
    $self->_parse_http_header();
    return $self;
}

sub protocol { $_[0]->{_protocol} }

sub method { $_[0]->{_method} }

sub path { $_[0]->{_path} }

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

sub _parse_http_header {
    my ($self) = @_;
    my ($method, $path, $protocol) = split /\s+/, $self->{req};
    $self->{_method} = $method;
    $self->{_path} = $path;
    $self->{_protocol} = $protocol;
}

1;
