package AppHH::Controller::Vacancies;
use Mojo::Base 'Mojolicious::Controller';

sub rec_into_db {
	my $self = shift;
	AppHH::DB->create_table;
	my $vacancies = AppHH::Hh_api->get_vacancies( $self, 'active', $self->auth_header );
	AppHH::DB->insert_vacancies($vacancies);
	for my $vacancy ( @$vacancies ) {
		for my $type ( qw /inbox hold invited discarded/ ) {
			my $negotiation = AppHH::Hh_api->get_negotiations( $self, $type, $vacancy->{id}, $self->auth_header );
			AppHH::DB->insert_negotiation( $vacancy->{id}, $negotiation ) if (defined @$negotiation);
		}
	}
	$self->render( json => $vacancies );

}

1;
