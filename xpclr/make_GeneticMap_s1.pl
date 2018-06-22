#!/usr/bin/perl -w

use Parallel::ForkManager;






open MM,"Jan09_2017/v1/all.vcf.chrID" or die "l";
#open MM,"res_data/merged_AllVCF_nrFiltered_chr_sorted_freq.frq"  or die "l";
while(<MM>){
	chomp;
	next if $_=~/^#|^CHROM/;
	@tem=split/\t/;

	$data->{$tem[0]}->{$tem[1]}=1;
}
close MM;





$pm = new Parallel::ForkManager(22);


foreach (keys %$data){
	
	my $pid = $pm->start and next;

	open TM,">xpclr_dir5/SnpPosInfo_$_" or die "l";
	foreach $in(sort {$a <=> $b} keys %{$data->{$_}}){
		print TM "$in\n";
	}
	close TM;


	$pm->finish;
}
	
$pm->wait_all_children;

