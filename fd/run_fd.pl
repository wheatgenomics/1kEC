#!/usr/bin/perl -w



open MM,"/home/DNA/shared_project/1000EC/data/1kEC_sample_information.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $tem[5] =~ /outgroup|species/ ;
	next if $tem[0] =~/accession/;
	
	#next if $tem[5] ne "lr";
	$i++;
	$acc{$tem[0]}=1;
}
close MM;




@tem=glob("res_data/GEOgroup_introgression/group*");
foreach $in(@tem){
	@name=split/_/,$in;
	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		#$acc{$_}=1;
	}
	close MM;
}

$n=@tem=keys %acc;
print "$n\n";

use Parallel::ForkManager;
$pm = new Parallel::ForkManager(48);

foreach $id(sort keys %acc){
	my $pid = $pm->start and next;
	print "$id\n";
	#$out="/home/feihe/project/1000genome/tmpdir/fd/res_data/outACC100SiteW_$id";
	$out="/home/feihe/project/1000genome/tmpdir/out4_psr920_$id";
	unlink($out);
	#chdir("/home/feihe/tool/genomics_general/");
	$mydir="/home/feihe/project/1000genome/tmpdir/tmp_fd_$id";
	`mkdir $mydir`;
	`cp /home/feihe/tool/genomics_general/ABBABABAwindows.py $mydir`;
	`cp /home/feihe/tool/genomics_general/genomics.py $mydir`;
	`cp /home/feihe/tool/genomics_general/genomics.pyc $mydir`;

	chdir("$mydir");
	$cmd="python ABBABABAwindows.py   -g /home/feihe/project/1000genome/tmpdir/fd/fdInput.allacc.iSiteOnly.gz -o $out  -T 1  -f diplo  -P1 emmerD emmerD1,emmerD10,emmerD11,emmerD12,emmerD13,emmerD14,emmerD15,emmerD16,emmerD17,emmerD18,emmerD19,emmerD2,emmerD20,emmerD21,emmerD22,emmerD23,emmerD24,emmerD25,emmerD26,emmerD27,emmerD28,emmerD29,emmerD3,emmerD30,emmerD31,emmerD32,emmerD33,emmerD34,emmerD35,emmerD4,emmerD5,emmerD6,emmerD7,emmerD8,emmerD9  -P2 Lr $id  -P3 emmerW emmerW1,emmerW10,emmerW11,emmerW12,emmerW13,emmerW14,emmerW15,emmerW16,emmerW17,emmerW18,emmerW19,emmerW2,emmerW20,emmerW21,emmerW22,emmerW23,emmerW24,emmerW25,emmerW26,emmerW27,emmerW28,emmerW29,emmerW3,emmerW30,emmerW31,emmerW32,emmerW33,emmerW4,emmerW5,emmerW6,emmerW7,emmerW8,emmerW9 -O OG outgroup --minData 0.5 --windCoords /home/feihe/project/1000genome/tmpdir/aa1  --windType predefined";

	print "$cmd\n\n";
	`$cmd`;	

	`rm -r $mydir`;
	#`python ABBABABAwindows.py   -g /home/feihe/project/1000genome/tmpdir/fd/fdInput.allLR.gz -o $out  -T 32  -f diplo  -P1 emmerD emmerD1,emmerD10,emmerD11,emmerD12,emmerD13,emmerD14,emmerD15,emmerD16,emmerD17,emmerD18,emmerD19,emmerD2,emmerD20,emmerD21,emmerD22,emmerD23,emmerD24,emmerD25,emmerD26,emmerD27,emmerD28,emmerD29,emmerD3,emmerD30,emmerD31,emmerD32,emmerD33,emmerD34,emmerD35,emmerD4,emmerD5,emmerD6,emmerD7,emmerD8,emmerD9  -P2 Lr $id  -P3 emmerW emmerW1,emmerW10,emmerW11,emmerW12,emmerW13,emmerW14,emmerW15,emmerW16,emmerW17,emmerW18,emmerW19,emmerW2,emmerW20,emmerW21,emmerW22,emmerW23,emmerW24,emmerW25,emmerW26,emmerW27,emmerW28,emmerW29,emmerW3,emmerW30,emmerW31,emmerW32,emmerW33,emmerW4,emmerW5,emmerW6,emmerW7,emmerW8,emmerW9 -O OG outgroup --minData 0.5 -w 100 --overlap 50 --windType sites  `;
	#`python ABBABABAwindows.py   -g /home/feihe/project/1000genome/tmpdir/fd/fdInput.acc.gz -o $out  -T 32  -f diplo  -P1 emmerD emmerD1,emmerD10,emmerD11,emmerD12,emmerD13,emmerD14,emmerD15,emmerD16,emmerD17,emmerD18,emmerD19,emmerD2,emmerD20,emmerD21,emmerD22,emmerD23,emmerD24,emmerD25,emmerD26,emmerD27,emmerD28,emmerD29,emmerD3,emmerD30,emmerD31,emmerD32,emmerD33,emmerD34,emmerD35,emmerD4,emmerD5,emmerD6,emmerD7,emmerD8,emmerD9  -P2 Lr $id  -P3 emmerW emmerW1,emmerW10,emmerW11,emmerW12,emmerW13,emmerW14,emmerW15,emmerW16,emmerW17,emmerW18,emmerW19,emmerW2,emmerW20,emmerW21,emmerW22,emmerW23,emmerW24,emmerW25,emmerW26,emmerW27,emmerW28,emmerW29,emmerW3,emmerW30,emmerW31,emmerW32,emmerW33,emmerW4,emmerW5,emmerW6,emmerW7,emmerW8,emmerW9 -O OG outgroup --minData 0.5 -w 100 --overlap 50 --windType sites  `;


	$pm->finish;

}

$pm->wait_all_children;






