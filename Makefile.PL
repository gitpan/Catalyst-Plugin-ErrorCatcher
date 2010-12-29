
use strict;
use warnings;

BEGIN { require 5.008001; }

use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Catch application errors and emit them somewhere',
  'AUTHOR' => 'Chisel Wright <chisel@chizography.net>',
  'BUILD_REQUIRES' => {
    'Catalyst' => '0',
    'Catalyst::Controller' => '0',
    'Catalyst::Plugin::Authentication' => '0',
    'Catalyst::Plugin::ConfigLoader' => '0',
    'Catalyst::Plugin::StackTrace' => '0',
    'Catalyst::Test' => '0',
    'DateTime' => '0',
    'File::Find::Rule' => '0',
    'File::Path' => '0',
    'File::Slurp' => '0',
    'FindBin' => '0',
    'IO::File' => '0',
    'MIME::Lite' => '0',
    'MRO::Compat' => '0',
    'Moose' => '0',
    'Path::Class' => '0',
    'Sys::Hostname' => '0',
    'Test::More' => '0.92',
    'overload' => '0',
    'version' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Catalyst-Plugin-ErrorCatcher',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Catalyst::Plugin::ErrorCatcher',
  'PREREQ_PM' => {
    'Class::Data::Accessor' => '0',
    'DateTime' => '0',
    'File::Slurp' => '0',
    'IO::File' => '0',
    'MIME::Lite' => '0',
    'MRO::Compat' => '0',
    'Path::Class' => '0',
    'Sys::Hostname' => '0'
  },
  'VERSION' => '0.0.8.3',
  'test' => {
    'TESTS' => 't/*.t t/bug/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



