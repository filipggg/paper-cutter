#!/usr/bin/perl

use strict;

my %found = ();

for my $filepath (@ARGV) {
    open(my $ih, '<', $filepath);
    binmode($ih, ':utf8');

    while (my $line=<$ih>) {
        while ($line =~ m<\\gonito(?:barescore|score|entry)\{([^\}]+)\}>g) {
            $found{$1} = 1;
        }
    }

    close($ih);
}

print join(" ", map { "scores/${_}.txt" } sort keys %found);
