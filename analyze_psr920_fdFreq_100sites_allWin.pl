#!/usrbin/perl -w


#location of psr920 in the CS v1 genome
#psr920-forward
#chr4A, from 179060863 to 179060604

#psr920-rev
#chr4A, from 179060203 to 179060535





#read sample information
#obtain geographical groups of samples.
open MM,"/home/DNA/shared_project/1000EC/data/1kEC_sample_information.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	#next if $tem[5] ne "lr" ;
	next if $tem[0] =~/accession/;
	next if $tem[1] eq "AVS";
	#next if $tem[5] ne "cul";
	#next if $tem[8] eq "-";
	
	
	

	if($tem[9]=~/Eur/){
		$g2acc->{"Europe"}->{$tem[0]}=1;
		$acc2group{$tem[0]}="Europe";
	}
	if($tem[9]=~/MiddleEast/){
		#$g2acc->{"Middle"}->{$tem[0]}=1;
		#$acc2group{$tem[0]}="Middle";
	}

	if($tem[9]=~/MiddleEast1/){
		$g2acc->{"MiddleEast"}->{$tem[0]}=1;
		$acc2group{$tem[0]}="MiddleEast";
	}
	if($tem[9]=~/MiddleEast2/){
		$g2acc->{"Turkey"}->{$tem[0]}=1;
		$acc2group{$tem[0]}="Turkey";
	}


	if($tem[9]=~/AsiaEast|AsiaIndia/){
		$g2acc->{$tem[9]}->{$tem[0]}=1;
		$acc2group{$tem[0]}=$tem[9];
	}

	if($tem[9]=~/AsiaCentral/){
		#$g2acc->{"CentralAsia"}->{$tem[0]}=1;
		#$acc2group{$tem[0]}="CentralAsia";
	}




}
close MM;

push @oo,"Europe";
push @oo,"Turkey"; #turkey
push @oo,"MiddleEast";
push @oo,"AsiaIndia";
push @oo,"AsiaEast";



foreach $gg(@oo){
	foreach $aa(sort keys %{$g2acc->{$gg}}){
		
		
		#the file stores fd statistic for each accession
		$ff="introgression/fd/results/accession_based/landrace_100site/out100SiteW_".$aa;
		if(!-e $ff){
			$ff="introgression/fd/results/accession_based/cultiva_100site/outACC100SiteW_".$aa;
		}
		next if !-e $ff;
		
		#print "$ff\n";	
		
		open MM,"$ff" or die "l";
		@all=<MM>;
		close MM;
		shift @all;
		
		$hash1{$gg}++; #all acc
		undef %check;
		foreach $in(@all){
			chomp $in;
			@tem=split/,/,$in;
			next if exists $check{$tem[0]."_".$tem[1]};
			$check{$tem[0]."_".$tem[1]}=1;

			
			$hash3->{$tem[0]."_".$tem[1]}->{$gg}++ if $tem[7] ne "nan";

			
			
		}


		
		
		#print NN "$gg\t$aa\t$tem[6]\t$tem[7]\t$tem[8]\n";
		

	}


}


#output the ratio of introgression for all 100 site windows in diffferent populations.
open NN,">tmpdir/res" or die "l";
print NN "window_ID";
foreach $gg(@oo){
	print NN "\t$gg";
}
print NN "\n";
foreach $ww(sort keys %$hash3){

	print NN "$ww\t";
	foreach $gg(@oo){
		$hash3->{$ww}->{$gg}=0 if !exists $hash3->{$ww}->{$gg};
		$rr=sprintf "%.4f",$hash3->{$ww}->{$gg}/$hash1{$gg};
		print NN "\t$rr";
	}
	print NN "\n";



}
close NN;


