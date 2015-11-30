package AppHH::DB;
use DBI;
use feature qw( switch say );
use Data::Dumper;

my $dbh;

sub db_connect {
	my $class = shift;
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
				status varchar(32),
				primary key (id)
		)"
	);

	$dbh->do("create table if not exists 
			negotiations (
				id int(10) not null,
				vacancy_id int(10) not null,
				first_name varchar(256),
				last_name varchar(256),
				middle_name varchar(256),
				gender varchar(16),
				age int(3),
				resume_title varchar(512),
				resume_url varchar(512),
				status varchar(32),
				primary key (id)
		)"
	);
}

sub select {
	my ( $class, $query ) = @_;
	my $sth = $dbh->prepare( $query );
	$sth->execute;
	my $data;
	while ( my $ref = $sth->fetchrow_hashref ) {
	push @$data, $ref;
	}
	return $data;
}


sub insert_vacancies {
	my ( $class, $type, $vacancies ) = @_;
	my $sth = $dbh->prepare("insert into vacancies set id = ?, name = ?, region = ?, created = ?, updated = ?, responses = ?, unread_responses = ?, views = ?, invitations = ?, status = ? 
	on duplicate key update name = values(name), region = values(region), updated = values(updated), responses = values(responses), unread_responses = values(unread_responses), views = values(views), invitations = values(invitations), status = values(status) ");
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
			$vacancy->{counters}{invitations},
			$type
		);
		$sth->execute(@values);
	}
	return;
}

sub insert_negotiation {
	my ( $class, $vacancy_id, $type, $negotiations ) = @_;
	my $sth = $dbh->prepare("insert into negotiations set id = ?, vacancy_id = ?, first_name = ?, last_name = ?, middle_name = ?, gender = ?, age = ?, resume_title = ?, resume_url = ?, status = ? 
	on duplicate key update  first_name = values(first_name), last_name = values(last_name), middle_name = values(middle_name), gender = values(gender), age = values(age), resume_title = values(resume_title), resume_url = values(resume_url), status = values(status)");
	for my $negotiation ( @$negotiations ) {
		my @values = (
			$negotiation->{id},
			$vacancy_id,
			$negotiation->{resume}{first_name},
			$negotiation->{resume}{last_name},
			$negotiation->{resume}{middle_name},
			$negotiation->{resume}{gender}{name},
			$negotiation->{resume}{age},
			$negotiation->{resume}{title},
			$negotiation->{resume}{alternate_url},
			$type
		);
		$sth->execute(@values);
	}
	return;
}

1;

