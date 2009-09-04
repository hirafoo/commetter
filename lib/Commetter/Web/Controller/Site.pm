package Commetter::Web::Controller::Site;
use self;
use Commetter::Utils;

sub index { not_found }

sub list {
    my ($req, $params) = @args;
    $params->{order} = { id => 'desc', };
    my ($result, $pager) = Commetter::Model::Site->list($params);
    { list  => 'current', pager => $pager, sites => $result, page_title => 'サイト一覧', }
}

sub comment {
    my ($req, $params) = @args;
    my $site = Commetter::Model::Site->find_by(id => $params->{id}) or return not_found;
    my ($comments, $pager) = Commetter::Model::Comment->list({site_id => $site->id, page => $params->{page}});
    { list  => 'current', site => $site, comments => $comments, pager => $pager, page_title => 'コメント', };
}
sub post_comment {
    my ($req, $params) = @args;
    my $tw = $req->session->get('twitter') or return { redirect => "/login2twitter" };
    my $site = Commetter::Model::Site->find_by(id => $params->{id}) or return not_found;
    my $guest = Commetter::Model::Guest->find_by(screen_name => $tw->{screen_name})
        or return { redirect => '/login2twitter' };

    my ($comments, $pager) = Commetter::Model::Comment->list({site_id => $site->id, page => $params->{page}});
    my $comment = $params->{comment} or
        return {
            site     => $site,
            list     => 'current',
            error    => '入力が空白です。',
            comments => $comments,
            pager    => $pager,
        };

    {
        list     => 'current',
        link     => '/site/comment/' . $site->id,
        message  => Commetter::Model::Comment->post($tw, $site, $guest, $comment),
        template => "result",
    }
}

sub edit {
    my ($req, $params) = @args;
    my $site = Commetter::Model::Site->find_by(id => $params->{id}) or return not_found;
    { list  => 'current', site => $site, };
}
sub post_edit {
    my ($req, $params) = @args;
    my $tw = $req->session->get('twitter') or return { redirect => "/login2twitter" };
    my $site = Commetter::Model::Site->find_by(id => $params->{id}) or return not_found;
    my $name = $params->{name} or return { list  => 'current', site => $site, error => "入力が空白です。" };
    $site->name($name);
    $site->update;
    { link => '/site/list', list  => 'current', template => "result", message => "サイト名を更新しました。" };
}

sub register { { register  => 'current', page_title => 'サイト登録' } }
sub post_register {
    my ($req, $url) = @args;
    my $tw = $req->session->get('twitter') or return { redirect => "/login2twitter" };
    $url = $url->{url};
    {
        link     => '/site/register',
        message  => Commetter::Model::Site->register($url),
        register => 'current',
        template => "result",
        page_title => 'サイト登録',
    }
}

1;
