#!/usr/bin/perl
 
use Modern::Perl; 
use AnyEvent;
use AnyEvent::HTTP;
use Data::Dumper;
use Time::HiRes qw( gettimeofday tv_interval );

use utf8;
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

$| = 1; print "Вставьте список url: ";

my $cv = AnyEvent->condvar;

my @stat;

sub statistic_callback {
    say "\nСтатистика:";

    foreach my $item (@stat) {
        say sprintf "%s -> %.4f ms", $item->{url}, $item->{duration};
    }

    exit 0;
}

sub stdin_callback {
    chomp ( my $data = <STDIN> );

    my @urls = split ",", $data;

    foreach my $url (@urls) {
        my $start_time = AnyEvent->time;
        
        http_request 
            GET => $url, 
            headers => {
                'User-Agent' => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2)'
            },
            timeout => 5, 
            sub {
                my ($body, $hdr) = @_;
                say "\n\n";

                my $completed = AnyEvent->time;
                
                push @stat, {
                    url => $url,
                    duration => $completed - $start_time,
                    status   => $hdr->{Status},
                };

                if ($hdr->{Status} =~ /^2/) {
                    say $url." -> OK";
                    say $body;
                } 
                else {
                    say $url." -> Ошибка: $hdr->{Status} $hdr->{Reason}";
                }
            };
    }
}

my $idle;

my $io = AnyEvent->io (
    fh   => \*STDIN,
    poll => 'r',
    cb   => sub { 
        $idle ||= AnyEvent->idle (
            cb => sub { 
                unless ($AnyEvent::HTTP::ACTIVE) {
                    undef $idle; 
                    statistic_callback();
                }
            },
        );

        stdin_callback();
    }
);

$cv->recv;

undef $io;
