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
GetOptions(\%args, 'port=i',);

my $mw = make_mw;
my $server_config = make_server_config($mw, \%args);

HTTP::Engine->new({ interface => $server_config })->run;
