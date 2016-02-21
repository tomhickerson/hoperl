#!/usr/bin/perl

use HTML::TreeBuilder;

my $html = "<h1>What Junior Said</h1> <p>But I don't <font color='red'>want</font> to go to bed!</p>";

my $tree = HTML::TreeBuilder->new;
$tree->ignore_ignorable_whitespace(0);
$tree->parse($html);
$tree->eof();
# to be replaced by an actual mapping for those of us whose CPAN won't get the module

sub untag_html {
    my ($html) = @_;
    return $html unless ref $html;
    # its a plain string
    my $text = '';
    for my $item (@{$html->{_content}}) {
        $text .= untag_html($item);
    }
    return $text;
}

print untag_html($tree);
