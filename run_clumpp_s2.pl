#!/usrbin/perl -w



#usage:
#perl run_clummp_s2.pl #_of_accessions


chdir("tmpdir");

$acc=$ARGV[0];
@file=glob("acc$acc"."_maf001_thin1k_ld04_ind.*");

foreach $in(@file){
	
	next if $in=~/out$|mis$|lot$/;
	$out=$in.".out";
	$mis=$in.".mis";
	@name=split/\./,$in;

	print "running clumpp for $in\n";
$info=<<EOF;
DATATYPE 0
INDFILE $in
OUTFILE $out
MISCFILE $mis
K $name[-1]
C $acc
R 10
M 3
W 0
S 2
GREEDY_OPTION 2
REPEATS 100
PRINT_EVERY_PERM 0
PRINT_RANDOM_INPUTORDER 0
EVERY_PERMFILE bb
PRINT_PERMUTED_DATA 0


OVERRIDE_WARNINGS 0
ORDER_BY_RUN 1 

EOF


	open NN,">paramfile" or die "l";
	print NN "$info\n\n";
	close NN;



	`/home/feihe/tool/CLUMPP_Linux64.1.1.2/CLUMPP`;



}



