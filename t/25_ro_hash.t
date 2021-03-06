use Test::More tests => 74;
use Test::Deep;
use Test::Data::Scalar;

{
    package MyClass;
    use Mouse;
    use MouseX::AttributeHelpers;

    has 'options' => (
        metaclass => 'Collection::Hash',
        is        => 'ro',
        isa       => 'HashRef',
        default   => sub { +{} },
        provides  => {
            exists => 'has_option_for',
            get    => 'get_option',
            keys   => 'option_keys',
            values => 'option_values',
            kv     => 'each_options',
            count  => 'num_options',
            empty  => 'has_options',
            set    => 'set_option',
            clear  => 'clear_options',
            delete => 'delete_option',
        },
        curries   => {
            set => { set_quantity => ['quantity'] },
        }
    );

    package MyImmutableClass;
    use Mouse;
    use MouseX::AttributeHelpers;

    has 'options' => (
        metaclass => 'Collection::Hash',
        is        => 'ro',
        isa       => 'HashRef',
        default   => sub { +{} },
        provides  => {
            exists => 'has_option_for',
            get    => 'get_option',
            keys   => 'option_keys',
            values => 'option_values',
            kv     => 'each_options',
            count  => 'num_options',
            empty  => 'has_options',
            set    => 'set_option',
            clear  => 'clear_options',
            delete => 'delete_option',
        },
        curries   => {
            set => { set_quantity => ['quantity'] },
        }
    );

    no Mouse;
    __PACKAGE__->meta->make_immutable;
}

for my $class (qw/MyClass MyImmutableClass/) {
    my $obj = $class->new(
        options => {
            foo => 1,
            bar => 2,
            baz => 3,
        },
    );

    my @providers = qw(
        has_option_for get_option option_keys option_values
        each_options num_options has_options

        set_option clear_options delete_option
    );
    for my $method (@providers) {
        can_ok $obj => $method;
    }

    my @curries = qw(set_quantity);
    for my $method (@curries) {
        can_ok $obj => $method;
    }

    cmp_deeply $obj->options => { foo => 1, bar => 2, baz => 3 }, 'get value ok, no options yet';

    # provides (Collection::ImmutableHash)
    ok $obj->has_options, 'provides empty ok';
    is $obj->num_options => 3, 'provides count ok, we have three options';

    is $obj->get_option('foo') => 1, 'provides get ok';
    is $obj->get_option('bar') => 2, 'provides get ok';
    is $obj->get_option('baz') => 3, 'provides get ok';
    cmp_deeply [ sort $obj->option_keys ] => [qw(bar baz foo)], 'provides keys ok';
    cmp_deeply [ sort $obj->option_values ] => [qw(1 2 3)], 'provides values ok';

    for my $kv ($obj->each_options) {
        ref_type_ok $kv => [], 'provides kv ok, type';
        my ($k, $v) = @$kv;
        like $k => qr/^(?:foo|bar|baz)$/, 'provides kv ok, key';
        like $v => qr/^[1-3]$/, 'provides kv ok, value';
    }

    ok $obj->has_option_for('foo'), 'provides exists ok';
    ok !$obj->has_option_for('quux'), 'provides exists ok, not exist keys';

    # provides
    $obj->set_option(foo => 100);
    is $obj->get_option('foo') => 100, 'provides set and get ok';

    $obj->delete_option('foo', 'bar');
    is $obj->num_options => 1, 'provides delete and count ok';
    ok !$obj->has_option_for('foo'), 'provides delete and exists ok';
    ok !$obj->has_option_for('bar'), 'provides delete and exists ok';
    ok $obj->has_option_for('baz'), 'provides delete and exists ok';

    $obj->clear_options;
    ok !$obj->has_options, 'provides empty ok';
    is $obj->num_options => 0, 'provides clear ok, we have no option';
}
