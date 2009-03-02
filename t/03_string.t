use Test::More tests => 19;
use Test::Deep;

do {
    package MyClass;
    use Mouse;
    use MouseX::AttributeHelpers;

    has 'string' => (
        metaclass => 'String',
        is        => 'rw',
        isa       => 'Str',
        default   => '',
        provides => {
            inc     => 'inc_string',
            append  => 'append_string',
            prepend => 'prepend_string',
            match   => 'match_string',
            replace => 'replace_string',
            chop    => 'chop_string',
            chomp   => 'chomp_string',
            clear   => 'clear_string',
        },
    );
};

my $obj = MyClass->new;

my @providers = qw(
    inc_string append_string prepend_string match_string
    replace_string chop_string chomp_string clear_string
);
for my $provider (@providers) {
    can_ok $obj => $provider;
}


is $obj->string => '', 'get default value ok';

$obj->string('a');
$obj->inc_string;
is $obj->string => 'b', 'increment string ok';

$obj->inc_string;
is $obj->string => 'c', 'increment string again ok';

$obj->append_string("foo$/");
is $obj->string => "cfoo$/", 'append string ok';

$obj->chomp_string;
is $obj->string => 'cfoo', 'chomp string ok';

$obj->chomp_string;
is $obj->string => 'cfoo', 'chomp is noop';

$obj->chop_string;
is $obj->string => 'cfo', 'chop string ok';

$obj->prepend_string('bar');
is $obj->string => 'barcfo', 'prepend string ok';

cmp_deeply [ $obj->match_string(qr/([ao])/) ] => [ 'a' ], 'match string ok';

$obj->replace_string(qr/([ao])/ => sub { uc($1) });
is $obj->string => 'bArcfo', 'replace string ok';

$obj->clear_string;
is $obj->string => '', 'clear string ok';
