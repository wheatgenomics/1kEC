#!/usr/bin/perl -w
use Parallel::ForkManager;





$cmd="/home/feihe/tool/gcta_1.91.1beta/gcta64";


#@file=glob("tmpdir/bb_*vcf.gz");
#@file=glob("tmpdir/gWindow*bed.chrID.vcf.gz");
#@file=glob("tmpdir/gcta/dat_ABgenomeGP08/*vcf.gz");
#@file=glob("tmpdir/gcta/dat_ABgenomeGP08thin10Kmaf002/*vcf.gz");


#@file=glob("tmpdir/gcta/dat_1kEmmerThin10kMaf002/gWindow_fd*bed.chrID.vcf.gz");
#@file=glob("tmpdir/gcta/dat_1kEmmer/gWindow_fd*bed.chrID.vcf.gz");
#@file=glob("tmpdir/gcta/dat_allGP08/gWindow_fd*bed.chrID.vcf.gz");

#$file[0]="1000EC/tmpdir/aa.ffp400.bed.chrID.vcf.gz";
#$file[1]="1000EC/tmpdir/aa.ffp4.bed.chrID.vcf.gz";

#$file[0]="1000EC/tmpdir/aa.hot.vcf.gz";
$file[1]="1000EC/tmpdir/aa.cold.vcf.gz";
$file[0]="1000EC/tmpdir/aa.hot_filtered.recode.vcf";

$cpu=8;


$pm = new Parallel::ForkManager(5);

foreach $in(@file){
	
	my $pid = $pm->start and next;
	
	print "$in\n";	
	$out=$in;
	$out=~s/\.vcf\.gz//;
	`plink --vcf $in   --make-bed --out $out `;
	
	$cc="$cmd --bfile $out --autosome-num 30   --make-grm-inbred --out $out --thread-num $cpu";
	print "$cc\n";
	`$cc`;
	
	$pm->finish;

}

$pm->wait_all_children;
	


	

















