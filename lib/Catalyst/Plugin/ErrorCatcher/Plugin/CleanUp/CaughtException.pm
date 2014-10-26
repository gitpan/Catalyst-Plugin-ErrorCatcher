package Catalyst::Plugin::ErrorCatcher::Plugin::CleanUp::CaughtException;
{
  $Catalyst::Plugin::ErrorCatcher::Plugin::CleanUp::CaughtException::VERSION = '0.0.8.10';
}
{
  $Catalyst::Plugin::ErrorCatcher::Plugin::CleanUp::CaughtException::DIST = 'Catalyst-Plugin-ErrorCatcher';
}
use strict;
use warnings;

sub tidy_message {
    my $plugin      = shift;
    my $errstr_ref  = shift;

    ${$errstr_ref} =~ s{
        Caught\s+exception\s+in\s+
        \S+\s+
        "
        (.+?)
        \s+at\s+
        \S+
        \s+
        line
        \s+
        .*
        "
        $
    }{$1}xmsg;

    $errstr_ref;
}

1;
# ABSTRACT: cleanup caught exception messages from Pg

__END__
=pod

=head1 NAME

Catalyst::Plugin::ErrorCatcher::Plugin::CleanUp::CaughtException - cleanup caught exception messages from Pg

=head1 VERSION

version 0.0.8.10

=head1 AUTHOR

Chisel <chisel@chizography.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Chisel Wright.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

