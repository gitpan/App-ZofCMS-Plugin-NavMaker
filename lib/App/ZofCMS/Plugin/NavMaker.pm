package App::ZofCMS::Plugin::NavMaker;

use warnings;
use strict;

our $VERSION = '0.0102';

use HTML::Template;

sub new { bless {}, shift }

sub process {
    my ( $self, $template, $query, $config ) = @_;

    return
        unless $template->{nav_maker};

    my $nav = delete $template->{nav_maker};

    my $html_template
    = HTML::Template->new_scalar_ref( \ $self->_get_html_template );

    for ( @$nav ) {
        next if ref;
        $_ = [ $_ ];
    }

    $html_template->param(
        nav => [
            map +{
                text    => $_->[0],
                title   => (defined $_->[2] ? $_->[2] : "Visit $_->[0]"),
                href    => (
                    defined $_->[1] ? $_->[1] : $self->_make_href( $_->[0] )
                ),
                id      => (
                    defined $_->[3]
                    ? $_->[3]
                    : $self->_make_id( $_->[0] )
                ),
            }, @$nav
        ],
    );

    $template->{t}{nav_maker} = $html_template->output;
    return 1;
}

sub _make_href {
    my ( $self, $text ) = @_;
    $text =~ s/[\W_]/-/g;
    return lc "/$text";
}

sub _make_id {
    my ( $self, $text ) = @_;
    $text =~ s/\W/_/g;
    return lc "nav_$text";
}

sub _get_html_template {
    return <<'END';
<ul id="nav"><tmpl_loop name="nav">
        <li id="<tmpl_var escape="html" name="id">"><a href="<tmpl_var escape="html" name="href">" title="<tmpl_var escape="html" name="title">"><tmpl_var escape="html" name="text"></a></li></tmpl_loop>
</ul>
END
}

1;
__END__

=head1 NAME

App::ZofCMS::Plugin::NavMaker - ZofCMS plugin for making navigation bars

=head1 SYNOPSIS

In your ZofCMS Template:

    nav_maker => [
        qw/Foo Bar Baz/,
        [ qw(Home /home) ],
        [ qw(Music /music) ],
        [ qw(foo /foo-bar-baz), 'This is the title=""', 'this_is_id' ],
    ],
    plugins => [ qw/NavMaker/ ],

In your L<HTML::Template> template:

    <tmpl_var name="nav_maker">

Produces this code:

    <ul id="nav">
            <li id="nav_foo"><a href="/foo" title="Visit Foo">Foo</a></li>
            <li id="nav_bar"><a href="/bar" title="Visit Bar">Bar</a></li>
            <li id="nav_baz"><a href="/baz" title="Visit Baz">Baz</a></li>
            <li id="nav_home"><a href="/home" title="Visit Home">Home</a></li>
            <li id="nav_music"><a href="/music" title="Visit Music">Music</a></li>
            <li id="this_is_id"><a href="/foo-bar-baz" title="This is the title=&quot;&quot;">foo</a></li>
    </ul>

=head1 DESCRIPTION

The plugin doesn't do much but after writing HTML code for hundreds of
navigation bars I was fed up... and released this tiny plugin.

This documentation assumes you've read L<App::ZofCMS>,
L<App::ZofCMS::Config> and L<App::ZofCMS::Template>

=head1 FIRST LEVEL ZofCMS TEMPLATE KEYS

=head2 C<plugins>

    plugins => [ qw/NavMaker/ ],

The obvious one is that you'd want to add C<NavMaker> into the list of
your plugins.

=head2 C<nav_maker>

    nav_maker => [
        qw/Foo Bar Baz/,
        [ qw(Home /home) ],
        [ qw(Music /music) ],
        [ qw(foo /foo-bar-baz), 'This is the title=""', 'this_is_id' ],
    ],

Takes an arrayref as a value elements of which can either be strings
or arrayrefs, element which is a string is the same as an arrayref with just
that string as an element. Each of those arrayrefs can contain from one
to four elements. They are interpreted as follows:

=head3 first element

    nav_maker => [ qw/Foo Bar Baz/ ],

    # same as

    nav_maker => [
        [ 'Foo' ],
        [ 'Bar' ],
        [ 'Baz' ],
    ],

B<Mandatory>. Specifies the text to use for the link.

=head3 second element

    nav_maker => [
        [ Foo => '/foo' ],
    ],

B<Optional>. Specifies the C<href=""> attribute for the link. If not
specified will be calculated from the first element (the text for the link)
in the following way:

    $text =~ s/[\W_]/-/g;
    return lc "/$text";

=head3 third element

    nav_maker => [
        [ 'Foo', '/foo', 'Title text' ],
    ],

B<Optional>. Specifies the C<title=""> attribute for the link. If not
specified the first element (the text for the link) will be used for the
title with word C<Visit > prepended.

=head3 fourth element

    nav_maker => [
        [ 'Foo', '/foo', 'Title text', 'id_of_the_li' ]
    ],

B<Optional>. Specifies the C<id=""> attribute for the C<< <li> >> element
of this navigation bar item. If not specified will be calculated from the
first element (the text of the link) in the following way:

    $text =~ s/\W/_/g;
    return lc "nav_$text";

=head1 USED HTML::Template VARIABLES

=head2 C<nav_maker>

    <tmpl_var name="nav_maker">

Plugin sets C<nav_maker> key in C<{t}> ZofCMS template special key, to
the generated HTML code, simply stick C<< <tmpl_var name="nav_maker"> >>
whereever you wish to have your navigation.

=head1 AUTHOR

Zoffix Znet, C<< <zoffix at cpan.org> >>
(L<http://zoffix.com>, L<http://haslayout.net>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-zofcms-plugin-navmaker at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-ZofCMS-Plugin-NavMaker>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::ZofCMS::Plugin::NavMaker

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-ZofCMS-Plugin-NavMaker>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-ZofCMS-Plugin-NavMaker>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-ZofCMS-Plugin-NavMaker>

=item * Search CPAN

L<http://search.cpan.org/dist/App-ZofCMS-Plugin-NavMaker>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 Zoffix Znet, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

