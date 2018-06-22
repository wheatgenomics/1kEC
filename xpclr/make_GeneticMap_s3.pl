#!/usr/bin/perl -w

@file=glob("xpclr_dir3/SnpPosInfo_chr*");
foreach $in(@file){
	print "$in\n";
	next if $in=~/un/i;
	
	$in2=$in;
	$in2=~s/SnpPosInfo/GeneticPosInfo/;
	$in2=$in2.".corrected";
	
	`cp $in tmpdir/aa`;
	`cp $in2 tmpdir/bb`;
	`R CMD BATCH interprolate.r`;
	
	@name=split/_/,$in;
	$new=$name[-1].".Interprolated_geneticMap";
	`mv tmpdir/info.txt xpclr_dir3/$new`;


}




