package HowmWeb::Dropbox;
use warnings;
use strict;
use Net::Dropbox::API;

sub new {
    my ($class, $c) = @_;

    my $self = bless {}, $class;

    my $user = $c->session->get('user');
    my $box = Net::Dropbox::API->new($c->config->{Dropbox});
    $box->access_token($user->{access_token});
    $box->access_secret($user->{access_secret});

    $self->{_box} = $box;
    return $self;
}

sub box {
    return $_[0]->{_box};
}

sub _get_files {
    my ($self, $dir, $files) = @_;
    my $path = substr($dir->{path},1);

    my $res = $self->box->metadata($path);
    return unless ( $res->{contents} && @{$res->{contents}} );

    for (@{ $res->{contents} }) {
        if ( $_->{is_dir} ) {
            $self->_get_files($_, $files);
        } else {
            next if $_->{path} =~ /[~#]$/;
            push @$files, $_;
        }
    }
}

sub all_files {
    my $self = shift;
    my @files;

    $self->_get_files({path=>'/'},\@files);
    return \@files;
}

sub get {
    my ($self, $file) = @_;
    my $path = substr($file->{path},1);
    my $data = $self->box->getfile($path);
    return $data;
}

1;
