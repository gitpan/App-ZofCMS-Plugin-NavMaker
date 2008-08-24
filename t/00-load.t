#!/usr/bin/env perl

use Test::More tests => 2;

BEGIN {
    use_ok('HTML::Template');
	use_ok( 'App::ZofCMS::Plugin::NavMaker' );
}

diag( "Testing App::ZofCMS::Plugin::NavMaker $App::ZofCMS::Plugin::NavMaker::VERSION, Perl $], $^X" );
