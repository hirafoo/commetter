package Commetter::Model::Tables;
use base qw/Data::Model/;
use Data::Model::SQL;
use Data::Model::Schema;
use Commetter::Utils;

# column definition
sub id {
    column id
    => int => {
        auto_increment => 1,
        require  => 1,
        unsigned => 1,
    };
    key 'id';
}

sub string {
    my $name= shift;

    column $name
    => varchar => {
        required => 1,
        size     => 255,
        default  => '',
    };
}

sub url {
    column url
    => varchar => {
        required => 1,
        size     => 255,
        default  => '',
    };
}

sub comment {
    column comment
    => varchar => {
        required => 1,
        size     => 255,
        default  => '',
    };
}

sub common_columns {
    #column visible
    #=> tinyint => {
    #    size     => 1,
    #    require  => 1,
    #    unsigned => 1,
    #    default  => 1,
    #};

    column deleted
    => tinyint => {
        size     => 1,
        require  => 1,
        unsigned => 1,
        default  => 0,
    };

    column created_at
    => datetime => {
        require  => 1,
    };

    column updated_at
    => datetime => {
        require => 1,
        default => sub { now_c->() },
    };
}

sub foreign_key {
    my $table = shift;
    column "$table\_id"
    => int => {
        require  => 1,
        unsigned => 1,
    };
}

# make table
install_model guest => schema {
    id;
    string 'name';
    string 'screen_name';
    foreign_key 'twitter'; # not foreign key, twitter user id
    string 'icon';
    string 'access_token';
    string 'access_token_secret';
    common_columns;
    index 'name';
    schema_options create_sql_attributes => {
        mysql => 'TYPE=InnoDB',
    };
};

install_model site => schema {
    id;
    url;
    string 'name';
    string 'edited_by';
    string 'registerd_by';
    common_columns;
    schema_options create_sql_attributes => {
        mysql => 'TYPE=InnoDB',
    };
};

install_model comment => schema {
    id;
    foreign_key 'site';
    foreign_key 'guest';
    string 'guest_icon';
    string 'guest_name';
    comment;
    common_columns;
    schema_options create_sql_attributes => {
        mysql => 'TYPE=InnoDB',
    };
};


# auto insert created_at / updated_at
sub update {
    my ($self, $obj) = @_;
    $obj->updated_at(now_c->());
    $self->next::method($obj);
}

my $auto_created_at = sub {
    my $self = shift;
    $_[2]->{created_at} = now_c->();
    $self->_insert_or_replace(0, @_);
};

no warnings 'redefine';
*Data::Model::Driver::DBI::set = $auto_created_at;

1;
