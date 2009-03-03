package MouseX::AttributeHelpers::Number;

use Mouse;

extends 'MouseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        return +{
            set => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[1]) };
            },
            add => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() + $_[1]) };
            },
            sub => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() - $_[1]) };
            },
            mul => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() * $_[1]) };
            },
            div => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() / $_[1]) };
            },
            mod => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() % $_[1]) };
            },
            abs => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name(abs $_[0]->$name()) };
            },
        };
    },
);

no Mouse;

package # hide from PAUSE
    Mouse::Meta::Attribute::Custom::Number;
sub register_implementation { 'MouseX::AttributeHelpers::Number' }

1;
