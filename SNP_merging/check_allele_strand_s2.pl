#!/usr/bin/perl -w

open MM,"res_data/introgression_file/res_by_fei" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$type{$tem[0]."_".$tem[1]}=$_;

}
close MM;


open NN,">tmpdir/aa" or die "l";
open MM,"res_data/introgression_file/out_chr5B.log" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	print NN "$_\t$type{$tem[2]}\n";

}
close MM;
close NN;



