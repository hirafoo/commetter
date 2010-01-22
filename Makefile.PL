use inc::Module::Install;

name 'Commetter';
all_from 'lib/Commetter.pm';

license  'gpl';

requires 'Config::Divide';
requires 'Config::Pit';
requires 'Data::Model';
requires 'Data::Visitor::Callback';
requires 'ExtUtils::Depends';
requires 'HTML::TagParser';
requires 'HTTP::Engine';
requires 'HTTP::Engine::Middleware';
requires 'HTTP::Session';
requires 'HTTPx::Dispatcher';
requires 'IO::Interface::Simple';
requires 'Net::Twitter';
requires 'Module::Pluggable::Fast';
requires 'Module::Reload';
requires 'MooseX::Types::Path::Class';
requires 'Path::Class';
requires 'String::Random';
requires 'Template::Plugin::LinkTo';
requires 'UNIVERSAL::require';
requires 'self';

auto_include;
auto_install;
WriteAll;
