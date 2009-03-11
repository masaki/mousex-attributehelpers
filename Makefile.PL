use inc::Module::Install;
name 'MouseX-AttributeHelpers';
all_from 'lib/MouseX/AttributeHelpers.pm';

requires 'Mouse' => '0.19';
requires 'Mouse::Meta::Attribute';
requires 'Mouse::Util::TypeConstraints';
requires 'Class::Method::Modifiers';

recommends 'Any::Moose' => '0.05';
recommends 'Class::Method::Modifiers::Fast';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'Test::UseAllModules';
test_requires 'Test::Deep';
test_requires 'Test::Data::Scalar';
author_tests 'xt';
use_test_base;

auto_include_deps;
WriteAll;
