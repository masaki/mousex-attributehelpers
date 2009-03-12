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
    my ($next, $self, $class, $name, %args) = @_;
    my $attr = $next->($self, $class, $name, %args);

    my $constructors = $attr->method_constructors;

    # curries
    my %curries = %{ $attr->{curries} || {} };
    while (my ($key, $curry) = each %curries) {
        next unless my $constructor = $constructors->{$key};

        my $code = $constructor->($attr, $name);

        while (my ($aliased, $args) = each %$curry) {
            if (exists $class->{methods}->{$aliased}) {
                my $classname = $class->name;
                confess "The method ($aliased) already exists in class ($classname)";
            }

            my $method = do {
                if (ref $args eq 'ARRAY') {
                    $attr->_make_curry($code, @$args);
                }
                elsif (ref $args eq 'CODE') {
                    $attr->_make_curry_with_sub($code, $args);
                }
                else {
                    confess "curries parameter must be ref type HASH or CODE";
                }
            };

            $class->add_method($aliased => $method);
        }
    }

    # provides
    my %provides = %{ $attr->{provides} || {} };
    while (my ($key, $aliased) = each %provides) {
        next unless my $constructor = $constructors->{$key};

        if (exists $class->{methods}->{$aliased}) {
            my $classname = $class->name;
            confess "The method ($aliased) already exists in class ($classname)";
        }

        $class->add_method($aliased => $constructor->($attr, $name));
    }

    return $attr;
};

around 'canonicalize_args' => sub {
    my ($next, $self, $name, %args) = @_;

    %args = $next->($self, $name, %args);
    $args{is}  = 'rw'               unless exists $args{is};
    $args{isa} = $self->helper_type unless exists $args{isa};

    unless (exists $args{default} or exists $args{builder} or exists $args{lazy_build}) {
        $args{default} = $self->helper_default if defined $self->helper_default;
    }

    return %args;
};

sub helper_type    {}
sub helper_default {}

sub _make_curry {
    my $self = shift;
    my $code = shift;
    my @args = @_;
    return sub {
        my $self = shift;
        $code->($self, @args, @_);
    };
}

sub _make_curry_with_sub {
    my $self = shift;
    my $body = shift;
    my $code = shift;
    return sub {
        my $self = shift;
        $code->($self, $body, @_);
    };
}

no Mouse;

1;

=head1 NAME

MouseX::AttributeHelpers::Base - Base class for attribute helpers

=head1 METHODS

=head2 method_constructors

=head2 helper_type

=head2 helper_default

=head2 create

=head2 canonicalize_args

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Mouse::Meta::Attribute>

=cut
