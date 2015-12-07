package App::Controller::Negotiations;
use base 'Mojolicious::Controller';

sub list {
  my $self = shift;
  my $query =  "select *, (select name from vacancies where id = vacancy_id) as vacancy from negotiations where status = ?";
  my $status = $self->param('status') || 'invited';
  my @params;
  push @params, $status;
  if ( $self->param('ID') ) {
       $query .= " and vacancy_id = ?";
       push @params, $self->param('ID');
      }
  my $negotiations = App::DB->select( $query, @params );
  return $self->render( negotiations => $negotiations);
}

sub negotiation {
  my $self = shift;
  my $query =  "select *, (select name from vacancies where id = vacancy_id) as vacancy from negotiations where id = ?";
  my $negotiation = App::DB->select( $query, $self->param('nID') )->[0];
  return $self->render( negotiation => $negotiation);
}

sub update {
    my $self = shift;
    my $sth = App::DB->db->prepare("update negotiations set local_status = ? where id = ?");
    $sth->execute( $self->param('local_status'), $self->param('nID') );
    my $vacancy_id = $self->param('nID');
    return $self->redirect_to("/negotiations/$vacancy_id");
}

1;
