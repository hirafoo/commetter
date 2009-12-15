package Commetter::Model::Comment;
use base qw/Commetter::Model::Base/;
use self;
use Commetter::Utils;
#use Config::Pit;
#use LWP::UserAgent;

sub post {
    my ($tw, $site, $guest, $comment) = @args;

    return '無効な入力です。入力した内容を確認してください。' unless $comment;

    my $comment_page = "http://commetter.net/site/comment/" . $site->id;
    #my $bit_ly = pit_get('bit.ly');
    #my $api_url =
    #    "http://api.bit.ly/shorten?version=2.0.1&format=xml&login=" .
    #    $bit_ly->{user} . "&apiKey=" .
    #    $bit_ly->{api_key} . "&longUrl=$comment_page";

    #my $ua = LWP::UserAgent->new(timeout => 3);
    #my $res = $ua->get($api_url);
    #if ($res->content =~ m{<shortUrl>(.+?)</shortUrl>}) {
    #    #$comment_page = $1;
    #}
    #else {
    #    #$comment_page = qq{http://commetter.net/site/comment/$site->id};
    #}

    my $nt = make_nt;
    $nt->access_token($tw->{access_token});
    $nt->access_token_secret($tw->{access_token_secret});
    model->set(comment => {
        site_id    => $site->id,
        guest_id   => $guest->id,
        guest_icon => $guest->icon,
        guest_name => $guest->screen_name,
        comment    => $comment,
    });
    $comment = join " ", $comment, $comment_page;
    $nt->update(u8de($comment));
    return 'コメントを投稿しました。';
}

1;
