package App::DB;
use DBI;

my $dbh;

sub db_connect {
	my $class = shift;
	$dbh = DBI->connect( sprintf( "DBI:mysql:dbname=%s;host=%s;port=%s", @_ ) ) or die "Couldn't connect!";
	$dbh->{'mysql_enable_utf8'} = 1;
	$dbh->do('SET NAMES utf8');
	return $dbh;
}

sub db {
	my $class = shift;
	return $dbh if $dbh;
}

sub select {
	my ( $class, $query, @param ) = @_;
	my $sth = $dbh->prepare( $query );
	$sth->execute( @param );
	my $data;
	while ( my $ref = $sth->fetchrow_hashref ) {
	push @$data, $ref;
	}
	return $data;
}

1;

