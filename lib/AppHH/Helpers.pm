
package AppHH::Helpers;
use base 'Mojolicious::Plugin';

sub  register {
  my ($self, $app) = @_;

  $app->helper( auth_header => sub {
    my $self  = shift;
    my %header  =  ( { Authorization => $self->session('token_type') ." ". $self->session('access_token') } );
  });

$app->helper( make_url => sub {
    my ( $self, $path, $query ) = @_;
    my $url = Mojo::URL->new;
    $url->scheme( 'https' );
    $url->host( 'api.hh.ru' );
    $url->path( $path );
    $url->query( $query );
    return $url->to_string;
  });

}

1;