package AppHH::Controller::Vacancies;
use Mojo::Base 'Mojolicious::Controller';
use feature qw( switch say );
use Data::Dumper;

sub rec_into_db {
	my $self = shift;
	AppHH::DB->create_table;
	my $vacancies = AppHH::Hh_api->get_vacancies( $self, 'active', $self->auth_header );
	AppHH::DB->insert_into_db($vacancies);
	$self->render( json => $vacancies );
}

1;
