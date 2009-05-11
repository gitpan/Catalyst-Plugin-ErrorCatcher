# Load the Module::Install bundled in ./inc/
use inc::Module::Install '0.87';

# Define metadata
name            'Catalyst-Plugin-ErrorCatcher';
version         '0.0.2.2';
all_from        'lib/Catalyst/Plugin/ErrorCatcher.pm';

# Specific dependencies
build_requires(
    'Test::More'                        => '0.72',
    'Catalyst::Plugin::StackTrace'      => 0,
    'Catalyst::Test'                    => 0,
    'FindBin'                           => 0,
    'Catalyst::Runtime'                 => '5.71001',
);

requires(
    'Catalyst::Runtime'                 => '5.71001',
    'version'                           => 0,   # core since 5.009
    'Class::Data::Accessor'             => 0,
    'IO::File'                          => 0,
    'MRO::Compat'                       => 0,
    'UNIVERSAL::can'                    => 0,
);

recommends(
    'MIME::Lite'                        => '3.023',
);

auto_install;
WriteAll;
