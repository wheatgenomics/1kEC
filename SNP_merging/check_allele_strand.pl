#!/usr/bin/perl -w

open MM,"res_data/introgression_file/wildEmmer_shared.CS.vcf" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^#/;
	@tem=split/\t/;
	$emmer{$tem[2]}=$tem[3]."\t".$tem[4];


}
close MM;


open NN,">tmpdir/res" or die "l";
open MM,"res_data/introgression_file/1k_shared.vcf" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^#/;
	@tem=split/\t/;
	@ss=split/\t/,$emmer{$tem[2]};
	
	$ls1=$tem[3]."\t".$tem[4];
	$ls2=$emmer{$tem[2]};

	@ssC=@ss;
	$ssC[0]=~tr/ATGC/TACG/;
	$ssC[1]=~tr/ATGC/TACG/;

	if($ls1=~/A|T/ && $ls1=~/C|G/){
		if($tem[3] eq $ss[0] && $tem[4] eq $ss[1] ){
			$type="sameStrand";
		}elsif($tem[3] eq $ss[1] && $tem[4] eq $ss[0] ){
			$type="sameStrand_alleleReversed";
		}elsif($tem[3] eq $ssC[0] && $tem[4] eq $ssC[1] ){
			$type="diffStrand";
		}elsif($tem[3] eq $ssC[1] && $tem[4] eq $ssC[0] ){
			$type="diffStrand_alleleReversed";
		}
		


	
	}else{
	
		$type="-";
	
	
	}



	

	print NN "$tem[0]\t$tem[1]\t$tem[3]\t$tem[4]\t$ss[0]\t$ss[1]\t$type\n";
}
close MM;
close NN;





