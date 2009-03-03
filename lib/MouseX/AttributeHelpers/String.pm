package MouseX::AttributeHelpers::String;

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

package # hide from PAUSE
    Mouse::Meta::Attribute::Custom::String;
sub register_implementation { 'MouseX::AttributeHelpers::String' }

1;
