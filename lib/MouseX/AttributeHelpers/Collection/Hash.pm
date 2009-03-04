package MouseX::AttributeHelpers::Collection::Hash;

use Mouse;
use MouseX::AttributeHelpers::Collection::ImmutableHash;

extends 'MouseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        my $attr = MouseX::AttributeHelpers::Collection::ImmutableHash->meta->get_attribute('method_constructors');
        return +{
            %{ $attr->default->() }, # apply MouseX::AttributeHelpers::Collection::ImmutableHash

            set => sub {
                my ($attr, $name) = @_;
                return sub {
                    if (@_ == 3) {
                        $_[0]->$name()->{$_[1]} = $_[2];
                    }
                    else {
                        my $self = shift;
                        my (@k, @v);
                        while (@_) {
                            push @k, shift;
                            push @v, shift;
                        }
                        @{ $self->$name() }{@k} = @v;
                    }
                };
            },
            clear => sub {
                my ($attr, $name) = @_;
                return sub { %{ $_[0]->$name() } = () };
            },
            delete => sub {
                my ($attr, $name) = @_;
                return sub { delete @{ shift->$name() }{@_} };
            },
        };
    },
);

no Mouse;

package # hide from PAUSE
    Mouse::Meta::Attribute::Custom::Collection::Hash;
sub register_implementation { 'MouseX::AttributeHelpers::Collection::Hash' }

1;
