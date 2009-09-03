package Commetter;
use Data::Model::Driver::DBI;
use Commetter::ConfigLoader;
use Commetter::Utils;
use Commetter::Model::Tables;

our ($config, $model);

sub setup {
    Commetter::Utils->setup_home;
    $config = {%$config, %{Commetter::ConfigLoader->load_config}};
    Commetter::Utils->setup_ip;

    my $driver = Data::Model::Driver::DBI->new(%{dbi_config()});
    my $dm = Commetter::Model::Tables->new;
    $dm->set_base_driver($driver);
    $model = $dm;
}

1;

__END__

=head1 NAME

Commetter - comment to site with Twitter

=head1 DESCRIPTION

comment to site with Twitter

=head1 AUTHOR

hirafoo

=head1 LICENSE
