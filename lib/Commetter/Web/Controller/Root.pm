package Commetter::Web::Controller::Root;
use self;
use Commetter::Utils;

sub index { 
    {
        top          => 'current',
        new_sites    => (Commetter::Model::Site->list({limit => 5, order => {id => 'desc'}}))[0],
        new_comments => (Commetter::Model::Comment->list({limit => 5, order => {id => 'desc'}}))[0],
    }
}

sub authors { { authors => 'current', page_title => '作者'} }

sub login2twitter {
    my ($req) = @args;

    my $nt = make_nt;
    my $url = $nt->get_authorization_url(callback => config->{twitter}->{callback});
    $req->session->set(
        oauth => {
            token        => $nt->request_token,
            token_secret => $nt->request_token_secret,
        },
    );

    { redirect => $url }
}

sub callback {
    my ($req, $params) = @args;
    my $verifier = $params->{oauth_verifier} or return not_found;

    my $nt = make_nt;
    $nt->request_token($req->session->get('oauth')->{token});
    $nt->request_token_secret($req->session->get('oauth')->{token_secret});

    my ($access_token, $access_token_secret) = $nt->request_access_token(verifier => $verifier);
    $nt->access_token($access_token);
    $nt->access_token_secret($access_token_secret);

    my $result = $nt->verify_credentials;
       $result->{access_token} = $access_token;
       $result->{access_token_secret} = $access_token_secret;

    $req->session->set(
        twitter => {
            icon  => $result->{profile_image_url},
            name  => u8en($result->{name}),
            screen_name  => $result->{screen_name},
            access_token => $access_token,
            access_token_secret => $access_token_secret,
        },
    );

    Commetter::Model::Guest->register($result);
   
    { redirect => '/' }
}

sub logout {
    my ($req) = @args;
    $req->session->remove('twitter');
    $req->session->store->delete($req->session->session_id);
}

1;
