#!/usrbin/perl -w


#updated on 02212018


#SNP filtering step:
#keep only selected samples, then,
#MAF>0.001 in the corresponding samples
#1 SNP per 1kb
#R2 of ld < 0.4
# of repeats (ADMIXTURE run) = 10 runs

#this script is to merge the 10 runs using clummp.


#set your # of accessions.
#This number is used to tell the script which dataset is used.

$acc=$ARGV[0];


$in="admixture/acc$acc"."_maf001_thin1k_ld04_rep*";
@dir=glob("$in");

for($q=2;$q<20;$q++){
	
	#set the input file name for clummp
	$in="tmpdir/acc$acc"."_maf001_thin1k_ld04_ind.$q";
	
	open NN,">$in" or die "l";
	foreach $dd(@dir){
	
	#set the Q file name
	$ff=$dd."/acc$acc"."_maf001_thin1k_ld04.$q.Q";
	print "$ff\n" if !-e $ff;
	$i=0;
	print "$ff\n";
	


	open MM,"$ff" or die "l";
	while(<MM>){
		
		$i++;
		chomp;
		@tem=split/\t| /;
		$ll=join " ",@tem;
		$n=11+ int $i/100;
		print NN "$i  $i  ($n)  $n  :  $ll\n";
	}
	close MM;
	print NN "\n"
	}

	close NN;

}








