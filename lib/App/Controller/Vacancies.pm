package App::Controller::Vacancies;
use base 'Mojolicious::Controller';

sub list {
	my $self = shift;
	my $query =  "select *, (select count(*) from negotiations where status = 'inbox' and vacancy_id = vacancies.id ) as count_responses from vacancies where status = ? order by updated desc";
	my $status = $self->param('status') || 'active';
	my $vacancies = App::DB->select( $query, $status );
	return $self->render( vacancies => $vacancies);
}

sub vacancy {
  my $self = shift;
  my $query =  "select *, (select count(*) from negotiations where status = 'inbox' and vacancy_id = vacancies.id ) as count_responses  from vacancies where id = ? order by updated desc";
  my $vacancy = App::DB->select($query, $self->param('ID'))->[0];
  $query = "select * from negotiations where vacancy_id = ? and status = ?";
  my $negotiations = App::DB->select( $query, $self->param('ID'), $self->param('status')||'invited');
  return $self->render( vacancy => $vacancy, negotiations => $negotiations);
}


1;
