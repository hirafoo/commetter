package Commetter::Model::Comment;
use base qw/Commetter::Model::Base/;
use self;
use Commetter::Utils;

sub post {
    my ($tw, $site, $guest, $comment) = @args;

    return '無効な入力です。入力した内容を確認してください。' unless $comment;

    my $nt = make_nt;
    $nt->access_token( $tw->{access_token} );
    $nt->access_token_secret( $tw->{access_token_secret} );
    model->set(comment => {
        site_id    => $site->id,
        guest_id   => $guest->id,
        guest_icon => $guest->icon,
        guest_name => $guest->screen_name,
        comment    => $comment,
    });
    $comment = join " ", $site->url, $comment;
    $nt->update(u8de($comment));
    return 'コメントを投稿しました。';
}

1;
