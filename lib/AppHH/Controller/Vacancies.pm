package AppHH::Controller::Vacancies;
use base 'Mojolicious::Controller';


sub vacancies {
  my $self = shift;
  my $query =  "select *, (select count(*) from negotiations where status = 'inbox' and vacancy_id = vacancies.id ) as count_responses  from vacancies";
  my $vacancies = AppHH::DB->select( $query );
  return $self->render( vacancies => $vacancies);
}

sub negotiations {
  my $self = shift;
  my $query =  "select *, (select name from vacancies where id = vacancy_id) as vacancy from negotiations";
  my @params;
  if ( $self->param( 'ID' ) ) {
    if ( $self->param( 'status' ) ) {
      $query = "select *, (select name from vacancies where id = vacancy_id) as vacancy from negotiations where vacancy_id = ? and status = ?";
       push @params, ( $self->param( 'ID' ), $self->param( 'status' ) );
      }
    else {
      $query = "select *, (select name from vacancies where id = vacancy_id) as vacancy from negotiations where vacancy_id = ?";
      push @params, $self->param( 'ID' );
    }
  }
  my $negotiations = AppHH::DB->select( $query, @params );
  return $self->render( negotiations => $negotiations);
}

sub save_negotiation {
    my $self = shift;
    my $sth = AppHH::DB->db->prepare("update negotiations set local_status = ? where id = ?");
    $sth->execute( $self->param('status'), $self->param('editID') );
    my $vacancy_id = $self->param( 'ID' );
    return $self->redirect_to("/negotiations/$vacancy_id");
}

1;
