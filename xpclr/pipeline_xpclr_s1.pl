#!/usr/bin/perl -w


use Parallel::ForkManager;

$pm = new Parallel::ForkManager(16);
#@file=glob("Jan09_2017/imputated_GT_overlap500/*GT*vcf.gz");
@file=glob("Jan09_2017/v1/*_beagleOutGL.783.vcf.GP08_maf01.recode.het.vcf");


foreach $in(@file){
	

	my $pid = $pm->start and next; 
	
	@name=split/\//,$in;
	next if $name[-1]=~/^22/;
	print "$in\n";
	
	@tem=split/_/,$name[-1];
	$out="xpclr_dir5/".$name[-1];
	$out=~s/\.vcf//;
	
	#`vcftools --gzvcf $in --maf 0.01 --thin 100 --plink --out $out --chr $tem[0] `;
	`vcftools --vcf $in --maf 0.01 --thin 100 --plink --out $out --chr $tem[0] `;
	
	$out2=$out.".recode01";
	` plink --file  $out --recode 01 --output-missing-genotype 9 --out $out2`;
	
	unlink("$out");

	$pm->finish; 
}

$pm->wait_all_children;




