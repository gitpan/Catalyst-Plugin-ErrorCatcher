
BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}

use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::NoTabsTests 0.05

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/Catalyst/Plugin/ErrorCatcher.pm',
    'lib/Catalyst/Plugin/ErrorCatcher/Email.pm',
    'lib/Catalyst/Plugin/ErrorCatcher/File.pm',
    'lib/Catalyst/Plugin/ErrorCatcher/Plugin/CleanUp/CaughtException.pm',
    'lib/Catalyst/Plugin/ErrorCatcher/Plugin/CleanUp/Pg/ForeignKeyConstraint.pm',
    'lib/Catalyst/Plugin/ErrorCatcher/Plugin/CleanUp/Pg/MissingColumn.pm',
    'lib/Catalyst/Plugin/ErrorCatcher/Plugin/CleanUp/Pg/TransactionAborted.pm',
    'lib/Catalyst/Plugin/ErrorCatcher/Plugin/CleanUp/Pg/UniqueConstraintViolation.pm',
    'lib/Catalyst/Plugin/ErrorCatcher/Plugin/CleanUp/TxnDo.pm'
);

notabs_ok($_) foreach @files;
done_testing;
