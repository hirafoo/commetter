package Commetter::Model::Base;
use self;
use Commetter::Utils;

sub table { my $table = (split(/::/, $self))[-1]; lc $table }

sub list {
    my ($cond) = @args;
    $cond->{deleted} = 0;

    my $order = delete $cond->{order};
       $order = $order ? ({ %$order }) : ();
    my $page = delete $cond->{page} || 1;
    my $offset = ($page == 1) ? 0 : $page * 10 - 10;
    my $limit = delete $cond->{limit} || 10;
    
    my $result = model->get($self->table => {
        limit  => $limit,
        offset => $offset,
        where  => [((%$cond) ? (%$cond) : ())],
        order => $order,
    });
    my $next = model->get($self->table => {
        limit  => $limit,
        offset => $offset + 10,
        where  => [((%$cond) ? (%$cond) : ())],
        order => $order,
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
