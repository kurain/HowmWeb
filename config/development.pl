use File::Spec;
use File::Basename qw(dirname);
my $basedir = File::Spec->rel2abs(File::Spec->catdir(dirname(__FILE__), '..'));
my $dbpath;
if ( -d '/home/dotcloud/') {
    $dbpath = "/home/dotcloud/development.db";
} else {
    $dbpath = File::Spec->catfile($basedir, 'db', 'development.db');
}
my $dropbox = require File::Spec->catfile($basedir, 'config', 'dropbox.pl');
+{
    'DBI' => [
        "dbi:mysql:dbname=howmweb",
        'nobody',
        'nobody',
    ],
    'Dropbox' => $dropbox,
};
