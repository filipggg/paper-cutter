#!/usr/bin/perl

# Flatten file structure (needed for an arxiv package)

use utf8;
use strict;

binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');

my $subdir_regexp = qr{(?:figures|images|plots)};

sub fix_subdirs {
    my ($p) = @_;

    $p =~ s{/}{-}g;

    return $p;
}

while (my $line=<>) {
    $line =~ s<\\graphicspath\{(\s*)\{${subdir_regexp}/\}(\s*)><\\graphicspath\{$1\{.\}$2>;
    $line =~ s<(\\includegraphics[^{}]*?\{)./${subdir_regexp}/><${1}./>g;
    $line =~ s<(\\includegraphics[^{}]*?\{)([^\.][^{}]+/)><"$1".fix_subdirs($2)>ge;
    $line =~ s<\\input\{inputs/><\\input\{inputs->g;
    $line =~ s<\\minput\{scores/\#1\.txt\}><\\minput{scores-#1.txt}>g;
    print $line;
}
