#!/usrbin/perl -w


$acc=$ARGV[0];



#$in="admixture/acc$acc"."_maf001_thin1k_ld04_merged/acc$acc"."_maf001_thin1k_ld04_ind.*.out*forPlot";
$in="admixture/acc$acc"."_maf001_thin1k_ld04_merged/acc$acc"."_maf001_thin1k_ld04_ind.100.out*forPlot";
@file=glob("$in");



print "the R code is here:\ntmpdir/res\nYou can run it in R, from the current dir\n";


open NN,">tmpdir/res" or die "l";

#print NN "poplab=read.delim('~/project/1000genome/1000EC/admixture/1k_emmer_100kThinned/popLabel.txt',stringsAsFactors = F,head=F)\n\n";
print NN "poplab=read.delim('tmpdir/popLabel_acc$acc.txt',stringsAsFactors = F,head=F)\n\n";


foreach $in(@file){
	print NN "iw=readQ('$in')\n";

	print NN "plotQ(iw,grplab=poplab,sortind ='all',grplabsize = 1,grplabangle = 70,grplabjust = 1,grplabpos = 1,linetype = 2,linesize=0.1,grplabheight = 1.7,pointsize = 1.5, divsize=0.1,divalpha = 0.2 )\n\n";
	#print NN "plotQ(iw,grplab=poplab,sortind ='all',grplabsize = 1,grplabangle = 90,grplabjust = 0.5,grplabpos = 0.2,linetype = 2,grplabheight = 1.7,pointsize = 1.5)\n\n";
}
close NN;



print "after you run the output script in R, the png files(bar plot) will be stored in current dir\n";
