package AppHH::Controller::Vacancies;
use Mojo::Base 'Mojolicious::Controller';
use feature qw( switch say );
use Data::Dumper;


sub vacancies {
	my $self		= shift;
	my $res			= $self->ua->get( make_url('me') => auth_header($self) )->res->json->{employer};
	my $employer_id	= $res->{id};
	my $manager_id	= $res->{manager_id};
	my $type		= $self->param('type');
	my $url = make_url( "employers/$employer_id/vacancies/$type", {manager_id => $manager_id} );
	$res = $self->ua->get( $url => auth_header($self) )->res->json;
	$self->render(json => $res);
}

sub vacancy {
	my $self = shift;
	my $id = $self->param('ID');
	my $url = make_url("vacancies/$id");
	my $res = $self->ua->get( $url => auth_header($self) )->res->json;
	$self->render(json => $res);
}

sub negotiations {
	my ( $self, $id ) = @_;
	my $url = make_url( 'negotiations', { vacancy_id => $self->param('ID') } );
	my $res = $self->ua->get( $url => auth_header($self) )->res->json;
	say Dumper $res;
	$self->render(json => $res);
}

sub auth_header {
	my $self = shift;
	my %header	=  ( { Authorization => $self->session('token_type') ." ". $self->session('access_token') } );
}

sub make_url {
	my ( $path, $query ) = @_;
	my $url = Mojo::URL->new;
	$url->scheme( 'https' );
	$url->host( 'api.hh.ru' );
	$url->path(	$path );
	$url->query( $query );
	say $url;
	return $url;
}

1;
