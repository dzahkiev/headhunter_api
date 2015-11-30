package AppHH::RefreshVac;
use feature qw( switch say );
use Data::Dumper;
use AppHH::Hh_api;

sub refresh {
	my ( $class, $self ) = @_;
	AppHH::DB->create_table;
	my $vacancies;
	for my $type ( qw /active archived hidden/ ) {
		$vacancies = AppHH::Hh_api->get_vacancies( $self, $type, $self->auth_header );
		AppHH::DB->insert_vacancies( $type, $vacancies );
		for my $vacancy ( @$vacancies ) {
			for my $type ( qw /inbox hold invited discarded/ ) {
				my $negotiation = AppHH::Hh_api->get_negotiations( $self, $type, $vacancy->{id}, $self->auth_header );
				AppHH::DB->insert_negotiation( $vacancy->{id}, $type, $negotiation ) if ( defined @$negotiation );
				say Dumper $negotiation;
			}
		}
	}

}

1;
