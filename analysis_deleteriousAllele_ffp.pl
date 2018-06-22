#!/usrbin/perl -w




open MM,"/home/DNA/shared_project/1000EC/data/sample_for_populationStructureAnalysis.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	#next if $tem[5] ne "lr" ;
	next if $tem[0] =~/accession/;
	next if $tem[1] eq "AVS" && $_=~/AUSTRALIA/;
	next if $tem[4]!~/compactum|macha|spelta|sphaerococcum|aestivum/;
	
	$allacc{$tem[0]}=$tem[5];
	#$lr{$tem[0]}=1 if $tem[5] eq "lr" ||  $tem[4]=~/compactum|macha|spelta|sphaerococcum/;
	#$cul{$tem[0]}=1 if $tem[5] eq "cul";


}
close MM;
#$n1=@tem=keys %lr;
#$n2=@tem=keys %cul;
#print "$n1\t$n2\n";

#foreach (keys %lr){
	#$allacc{$_}="lr";
#}

#foreach (keys %cul){
	#$allacc{$_}="cul";
#}



$in="summary_resultsData/ffp_bins/bin_ffp_19";

open NN,">tmpdir/res.ffpTop5p" or die "l";
	
	

foreach $acc(sort keys %allacc){
	
	$i1="tmpdir/geneticLoad_acc_HC_noD/dAllele.$acc";
	$i2="tmpdir/geneticLoad_acc_HC_noD/synAllele.$acc";
	$i3="tmpdir/geneticLoad_acc_HC_noD/nsynAllele.$acc";
		
		

		next if !-e $i1;
		

		
		
		
		$n=0;
		print "$in\t$i1\n";
		$cmd="bedmap --echo --skip-unmapped  $i1 $in > tmpdir/aa ";
		#print "$cmd\n\n";
		`$cmd`;
		open MM,"tmpdir/aa" or die "l";
		$n=@all=<MM>;
		close MM;
		$acc2dAllele{$acc}=$n;
		

		$n=0;
		$cmd="bedmap --echo --skip-unmapped  $i2 $in > tmpdir/aa ";
		#print "$cmd\n\n";
		`$cmd`;
		open MM,"tmpdir/aa" or die "l";
		$n=@all=<MM>;
		close MM;
		$acc2synAllele{$acc}=$n;
		
		$n=0;
		$cmd="bedmap --echo --skip-unmapped  $i3 $in > tmpdir/aa ";
		#print "$cmd\n\n";
		`$cmd`;
		open MM,"tmpdir/aa" or die "l";
		$n=@all=<MM>;
		close MM;
		$acc2nsynAllele{$acc}=$n;




		open MM,"$i1" or die "l";
		$a1=@all=<MM>;
		close MM;
		open MM,"$i2" or die "l";
		$a2=@all=<MM>;
		close MM;
		open MM,"$i3" or die "l";
		$a3=@all=<MM>;
		close MM;


		print NN "$acc\tbackground\t$allacc{$acc}\t$a1\t$a2\t$a3\n";
		print NN "$acc\tffp\t$allacc{$acc}\t$acc2dAllele{$acc}\t$acc2synAllele{$acc}\t$acc2nsynAllele{$acc}\n";


}
	
close NN;




