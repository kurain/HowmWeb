package HowmWeb::Web::Dropbox;
use warnings;
use strict;

use HowmWeb::Dropbox;

sub refresh {
    my ($class, $c) = @_;
    my $user = $c->session->get('user');

    return $c->redirect('/') unless $user;

    my $box = HowmWeb::Dropbox->new($c);
    my $files = $box->all_files;

    for (@$files) {
        my $file = $box->get($_);
        my ($title, $date_str) = parse_file($file);
        warn $title;
        warn $date_str;
        $c->db->insert('memo',{
            path => $_->{path},
            timestamp => $date_str,
            title => $title,
            body => $file,
        });
    }
    return $c->render('list.tt', { files => $files });
}


sub parse_file {
    my $file = shift;
    my @lines = split "\n", $file;
    my $count = 0;

    my $title = 'no title';
    my $date_str;

    for my $line (@lines) {
        if ( $count == 0 && index($line,'=') == 0 ) {
            my $tmp = substr($line,1);
            $tmp =~ s/(^\s+|\s+$)//;
            $title = $tmp if $tmp;
        } elsif ($line =~ /^\[(\d{4}\-\d{2}-\d{2} \d{2}:\d{2})]/o) {
            my $date = $1;
            if ( $date ) {
                $date_str = $date . ':00';
                last;
            }
        }
        $count++;
    }
    return ($title,$date_str);
}
1;
