#!/usr/bin/perl -w

#$vcf="1000EC/vcf/imputation/ABgenome.GP08.vcf.gz";
#$vcf="1000EC/vcf/imputation/ABgenome.GP08_thin10k_maf002.recode.vcf.gz";
#$vcf="1000EC/vcf/shared_SNPsites_with_otherDatasets/1k_emmer.vcf";


#open MM,"1000EC/summary_resultsData/info_fdCount.allAccession.1Mb" or die "l";
#open MM,"1000EC/summary_resultsData/info_fdCount.allAccession.1Mb" or die "l";
#open MM,"1000EC/summary_resultsData/info_fdCount.allAccession" or die "l";

open MM,"tmpdir/info_fd5m" or die "l";

#open MM,"1000EC/tmpdir/info" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^#/;
	@tem=split/\t/;
	#if($tem[3]==0){
	#	$hash2{$tem[0]."\t".$tem[1]."\t".$tem[2]}=0;
	#}else{
		$hash{$tem[0]."\t".$tem[1]."\t".$tem[2]}=$tem[3];
	
	#}
}
close MM;

foreach (sort {$hash{$a}<=>$hash{$b} || $a cmp $b} keys %hash ){
	push @oo,$_;
}
$n=int @oo/5;



`rm tmpdir/aa_*`;
=head
open TM,">tmpdir/aa_desert" or die "l";
foreach (keys %hash2){
	@tem=split/\t/;
	$tem[0]=&changeName1($tem[0]);
	print TM "$tem[0]\t$tem[1]\t$tem[2]\n";
}
close TM;
=cut

print "$n\n";
for($i=0;$i<@oo;$i=$i+$n){
	$ii=int $i/$n;
	open TM,">tmpdir/aa_$ii" or die "l";
	for($j=0;$j<$n;$j++){

		next if $i+$j+1 > @oo;
		@tem=split/\t/,$oo[$i+$j];
		$tem[0]=&changeName1($tem[0]);
		print TM "$tem[0]\t$tem[1]\t$tem[2]\n";
		#print TM "$tem[0]\t$tem[1]\t$tem[2]\t$hash{$oo[$i+$j]}\n";
	}
	close TM;


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





