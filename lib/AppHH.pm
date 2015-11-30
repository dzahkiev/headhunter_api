package AppHH;
use Mojo::Base 'Mojolicious';
use AppHH::DB;
use AppHH::RefreshVac;

sub startup {
	my $self = shift;

	$self->plugin('AppHH::Helpers');

	my $r = $self->routes;
	$r->get('/auth')		->to('auth#callback')		->name('auth_user');
	$r->get('/login')		->to('auth#login')		->name('login');
	my $auth = $r->under( '/' )	->to('auth#login')		->name('login');
	$auth->get('/vacancies')	->to('vacancies#rec__db')	->name('rec_db');

	AppHH::DB->db_connect( 'test', 'localhost', '3306' );
}

1;
