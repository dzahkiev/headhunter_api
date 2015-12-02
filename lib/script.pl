#!/usr/bin/perl
use strict;
use lib::AppHH::HH::Api;
use lib::AppHH::DB;
use Mojo::UserAgent;

AppHH::DB->db_connect( 'test', 'localhost', '3306' );
AppHH::DB->create_table;

open FILE_INPUT, '<', 'lib/config/conf.txt';
chomp (my @lines = <FILE_INPUT>);
my $access;
$access->{access_token}  = $lines[0];
$access->{refresh_token} = $lines[1];
my %auth_header = ( Authorization => "Bearer $access->{access_token}" );

my $ua = Mojo::UserAgent->new;
my $res= $ua->get( "https://api.hh.ru/me" => { %auth_header } )->res;
if ( $res->code == 403 ) {
	$access = $ua->post( "https://hh.ru/oauth/token" => form => {
	grant_type 		=> 'refresh_token',
	refresh_token 	=> $access->{refresh_token}	 })->res->json;
	open	FILE, '>', 'lib/config/conf.txt';
	print	FILE $access->{access_token} . "\n";
	print	FILE $access->{refresh_token} . "\n";
	close	FILE;
}

my $employer_id	= $res->json->{employer}{id};
my $manager_id	= $res->json->{employer}{manager_id};
for my $type ( qw /active archived hidden/ ) {
	my $vacancies = AppHH::HH::Api->get_vacancies( $type, $employer_id, $manager_id, %auth_header );
	AppHH::DB->insert_vacancies( $type, $vacancies );
	for my $vacancy ( @$vacancies ) {
		for my $type ( qw /inbox hold invited discarded/ ) {
			my $negotiation = AppHH::HH::Api->get_negotiations( $type, $vacancy->{id}, %auth_header );
			AppHH::DB->insert_negotiation( $vacancy->{id}, $type, $negotiation ) if ( @$negotiation );
		}
	}
}