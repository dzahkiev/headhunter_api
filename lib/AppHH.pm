package AppHH;
use Mojo::Base 'Mojolicious';
use AppHH::DB;

sub startup {
	my $self = shift;

	my $r = $self->routes;
	$r->get('/auth'	)	->to(	'auth#callback'	)	->name('auth_user');
	$r->get('/login')	->to(	'auth#login'	)	->name('login');
	$r->get('/logout')	->to(	'auth#delete'	)	->name('logout');
	$r->get('/form'	)	->to(	'auth#form'	)		->name('auth_form');
	my $auth = $r->under( '/' )->to('auth#login')	->name('login');

	$auth->get('/')									->to('vacancies#vacancies')			->name('show_vacancies');
	$auth->get('/vacancies')						->to('vacancies#vacancies')			->name('show_vacancies');
	$auth->get('/negotiations')						->to('vacancies#negotiations')		->name('show_negotiations');
	$auth->get('/negotiations/:ID')					->to('vacancies#negotiations')		->name('show_negotiations');
	$auth->get('/negotiations/:ID/:editID')			->to('vacancies#negotiations')		->name('show_negotiations');
	$auth->post('/negotiations/:ID/:editID/save')	->to('vacancies#save_negotiation')	->name('save_negotiation');

	AppHH::DB->db_connect( 'test', 'localhost', '3306' );
}

1;
