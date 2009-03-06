package MouseX::AttributeHelpers::Collection::List;

{
    package # hide from PAUSE
        Mouse::Meta::Attribute::Custom::Collection::List;
    sub register_implementation { 'MouseX::AttributeHelpers::Collection::List' }
}

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

1;

=head1 NAME

MouseX::AttributeHelpers::Collection::List

=head1 SYNOPSIS

    package MyClass;
    use Mouse;
    use MouseX::AttributeHelpers;

    has 'options' => (
        metaclass => 'Collection::List',
        is        => 'rw',
        isa       => 'ArrayRef',
        default   => sub { [] },
        provides  => {
            count    => 'num_options',
            empty    => 'has_options',
            map      => 'map_options',
            grep     => 'filter_options',
            elements => 'all_options',
        },
    );

=head1 DESCRIPTION

This module provides an List attribute which provides
a number of list operations.

=head1 PROVIDERS

=over 4

=item B<count>

=item B<empty>

=item B<find>

=item B<map>

=item B<grep>

=item B<elements>

=item B<join>

=item B<get>

=item B<first>

=item B<last>

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<MouseX::AttributeHelpers>, L<MouseX::AttributeHelpers::Base>

=cut
