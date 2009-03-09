package MouseX::AttributeHelpers::Bool;

{
    package # hide from PAUSE
        Mouse::Meta::Attribute::Custom::Bool;
    sub register_implementation { 'MouseX::AttributeHelpers::Bool' }
}

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

sub helper_type { 'Bool' }

no Mouse;

1;

=head1 NAME

MouseX::AttributeHelpers::Bool

=head1 SYNOPSIS

    package Room;
    use Mouse;
    use MouseX::AttributeHelpers;
  
    has 'is_lit' => (
        metaclass => 'Bool',
        is        => 'rw',
        isa       => 'Int',
        default   => 0,
        provides  => {
            set    => 'illuminate',
            unset  => 'darken',
            toggle => 'flip_switch',
            not    => 'is_dark',
        },
    );


    package main;
    my $room = Room->new;

    $room->illuminate;  # same as $room->is_lit(1);
    $room->darken;      # same as $room->is_lit(0);
    $room->flip_switch; # same as $room->is_lit(not $room->is_lit);
    $room->is_dark;     # same as !$room->is_lit

=head1 DESCRIPTION

This module provides a simple boolean attribute,
which supports most of the basic math operations.

=head1 PROVIDERS

=head2 set

=head2 unset

=head2 toggle

=head2 not

=head1 METHODS

=head2 method_constructors

=head2 helper_type

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<MouseX::AttributeHelpers>, L<MouseX::AttributeHelpers::Base>

=cut
