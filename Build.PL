use Module::Build;

Module::Build->new(
	module_name        => 'WWW::Live365',
	license            => 'perl',
	build_requires     => {
		'Test::More'            => 0,
		'Test::Pod'             => 1,
		'Test::Pod::Coverage'   => 0,
		'Test::Without::Module' => 0,
		'Net::Ping::External'   => 0,
	},
	requires => {
		'WWW::Mechanize'      => 0,
	},
	dist_version_from  => 'lib/WWW/Live365.pm',
	create_makefile_pl => 'traditional',
)->create_build_script();