package AppHH;
use Mojo::Base 'Mojolicious';
use AppHH::DB;

sub startup {
	my $self = shift;

	$self->plugin('AppHH::Helpers');

	my $r = $self->routes;
	$r->get('/auth')		->to('auth#callback')		->name('auth_user');
	$r->get('/login')		->to('auth#login')		->name('login');
	$r->get('/')	->to('vacancies#vacancies')->name('show_vacancies');
	$r->get('/vacancies')	->to('vacancies#vacancies')->name('show_vacancies');
	$r->get('/negotiations')	->to('vacancies#negotiations')->name('show_negotiations');
	my $auth = $r->under( '/' )	->to('auth#login')		->name('login');
	$auth->get('/vacancies')	->to('vacancies#rec__db')	->name('rec_db');

	AppHH::DB->db_connect( 'test', 'localhost', '3306' );
}

1;
