package AppHH::HH::Conf;

sub get_conf {
	my %config = (
	client_id				=> 'K172TB7M5RTLQBTUMISDUI9VASC3TQK38L567CUIB7ULN2CRD0LC00HCGPF673TQ',
	secret_key				=> 'K1732BK1GP33A05UBEGVA930DNP0RQ1AFI3CA3R0HFV6J5B5H2SVAB7J1P8I3LAM',
	access_token_url			=> 'https://hh.ru/oauth/token',
	redirect_uri			=> 'http://localhost:3011/auth/'
	);
	return %config;
}



1;