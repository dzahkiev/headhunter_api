package AppHH::HH::Api;
use warnings;
use feature qw( switch say );
use Data::Dumper;
use Mojo::UserAgent;

my $ua = Mojo::UserAgent->new;

sub get_vacancies {
	my ( $class, $type, %header ) = @_;
	my $res	= $ua->get( "https://api.hh.ru/me" => { %header } )->res->json->{employer};
	my $employer_id	= $res->{id};
	my $manager_id	= $res->{manager_id};
	my $url = "https://api.hh.ru/employers/$employer_id/vacancies/$type?manager_id=$manager_id";
	$res = $ua->get( $url => { %header } )->res->json->{items};
	return $res;
}

sub get_vacancy {
	my ( $class, $id, %header ) = @_;
	my $url = "https://api.hh.ru/vacancies/$id";
	my $res = $ua->get( $url => { %header } )->res->json;
	return $res;
}

sub get_negotiations {
	my ( $class, $type, $id, %header ) = @_;
	my $url = "https://api.hh.ru/negotiations/$type?vacancy_id=$id";
	my $res = $ua->get( $url => { %header } )->res->json->{items};
	return $res;
}

1;