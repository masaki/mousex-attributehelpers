package MouseX::AttributeHelpers::Counter;

use Mouse;

extends 'Mouse::Meta::Attribute';

{
    my $providers = {
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

    around 'create' => sub {
        my ($next, @args) = @_;
        my $attr = $next->(@args);

        my %provides = %{ $attr->{provides} || {} };
        while (my ($name, $aliased) = each %provides) {
            next unless exists $providers->{$name};
            $attr->associated_class->add_method(
                $aliased => $providers->{$name}->($attr, $attr->name)
            );
        }

        return $attr;
    };
}

no Mouse;

package # hide from PAUSE
    Mouse::Meta::Attribute::Custom::Counter;
sub register_implementation { 'MouseX::AttributeHelpers::Counter' }

1;
