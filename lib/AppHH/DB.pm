package AppHH::DB;
use DBI;

my $dbh;

sub db_connect {
	my ( $class ) = shift; 
	$dbh = DBI->connect( sprintf( "DBI:mysql:dbname=%s;host=%s;port=%s", @_ ) ) or die "Couldn't connect!";
	return $dbh;
}

sub create_table {
	my $class = shift;
	$dbh->do("create table if not exists 
			vacancies (
				id int(10) not null,
				name varchar(256),
				region varchar(256),
				created varchar(32),
				updated varchar(32),
				responses int(10),
				unread_responses int(10),
				views int(10),
				invitations int(10),
				primary key (id)
		)"
	);
}

sub insert_into_db {
	my ( $class, $vacancies ) = @_;
	my $sth = $dbh->prepare("insert into vacancies set id = ?, name = ?, region = ?, created = ?, updated = ?, responses = ?, unread_responses = ?, views = ?, invitations = ? 
	on duplicate key update name = values(name), region = values(region), updated = values(updated), responses = values(responses), unread_responses = values(unread_responses), views = values(views), invitations = values(invitations) ");
	for my $vacancy ( @$vacancies ) {
		my @values = (
			$vacancy->{id},
			$vacancy->{name},
			$vacancy->{area}{name},
			$vacancy->{created_at},
			$vacancy->{published_at},
			$vacancy->{counters}{responses},
			$vacancy->{counters}{unread_responses},
			$vacancy->{counters}{views},
			$vacancy->{counters}{invitations}
		);
		$sth->execute(@values);
	}
	return;
}

1;

