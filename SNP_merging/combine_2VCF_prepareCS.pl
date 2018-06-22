#!/usr/bin/perl -w

use Parallel::ForkManager;




open MM,"res_data/introgression_file/allele_match_info2" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;

	$cs{$tem[0]."_".$tem[1]}=1;
	
	
	
}
close MM;


@file=glob("/home/feihe/project/1000genome/Jan09_2017/v1/*_beagleOutGT.783.vcf");



open NN,">tmpdir/1k_shared.vcf" or die "l";



foreach $in(@file){
	print "$in\n";
	open MM,"$in" or die "l";
	while(<MM>){
		next if $_=~/^#/;
		@tem=split/\t/;
		@name=split/_/,$tem[2];
		next if !exists $cs{$name[0]."_".$tem[1]};
		$tem[0]=$name[0];
		$tem[2]=$name[0]."_".$tem[1];
		$tem[7]=".";
		$tem[8]="GT";
	
		$ll=join "\t",@tem;
		print NN "$ll";
	}
	close MM;

}
close NN;
