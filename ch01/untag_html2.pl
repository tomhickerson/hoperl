#!/usr/bin/perl

my $html = "<h1>What Junior Said</h1> <p>But I don't <font color='red'>want</font> to go to bed!</p>";

my $tree = {_tag=> "p",
            _content=> [ "But I don't ",
                         {_tag=> "font",
                          _content=> ["want"],
                          color=> "red",
                          size=> 3,
                         },
                         " to go to bed now!",
                ],
};

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

print untag_html($tree) . "\n";
