package App;
use Mojo::Base 'Mojolicious';
use App::DB;

sub startup {
	my $self = shift;

	my $r = $self->routes;
	$r->get('/auth')		->to('auth#callback')	->name('auth_user');
	$r->get('/login')		->to('auth#create')	->name('login');
	$r->get('/logout')		->to('auth#delete')	->name('logout');
	$r->get('/form')		->to('auth#form')	->name('auth_form');
	
	my $auth = $r->under( '/' )			->to('auth#auth')			->name('check_auth');
	$auth->get('/')					->to('vacancies#list')			->name('show_vacancies');
	$auth->post('/')					->to('vacancies#list')			->name('show_vacancies');
	$auth->get('/vacancies')			->to('vacancies#list')			->name('show_vacancies');
	$auth->post('/vacancies')			->to('vacancies#list')			->name('show_vacancies');
	$auth->get('/vacancies/:ID')			->to('vacancies#vacancy')			->name('show_vacancy');
	$auth->post('/vacancies/:ID')			->to('vacancies#vacancy')			->name('show_vacancy');
	$auth->get('/negotiations')			->to('negotiations#list')		->name('show_negotiations');
	$auth->post('/negotiations')			->to('negotiations#list')		->name('show_negotiations');
	$auth->get('/negotiations/:ID')			->to('negotiations#list')		->name('show_negotiations');
	$auth->post('/negotiations/:ID')			->to('negotiations#list')		->name('show_negotiations');
	$auth->get('/negotiation/:nID')			->to('negotiations#negotiation')		->name('show_negotiation');
	$auth->post('/negotiation/:nID/update')			->to('negotiations#update')		->name('update_negotiation');
	App::DB->db_connect( 'test', 'localhost', '3306' );
}

1;
