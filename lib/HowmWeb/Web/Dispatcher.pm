package HowmWeb::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

use HowmWeb::Web::Index;
use HowmWeb::Web::Dropbox;

any '/' => sub {
    my ($c) = @_;
    HowmWeb::Web::Index->default($c);
};

get '/callback' => sub {
    my ($c) = @_;
    HowmWeb::Web::Index->callback($c);
};

post '/logout' => sub {
    my ($c) = @_;
    HowmWeb::Web::Index->logout($c);
};


get '/refresh' => sub {
    my ($c) = @_;
    HowmWeb::Web::Dropbox->refresh($c);
};
1;
