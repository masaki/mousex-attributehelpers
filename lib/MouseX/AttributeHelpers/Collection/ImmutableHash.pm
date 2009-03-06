package MouseX::AttributeHelpers::Collection::ImmutableHash;

{
    package # hide from PAUSE
        Mouse::Meta::Attribute::Custom::Collection::ImmutableHash;
    sub register_implementation { 'MouseX::AttributeHelpers::Collection::ImmutableHash' }
}

use Mouse;

extends 'MouseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        return +{
            exists => sub {
                my ($attr, $name) = @_;
                return sub { exists $_[0]->$name()->{$_[1]} ? 1 : 0 };
            },
            get => sub {
                my ($attr, $name) = @_;
                return sub { @_ == 2 ? $_[0]->$name()->{$_[1]} : @{ shift->$name() }{@_} };
            },
            keys => sub {
                my ($attr, $name) = @_;
                return sub { keys %{ $_[0]->$name() } };
            },
            values => sub {
                my ($attr, $name) = @_;
                return sub { values %{ $_[0]->$name() } };
            },
            kv => sub {
                my ($attr, $name) = @_;
                return sub {
                    my $h = $_[0]->$name();
                    map { [ $_, $h->{$_} ] } keys %$h;
                };
            },
            count => sub {
                my ($attr, $name) = @_;
                return sub { scalar keys %{ $_[0]->$name() } };
            },
            empty => sub {
                my ($attr, $name) = @_;
                return sub { scalar keys %{ $_[0]->$name() } ? 1 : 0 };
            },
        };
    },
);

no Mouse;

1;

=head1 NAME

MouseX::AttributeHelpers::Collection::ImmutableHash

=head1 SYNOPSIS

    package MyClass;
    use Mouse;
    use MouseX::AttributeHelpers;

    has 'options' => (
        metaclass => 'Collection::ImmutableHash',
        is        => 'rw',
        isa       => 'HashRef',
        default   => sub { +{} },
        provides  => {
            get   => 'get_option',
            empty => 'has_options',
            keys  => 'get_option_list',
        },
    );

=head1 DESCRIPTION

This module provides a immutable HashRef attribute
which provides a number of hash-line operations.

=head1 PROVIDERS

=over 4

=item B<count>

=item B<empty>

=item B<exists>

=item B<get>

=item B<keys>

=item B<values>

=item B<kv>

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<MouseX::AttributeHelpers>, L<MouseX::AttributeHelpers::Base>

=cut
