package MouseX::AttributeHelpers;

use 5.008_001;
use Mouse 0.17 (); # 0.18 ();
use MouseX::AttributeHelpers::Counter;
use MouseX::AttributeHelpers::Number;
use MouseX::AttributeHelpers::String;
use MouseX::AttributeHelpers::Bool;
use MouseX::AttributeHelpers::Collection::List;
use MouseX::AttributeHelpers::Collection::Array;
use MouseX::AttributeHelpers::Collection::ImmutableHash;
use MouseX::AttributeHelpers::Collection::Hash;
use MouseX::AttributeHelpers::Collection::Bag;

our $VERSION = '0.01';

1;

=head1 NAME

MouseX::AttributeHelpers - Extend your attribute interfaces

=head1 SYNOPSIS

    package MyClass;

    use Mouse;
    use MouseX::AttributeHelpers;

    has 'mapping' => (
        metaclass => 'Collection::Hash',
        is        => 'rw',
        isa       => 'HashRef',
        default   => sub { +{} },
        provides  => {
            exists => 'exists_in_mapping',
            keys   => 'ids_in_mapping',
            get    => 'get_mapping',
            set    => 'set_mapping',
        },
    );

    package main;

    my $obj = MyClass->new;
    $obj->set_quantity(10);      # quantity => 10
    $obj->set_mapping(4, 'foo'); # 4 => 'foo'
    $obj->set_mapping(5, 'bar'); # 5 => 'bar'
    $obj->set_mapping(6, 'baz'); # 6 => 'baz'

    # prints 'bar'
    print $obj->get_mapping(5) if $obj->exists_in_mapping(5);

    # prints '4, 5, 6'
    print join ', ', $obj->ids_in_mapping;

=head1 DESCRIPTION

MouseX::AttributeHelpers provides commonly used attribute helper
methods for more specific types of data.

=head1 PARAMETERS

=head2 provides

This points to a hashref that uses C<provider> for the keys and
C<method> for the values. The method will be added to the object
itself and do what you want.

=head2 curries

This points to a hashref that uses C<provider> for the keys and
has two choices for the value:

You can supply C<< { method => \@args } >> for the values.
The method will be added to the object itself (always using C<@args>
as the beginning arguments).

Another approach to curry a method provider is to supply a coderef
instead of an arrayref. The code ref takes C<$self>, C<$body>,
and any additional arguments passed to the final method.

=head1 METHOD PROVIDERS

=head2 L<Counter|MouseX::AttributeHelpers::Counter>

=head2 L<Number|MouseX::AttributeHelpers::Number>

=head2 L<String|MouseX::AttributeHelpers::String>

=head2 L<Bool|MouseX::AttributeHelpers::Bool>

=head2 L<Collection::List|MouseX::AttributeHelpers::Collection::List>

=head2 L<Collection::Array|MouseX::AttributeHelpers::Collection::Array>

=head2 L<Collection::Hash|MouseX::AttributeHelpers::Collection::Hash>

=head2 L<Collection::ImmutableHash|MouseX::AttributeHelpers::Collection::ImmutableHash>

=head2 L<Collection::Bag|MouseX::AttributeHelpers::Collection::Bag>

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<MooseX::AttributeHelpers>

=cut
