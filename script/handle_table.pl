#!/usr/bin/perl
use lib qw/lib/;
use Data::Model::Driver::DBI;
use Commetter;
use Commetter::Utils;
use Commetter::Model::Tables;
use Getopt::Long;

@ARGV or die "usage: ./script/hendle_table.pl [-create|-delete|-reset]\n";
my %args;
GetOptions(\%args, qw/create delete reset/);

Commetter->setup;

my ($dsn, $username, $password) = dbi_config;
my $driver = Data::Model::Driver::DBI->new(%{dbi_config()});
my $tables = Commetter::Model::Tables->new;
$tables->set_base_driver($driver);

my $dbh = DBI->connect($dsn, $username, $password, {RaiseError => 1, PrintError => 0});

if ($args{delete} or $args{reset}) {
    for my $target ($tables->schema_names) {
        my $sql = "drop table $target";
        print "$sql\n";
        $dbh->do($sql);
    } 
}
if ($args{create} or $args{reset}) {
    for my $target ($tables->schema_names) {
        for my $sql ($tables->as_sqls($target)) {
            print "$sql\n";
            $dbh->do($sql);
        }
    }
}

$dbh->disconnect;
