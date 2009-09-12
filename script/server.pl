#!/usr/bin/perl
use lib qw/lib/;
use Getopt::Long;
use Commetter;
use Commetter::AppLoader;
use Commetter::Utils;
use Commetter::Web::Dispatcher;
use Commetter::Web::Handler;

Commetter->setup;

my %args;
GetOptions(\%args, qw/port=i trace/);

my $mw = make_mw;
my $server_config = make_server_config($mw, \%args);

if ($args{trace}) {
    no warnings 'redefine';
    *Data::Model::Driver::DBI::start_query = sub {
        my($c, $sql, $binds) = @_;
        p [$sql, join ",", @$binds];
    };
}

HTTP::Engine->new({ interface => $server_config })->run;
