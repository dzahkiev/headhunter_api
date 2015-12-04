package App::Controller::Vacancies;
use base 'Mojolicious::Controller';

sub list {
  my $self = shift;
  my $query =  "select *, (select count(*) from negotiations where status = 'inbox' and vacancy_id = vacancies.id ) as count_responses  from vacancies";
  my $vacancies = App::DB->select( $query );
  return $self->render( vacancies => $vacancies);
}


1;
