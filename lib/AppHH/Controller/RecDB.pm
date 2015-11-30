package AppHH::Controller::Vacancies;
use Mojo::Base 'Mojolicious::Controller';

sub rec__db {
	my $self = shift;
	AppHH::RefreshVac->refresh( $self );
	$self->render();
}

1;
