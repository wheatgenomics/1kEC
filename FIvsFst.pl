#!/usr/bin/perl -w

#compare FI and fst



use Statistics::RankCorrelation;





open NN,">tmpdir/aa" or die "l";

#open MM,"result_data2000/IF.allP3.LR" or die "l";
#open MM,"result_data2000/IF.allP3.max.allWin" or die "l";
open MM,"result_data2000/IF.south1" or die "l";
while(<MM>){
	next if $_=~/^#/;
	chomp;
	@tem=split/\t/;
	#next if $tem[3]==0;
	print NN "$tem[0]\t$tem[1]\t$tem[2]\t$tem[0]:$tem[1]\t$tem[3]\n";

}
close MM;
close NN;
`sort-bed tmpdir/aa >tmpdir/aa1`;




open NN,">tmpdir/aa" or die "l";

#open MM,"tmpdir/fst/aa.outFST_WEsouth1.vs.LR.weir.fst" or die "l";
open MM,"tmpdir/fst/aa.outFST_WEsouth1.vs.DE.weir.fst" or die "l";
while(<MM>){
	chomp;
	next if $_=~/CHROM/;
	
	@tem = split /\t/;
	
	next if $tem[2]=~/na/;
	$tem[0]=&changeName2($tem[0]);
	#next if  $tem[2] ==0;

	

	$p2=$tem[1]+1;
	print NN "$tem[0]\t$tem[1]\t$p2\t$tem[0]:$tem[1]\t$tem[2]\n"; 
}
close MM;
close NN;









#compare pi aganist introgression freq.
`sort-bed tmpdir/aa > tmpdir/aa2`;
`bedmap --echo --count --range 100000 --skip-unmapped --mean tmpdir/aa1 tmpdir/aa2 > tmpdir/aa`;
`sed -i 's/|/\t/g' tmpdir/aa`;	

print "in the output file, tmpdir/res\n, the first column is the introgression freq. for a genomic window\n";
print "the second column is the pi diversity (or dxy/fst)for that window\n";
`cut -f5,7 tmpdir/aa > tmpdir/res`;




`awk '{print \$1"\t"\$2}' tmpdir/res > tmpdir/res1`;


`awk '{print \$2"\t"\$1}' tmpdir/res > tmpdir/res2`;












undef @aa;
undef @bb;

open NN,">tmpdir/info" or die "l";
open MM,"tmpdir/res" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	
	if($tem[0]==0){
		print NN "other\t$_\n";
		next;
	
	}else{
		print NN "IGR\t$_\n" if $tem[0]>20 ;
		print NN "middle\t$_\n" if $tem[0]<=20 ;
	}
	
	push @aa,$tem[0];
	push @bb,$tem[1];
}
close MM;
close NN;


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





