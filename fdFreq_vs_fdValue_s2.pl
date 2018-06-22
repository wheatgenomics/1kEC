#!/usr/bin/perl -w


use Statistics::Basic qw(:all);

open MM,"summary_resultsData/info_fdCount.allAccession_VS_fdValue" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^#/;
	@tem=split/\t/;

	push @{$data->{$tem[1]}},$tem[0];

}
close MM;


open NN,">tmpdir/res" or die "l";
foreach (keys %$data){
	@tem=@{$data->{$_}};
	$m1=sprintf "%.4f",mean(@tem);
	$m2=sprintf "%.4f",median(@tem);
	$ss=sprintf "%.4f",stddev(@tem);
	

	print NN "$_\t$m1\t$m2\t$ss\n";

}
close NN;

