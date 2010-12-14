
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Catch application errors and emit them somewhere',
  'AUTHOR' => 'Chisel Wright <chisel@chizography.net>',
  'BUILD_REQUIRES' => {},
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Catalyst-Plugin-ErrorCatcher',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Catalyst::Plugin::ErrorCatcher',
  'PREREQ_PM' => {
    'Catalyst' => '5.80',
    'Catalyst::Controller::MessageDriven' => '0',
    'Catalyst::Engine::Stomp' => '0.07',
    'Catalyst::Plugin::ErrorCatcher' => '0.0.7',
    'Catalyst::Plugin::StackTrace' => '0.10',
    'Catalyst::Runtime' => '5.80',
    'Data::Rx' => '0.007',
    'Data::Serializer' => '0.49',
    'Data::Serializer::JSON' => '0.03',
    'Data::Visitor' => '0.26',
    'DateTime' => '0.4304',
    'DateTime::Format::ISO8601' => '0.07',
    'File::Pid' => '1.01',
    'FindBin::libs' => '1.42',
    'JSON::Any' => '1.22',
    'Log::Log4perl' => '1.17',
    'Module::Pluggable' => '3.9',
    'Moose' => '0.93',
    'MooseX::Types' => '0.20',
    'Net::Stomp' => '0.38',
    'Path::Class' => '0.17',
    'Scalar::Util' => '1.19',
    'Test::Exception' => '0.27',
    'Test::More' => '0.92',
    'Test::UseAllModules' => '0.12',
    'Time::HiRes' => '1.86',
    'version' => '0.76'
  },
  'VERSION' => '0.0.8',
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



