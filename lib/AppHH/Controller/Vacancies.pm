package AppHH::Controller::Vacancies;
use base 'Mojolicious::Controller';
use feature qw( switch say );
use Data::Dumper;
use AppHH::DB;


sub vacancies {
  my $self = shift;
  my $query =  "select * from vacancies";
  my $vacancies = AppHH::DB->select( $query );
  say Dumper $vacancies;
  return $self->render( vacancies => $vacancies);
}

sub negotiations {
  my $self = shift;
  my $query =  "select * from negotiations";
  my $negotiations = AppHH::DB->select( $query );
  say Dumper $negotiations;
  return $self->render( negotiations => $negotiations);
}

1;
