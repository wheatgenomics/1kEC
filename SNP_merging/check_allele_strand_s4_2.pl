#!/usr/bin/perl -w

open MM,"tmpdir/res" or die "l";
open NN,">tmpdir/aa" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;

	$wr=$tem[2];
	$wa=$tem[3];
	$er=$tem[4];
	$ea=$tem[5];

	if($tem[-1] =~/same/i){
		if($wr eq $er && $wa eq $ea){
			$type="N";
		}elsif($wr eq $ea && $wa eq $er ){
			$type="Y";
		}else{
			print "w\t$_\n";
		}
	}elsif($tem[-1]=~/diff/i){
		
		$er=~tr/ATGC/TACG/;
		$ea=~tr/ATGC/TACG/;
		if($wr eq $er && $wa eq $ea){
			$type="N";
		}elsif($wr eq $ea && $wa eq $er ){
			$type="Y";
		}else{
			print "w\t$_\n";
		}
		
	}
	print NN "$_\t$type\n";


}	
close MM;
close NN;
