#!/usr/bin/perl
use lib qw/lib/;
use Data::Model::Driver::DBI;
use Commetter;
use Commetter::Utils;
use Commetter::Model::Tables;
local $Data::Dumper::Indent = 1;
local $Data::Dumper::Terse  = 1;
no strict;

Commetter->setup;

while (1) {
    print '$ ';
    my $in = <STDIN>;
    print Data::Dumper::Dumper eval "$in";
}
