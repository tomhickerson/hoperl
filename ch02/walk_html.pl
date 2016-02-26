#!/usr/bin/perl

# walk_html, examples taken from pages 77-78 of HOP
# several versions of walk_html are suggested in the book, currently going with the last one with several functions added
use Data::Dumper;

my @textarray;

my $html = "<h1>loren ipsum</h1> <p>Neque porro quisquam</p> <p>est qui <font color='red'>dolorem ipsum</font></p>";

my $tree = {{_tag=> "h1",
            _content=> ["loren ipsum"]},
            {_tag=> "p",
            _content=> [ "Neque porro quisquam"]},
            {_tag=> "p",
             _content=> ["est qui", {_tag=> "font", _content=> ["dolorem ipsum"], color=> "red"}]}
};

sub walk_html {
    my ($html, $textfunc, $elementfunc, $userparam) = @_;
    return $textfunc->($html, $userparam) unless ref $html;
    my ($item, @results);
    for $item (@{$html->{_content}}) {
        push @results, walk_html($item, $textfunc, $elementfunc, $userparam);
    }
    return $elementfunc->($html, $userparam, @results);
}

sub elementfunc {
    my $table = { h1 => sub { shift; my $text3 = join '', @_; print $text3; return $text3; },
                _DEFAULT_ => sub { shift; my $text4 = join '', @_; return $text4; }
    };

    my ($element) = @_;
    my $tag = $element->{_tag};
    my $action = $table->{$tag} || $table->{_DEFAULT_};
    return $action->(@_);
}

@textarray = walk_html($tree, sub { my ($text, $aref) = @_; push @$aref, $text; }, \&elementfunc, \@textarray);
print Dumper(\@textarray);
