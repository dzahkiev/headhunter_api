package App::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';
use App::HH::Conf;

my %data= App::HH::Conf->get_conf;

sub auth {
	my $self = shift;
	return 1 if ( $self->session('login') );
	$self->redirect_to('login');
}

sub create {
	my $self = shift;
	open FILE, '<', '../conf.txt';
	chomp (my @lines = <FILE>);
	close	FILE;
	if ( $lines[0] ) {
		if ($self->param('submit')) {
		my $login  = $self->param( 'email' );
		my $password = $self->param( 'password' );
		my $sth = App::DB->db->prepare("select * from users where email = ? and password = MD5(?)");
		$sth->execute($login, $password);
		my $res = $sth->fetchrow_hashref;
		if ( $res ) {
		$self->session ( login => $login );
		$self->redirect_to('show_vacancies');
			}
		} else {
			$self->redirect_to('login_form');
		}
	}
	else {
		$self->redirect_to( 'auth_form');
	}
}

sub form {
	my $self = shift;
	if ($self->param('submit')) {
	my $params = $self->req->params->to_hash;
	my $validator = Mojolicious::Validator->new;
	my $validation = $validator->validation;
	$validation->input( $params );
	$validation->required('email')->like( qr/^([a-z0-9_-]+\.*)*@[a-z0-9_-]+\.[a-z]{2,6}$/i );
	$validation->required('password')->like( qr/^[a-z0-9]{6,}$/i );
	if (! $validation->has_error) {
		my $sth = App::DB->db->prepare("insert into users set email = ?, password = MD5(?)");
		$sth->execute($self->param('email'), $self->param('password'));
		my $url = Mojo::URL->new( sprintf("https://hh.ru/oauth/authorize?response_type=code&client_id=%s&redirect_uri=%s", $data{client_id}, $data{redirect_uri} ) );
		$self->redirect_to($url);
	} else {
		return $self->render;
	}
}
	return $self->render;
}

sub callback {
	my $self = shift;
	my $access = $self->ua->post( $data{access_token_url} => form => {
		grant_type	=> 'authorization_code',
		client_id	=> $data{client_id},
		client_secret	=> $data{secret_key},
		code		=> $self->param( 'code' ),
		redirect_uri	=> $data{redirect_uri}		} )->res->json;
	$self->session (access_token	=> $access->{access_token});
	$self->session(expiration => $access->{expires_in});
	open	FILE, '>', '../conf.txt';
	print	FILE $access->{access_token} . "\n";
	print	FILE $access->{refresh_token} . "\n";
	close	FILE;
	$self->redirect_to('login');
}

sub delete {
	my $self = shift;
	$self->session(expires => 1);
	$self->redirect_to( 'login' );
}

1;