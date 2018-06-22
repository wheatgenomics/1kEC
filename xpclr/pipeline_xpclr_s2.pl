#!/usr/bin/perl -w


use Parallel::ForkManager;



#@file=glob("xpclr_dir2/*GT*recode01*ped");
#@group=glob("xpclr_dir2/groupAcc_*");

@file=glob("xpclr_dir5/*GL*recode01*ped");
@group1=glob("xpclr_dir6/groupAcc_*");
foreach (@group1){
	push @group,$_ if $_ !~/ped/;
}
print "@group\n";



$pm = new Parallel::ForkManager(32);

foreach $in(@file){
	
	my $pid = $pm->start and next;
	
	foreach $gg(@group){
		next if $gg=~/\./;
		print "$in\t$gg\n";
		
		`perl pipeline_xpclr_s2_filterPED.pl $gg $in `;
	
	}
	
	$pm->finish; 
}




$pm->wait_all_children;

