use Test::More tests => 16;

do {
    package MyClass;
    use Mouse;
    use MouseX::AttributeHelpers;

    has 'integer' => (
        metaclass => 'Number',
        is        => 'rw',
        isa       => 'Int',
        default   => 5,
        provides  => {
            set => 'set',
            add => 'add',
            sub => 'sub',
            mul => 'mul',
            div => 'div',
            mod => 'mod',
            abs => 'abs',
        },
    );
};

my $obj = MyClass->new;

my @providers = qw(set add sub mul div mod abs);
for my $provider (@providers) {
    can_ok $obj => $provider;
}

is $obj->integer => 5, 'get default value ok';

$obj->add(10);
is $obj->integer => 15, 'add ok';

$obj->sub(3);
is $obj->integer => 12, 'subtract ok';

$obj->set(10);
is $obj->integer => 10, 'set value ok';

$obj->div(2);
is $obj->integer => 5, 'divide ok';

$obj->mul(2);
is $obj->integer => 10, 'multiplied ok';

$obj->mod(2);
is $obj->integer => 0, 'mod ok';

$obj->set(7);
$obj->mod(5);
is $obj->integer => 2, 'set and mod ok';

$obj->set(-1);
$obj->abs;
is $obj->integer => 1, 'abs ok';
