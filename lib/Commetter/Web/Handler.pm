package Commetter::Web::Handler;
use Commetter::Utils;

sub handler {
    my ($self, $req) = @_;
    
    my $rule       = Commetter::Web::Dispatcher->match($req);
    my $params = { %{$rule->{args}}, %{$req->params} };
    my $controller = $rule->{controller}
                   ? "Commetter::Web::Controller::$rule->{controller}"
                   : "Commetter::Web::Controller::Root";
    my $meth       = $rule->{action} || '';
    my $post_meth  = "post_$meth";

    my $res;
    if ($controller->can($meth)) {
        $controller->auto($req, $params) if $controller->can('auto');

        if ($req->method =~ /POST/i) {
            $res = $controller->$post_meth($req, $params);
        }
        else {
            $res = $controller->$meth($req, $params);
        }
        $controller = ($rule->{controller} eq 'Root') ? '' : lc "$rule->{controller}/";
    }
    else {
        $meth = 'not_found';
        $controller = ''; 
    }
    $res = ref $res eq 'HASH' ? $res : {};
    $res->{session}->{$_} = $req->session->get($_) for ($req->session->keys);

    if (my $url = $res->{redirect}) {
        my $response = HTTP::Engine::Response->new;
        $response->status(302);
        $response->header(Location => $url);
        return $response;
    }

    $res->{uri} ||= $req->uri;
    $res->{uri} =~ s/\?.+//;
    $res->{params} = $params;

    my $v = Commetter::Web::View::Template->new(config->{'View::Template'});
    my $template = ($res->{template} and ($res->{template} eq 'not_found'))
                   ? 'not_found'
                 : $res->{template}
                   ? "$controller$res->{template}"
                 : "$controller$meth";
    $v->process("$template.tt", $res, \my $body);
    return HTTP::Engine::Response->new(body => $body);
}

1;
