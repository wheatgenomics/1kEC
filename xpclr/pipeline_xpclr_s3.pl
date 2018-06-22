#!/usr/bin/perl -w


use Parallel::ForkManager;



@file=glob("/home/feihe/project/1000genome/xpclr_dir6/groupAcc_*ped");


$pm = new Parallel::ForkManager(32);

foreach $in(@file){
	my $pid = $pm->start and next;

	print "$in\n";
	$new=$in.".r";
	$out=$in.".RoutFile";
	open TM,">$new" or  die "l";

	print TM "iw=read.table('$in',head=F)\n";
	print TM "iw=iw[,-c(1:6)]\n";
	print TM "iw=t(iw)\n";
	print TM "write.table(iw,'$out',col.names=F,row.names=F)\n";
	close TM;
	`R CMD BATCH $new`;
	`perl pipeline_xpclr_s3_ped2xpclr.pl $out`;


	$pm->finish;
}
$pm->wait_all_children;




