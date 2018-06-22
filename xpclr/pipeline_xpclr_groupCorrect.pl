#!/usrbin/perl -w



#prepare group for xpclr
#updated 12/11/2017


#check local adaptation
#original vs. other geographical group

open MM,"/home/DNA/shared_project/1000EC/data/1kEC_sample_information.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	
	


	if($tem[3] =~/AsiaMiddle|MiddleEast/){
		$group2acc->{"ref"}->{$tem[0]}=1 ;
	
		next;
	}



	next if $tem[1] eq "AVS" && $tem[2] eq "AUSTRALIA"; #ignore Aus synthetic lines

	if($tem[9]=~/Asia/){
		$group2acc->{"Asia"}->{$tem[0]}=1 ;
	}
	if($tem[9]=~/OCEANIA/){
		$group2acc->{"OCEANIA"}->{$tem[0]}=1 ;
	}
	if($tem[9]=~/SOVIETUNION/){
		$group2acc->{"SOVIETUNION"}->{$tem[0]}=1 ;
	}
	

	if($tem[9]=~/AfricaNorth/){
		$group2acc->{"AfricaNorth"}->{$tem[0]}=1 ;
	}
	if($tem[9]=~/AfricaSouth/){
		$group2acc->{"AfricaSouth"}->{$tem[0]}=1 ;
	}



	if($tem[9]=~/AmeN/){
		$group2acc->{"AmeNorth"}->{$tem[0]}=1 ;
	}
	if($tem[9]=~/AmeCentral|AmeMexico/){
		$group2acc->{"AmeCentral"}->{$tem[0]}=1 ;
	}
	if($tem[9]=~/AmeS/){
		$group2acc->{"AmeSouth"}->{$tem[0]}=1 ;
	}

	if($tem[9]=~/EurBalkans|EurEast/){
		$group2acc->{"EurEast"}->{$tem[0]}=1 ;
	}
	if($tem[9]=~/EurIberian|EurNorth|EurWest/){
		$group2acc->{"EurWest"}->{$tem[0]}=1 ;
	}


}
close MM;



foreach (sort keys %$group2acc){
	$new="xpclr_dir6/groupAcc_$_";

	$n=@tem=sort keys %{$group2acc->{$_}};
	print "$_\t$n\n";
	open NN,">$new" or die "l";
	foreach $in(@tem){
		print NN "$in\n";
	}
	close NN;

}


die;

#check improvement
#landrace vs. cultiva
open MM,"/home/DNA/shared_project/1000EC/data/1kEC_sample_information.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	#$group2acc->{$tem[6]}->{$tem[0]}=1 if $tem[6] !~ /xpclr|\-/;
	if($tem[3] ne "AfricaN" && $tem[6] eq "ref"){
		$group2acc->{"ref"}->{$tem[0]}=1 ;
	}

	next if $tem[1] eq "AVS" && $tem[2] eq "AUSTRALIA"; #ignore Aus synthetic lines

	next if $tem[5] ne "cul";
	if($tem[9]=~/Asia/){
		$group2acc->{"Asia"}->{$tem[0]}=1 ;
	}
	if($tem[9]=~/OCEANIA/){
		$group2acc->{"OCEANIA"}->{$tem[0]}=1 ;
	}
	if($tem[9]=~/SOVIETUNION/){
		$group2acc->{"SOVIETUNION"}->{$tem[0]}=1 ;
	}
	
	if($tem[9]=~/Africa/){
		$group2acc->{"Africa"}->{$tem[0]}=1 ;
	}

	if($tem[9]=~/AmeN/){
		$group2acc->{"AmeNorth"}->{$tem[0]}=1 ;
	}
	if($tem[9]=~/AmeCentral|AmeMexico/){
		$group2acc->{"AmeCentral"}->{$tem[0]}=1 ;
	}
	if($tem[9]=~/AmeS/){
		$group2acc->{"AmeSouth"}->{$tem[0]}=1 ;
	}

	if($tem[9]=~/EurBalkans|EurEast/){
		$group2acc->{"EurEast"}->{$tem[0]}=1 ;
	}
	if($tem[9]=~/EurIberian|EurNorth|EurWest/){
		$group2acc->{"EurWest"}->{$tem[0]}=1 ;
	}




}
close MM;










