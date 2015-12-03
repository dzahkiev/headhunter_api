#!/usr/bin/perl
use strict;
use lib::App::HH::Api;
use Mojo::UserAgent;
use DBI;
my $dbh = DBI->connect( sprintf( "DBI:mysql:dbname=test;host=localhost;port=3306" ) ) or die "Couldn't connect!";

open FILE, '<', '../conf.txt';
chomp (my @lines = <FILE>);
close FILE;
my $access;
$access->{access_token}  = $lines[0];
$access->{refresh_token} = $lines[1];
my %auth_header = ( Authorization => "Bearer $access->{access_token}" );
my $ua = Mojo::UserAgent->new;
my $res= $ua->get( "https://api.hh.ru/me" => { %auth_header } )->res;
if ( $res->code == 403 ) {
	$access = $ua->post( "https://hh.ru/oauth/token" => form => {
	grant_type 		=> 'refresh_token',
	refresh_token 	=> $access->{refresh_token}	 })->res->json;
	open	FILE, '>', '../conf.txt';
	print	FILE $access->{access_token} . "\n";
	print	FILE $access->{refresh_token} . "\n";
	close	FILE;
}

my $employer_id	= $res->json->{employer}{id};
my $manager_id	= $res->json->{employer}{manager_id};
for my $type ( qw /active archived hidden/ ) {
	my $vacancies = App::HH::Api->get_vacancies( $type, $employer_id, $manager_id, %auth_header );
	my $sth_vacancy = $dbh->prepare("insert into vacancies set id = ?, name = ?, region = ?, created = ?, updated = ?, responses = ?, unread_responses = ?, views = ?, invitations = ?, status = ? 
	on duplicate key update name = values(name), region = values(region), updated = values(updated), responses = values(responses), unread_responses = values(unread_responses), views = values(views), invitations = values(invitations), status = values(status)");
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
			$vacancy->{counters}{invitations_and_responses},
			$type
		);
		$sth_vacancy->execute(@values);
		for my $type_status ( qw /inbox hold invited discarded/ ) {
			my $negotiations = App::HH::Api->get_negotiations( $type_status, $vacancy->{id}, %auth_header );
			if ( @$negotiations ) {
			my $sth_negotiation = $dbh->prepare("insert into negotiations set id = ?, vacancy_id = ?, first_name = ?, last_name = ?, middle_name = ?, gender = ?, age = ?, resume_title = ?, resume_url = ?, status = ? 
			on duplicate key update  first_name = values(first_name), last_name = values(last_name), middle_name = values(middle_name), gender = values(gender), age = values(age), resume_title = values(resume_title), resume_url = values(resume_url), status = values(status)");
			for my $negotiation ( @$negotiations ) {
				my @values = (
					$negotiation->{id},
					$vacancy->{id},
					$negotiation->{resume}{first_name},
					$negotiation->{resume}{last_name},
					$negotiation->{resume}{middle_name},
					$negotiation->{resume}{gender}{name},
					$negotiation->{resume}{age},
					$negotiation->{resume}{title},
					$negotiation->{resume}{alternate_url},
					$type_status
				);
				$sth_negotiation->execute(@values);
				}
			}
		}
	}
}
$dbh->do("delete from negotiations where vacancy_id in (select id from vacancies where status = 'hidden' )");
$dbh->do("delete from vacancies where status = 'hidden'");


