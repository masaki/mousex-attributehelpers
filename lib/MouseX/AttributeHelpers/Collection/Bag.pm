package MouseX::AttributeHelpers::Collection::Bag;

use Mouse;
use MouseX::AttributeHelpers::Collection::ImmutableHash;

extends 'MouseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        my $attr = MouseX::AttributeHelpers::Collection::ImmutableHash->meta->get_attribute('method_constructors');
        return +{
            %{ $attr->default->() }, # apply MouseX::AttributeHelpers::Collection::ImmutableHash

            add => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name()->{$_[1]}++ };
            },
            delete => sub {
                my ($attr, $name) = @_;
                return sub { delete $_[0]->$name()->{$_[1]} };
            },
            reset => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name()->{$_[1]} = 0 };
            },
        };
    },
);

no Mouse;

package # hide from PAUSE
    Mouse::Meta::Attribute::Custom::Collection::Bag;
sub register_implementation { 'MouseX::AttributeHelpers::Collection::Bag' }

1;
