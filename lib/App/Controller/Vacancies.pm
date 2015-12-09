package App::Controller::Vacancies;
use base 'Mojolicious::Controller';

sub list {
	my $self = shift;
	my $query =  "select *, (select count(*) from negotiations where status = 'inbox' and vacancy_id = vacancies.id ) as count_responses from vacancies where status = ? order by updated desc";
	my $status = $self->param('status') || 'active';
  my $vacancies;
  if ($self->param('status') eq 'all') {
    $query =  "select *, (select count(*) from negotiations where status = 'inbox' and vacancy_id = vacancies.id ) as count_responses from vacancies order by updated desc";
    $vacancies = App::DB->select($query);
  }
  else {
    $vacancies = App::DB->select( $query, $status );
  }
	return $self->render( vacancies => $vacancies);
}

sub vacancy {
  my $self = shift;
  my @param;
  my $status = $self->param('status')||'inbox';
  push @param, $self->param('ID');
  my $query =  "select *, (select count(*) from negotiations where status = 'inbox' and vacancy_id = vacancies.id ) as count_responses  from vacancies where id = ? order by updated desc";
  my $vacancy = App::DB->select($query, $self->param('ID'))->[0];
  if ($status eq 'all') {
    $query = "select * from negotiations where vacancy_id = ? order by created desc";
  }
  else {
    $query = "select * from negotiations where vacancy_id = ? and status = ? order by created desc";
    push @param, $status;
  }
  my $negotiations = App::DB->select($query, @param);
  return $self->render( vacancy => $vacancy, negotiations => $negotiations);
}


1;
