package Commetter::Model::Site;
use base qw/Commetter::Model::Base/;
use self;
use Commetter::Utils;
use HTML::TagParser;
use LWP::UserAgent;

sub register {
    my ($url) = @args;

    return '無効な入力です。入力したURLを確認してください。' unless $url;

    my $ua = LWP::UserAgent->new(timeout => 3);
    return '既に登録されているURLです。サイト一覧から探してみてください。'
        if $self->find_by(url => $url);

    my $res = $ua->get($url);
    return 'URLにアクセスできませんでした。URLが正しい場合、時間をおいて試してみてください。'
        unless $res->is_success;

    my $html = HTML::TagParser->new($res->content);
    my $title = $html->getElementsByTagName('title')->innerText;
    model->set(site => {
        url  => $url,
        name => $title,
    });
    return 'サイトを登録しました。サイト一覧から探して、コメントを投稿できます。';
}

1;
