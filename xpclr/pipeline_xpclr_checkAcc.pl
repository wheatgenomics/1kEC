#!/usr/bin/perl -w





#@file=glob("xpclr_dir2/*GT*recode01*ped");
@group=glob("xpclr_dir2/groupAcc_*");

foreach (@group){
	next if $_=~/ped/;
	push @file,$_;
	#print "$_\n";
	#`cp $_ xpclr_dir3/`;
}


open MM,"res_data/sampleList_wheat783" or die "l";
while(<MM>){
	chomp;
	$list{$_}=1;
}	
close MM;

foreach $in(@file){
	print "=$in\n";
	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		print "$in\t$_\n" if exists $list{$_};
	
	}
	close MM;

}




