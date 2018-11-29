#!/usrbin/perl -w



$sp{'WT'}=1;
$sp{'WS1'}=1;
$sp{'WS2'}=1;
foreach (sort keys %sp){
	print "$_\n";
}


























open MM,"result_data2000/geneList2window.edited" or die "l";
#open MM,"../1000EC/tmpdir/geneList2window.edited" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$tem[3]=&changeName1($tem[3]);
	#$gene2win{$tem[0]}=$tem[3]."\t".$tem[4]."\t".$tem[5];
	$win2gene{$tem[3]."\t".$tem[4]."\t".$tem[5]}=$tem[0];
}
close MM;

open MM,"../1000EC/data/sample_for_populationStructureAnalysis.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $_=~/domesticatedE|improvementStatus|wildE/;
	$acc{$tem[0]}=1;

}
close MM;

$n=@tem=keys %acc;
print "$n\n";

#@file=glob("tmpdir/fd/res2000/accession_based/out100SiteW.*_*");


open NN,">tmpdir/res" or die "l";
#foreach $in(@file){
	
$in="result_data2000/fdAcc.max";
	@name=split/_/,$in;
	print "$in\n";
	
	#get fd>0 window in each acc
	open MM,"$in" or die "l";
	while(<MM>){
		next if $_=~/scaffold/;
		chomp;
		@tem=split/,|\t/;
		next if !exists $acc{$tem[0]};
		#next if $tem[7] =~/nan/ || $tem[7]>1 || $tem[7]<0;
		$tem[1]=&changeName1($tem[1]);
		#print TM "$tem[0]\t$tem[1]\t$tem[2]\n";
		
		
		
		next if !exists $win2gene{$tem[1]."\t".$tem[2]."\t".$tem[3]};
		#$dat->{$name[-1]}->{$win2gene{$tem[1]."\t".$tem[2]."\t".$tem[3]}}=$tem[4];
		$id=$tem[1]."\t".$tem[2]."\t".$tem[3];
		print NN "$tem[0]\t$win2gene{$id}\t$tem[4]\n";
	}
	close MM;
	
	

close NN;















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





