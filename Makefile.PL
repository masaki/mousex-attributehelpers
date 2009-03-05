use inc::Module::Install;
name 'MouseX-AttributeHelpers';
all_from 'lib/MouseX/AttributeHelpers.pm';

requires 'Mouse' => '0.18';
requires 'Mouse::Meta::Attribute';

recommends 'Any::Moose' => '0.05';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'ok';
test_requires 'Test::Deep';
test_requires 'Test::Data::Scalar';
author_tests 'xt';
use_test_base;

auto_include_deps;
WriteAll;
