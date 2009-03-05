package MouseX::AttributeHelpers::String;

{
    package # hide from PAUSE
        Mouse::Meta::Attribute::Custom::String;
    sub register_implementation { 'MouseX::AttributeHelpers::String' }
}

use Mouse;

extends 'MouseX::AttributeHelpers::Base';

has '+method_constructors' => (
    default => sub {
        return +{
            append => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[0]->$name() . $_[1]) };
            },
            prepend => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name($_[1] . $_[0]->$name()) };
            },
            replace => sub {
                my ($attr, $name) = @_;
                return sub {
                    my $v = $_[0]->$name();
                    if ((ref $_[2] || '') eq 'CODE') {
                        $v =~ s/$_[1]/$_[2]->()/e;
                    }
                    else {
                        $v =~ s/$_[1]/$_[2]/;
                    }
                    $_[0]->$name($v);
                };
            },
            match => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name() =~ $_[1] };
            },
            chop => sub {
                my ($attr, $name) = @_;
                return sub {
                    my $v = $_[0]->$name();
                    CORE::chop($v);
                    $_[0]->$name($v);
                };
            },
            chomp => sub {
                my ($attr, $name) = @_;
                return sub {
                    my $v = $_[0]->$name();
                    CORE::chomp($v);
                    $_[0]->$name($v);
                };
            },
            inc => sub {
                my ($attr, $name) = @_;
                return sub {
                    my $v = $_[0]->$name();
                    $v++;
                    $_[0]->$name($v);
                };
            },
            clear => sub {
                my ($attr, $name) = @_;
                return sub { $_[0]->$name('') };
            },
        };
    },
);

no Mouse;

1;

=head1 NAME

MouseX::AttributeHelpers::String

=head1 SYNOPSIS

T.B.D.

=head1 PROVIDED METHODS

=head2 append

=head2 prepend

=head2 replace

=head2 match

=head2 chop

=head2 chomp

=head2 inc

=head2 clear

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<MouseX::AttributeHelpers>, L<MouseX::AttributeHelpers::Base>

=cut
