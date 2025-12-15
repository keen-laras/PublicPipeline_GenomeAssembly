#!/usr/bin/perl
use strict;
use warnings;

# ===================================================
# Usage:
#   perl extract_lowercase_bed.pl <genome.fa> <output.bed>
# Description:
#   Detects lowercase regions (softmasked) in a FASTA file
#   and writes them as BED intervals (0-based coordinates).
# ===================================================

# --- check arguments ---
if (@ARGV != 2) {
    die "Usage: perl $0 <input.fasta> <output.bed>\n";
}

my ($fasta, $out) = @ARGV;

open(my $IN,  "<", $fasta) or die "Cannot open FASTA file $fasta: $!\n";
open(my $OUT, ">", $out)   or die "Cannot write to $out: $!\n";

my ($chr, $pos, $start, $in);

while (my $line = <$IN>) {
    chomp $line;

    # Header line
    if ($line =~ /^>(\S+)/) {
        # If previous chromosome had an open region, print it
        if (defined $in && $in == 1) {
            print $OUT "$chr\t$start\t$pos\n";
        }
        $chr  = $1;
        $pos  = 0;
        $in   = 0;
        $start = undef;
        next;
    }

    # Sequence line
    my @bases = split('', $line);
    for my $b (@bases) {
        if ($b =~ /[a-z]/) {
            $start = $pos if !$in;  # record start
            $in = 1;
        } else {
            if ($in) {
                print $OUT "$chr\t$start\t$pos\n";
                $in = 0;
            }
        }
        $pos++;
    }
}

# End of file — if last region still open, print it
if ($in) {
    print $OUT "$chr\t$start\t$pos\n";
}

close $IN;
close $OUT;

print "✅ Done. BED file written to $out\n";
