package MouseX::AttributeHelpers::Collection::List;

use Mouse;

extends 'MouseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        return +{
            count => sub {
                my ($attr, $name) = @_;
                return sub { scalar @{ $_[0]->$name() } };
            },
            empty => sub {
                my ($attr, $name) = @_;
                return sub { scalar @{ $_[0]->$name() } ? 1 : 0 };
            },
            find => sub {
                my ($attr, $name) = @_;
                return sub {
                    for my $v (@{ $_[0]->$name() }) {
                        return $v if $_[1]->($v);
                    }
                    return;
                };
            },
            map => sub {
                my ($attr, $name) = @_;
                return sub { map { $_[1]->($_) } @{ $_[0]->$name() } };
            },
            grep => sub {
                my ($attr, $name) = @_;
                return sub { grep { $_[1]->($_) } @{ $_[0]->$name() } };
            },
            elements => sub {
                my ($attr, $name) = @_;
                return sub { @{ $_[0]->$name() } };
            },
            join => sub {
                my ($attr, $name) = @_;
                return sub { join $_[1], @{ $_[0]->$name() } };
            },
            get => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name()->[$_[1]] };
            },
            first => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name()->[0] };
            },
            last => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name()->[-1] };
            },
        };
    },
);

no Mouse;

package # hide from PAUSE
    Mouse::Meta::Attribute::Custom::Collection::List;
sub register_implementation { 'MouseX::AttributeHelpers::Collection::List' }

1;
