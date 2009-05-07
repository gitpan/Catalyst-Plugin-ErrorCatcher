package Catalyst::Plugin::ErrorCatcher;
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;
use 5.008001;
use base qw/Class::Accessor::Fast/;
use IO::File;
use Scalar::Util qw/blessed/;
use MRO::Compat;
use UNIVERSAL::can;

use version; our $VERSION = qv(0.0.1)->numify;

__PACKAGE__->mk_accessors(qw<_errorcatcher _errorcatcher_msg>);

sub setup {
    my $c = shift;

    # should we be replacing this?
    $c->maybe::next::method(@_);

    $c->config->{"Plugin::ErrorCatcher"}->{context} ||= 4;
    $c->config->{"Plugin::ErrorCatcher"}->{verbose} ||= 0;
}

# implementation borrowed from ABERLIN
sub finalize_error {
    my $c = shift;
    my $conf = $c->config->{"Plugin::ErrorCatcher"};

    # this should let ::StackTrace do some of our heavy-lifting
    # and prepare the Devel::StackTrace frames for us to re-use
    $c->maybe::next::method(@_);

    if (
        # we have an error
        $c->error
            and
        (
            # the config file insists we run
            defined $conf->{enable} && $conf->{enable}
                or
            # we're in debug mode
            !defined $conf->{enable} && $c->debug
        )
    ) {
        $c->my_finalize_error;
    }

    return;
}

sub my_finalize_error {
    my $c = shift;
    $c->_keep_frames;
    $c->_prepare_message;
    $c->_emit_message;
    return;
}

sub _emit_message {
    my $c = shift;
    my $emitted_count = 0;

    return
        unless defined($c->_errorcatcher_msg);

    # use a custom emit method?
    if (defined (my $emit_list = $c->config->{"Plugin::ErrorCatcher"}->{emit_module})) {
        my @emit_list;
        # one item or a list?
        if (defined ref($emit_list) and 'ARRAY' eq ref($emit_list)) {
            @emit_list = @{ $emit_list };
        }
        elsif (not ref($emit_list)) {
            @emit_list = ( $emit_list );
        }

        foreach my $emitter (@emit_list) {
            # require, and call methods
            my $emitted_ok = $c->_require_and_emit(
                $emitter, $c->_errorcatcher_msg
            );
            if ($emitted_ok) {
                $emitted_count++;
            }
        }
    }

    # by default use $c->log
    if (not $emitted_count) {
        $c->log->info(
            $c->_errorcatcher_msg
        );
    }

    return;
}

sub _require_and_emit {
    my $c = shift;
    my $emitter_name = shift;
    my $output = shift;

    # make sure our emitter loads
    eval "require $emitter_name";
    if ($@) {
        $c->log->error($@);
        return;
    }
    # make sure it "can" emit
    if ($emitter_name->can('emit')) {
        eval {
            $emitter_name->emit(
                $c, $output
            );
        };
        if ($@) {
            $c->log->error($@);
            return;
        }
        # we are happy when they emitted without incident
        return 1;
    }

    # default is, "no we didn't emit anything"
    return;
}

sub _cleaned_error_message {
    my $error_message = shift;

    # Caught exception ... ... line XX."
    $error_message =~ s{
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

    chomp $error_message;
    return $error_message;
}

sub _prepare_message {
    my $c = shift;
    my ($feedback, $full_error, $parsed_error);

    # get the (list of) error(s)
    for my $error (@{ $c->error }) {
        $full_error .= qq{$error\n\n};
    }
    # trim out some extra fluff from the full message
    $parsed_error = _cleaned_error_message($full_error);

    # A title for the feedback
    $feedback .= qq{Exception caught:\n};

    # the (parsed) error
    $feedback .= "\n  Error: " . $parsed_error . "\n";

    # general request information
    $feedback .= "   Time: " . scalar(localtime) . "\n";
    $feedback .= " Client: " . $c->request->address;
    $feedback .=        " (" . $c->request->hostname . ")\n";
    $feedback .= "  Agent: " . $c->request->user_agent . "\n";
    $feedback .= "    URI: " . $c->request->uri . "\n";
    $feedback .= " Method: " . $c->request->method . "\n";


    if ('ARRAY' eq ref($c->_errorcatcher)) {
        # push on information and context
        for my $frame ( @{$c->_errorcatcher} ) {
            # clean up the common filename of
            # .../MyApp/script/../lib/...
            if ( $frame->{file} =~ /../ ) {
                $frame->{file} =~ s{script/../}{};
            }

            my $pkg  = $frame->{pkg};
            my $line = $frame->{line};
            my $file = $frame->{file};
            my $code_preview = _print_context(
                $frame->{file},
                $frame->{line},
                $c->config->{"Plugin::ErrorCatcher"}->{context}
            );

            $feedback .= "\nPackage: $pkg\n   Line: $line\n   File: $file\n";
            $feedback .= "\n$code_preview\n";
        }
    }
    else {
        $feedback .= "\nStack trace unavailable - use and enable Catalyst::Plugin::StackTrace\n";
    }

    # in case we bugger up the s/// on the original error message
    if ($c->error) {
        $feedback .= "\nOriginal Error:\n\n$full_error";
    }

    # store it, otherwise we've done the above for mothing
    if (defined $feedback) {
        $c->_errorcatcher_msg($feedback);
    }

    return;
}

# we don't have to do much here now that we're relying on ::StackTrace to do
# the work for us
sub _keep_frames {
    my $c = shift;
    my $stacktrace;

    eval {
        $stacktrace = $c->_stacktrace;
    };

    if (defined $stacktrace) {
        $c->_errorcatcher( $stacktrace );
    }
    return;
}

# borrowed heavily from Catalyst::Plugin::StackTrace
sub _print_context {
    my ( $file, $linenum, $context ) = @_;

    my $code;
    if ( -f $file ) {
        my $start = $linenum - $context;
        my $end   = $linenum + $context;
        $start = $start < 1 ? 1 : $start;
        if ( my $fh = IO::File->new( $file, 'r' ) ) {
            my $cur_line = 0;
            while ( my $line = <$fh> ) {
                ++$cur_line;
                last if $cur_line > $end;
                next if $cur_line < $start;
                my @tag = $cur_line == $linenum ? ('-->', q{}) : (q{   }, q{});
                $code .= sprintf(
                    '%s%5d: %s%s',
                        $tag[0],
                        $cur_line,
                        $line ? $line : q{},
                        $tag[1],
                );
            }
        }
    }
    return $code;
}

1;
__END__

=pod

=head1 NAME

Catalyst::Plugin::ErrorCatcher - Catch application errors and emit them somewhere

=head1 SYNOPSIS

  use Catalyst qw/-Debug StackTrace ErrorCatcher/;

=head1 DESCRIPTION

This plugin allows you to do More Stuff with the information that would
normally only be seen on the Catalyst Error Screen courtesy of the
L<Catalyst::Plugin::StackTrace> plugin.

=head1 CONFIGURATION

The plugin is configured in a similar manner to other Catalyst plugins:

  <Plugin::ErrorCatcher>
    enabled     1
    context     5

    emit_module A::Module
  </Plugin::ErrorCatcher>

=over 4

=item B<enabled>

Setting this to I<true> forces the module to work its voodoo.

It's also enabled if the value is unset and you're running Catalyst in
debug-mode.

=item B<context>

When there is stack-trace information to share, how many lines of context to
show around the line that caused the error.

=item B<emit_module>

This specifies which module to use for custom output behaviour.

You can chain multiple modules by specifying a line in the config for each
module you'd like used:

    emit_module A::Module
    emit_module Another::Module
    emit_module Yet::Another::Module

If none are specified, or all that are specified fail, the default behaviour
is to log the prepared message at the INFO level via C<$c-E<gt>log()>.

For details on how to implement a custom emitter see L</"CUSTOM EMIT CLASSES">
in this documentation.

=back

=head1 CUSTOM EMIT CLASSES

A custom emit class takes the following format:

  package A::Module;
  # vim: ts=8 sts=4 et sw=4 sr sta
  use strict;
  use warnings;
  
  sub emit {
    my ($class, $c, $output) = @_;
  
    $c->log->info(
      'IGNORING OUTPUT FROM Catalyst::Plugin::ErrorCatcher'
    );
  
    return;
  }
  
  1;
  __END__

The only requirement is that you have a sub called C<emit>.

C<Catalyst::Plugin::ErrorCatcher> passes the following parameters in the call
to C<emit()>:

=over 4

=item B<$class>

The package name

=item B<$c>

A L<Context|Catalyst::Manual::Intro/"Context"> object

=item B<$output>

The processed output from C<Catalyst::Plugin::ErrorCatcher>

=back

If you want to use the original error message you should use:

  my @error = @{ $c->error };

You may use and abuse any Catalyst methods, or other Perl modules as you see
fit.

=head1 KNOWN ISSUES

B<This module has no tests!>

=head1 SEE ALSO

L<Catalyst>,
L<Catalyst::Plugin::StackTrace>


=head1 AUTHORS

Chisel Wright C<< <chisel@herlpacker.co.uk> >>

=head1 THANKS

The authors of L<Catalyst::Plugin::StackTrace>, from which a lot of
code was used.

Ash Berlin for guiding me in the right direction after a known hacky first
implementation.

=head1 COPYRIGHT

This program is free software, you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
