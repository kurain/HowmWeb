package HowmWeb::Web::Index;
use warnings;
use strict;
use Net::Dropbox::API;

sub default {
    my ($class, $c) = @_;
    my $user = $c->session->get('user');

    unless ($user) {
        my $box = Net::Dropbox::API->new($c->config->{Dropbox});
        my $link = $box->login;
        $c->session->set('oauth' => {
            request_token  => $box->request_token,
            request_secret => $box->request_secret,
        });
        return $c->render('index.tt', { login => $link });
    }

    my $box = Net::Dropbox::API->new($c->config->{Dropbox});
    $box->access_token($user->{access_token});
    $box->access_secret($user->{access_secret});
    my $file_exist = scalar @{$box->metadata()->{contents} };
    return $c->render('index.tt', { user  => $user, file_exist => $file_exist });
}

sub callback {
    my ($class, $c) = @_;
    return $c->redirect('/') unless $c->req->param('oauth_token');

    my $oauth = $c->session->get('oauth');
    my $box = Net::Dropbox::API->new($c->config->{Dropbox});
    $box->request_token($oauth->{request_token});
    $box->request_secret($oauth->{request_secret});
    $box->auth;
    $c->session->set('user' => {
        access_token  => $box->access_token,
        access_secret => $box->access_secret,
    });
    return $c->redirect('/');
}

sub logout {
    my ($class, $c) = @_;
    $c->session->expire('user');
    $c->session->expire('oauth');
    return $c->redirect('/');
};

1;
