use inc::Module::Install;
name 'MouseX-AttributeHelpers';
all_from 'lib/MouseX/AttributeHelpers.pm';

# requires '';

# install_script '';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'ok';
author_tests 'xt';
use_test_base;

auto_include_deps;
WriteAll;
