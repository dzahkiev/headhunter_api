package App::Controller::Negotiations;
use base 'Mojolicious::Controller';

sub list {
  my $self = shift;
  my @params;
  my $query =  "select *, (select name from vacancies where id = vacancy_id) as vacancy from negotiations order by created desc"; 
  my $status = $self->param('status') || 'inbox';
  unless ($self->param('status') eq 'all') {
    $query =  "select *, (select name from vacancies where id = vacancy_id) as vacancy from negotiations where status in (?) order by created desc";
    push @params, $status;
  } 
  if ( $self->param('ID') ) {
    unless ($self->param('status') eq 'all') {
      $query = "select *, (select name from vacancies where id = vacancy_id) as vacancy from negotiations where vacancy_id = ? order by created desc";
    }
    else {
      $query = "select *, (select name from vacancies where id = vacancy_id) as vacancy from negotiations where status in (?) and vacancy_id = ? order by created desc";
    }
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
  my $id = $self->param('nID');
  return $self->redirect_to("/negotiation/$id");
}

sub update_status{
  my $self = shift;
  my $id = $self->param('nID');
  my $status = $self->param('set_status');
  my $url = "https://api.hh.ru/negotiations/$status/$id";
  my $res = $self->ua->put( $url => { Authorization => "Bearer ".$self->session('access_token') } )->res;
  if ($res->code == 204) {
    my $sth = App::DB->db->prepare("update negotiations set status = ? where id = ?");
    $sth->execute($status, $id);
  }
  return $self->redirect_to("/negotiation/$id");

}

1;
