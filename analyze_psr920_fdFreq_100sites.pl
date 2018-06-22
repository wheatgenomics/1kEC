#!/usrbin/perl -w


#location of psr920 in the CS v1 genome
#psr920-forward
#chr4A, from 179060863 to 179060604

#psr920-rev
#chr4A, from 179060203 to 179060535





#read sample information
#obtain geographical groups of samples.
#open MM,"/home/DNA/shared_project/1000EC/data/1kEC_sample_information.txt" or die "l";
open MM,"/home/DNA/shared_project/1000EC/data/sample_for_populationStructureAnalysis.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	#next if $tem[5] ne "lr" ;
	next if $tem[0] =~/accession/;
	next if $tem[1] eq "AVS" && $_=~/AUSTRALIA/;
	#next if $tem[5] ne "cul";
	#next if $tem[8] eq "-";
	
	$tem[9]=$tem[6];
	

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
		if(!-e $ff){
			$ff="introgression/fd/results/accession_based/landraceOther_100site/out100site_otherLR_".$aa;
		}

		print "$ff\n" if !-e $ff;
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

			
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
#those functions need another script
#not implemented in this script 
			#set the range of flanking sequence around psr920
			#do you want to use 10M flanking sequence around psr920?
			#do you want to use the 1M flanking sequence around psr920?

			#if($tem[1] eq 175000000){ #10M
			#if($tem[1] eq 178810682){ #500K
			#if($tem[1] eq 178560682){ #1M
			#if($tem[1] eq 176560682){ #5M
###########################################################################################
###########################################################################################
###########################################################################################
			
			#use 100site Window that covers psr920.
			if($tem[1] eq 175002939){	
				if($tem[7] ne "nan"){
					$hash2{$gg}++; #freq of introgression in each population
					#print "$ff\t$gg\n";
				}

			
			
			}
		}


		
		
		#print NN "$gg\t$aa\t$tem[6]\t$tem[7]\t$tem[8]\n";
		

	}


}


#output the ratio of introgression near psr920 in diffferent populations.
open NN,">tmpdir/res" or die "l";
print NN "pop\t#of acc\t#of acc that are introgressed at psr920\tratio of introgression\n";
foreach (sort keys %hash1){
	$hash2{$_}=0 if !exists $hash2{$_};
	$rr=sprintf "%.4f",$hash2{$_}/$hash1{$_};
	print NN "$_\t$hash1{$_}\t$hash2{$_}\t$rr\n";


}

close NN;


