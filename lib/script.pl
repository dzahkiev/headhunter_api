#!/usr/bin/perl
use strict;
use warnings;
use lib::AppHH::HH::Api;
use lib::AppHH::DB;
use feature qw( switch say );

AppHH::DB->db_connect( 'test', 'localhost', '3306' );
AppHH::DB->create_table;

open FILE_INPUT, "< lib/config/conf.txt";
chomp (my @lines = <FILE_INPUT>);
my $access_tocken  = $lines[0];
my %auth_header = ( Authorization => "Bearer $access_tocken" );

for my $type ( qw /active archived hidden/ ) {
	my $vacancies = AppHH::HH::Api->get_vacancies( $type, %auth_header );
	AppHH::DB->insert_vacancies( $type, $vacancies );
	for my $vacancy ( @$vacancies ) {
		for my $type ( qw /inbox hold invited discarded/ ) {
			my $negotiation = AppHH::HH::Api->get_negotiations( $type, $vacancy->{id}, %auth_header );
			AppHH::DB->insert_negotiation( $vacancy->{id}, $type, $negotiation ) if ( defined @$negotiation );
		}
	}
}
