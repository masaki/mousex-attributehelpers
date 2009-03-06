package MouseX::AttributeHelpers::Counter;

{
    package # hide from PAUSE
        Mouse::Meta::Attribute::Custom::Counter;
    sub register_implementation { 'MouseX::AttributeHelpers::Counter' }
}

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

1;

=head1 NAME

MouseX::AttributeHelpers::Counter

=head1 SYNOPSIS

    package MyHomePage;
    use Mouse;
    use MouseX::AttributeHelpers;
  
    has 'counter' => (
        metaclass => 'Counter',
        is        => 'rw',
        isa       => 'Num',
        default   => 0,
        provides  => {
            inc   => 'inc_counter',
            dec   => 'dec_counter',
            reset => 'reset_counter',
        },
    );

    package main;
    my $page = MyHomePage->new;

    $page->inc_counter; # same as $page->counter($page->counter + 1);
    $page->dec_counter; # same as $page->counter($page->counter - 1);

=head1 DESCRIPTION

This module provides a simple counter attribute,
which can be incremented and decremented.

=head1 PROVIDERS

=over 4

=item B<reset>

=item B<set>

=item B<inc>

=item B<dec>

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<MouseX::AttributeHelpers>, L<MouseX::AttributeHelpers::Base>

=cut
