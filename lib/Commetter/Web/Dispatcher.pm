package Commetter::Web::Dispatcher;
use Commetter::Utils;
use HTTPx::Dispatcher;

connect 'site/'            => { controller => 'Site', action => 'index' };
connect 'site/:action/:id' => { controller => 'Site', };
connect 'site/:action'     => { controller => 'Site', };
connect ':action'          => { controller => 'Root', };
connect ''                 => { controller => 'Root', action => 'index' };

1;
