#!/usr/bin/perl

# walk_html, examples taken from pages 77-78 of HOP
# several versions of walk_html are suggested in the book, currently going with the last one with several functions added
use Data::Dumper;

my @textarray;

my $html = "<h1>loren ipsum</h1> <p>Neque porro quisquam</p> <p>est qui <font color='red'>dolorem ipsum</font></p>";

my $tree = {_tag=> "body",
            _content=>
                [{_tag=> "h1",
                  _content=> ["loren ipsum"]},
                 {_tag=> "p",
                  _content=> [ "Neque porro quisquam"]},
                 {_tag=> "p",
                  _content=> ["est qui", {_tag=> "font", _content=> ["dolorem ipsum"], color=> "red"}]}]
};

my $tree2 = {};

sub walk_html {
    my ($html, $textfunc, $elementfunc, $userparam) = @_;
    return $textfunc->($html, $userparam) unless ref $html;
    my ($item, @results);
    #print "walking\n";
    for $item (@{$html->{_content}}) {
        push @results, walk_html($item, $textfunc, $elementfunc, $userparam);
        #print Dumper(@results);
    }
    return $elementfunc->($html, $userparam, @results);
}

sub elementfunc {
    my $table = { h1 => sub { print "H1\n"; return "H1"; },
                _DEFAULT_ => sub { return "DEFAULT"; }
    };

    my ($element, $userparam, $results) = @_;
    my $tag = $element->{_tag};
    my $action = $table->{$tag} || $table->{_DEFAULT_};
    push @$userparam, $action->($element);
    # note that we are pushing to the textarray referenced in the walk_html main code
    return $action->(@_);
}

# first run on walk_html with an elementfunc passed and the text array

walk_html($tree, sub { my ($text, $aref) = @_; push @$aref, $text; }, \&elementfunc, \@textarray);
print Dumper(@textarray);

print "\n";

# second run of the walk_html with no elementfunc, note that we add four lines on to the existing text array since we didn't clear it out

walk_html($tree, sub { my ($text, $aref) = @_; push @$aref, $text; }, sub { }, \@textarray);
print Dumper(@textarray);
