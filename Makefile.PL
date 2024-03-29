
use strict;
use warnings;

use 5.008004;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Catch application errors and emit them somewhere",
  "AUTHOR" => "Chisel <chisel\@chizography.net>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Catalyst-Plugin-ErrorCatcher",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Catalyst::Plugin::ErrorCatcher",
  "PREREQ_PM" => {
    "Catalyst::ClassData" => 0,
    "Data::Dump" => 0,
    "DateTime" => 0,
    "File::Slurp" => 0,
    "File::Type" => 0,
    "IO::File" => 0,
    "MIME::Lite" => 0,
    "Module::Pluggable::Object" => 0,
    "Moose" => 0,
    "Path::Class" => 0,
    "Sys::Hostname" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Catalyst" => 0,
    "Catalyst::Controller" => 0,
    "Catalyst::Plugin::Authentication" => "0.10010",
    "Catalyst::Plugin::ConfigLoader" => "0.22",
    "Catalyst::Plugin::Session" => 0,
    "Catalyst::Plugin::Session::State::Cookie" => 0,
    "Catalyst::Plugin::Session::Store::File" => 0,
    "Catalyst::Plugin::StackTrace" => "0.10",
    "Catalyst::Runtime" => "5.80",
    "Catalyst::Test" => 0,
    "Config::General" => 0,
    "DateTime" => 0,
    "File::Find::Rule" => 0,
    "File::Path" => 0,
    "File::Slurp" => 0,
    "File::Spec::Functions" => 0,
    "FindBin::libs" => 0,
    "HTTP::Request::Common" => 0,
    "IO::File" => 0,
    "MIME::Lite" => 0,
    "MRO::Compat" => 0,
    "Path::Class" => 0,
    "Sys::Hostname" => 0,
    "Test::Exception" => 0,
    "Test::More" => "0.92",
    "Test::UseAllModules" => 0,
    "base" => 0,
    "namespace::autoclean" => 0,
    "overload" => 0,
    "version" => 0
  },
  "VERSION" => "0.0.8.15",
  "test" => {
    "TESTS" => "t/*.t t/bug/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

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



