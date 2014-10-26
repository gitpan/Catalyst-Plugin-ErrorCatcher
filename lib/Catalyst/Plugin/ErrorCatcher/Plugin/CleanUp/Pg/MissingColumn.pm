package Catalyst::Plugin::ErrorCatcher::Plugin::CleanUp::Pg::MissingColumn;
{
  $Catalyst::Plugin::ErrorCatcher::Plugin::CleanUp::Pg::MissingColumn::VERSION = '0.0.8.13';
}
{
  $Catalyst::Plugin::ErrorCatcher::Plugin::CleanUp::Pg::MissingColumn::DIST = 'Catalyst-Plugin-ErrorCatcher';
}
use strict;
use warnings;

sub tidy_message {
    my $plugin      = shift;
    my $errstr_ref  = shift;

    # column XXX does not exist
    ${$errstr_ref} =~ s{
        \A
        .+?
        DBI \s Exception:
        .+?
        ERROR:\s+
        (column \s+ \S+ \s+ does \s+ not \s+ exist)
        \s+
        .+
        $
    }{$1}xmsg;

    $errstr_ref;
}

1;
# ABSTRACT: cleanup column XXX does not exist messages from Pg

__END__

=pod

=head1 NAME

Catalyst::Plugin::ErrorCatcher::Plugin::CleanUp::Pg::MissingColumn - cleanup column XXX does not exist messages from Pg

=head1 VERSION

version 0.0.8.13

=head1 AUTHOR

Chisel <chisel@chizography.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Chisel Wright.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
