#!/usr/bin/perl -w

use Parallel::ForkManager;








open MM,"../genome_mapping/res_data/emmerSNP_on_CS/matched_SNP_all" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	@name=split/_/,$tem[2];
	$em2cs{$name[1]."_".$name[2]}=$tem[0]."_".$tem[1];

}
close MM;

open MM,"res_data/introgression_file/allele_match_info2" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$cs2type{$tem[0]."_".$tem[1]}=$tem[-1];
	$cs2allele{$tem[0]."_".$tem[1]}=$tem[2]."\t".$tem[3];
}
close MM;






$n=@tem=keys %em2cs;
print "$n\n";

open NN,">/home/feihe/project/1000genome/data/emmerVCF/combined_beagleOut_sharedWithCS.vcf" or die "l";
open MM,"/home/feihe/project/1000genome/data/emmerVCF/combined_beagleOut.vcf" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	
	#die "$_\n" if !$tem[3] || !$tem[4];

	if($_=~/^#/){
		print NN "$_\n";
		next;
	}
	next if (length $tem[3] !=1) or( length $tem[4] !=1);

	$ss=$tem[0]."_".$tem[1];

	next if !exists $em2cs{$ss};
	$ss=$em2cs{$ss};
	
	$count{$ss}++;

	@name=split/_/,$ss;
	$tem[0]=$name[0];
	$tem[1]=$name[1];
	$tem[2]=$ss;


	if(!exists $cs2allele{$ss}){
		print "$ss\n";
		next;
	}
	@aa=split/\t/,$cs2allele{$ss};
	$tem[3]=$aa[0];
	$tem[4]=$aa[1];


	if(!exists $cs2type{$ss}){
		#print "$ss\n";
		$n2++;
		next;
	}
	
	for($i=9;$i<@tem;$i++){
		@aa=split/:/,$tem[$i];
		

		if($cs2type{$ss} eq "Y" ){
			$aa[0]=&switchGT($aa[0]);
		}
		
		$tem[$i]=$aa[0];
	}
	$tem[8]="GT";
	$tem[7]=".";
	$tem[6]=".";
	
	$ll=join "\t",@tem;
	print NN "$ll\n";


}
close MM;
close NN;



print "$n2\n";

foreach (sort keys %count){
	print "$_\t$count{$_}\n" if $count{$_}>1;
}








sub switchGT{
	my $line=$_[0];
	$line=~s/1/X/g;
	$line=~s/0/Y/g;
	
	$line=~s/X/0/g;
	$line=~s/Y/1/g;
	
	return $line;
}


