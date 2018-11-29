#!/usr/bin/perl -w



#compare FI and divergence(fst,dxy)






use Statistics::RankCorrelation;





open NN,">tmpdir/aa" or die "l";

open MM,"result_data2000/IF.allP3.max.allWin" or die "l";
#open MM,"result_data2000/IF.south1" or die "l";
while(<MM>){
	next if $_=~/^#/;
	chomp;
	@tem=split/\t/;
	next if $tem[3]==0;
	print NN "$tem[0]\t$tem[1]\t$tem[2]\t$tem[0]:$tem[1]\t$tem[3]\n";

}
close MM;
close NN;
`sort-bed tmpdir/aa >tmpdir/aa1`;



#read the population statistics
#those statistic are based on share SNP
#$f1="basic_popGen_statistic/outPopGen_lrVScul"; #this file has the statistic for lr and cul
#$f1="../1000EC/basic_popGen_statistic/outPopGen_emmerWVSemmerD"; #this file has the statistic for emmerW and emmerD
#$f1="../1000EC/basic_popGen_statistic/outPopGen_wheatVSemmerD";
$f1="../1000EC/basic_popGen_statistic/outPopGen_wheatVSemmerW";
#$f1="result_data/popGeneWin.LR_vs_WEws2";
#$f1="result_data/popGeneWin.wheat_vs_WEws2";
#$f1="result_data/popGeneWin.DE_vs_WEws2";


#ws2 is south1


#other files with similar names can be found in the same folder, basic_popGen_statistic
#outPopGen_wheatVSemmerD
#and etc.


open MM,"$f1" or die "l";
open NN,">tmpdir/aa" or die "l";
while(<MM>){
	chomp;
	@tem = split /,/;
	next if $_=~/^sca/;
	$tem[0]=&changeName2($tem[0]);
	
	#do you want to get the pi diversity for lr or cul?
	#do you want to get the compare fst or dxy?;
	#set it here:
	#tem[5], $tem[6] is pi for each population
	#$tem[7] is the dxy
	#$tem[8] is the fst
	#print NN "$tem[0]\t$tem[1]\t$tem[2]\t$tem[0]:$tem[1]\t$tem[6]\n"; #pi for cul
	print NN "$tem[0]\t$tem[1]\t$tem[2]\t$tem[0]:$tem[1]\t$tem[7]\n"; 


}
close NN;




#compare pi aganist introgression freq.
`sort-bed tmpdir/aa > tmpdir/aa2`;
`bedmap --echo --count --mean tmpdir/aa1 tmpdir/aa2 > tmpdir/aa`;
`sed -i 's/|/\t/g' tmpdir/aa`;	

print "in the output file, tmpdir/res\n, the first column is the introgression freq. for a genomic window\n";
print "the second column is the pi diversity (or dxy/fst)for that window\n";
`cut -f5,7 tmpdir/aa > tmpdir/res`;
`awk '{print \$2"\t"\$1}' tmpdir/res > tmpdir/res2`;




undef @aa;
undef @bb;
open MM,"tmpdir/res" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	push @aa,$tem[0];
	push @bb,$tem[1];
}
close MM;

$N=@aa;
use Statistics::RankCorrelation;
$c = Statistics::RankCorrelation->new( \@aa, \@bb, sorted => 1 );
$n = $c->spearman;
$n=sprintf "%.4f",$n;
print "sCC=\t$n\t$N\n";








sub getLen{
	my $in=shift;
	my $l2;
	my $l1=0;

	open MM,"$in" or die "l";
	my @all=<MM>;
	close MM;
	foreach $in (@all){
		chomp $in;
		@tem=split/\t|\|/,$in;
		$l2 = $tem[2]-$tem[1];
		$l1 += $l2;
	
	}

	$l1=sprintf "%.2e",$l1;
	return $l1;



}




sub changeName1{

		my $id=$_[0];
		my $id2;
$id2=	1	if	$id eq 	"chr1A"	;
$id2=	2	if	$id eq	"chr1B"	;
$id2=	3	if	$id eq	"chr1D"	;
$id2=	4	if	$id eq	"chr2A"	;
$id2=	5	if	$id eq	"chr2B"	;
$id2=	6	if	$id eq	"chr2D"	;
$id2=	7	if	$id eq	"chr3A"	;
$id2=	8	if	$id eq	"chr3B"	;
$id2=	9	if	$id eq	"chr3D"	;
$id2=	10	if	$id eq	"chr4A"	;
$id2=	11	if	$id eq	"chr4B"	;
$id2=	12	if	$id eq	"chr4D"	;
$id2=	13	if	$id eq	"chr5A"	;
$id2=	14	if	$id eq	"chr5B"	;
$id2=	15	if	$id eq	"chr5D"	;
$id2=	16	if	$id eq	"chr6A"	;
$id2=	17	if	$id eq	"chr6B"	;
$id2=	18	if	$id eq	"chr6D"	;
$id2=	19	if	$id eq	"chr7A"	;
$id2=	20	if	$id eq	"chr7B"	;
$id2=	21	if	$id eq	"chr7D"	;
$id2=	22	if	$id eq	"chrUn"	;



		return $id2;
}






sub changeName2{
		
		my $id=$_[0];
		my $id2;
$id2= "chr1A" if $id== 1 ;
$id2= "chr1B" if $id== 2 ;
$id2= "chr1D" if $id== 3 ;
$id2= "chr2A" if $id== 4 ;
$id2= "chr2B" if $id== 5 ;
$id2= "chr2D" if $id== 6 ;
$id2= "chr3A" if $id== 7 ;
$id2= "chr3B" if $id== 8 ;
$id2= "chr3D" if $id== 9 ;
$id2= "chr4A" if $id== 10 ;
$id2= "chr4B" if $id== 11 ;
$id2= "chr4D" if $id== 12 ;
$id2= "chr5A" if $id== 13 ;
$id2= "chr5B" if $id== 14 ;
$id2= "chr5D" if $id== 15 ;
$id2= "chr6A" if $id== 16 ;
$id2= "chr6B" if $id== 17 ;
$id2= "chr6D" if $id== 18 ;
$id2= "chr7A" if $id== 19 ;
$id2= "chr7B" if $id== 20 ;
$id2= "chr7D" if $id== 21 ;
$id2= "chrUn" if $id== 22 ;



		return $id2;

}





