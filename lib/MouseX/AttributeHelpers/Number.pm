package MouseX::AttributeHelpers::Number;

{
    package # hide from PAUSE
        Mouse::Meta::Attribute::Custom::Number;
    sub register_implementation { 'MouseX::AttributeHelpers::Number' }
}

use Mouse;

extends 'MouseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        return +{
            set => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[1]) };
            },
            add => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() + $_[1]) };
            },
            sub => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() - $_[1]) };
            },
            mul => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() * $_[1]) };
            },
            div => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() / $_[1]) };
            },
            mod => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() % $_[1]) };
            },
            abs => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name(abs $_[0]->$name()) };
            },
        };
    },
);

no Mouse;

1;

=head1 NAME

MouseX::AttributeHelpers::Number

=head1 SYNOPSIS

T.B.D.

=head1 PROVIDED METHODS

=head2 set

=head2 add

=head2 sub

=head2 mul

=head2 div

=head2 mod

=head2 abs

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<MouseX::AttributeHelpers>, L<MouseX::AttributeHelpers::Base>

=cut
