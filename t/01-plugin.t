#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

eval "use App::ZofCMS::Test::Plugin 0.0104;";
plan skip_all
=> "App::ZofCMS::Test::Plugin version 0.0104 is required for testing plugin"
    if $@;

plugin_ok(
    'NavMaker',
    {
        nav_maker => [
            [foo => 'bar'],
        ],
    },
);