package AppHH::Hh_api;
use warnings;

my $ua = Mojo::UserAgent->new;

sub get_vacancies {
	my ( $class, $self, $type, $header ) = @_;
	my $res	= $ua->get( $self->make_url("me") => $header )->res->json->{employer};
	my $employer_id	= $res->{id};
	my $manager_id	= $res->{manager_id};
	my $url = $self->make_url( "employers/$employer_id/vacancies/$type", {manager_id => $manager_id} );
	$res = $ua->get( $url => $header )->res->json->{items};
	return $res;
}

sub get_vacancy {
	my ( $class, $self, $id, $header ) = @_;
	my $url = $class->make_url("vacancies/$id");
	my $res = $ua->get( $url => $header )->res->json;
	return $res;
}

sub get_negotiations {
	my ( $class, $self, $id, $header ) = @_;
	my $url = $class->make_url( 'negotiations', { vacancy_id => $id } );
	my $res = $ua->get( $url => $header )->res->json;
	return $res;
}

1;
