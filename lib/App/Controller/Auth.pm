package App::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';
use App::HH::Conf;

my %data= App::HH::Conf->get_conf;

sub auth {
	my $self = shift;
	return 1 if ( $self->session( 'access_token') );
	$self->redirect_to('login');
}

sub create {
	my $self = shift;
	open FILE, '<', '../conf.txt';
	chomp (my @lines = <FILE>);
	close	FILE;
	$self->session (access_token	=> $lines[0]);
	if ( $self->session( 'access_token') ) {
		$self->redirect_to('show_vacancies');
	}
	else {
		$self->redirect_to( 'auth_form');
	}
}

sub form {
	my $self = shift;
	my $url = Mojo::URL->new( sprintf("https://hh.ru/oauth/authorize?response_type=code&client_id=%s&redirect_uri=%s", $data{client_id}, $data{redirect_uri} ) );
	$self->render(url => $url);
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
	$self->redirect_to('show_vacancies');
}

sub delete {
	my $self = shift;
	$self->session(expires => 1);
	$self->redirect_to( 'http://hh.ru/account/logout' );
}

1;
