package App::HH::Api;
use warnings;
use Mojo::UserAgent;
use feature qw (say switch);
use Data::Dumper;

my $ua = Mojo::UserAgent->new;

sub get_vacancies {
	my ( $class, $type, $employer_id, $manager_id, %header ) = @_;
	my $url = "https://api.hh.ru/employers/$employer_id/vacancies/$type?manager_id=$manager_id&per_page=999";
	$res = $ua->get( $url => { %header } )->res->json->{items};
	return $res;
}

sub get_vacancy {
	my ( $class, $id, %header ) = @_;
	my $url = "https://api.hh.ru/vacancies/$id?per_page=999";
	my $res = $ua->get( $url => { %header } )->res->json->{description};
	return $res;
}

sub get_negotiations {
	my ( $class, $type, $id, %header ) = @_;
	my $url = "https://api.hh.ru/negotiations/$type?vacancy_id=$id&per_page=999";
	my $res = $ua->get( $url => { %header } )->res->json->{items};
	say Dumper $res;
	return $res;
}

sub get_negotiation {
	my ( $class, $id, %header ) = @_;
	my $url = "https://api.hh.ru/negotiations/nid=$id&per_page=999";
	my $res = $ua->get( $url => { %header } )->res->json->{items};
	say "---------------------------------";
	say Dumper $res;
	say "---------------------------------";
	return $res;
}

1;