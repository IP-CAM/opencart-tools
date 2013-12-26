#!/usr/bin/perl -w

use File::Basename;
use File::Path qw/make_path/;

($#ARGV == 0) or die "Usage: $0 [directory]\n"; 

use File::Find;
my @files;
my $infile="/tmp/text.sv";

find(sub {push @files, $File::Find::name if -f } , @ARGV);

open LNG, "$infile" or die "Could not open $infile"; 

foreach (@files) 
{
	print "Processing file : $_\n";

	$outfile = $_;
	$infile = $_;

	$outfile =~ s/[^\/]*\///;

	$dir = dirname($outfile);
	make_path($dir);

	open OUT, ">$outfile" or die "Could not create $outfile";

	open IN, $infile or die "Could not open file $infile";
	while (<IN>){
		chomp;
		$_ =~ s/=\s*[\'|\"].*//s;
		print OUT $_;
		if (/^\$_*/) {
		        $text=<LNG>;
			chomp $text;
			$text =~ s/ *,/\,/g;
			$text =~ s/ *\./\./g;
			$text =~ s/ *:/:/g;
			$text =~ s/ *!/!/g;
			print OUT "= '$text';\n";
		} else {
			print OUT "\n";
		}
	}
	close(IN);
	close(OUT);
}
close(LNG);
