package AppHH;
use Mojo::Base 'Mojolicious';


sub startup {
	my $self = shift;
	my $r = $self->routes;
	$r->get('/auth')					->to('auth#callback')				->name('auth_user');
	$r->get('/login')					->to('auth#login')					->name('auth_user');
	my $auth = $r->under( '/' )			->to('auth#login')					->name('auth_user');
	$auth->get('/vacancies/:type')		->to('vacancies#vacancies')			->name('get_vacancies');
	$auth->get('/vacancy/:ID')			->to('vacancies#vacancy')			->name('get_vacancy');
	$auth->get('/negotiations/:ID')		->to('vacancies#negotiations')		->name('get_negotiations');
}

1;
