package App::Controller::Negotiations;
use base 'Mojolicious::Controller';

sub list {
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
  my $negotiations = App::DB->select( $query, @params );
  return $self->render( negotiations => $negotiations);
}

sub update {
    my $self = shift;
    my $sth = App::DB->db->prepare("update negotiations set local_status = ? where id = ?");
    $sth->execute( $self->param('status'), $self->param('editID') );
    my $vacancy_id = $self->param( 'ID' );
    return $self->redirect_to("/negotiations/$vacancy_id");
}

1;
