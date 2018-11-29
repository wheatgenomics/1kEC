#!/usr/bin/perl -w


#calculate fd value for each wheat population
#the same population in population admixture analysis was used here



open MM,"/home/DNA/shared_project/1000EC/data/1kEC_sample_information_updated02022018.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $_=~/^accession|outgroup/;
	next if $tem[9] eq "-";
	next if $tem[1] eq "AVS" && $_=~/AUSTRALIA/;
	
	push @{$pop2acc{$tem[9]}},$tem[0];
	

}
close MM;







$in="/home/feihe/project/1000genome/1000EC_10012018/tmpdir/fd/fdInput2000.gz";

$WT="WT1,WT2,WT3,WT4,WT5,WT6,WT7,WT8,WT9,WT10,WT11,WT12";
$WS1="WS1i1,WS1i2,WS1i3,WS1i4,WS1i5,WS1i6,WS1i7,WS1i8,WS1i9,WS1i10,WS1i11,WS1i12,WS1i13";
$WS2="WS2i1,WS2i2,WS2i3,WS2i4,WS2i5 ";







use Parallel::ForkManager;
$pm = new Parallel::ForkManager(8);
foreach $id(sort keys %pop2acc){
	
	
	my $pid = $pm->start and next;
	
	$ll=join ",",@{$pop2acc{$id}};






	$mydir="/home/feihe/project/1000genome/1000EC_10012018/tmpdir/tmp_str_$id";
	`mkdir $mydir`;
	`cp /home/feihe/tool/genomics_general/ABBABABAwindows.py $mydir`;
	`cp /home/feihe/tool/genomics_general/genomics.py $mydir`;
	`cp /home/feihe/tool/genomics_general/genomics.pyc $mydir`;

	chdir("$mydir");
	$out="/home/feihe/project/1000genome/1000EC_10012018/tmpdir/fd/res2000/population_based/str_group/out100SiteW.WS1_$id";	
	$cmd="python ABBABABAwindows.py -g $in -o $out -T 4  -f diplo  -P1 emmerD emmerD1,emmerD10,emmerD11,emmerD12,emmerD13,emmerD14,emmerD15,emmerD16,emmerD17,emmerD18,emmerD19,emmerD2,emmerD20,emmerD21,emmerD22,emmerD23,emmerD24,emmerD25,emmerD26,emmerD27,emmerD28,emmerD29,emmerD3,emmerD30,emmerD31,emmerD32,emmerD33,emmerD34,emmerD35,emmerD4,emmerD5,emmerD6,emmerD7,emmerD8,emmerD9  -P2 Lr $ll -P3 WE $WS1  -O OG outgroup --minData 0.5 -w 100 --overlap 50 --windType sites";
	print "$cmd\n";
	`$cmd`;


	$out="/home/feihe/project/1000genome/1000EC_10012018/tmpdir/fd/res2000/population_based/str_group/out100SiteW.WS2_$id";	
	$cmd="python ABBABABAwindows.py -g $in -o $out -T 4  -f diplo  -P1 emmerD emmerD1,emmerD10,emmerD11,emmerD12,emmerD13,emmerD14,emmerD15,emmerD16,emmerD17,emmerD18,emmerD19,emmerD2,emmerD20,emmerD21,emmerD22,emmerD23,emmerD24,emmerD25,emmerD26,emmerD27,emmerD28,emmerD29,emmerD3,emmerD30,emmerD31,emmerD32,emmerD33,emmerD34,emmerD35,emmerD4,emmerD5,emmerD6,emmerD7,emmerD8,emmerD9  -P2 Lr $ll -P3 WE $WS2  -O OG outgroup --minData 0.5 -w 100 --overlap 50 --windType sites";
	print "$cmd\n";
	`$cmd`;


	$out="/home/feihe/project/1000genome/1000EC_10012018/tmpdir/fd/res2000/population_based/str_group/out100SiteW.WT_$id";	
	$cmd="python ABBABABAwindows.py -g $in -o $out -T 4  -f diplo  -P1 emmerD emmerD1,emmerD10,emmerD11,emmerD12,emmerD13,emmerD14,emmerD15,emmerD16,emmerD17,emmerD18,emmerD19,emmerD2,emmerD20,emmerD21,emmerD22,emmerD23,emmerD24,emmerD25,emmerD26,emmerD27,emmerD28,emmerD29,emmerD3,emmerD30,emmerD31,emmerD32,emmerD33,emmerD34,emmerD35,emmerD4,emmerD5,emmerD6,emmerD7,emmerD8,emmerD9  -P2 Lr $ll -P3 WE $WT  -O OG outgroup --minData 0.5 -w 100 --overlap 50 --windType sites";
	print "$cmd\n";
	`$cmd`;

	
	`rm -r $mydir`;
	$pm->finish;

}

$pm->wait_all_children;






