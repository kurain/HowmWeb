package HowmWeb;
use strict;
use warnings;
use utf8;
use parent qw/Amon2/;
our $VERSION='0.01';
use 5.008001;

__PACKAGE__->load_plugin(qw/DBI/);

# initialize database
use DBI;
sub setup_schema {
    my $self = shift;
    my $dbh = $self->dbh();
    my $driver_name = $dbh->{Driver}->{Name};
    my $fname = lc("sql/${driver_name}.sql");
    open my $fh, '<:encoding(UTF-8)', $fname or die "$fname: $!";
    my $source = do { local $/; <$fh> };
    for my $stmt (split /;/, $source) {
        next unless $stmt =~ /\S/;
        $dbh->do($stmt) or die $dbh->errstr();
    }
}

use Teng;
use Teng::Schema::Loader;
use HowmWeb::DB;
my $schema;
sub db {
    my $self = shift;
    if ( !defined $self->{db} ) {
        my $conf = $self->config->{'DBI'}
        or die "missing configuration for 'DBI'";
        my $dbh = DBI->connect(@{$conf});
        $schema ||= Teng::Schema::Loader->load(
            namespace => 'HowmWeb::DB',
            dbh       => $dbh,
	    );
        $self->{db} = HowmWeb::DB->new(
            dbh    => $dbh,
            schema => $schema,
	    );
    }
    return $self->{db};
}

1;
