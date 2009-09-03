package Commetter::Model::Guest;
use base qw/Commetter::Model::Base/;
use self;
use Commetter::Utils;

sub register {
    my ($args) = @args;

    my $guest = model->get(guest => {
        where => [screen_name => $args->{screen_name}],
    });

    if ($guest and $guest = $guest->next) {
        $guest->icon($args->{profile_image_url});
        $guest->access_token($args->{access_token});
        $guest->access_token_secret($args->{access_token_secret});
        $guest->update;
    }
    else {
        model->set(guest => {
            name                => $args->{name},
            icon                => $args->{profile_image_url},
            screen_name         => $args->{screen_name},
            twitter_id          => $args->{id},
            access_token        => $args->{access_token},
            access_token_secret => $args->{access_token_secret},
        });
    }
}

1;
