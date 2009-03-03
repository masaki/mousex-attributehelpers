package MouseX::AttributeHelpers::Counter;

use Mouse;

extends 'MouseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        return +{
            reset => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($attr->default) };
            },
            set => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[1]) };
            },
            inc => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() + (defined $_[1] ? $_[1] : 1)) };
            },
            dec => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() - (defined $_[1] ? $_[1] : 1)) };
            },
        };
    },
);

no Mouse;

package # hide from PAUSE
    Mouse::Meta::Attribute::Custom::Counter;
sub register_implementation { 'MouseX::AttributeHelpers::Counter' }

1;
