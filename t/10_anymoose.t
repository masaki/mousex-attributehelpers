use Test::More;
use Test::Deep;

eval "use Any::Moose 0.05";
plan skip_all => "Any::Moose 0.05 required for testing" if $@;
plan tests => 19;

{
    package MyClass;
    BEGIN { $ENV{ANY_MOOSE} = 'Mouse' }

    use Any::Moose;
    use Any::Moose 'X::AttributeHelpers';

    has 'config' => (
        metaclass => 'Collection::Hash',
        is        => 'rw',
        isa       => 'HashRef',
        default   => sub { +{} },
        provides  => {
            exists => 'has_config_for',
            get    => 'get_config_for',
            set    => 'set_config_for',
            delete => 'delete_config_for',
            count  => 'num_configs',
            empty  => 'has_configs',
        },
    );

    has 'plugins' => (
        metaclass => 'Collection::Array',
        is        => 'rw',
        isa       => 'ArrayRef',
        default   => sub { [] },
        provides  => {
            push    => 'add_plugins',
            clear   => 'clear_plugins',
            count   => 'num_plugins',
            empty   => 'has_plugins',
            grep    => 'plugins_for',
        },
    );
}

is ref(MyClass->meta) => 'Mouse::Meta::Class', 'Any::Moose uses Mouse';

my $obj = MyClass->new(
    config  => { foo => 1, bar => 2, baz => 3 },
    plugins => [qw(Foo Bar Baz)],
);

# Collection::Hash
ok $obj->has_configs, 'hash empty ok';
is $obj->num_configs => 3, 'hash count ok';

is $obj->get_config_for('foo') => 1, 'hash get ok';
is $obj->get_config_for('bar') => 2, 'hash get ok';
is $obj->get_config_for('baz') => 3, 'hash get ok';

ok $obj->has_config_for('foo'), 'hash exists ok';
ok !$obj->has_config_for('quux'), 'hash exists ok, not exist keys';

$obj->set_config_for(foo => 100);
is $obj->get_config_for('foo') => 100, 'hash set and get ok';

$obj->delete_config_for('foo');
is $obj->num_configs => 2, 'hash delete and count ok';
ok !$obj->has_config_for('foo'), 'hash delete and exists ok';
ok $obj->has_config_for('bar'), 'hash delete and exists ok';
ok $obj->has_config_for('baz'), 'hash delete and exists ok';

# Collection::Array
ok $obj->has_plugins, 'array empty ok';
is $obj->num_plugins => 3, 'array count ok';

$obj->add_plugins('Quux');
is $obj->num_plugins => 4, 'array push ok';

cmp_deeply [ $obj->plugins_for(sub { /^B/ }) ] => [qw(Bar Baz)], 'array grep ok';

$obj->clear_plugins;
ok !$obj->has_plugins, 'array clear and empty ok';
is $obj->num_plugins => 0, 'array clear and count ok';
