package MouseX::AttributeHelpers::Collection::Array;

use Mouse;
use MouseX::AttributeHelpers::Collection::List;

extends 'MouseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        my $attr = MouseX::AttributeHelpers::Collection::List->meta->get_attribute('method_constructors');
        return +{
            %{ $attr->default->() }, # apply MouseX::AttributeHelpers::Collection::List
            push => sub {
                my ($attr, $name) = @_;
                return sub { CORE::push @{ CORE::shift->$name() } => @_ };
            },
            pop => sub {
                my ($attr, $name) = @_;
                return sub { CORE::pop @{ $_[0]->$name() } };
            },
            unshift => sub {
                my ($attr, $name) = @_;
                return sub { CORE::unshift @{ CORE::shift->$name() } => @_ };
            },
            shift => sub {
                my ($attr, $name) = @_;
                return sub { CORE::shift @{ $_[0]->$name() } };
            },
            get => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name()->[$_[1]] };
            },
            set => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name()->[$_[1]] = $_[2] };
            },
            clear => sub {
                my ($attr, $name) = @_;
                return sub { @{ $_[0]->$name() } = () };
            },
            delete => sub {
                my ($attr, $name) = @_;
                return sub { CORE::splice @{ $_[0]->$name() }, $_[1], 1 };
            },
            insert => sub {
                my ($attr, $name) = @_;
                return sub { CORE::splice @{ $_[0]->$name() }, $_[1], 0, $_[2] };
            },
            splice => sub {
                my ($attr, $name) = @_;
                return sub {
                    my ($self, $offset, $length, @args) = @_;
                    CORE::splice @{ $self->$name() }, $offset, $length, @args;
                };
            },
        };
    },
);

no Mouse;

package # hide from PAUSE
    Mouse::Meta::Attribute::Custom::Collection::Array;
sub register_implementation { 'MouseX::AttributeHelpers::Collection::Array' }

1;
