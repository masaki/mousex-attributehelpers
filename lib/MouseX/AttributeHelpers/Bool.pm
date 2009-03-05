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

no Mouse;

1;

=head1 NAME

MouseX::AttributeHelpers::Bool

=head1 SYNOPSIS

T.B.D.

=head1 PROVIDED METHODS

=head2 set

=head2 unset

=head2 toggle

=head2 not

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<MouseX::AttributeHelpers>, L<MouseX::AttributeHelpers::Base>

=cut
