#!/usrbin/perl -w


$in="introgression/wildEmmerPD_Allele/iAllele_ratio_in_landraceOther";


open NN,">tmpdir/res" or die "l";
open MM,"$in" or die "l";
while(<MM>){
	next if $_=~/^#/;
	chomp;
	@tem=split/\t/;
	print NN "$tem[3]\tlr\n";


}
close MM;







$in="introgression/wildEmmerPD_Allele/iAllele_ratio_in_eachAcc";


open MM,"$in" or die "l";
while(<MM>){
	next if $_=~/^#/;
	chomp;
	@tem=split/\t/;
	next if $tem[4]=~/unknown|out/;
	print NN "$tem[3]\t$tem[4]\n";


}
close MM;
close NN;
