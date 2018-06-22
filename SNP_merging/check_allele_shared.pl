#!/usr/bin/perl -w

use Parallel::ForkManager;




open MM,"res_data/introgression_file/allele_match_info2" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^#/;
	@tem=split/\t/;

	#$cs{$tem[0]."_".$tem[1]}=1;

	
	
	
}
close MM;


open MM,"Jan09_2017/v1/allGT_783.recode.vcf" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^#/;
	@tem=split/\t/;

	$cs{$tem[0]."_".$tem[1]}=1;
	#next if !exists $cs{$tem[0]."_".$tem[1]};
	$n++;

}
close MM;

print "$n\n";

open NN,">res_data/introgression_file/out.het_beagleOut.HC.vcf" or die "l";
open MM,"res_data/introgression_file/out.het_beagleOut.vcf" or die "l";
while(<MM>){
	chomp;
	print NN "$_\n" if $_=~/^#/;
	next if $_=~/^#/;;
	@tem=split/\t/;

	next if !exists $cs{$tem[0]."_".$tem[1]};
	print NN "$_\n";

}
close MM;
close NN;
