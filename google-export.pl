#!/usr/bin/perl -w

($#ARGV == 0) or die "Usage: $0 [directory]\n"; 

use File::Find;
my @files;
my $outfile="/tmp/text.en";

find(sub {push @files, $File::Find::name if -f } , @ARGV);

open OUT, ">$outfile" or die "Could not create $outfile"; 

foreach (@files) 
{
	print "Processing file : $_\n";

	open IN, $_ or die "Could not open file $_";
	while (<IN>){
		next if not /^\$_*/;
	       		$_ =~ s/=\s*[\'|\"](.*)[\'|\"]/$1/s;
			print OUT "$1\n";
	}
	close(IN);
}
close(OUT);
