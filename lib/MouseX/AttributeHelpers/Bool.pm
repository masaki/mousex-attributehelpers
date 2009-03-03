package MouseX::AttributeHelpers::Bool;

use Mouse;

extends 'MouseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        return +{
            set => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name(1) };
            },
            unset => sub  {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name(0) };
            },
            toggle => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name(!$_[0]->$name()) };
            },
            not => sub {
                my ($attr, $name) = @_;
                return sub { !$_[0]->$name() };
            },
        };
    },
);

no Mouse;

package # hide from PAUSE
    Mouse::Meta::Attribute::Custom::Bool;
sub register_implementation { 'MouseX::AttributeHelpers::Bool' }

1;
