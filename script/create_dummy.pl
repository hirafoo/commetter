#!/usr/bin/perl
use lib qw/lib/;
use Data::Model::Driver::DBI;
use Commetter;
use Commetter::Utils;
use Commetter::Model::Tables;
use String::Random;

Commetter->setup;

my $s = String::Random->new;
my ($r, $t);
sub ri { int(rand(shift) + 1) }
sub rs { $s->randregex("[a-zA-Z0-9]{$_[0]}") }

for my $i (1..25) {
    $r = ri(15);
    model->set(guest => {
        name       => rs($r),
        twitter_id => $r,
    });
    $r = ri(15);
    model->set(site => {
        url  => 'http://example.com/' . $r,
        name => rs($r),
    });
}
for my $i (1..250) {
    $r = ri(10);
    $t = ri(90);
    model->set(comment => {
        site_id    => ri(25),
        guest_id   => ri(25),
        guest_name => rs($r),
        #comment    => 'http://example.com/' . rs($r) . ' ' . rs($t),
        comment    => rs($t),
    });
}
