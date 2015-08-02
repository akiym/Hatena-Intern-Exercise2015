use strict;
use warnings;
use Term::ReadKey ();
use Parser;

my $parser = Parser->new(filename => '../sample_data/large_log.ltsv');
my $logs = $parser->parse();

my %result;
for my $log (@$logs) {
    $result{$log->path}->{$log->{status}}++;
}

print_diagram(%result);

sub print_diagram {
    my (%result) = @_;
    for my $path (sort keys %result) {
        print "$path\n";

        my %r = %{$result{$path}};
        my ($max_column_len) = sort { $b <=> $a } map length, keys %r;
        my ($max_scale) = sort { $b <=> $a } values %r;
        $max_scale = $max_scale < 50 ? 50 : $max_scale;
        my ($scale, $scale_text) = scale($max_scale, $max_column_len + length($max_scale));

        print '-' x $max_column_len . ':';
        print $scale_text;
        print "\n";

        for my $key (sort keys %r) {
            print ljust($key, $max_column_len) . ':';
            my $n = int($r{$key} * $scale);
            print '=' x ($n - 1);
            print '*';
            print $r{$key};
            print "\n";
        }
        print "\n";
    }
}

sub scale {
    my ($max_scale, $max_column_len) = @_;

    my ($wchar, undef, undef, undef) = Term::ReadKey::GetTerminalSize();
    my $scale_len = int($wchar) - $max_column_len - 1;
    $scale_len = $scale_len - $scale_len % 10;
    my $scale = $scale_len / $max_scale;

    my ($interval) = map { $_->[1] } sort { $b->[0] <=> $a->[0] } interval($max_scale);
    my $m = int($scale * $interval);
    my $scale_text = ljust('', $m);
    for (my $i = $interval; $i < $max_scale; $i += $interval) {
        my $s = ljust($i, $m);
        if (length($scale_text) + length($s) <= $scale_len) {
            $scale_text .= $s;
        } else {
            last;
        }
    }

    return ($scale, $scale_text);
}

sub interval {
    my ($max_scale) = @_;
    my @interval;
    my $m = 10;
    my $n = $max_scale;
    $n = int($n / 10);
    while ($n > 0) {
        $n = int($n / 10);
        push @interval, [int($max_scale / $m), $m];
        $m *= 10;
    }
    return @interval;
}

sub ljust {
    my ($s, $width, $fill) = @_;
    $fill //= ' ';

    my $n = $width - length $s;
    if ($n > 0) {
        return $s . $fill x $n;
    } else {
        return $s;
    }
}
