package Commetter::ModPerl;
use base qw/HTTP::Engine::Interface::ModPerl/;
use Commetter;
use Commetter::AppLoader;
use Commetter::Utils;
use Commetter::Web::Dispatcher;
use Commetter::Web::Handler;

Commetter->setup;
my $mw = make_mw;
my $server_config = make_server_config($mw);

sub create_engine {
    my($class, $r, $context_key) = @_;
    HTTP::Engine->new({ interface => $server_config });
}

1;
