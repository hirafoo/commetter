package Commetter::AppLoader;
use Commetter::Utils;
use Module::Pluggable::Fast
    name    => 'components',
    require => 1,
    search  => [qw/Commetter::Web::Controller Commetter::Model Commetter::Web::View/];

sub import {
    for my $p (__PACKAGE__->components) {
        next if ((split /::/, $p)[-1] =~ /^[a-z]+$/);
        $p->use;
    }
}

1;
