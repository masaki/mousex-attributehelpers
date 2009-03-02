package MouseX::AttributeHelpers::Base;

use Mouse;

extends 'Mouse::Meta::Attribute';

has 'method_constructors' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { +{} },
);

around 'create' => sub {
    my ($next, @args) = @_;
    my $attr = $next->(@args);

    my $constructors = $attr->method_constructors;
    my %provides = %{ $attr->{provides} || {} };
    while (my ($name, $aliased) = each %provides) {
        next unless exists $constructors->{$name};
        $attr->associated_class->add_method(
            $aliased => $constructors->{$name}->($attr, $attr->name)
        );
    }

    return $attr;
};

no Mouse;

1;

=head1 NAME

MouseX::AttributeHelpers::Base - Base class for attribute helpers

=head1 ATTRIBUTES

=head2 method_constructors

=head1 METHODS

=head2 create

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
