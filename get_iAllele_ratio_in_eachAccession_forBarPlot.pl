#!/usrbin/perl -w


push @file,"introgression/wildEmmerPD_Allele/iAllele_ratio_in_emmer";
push @file,"introgression/wildEmmerPD_Allele/iAllele_ratio_in_landraceOther";
push @file,"introgression/wildEmmerPD_Allele/iAllele_ratio_in_eachAcc";


foreach $in(@file){
	open MM,"$in" or die "l";
	while(<MM>){
		next if $_=~/^#/;
		chomp;
		@tem=split/\t/;

		$acc2ratio{$tem[0]}=$tem[3];
		



	}
	close MM;




}

$acc=$ARGV[0];
$in="admixture/acc$acc"."_maf001_thin1k_ld04_merged/acc$acc"."_maf001_thin1k_ld04_ind.2.out.forHumanCheck";


open NN,">tmpdir/aa" or die "l";
open MM,"$in" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	if(!exists $acc2ratio{$tem[0]}){
		print "=>$_\n";
	}


	$xx=1-$acc2ratio{$tem[0]};
	print 	NN "$acc2ratio{$tem[0]}\t$xx\n";


}
close MM;
close NN;










