package Commetter::Utils;
use base qw/Exporter/;
use strict;
use warnings;
use Commetter;
use Data::Dumper;
use DateTime;
use Encode qw/encode decode/;
use HTTP::Engine;
use HTTP::Engine::Middleware;
use Path::Class;
use Path::Class::Dir;
use Path::Class::File;
use IO::Interface::Simple;
use Config::Pit;
use Net::Twitter;

our @EXPORT = qw/config p path_to ip env now now_c dbi_config
                 model not_found make_nt make_mw make_server_config
                 u8en u8de/;

sub import {
    strict->import;
    warnings->import;
    __PACKAGE__->export_to_level(1, @_);
}

sub config { $Commetter::config }

sub p {
    local $Data::Dumper::Indent = 1;
    local $Data::Dumper::Terse  = 1;
    warn Dumper shift;
    my @c = caller;
    print STDERR "  at $c[1]:$c[2]\n\n";
}

sub setup_home {
    my $caller = caller(0);
    my $dist = $INC{"$caller.pm"};
    $Commetter::config->{home} = dir($dist)->parent->parent->absolute->stringify;
}

sub path_to {
    my @path = @_;
    my $path = Path::Class::Dir->new(config->{home}, @path);
    return $path if -d $path;
    return Path::Class::File->new(config->{home}, @path);
}

sub env { $ENV{COMMETTER_ENV} || 'development' }

sub ip { IO::Interface::Simple->new(shift || 'eth0')->address }
sub setup_ip { config->{server}->{args}->{host} = ip }

my $tz = DateTime::TimeZone->new(name => 'local');
sub now { DateTime->now(time_zone => $tz) }
sub now_c { sub { sprintf "%s %s", now->ymd, now->hms } }

sub dbi_config {
    my $db = config->{db};
    my @items = qw/dsn username password dbi_config/;
    my %r;
    $r{$_} = $db->{$_} || '' for (@items);
    wantarray ? @r{@items} : \%r;
}

sub model { $Commetter::model }

sub u8en { Encode::encode('utf8', shift) }
sub u8de { Encode::decode('utf8', shift) }

sub not_found { +{ template => "not_found", @_, } }

sub make_nt {
    my $key = pit_get('commetter.net');
    my $config_t = { %{config->{twitter}}, %$key };
    Net::Twitter->new($config_t);
}

sub make_mw {
    my $mw = HTTP::Engine::Middleware->new(
        method_class => 'HTTP::Engine::Request',
    );

    my @install = (
        ((env eq 'development') ? (
        'HTTP::Engine::Middleware::ModuleReload',
        'HTTP::Engine::Middleware::Static' => {
            regexp  => qr{^/(robots\.txt|(?:css|js|image)/.+|.+\.html)$},
            docroot => config->{home} . '/root/static',
        },) : ()), 
        'HTTP::Engine::Middleware::HTTPSession' => {
            store => {
                class => 'File',
                args  => { dir => config->{session}->{dir}, }
            },
            state => {
                class => 'Cookie',
                args  => { session_id_name => config->{session}->{name}, },
            }
        }
    );

    $mw->install(@install);
    $mw;
}

sub make_server_config {
    my ($mw, $args) = @_;

    my $server_config = config->{server};
    $server_config->{args}->{port} = $args->{port} if $args->{port};
    $server_config->{request_handler} = $mw->handler(sub {
        my $req = shift;
        Commetter::Web::Handler->handler($req);
    });
    $server_config;
}

1;
