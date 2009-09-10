package Commetter::Model::Base;
use self;
use Commetter::Utils;

sub table { my $table = (split(/::/, $self))[-1]; lc $table }

sub search {
    my ($cond, $attrs) = @args;
    $cond->{deleted} = 0;

    if ($cond->{name}) {
        my @names = split / |　/, $cond->{name};
        $cond = [];
        my %_cond;
        for my $name (@names) {
            %_cond = (name => {like => "\%$name\%"});
            push @$cond, %_cond;
        }
    }

    my $page = $attrs->{page} || 1;
    my $offset = ($page == 1) ? 0 : $page * 10 - 10;

    my $result = model->get($self->table => {
        where  => [ref $cond eq 'HASH' ? %$cond : @$cond],
        limit  => $attrs->{limit} || 10,
        offset => $offset,
        order  => $attrs->{order} ? $attrs->{order} : (),
    });
    my $next = model->get($self->table => {
        where  => [ref $cond eq 'HASH' ? %$cond : @$cond],
        limit  => $attrs->{limit} || 10,
        offset => $offset + 10,
        order  => $attrs->{order} ? $attrs->{order} : (),
    });
    return undef unless $result;

    my $pager;
    $pager->{current_page}  = $page;
    $pager->{previous_page} = ($page == 1) ? undef : $page - 1;
    $pager->{next_page}     = $next ? $page + 1 : undef;
    ($result, $pager);
}

sub find_by {
    my (%cond) = @args;
    $cond{deleted} = 0;

    my $result = model->get($self->table => {
        where => [%cond],
    });

    return undef unless $result;
    return $result->next;
}

1;
