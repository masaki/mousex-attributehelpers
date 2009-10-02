use inc::Module::Install;
name 'MouseX-AttributeHelpers';
all_from 'lib/MouseX/AttributeHelpers.pm';

requires 'Mouse' => '0.37';
requires 'Mouse::Meta::Attribute';
requires 'Mouse::Util::TypeConstraints';

recommends 'Class::Method::Modifiers::Fast';

tests 't/*.t';
test_requires 'Any::Moose' => '0.10';
test_requires 'Test::More';
test_requires 'Test::UseAllModules';
test_requires 'Test::Deep';
test_requires 'Test::Data::Scalar';
author_tests 'xt';

use_test_base;

include_deps 'Test::More';
include_deps 'Test::UseAllModules';
include_deps 'Test::Deep';
include_deps 'Test::Data::Scalar';

WriteAll;
