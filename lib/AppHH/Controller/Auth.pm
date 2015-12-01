package AppHH::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';

has client_id				=> 'K172TB7M5RTLQBTUMISDUI9VASC3TQK38L567CUIB7ULN2CRD0LC00HCGPF673TQ';
has secret_key				=> 'K1732BK1GP33A05UBEGVA930DNP0RQ1AFI3CA3R0HFV6J5B5H2SVAB7J1P8I3LAM';
has access_token_url			=> 'https://hh.ru/oauth/token';
has redirect_uri			=> 'http://localhost:3010/auth/';

sub login {
	my $self = shift;
	return 1 if ( $self->session( 'access_token') );
	my $url = Mojo::URL->new( sprintf("https://hh.ru/oauth/authorize?response_type=code&client_id=%s&redirect_uri=%s", $self->client_id, $self->redirect_uri ) );
	$self->redirect_to( $url );
}

sub callback {
	my $self = shift;
	my $access = $self->ua->post( $self->access_token_url => form => {
		grant_type	=> 'authorization_code',
		client_id	=> $self->client_id,
		client_secret	=> $self->secret_key,
		code		=> $self->param( 'code' ),
		redirect_uri	=> $self->redirect_uri		})->res->json;
	$self->session ({
		access_token	=> $access->{access_token},
		expires_in	=> $access->{expires_in},
		refresh_token	=> $access->{refresh_token},
		token_type	=> "\u$access->{token_type}"	});
	open	FILE, '>', 'lib/config/conf.txt';
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
