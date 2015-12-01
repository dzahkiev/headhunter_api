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
  my @params;
  if ( $self->param( 'ID' ) ) {
    if ( $self->param( 'status' ) ) {
      $query = "select * from negotiations where vacancy_id = ? and status = ?";
       push @params, ( $self->param( 'ID' ), $self->param( 'status' ) );
      }
    else {
      $query = "select * from negotiations where vacancy_id = ?";
      push @params, $self->param( 'ID' );
    }
  }
  my $negotiations = AppHH::DB->select( $query, @params );
  return $self->render( negotiations => $negotiations);
}

1;
