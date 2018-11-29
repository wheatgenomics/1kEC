#!/usr/bin/perl -w



#this script is used to calculate fd value for each accession


open MM,"/home/DNA/shared_project/1000EC/data/1kEC_sample_information.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	#next if $tem[5] =~ /outgroup|species/ ;
	next if $tem[0] =~/accession/;
	next if $tem[1] eq "AVS" && $_=~/AUSTRALIA/;
	
	#if ($tem[4] =~/compactum|macha|spelta|sphaerococcum/){
		
		$i++;
		$acc{$tem[0]}=1;
	#}
}
close MM;

$acc{'ExomeCapture-WSC-4-8'}=1;
$acc{'ExomeCapture-WSC-7-5'}=1;


$in="/home/feihe/project/1000genome/1000EC_10012018/tmpdir/fd/fdInput2000.gz";

#north wild emmer sub population
$WT="WT1,WT2,WT3,WT4,WT5,WT6,WT7,WT8,WT9,WT10,WT11,WT12";

#south2 wild emmer sub population
$WS1="WS1i1,WS1i2,WS1i3,WS1i4,WS1i5,WS1i6,WS1i7,WS1i8,WS1i9,WS1i10,WS1i11,WS1i12,WS1i13";

#south1 wild emmer sub population
$WS2="WS2i1,WS2i2,WS2i3,WS2i4,WS2i5 ";


use Parallel::ForkManager;
$pm = new Parallel::ForkManager(16);

foreach $id(sort keys %acc){
	my $pid = $pm->start and next;
	print "$id\n";




	$mydir="/home/feihe/project/1000genome/1000EC_10012018/tmpdir/tmp_fd_$id";
	`mkdir $mydir`;
	`cp /home/feihe/tool/genomics_general/ABBABABAwindows.py $mydir`;
	`cp /home/feihe/tool/genomics_general/genomics.py $mydir`;
	`cp /home/feihe/tool/genomics_general/genomics.pyc $mydir`;

	chdir("$mydir");
	$out="/home/feihe/project/1000genome/1000EC_10012018/tmpdir/fd/res2000/accession_based/out100SiteW.WS1_$id";	
	$cmd="python ABBABABAwindows.py -g $in -o $out -T 2  -f diplo  -P1 emmerD emmerD1,emmerD10,emmerD11,emmerD12,emmerD13,emmerD14,emmerD15,emmerD16,emmerD17,emmerD18,emmerD19,emmerD2,emmerD20,emmerD21,emmerD22,emmerD23,emmerD24,emmerD25,emmerD26,emmerD27,emmerD28,emmerD29,emmerD3,emmerD30,emmerD31,emmerD32,emmerD33,emmerD34,emmerD35,emmerD4,emmerD5,emmerD6,emmerD7,emmerD8,emmerD9  -P2 Lr $id -P3 WE $WS1  -O OG outgroup --minData 0.5 -w 100 --overlap 50 --windType sites";
	print "$cmd\n";
	`$cmd`;


	$out="/home/feihe/project/1000genome/1000EC_10012018/tmpdir/fd/res2000/accession_based/out100SiteW.WS2_$id";	
	$cmd="python ABBABABAwindows.py -g $in -o $out -T 2  -f diplo  -P1 emmerD emmerD1,emmerD10,emmerD11,emmerD12,emmerD13,emmerD14,emmerD15,emmerD16,emmerD17,emmerD18,emmerD19,emmerD2,emmerD20,emmerD21,emmerD22,emmerD23,emmerD24,emmerD25,emmerD26,emmerD27,emmerD28,emmerD29,emmerD3,emmerD30,emmerD31,emmerD32,emmerD33,emmerD34,emmerD35,emmerD4,emmerD5,emmerD6,emmerD7,emmerD8,emmerD9  -P2 Lr $id -P3 WE $WS2  -O OG outgroup --minData 0.5 -w 100 --overlap 50 --windType sites";
	print "$cmd\n";
	`$cmd`;


	$out="/home/feihe/project/1000genome/1000EC_10012018/tmpdir/fd/res2000/accession_based/out100SiteW.WT_$id";	
	$cmd="python ABBABABAwindows.py -g $in -o $out -T 2  -f diplo  -P1 emmerD emmerD1,emmerD10,emmerD11,emmerD12,emmerD13,emmerD14,emmerD15,emmerD16,emmerD17,emmerD18,emmerD19,emmerD2,emmerD20,emmerD21,emmerD22,emmerD23,emmerD24,emmerD25,emmerD26,emmerD27,emmerD28,emmerD29,emmerD3,emmerD30,emmerD31,emmerD32,emmerD33,emmerD34,emmerD35,emmerD4,emmerD5,emmerD6,emmerD7,emmerD8,emmerD9  -P2 Lr $id -P3 WE $WT  -O OG outgroup --minData 0.5 -w 100 --overlap 50 --windType sites";
	print "$cmd\n";
	`$cmd`;

	
	`rm -r $mydir`;
	$pm->finish;

}

$pm->wait_all_children;






