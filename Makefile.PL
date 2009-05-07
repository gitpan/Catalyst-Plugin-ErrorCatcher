# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name            'Catalyst-Plugin-ErrorCatcher';
version         '0.0.1';
all_from        'lib/Catalyst/Plugin/ErrorCatcher.pm';

# Specific dependencies
build_requires  'Test::More'            => '0.72';

requires(
    'Catalyst::Runtime'                 => 0,
    'version'                           => 0,   # core since 5.009
    'Class::Accessor::Fast'             => 0,
    'IO::File'                          => 0,
    'MRO::Compat'                       => 0,
    'Scalar::Util'                      => 0,
    'UNIVERSAL::can'                    => 0,
);

auto_install;
WriteAll;
