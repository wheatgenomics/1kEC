#!/usr/bin/perl -w

open MM,"../genome_mapping/res_data/emmerSNP_on_CS/matched_SNP_all" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	@name=split/_/,$tem[2];
	$em2cs{$name[1]."_".$name[2]}=$tem[0]."_".$tem[1];
	$cs2em{$tem[0]."_".$tem[1]}=$name[1]."_".$name[2];

}
close MM;


open MM,"res_data/introgression_file/allele_match_info2" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$cs2type{$tem[0]."_".$tem[1]}=$tem[-1];
	$cs2allele{$tem[0]."_".$tem[1]}=$_;
}
close MM;



@file=glob("../genome_mapping/res_data/emmerSNP_on_CS/emmerSNPmappingInfo_chr*");
foreach $in(@file){
	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		@tem=split/\t/;
		@name=split/_/,$tem[2];
		next if !exists $cs2type{$tem[3]."_".$tem[4]};
		$direction{$tem[3]."_".$tem[4]}=$tem[5];

	}
	close MM;

}






open MM,"res_data/introgression_file/emmerHC.frq" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^CHROM/;
	@tem=split/\t/;
	$tem[0]=&changeName2($tem[0]);
	@aa=split/:/,$tem[4];
	@bb=split/:/,$tem[5];
	if($aa[1]>$bb[1]){
		$maf=$tem[5];
	}else{
		$maf=$tem[4];
	}

	$frq1{$tem[0]."_".$tem[1]}=$maf;


}
close MM;




open NN,">tmpdir/res" or die "l";
open MM,"data/emmerVCF/combined_beagleOut.frq" or die "l";
while(<MM>){
	chomp;
	next if $_=~/^CHROM/;
	@tem=split/\t/;
	@aa=split/:/,$tem[4];
	@bb=split/:/,$tem[5];
	next if length $aa[0] > 1 ||  length $bb[0] > 1 ;


	next if !exists $em2cs{$tem[0]."_".$tem[1]};
	$ss=$em2cs{$tem[0]."_".$tem[1]};
	
	next if exists $hash{$ss};
	$hash{$ss}++;
	
	#print "$tem[0]\n";
	next if !exists $frq1{$ss};
	
	if($aa[1]>$bb[1]){
		$maf=$tem[5];
	}else{
		$maf=$tem[4];
	}

	print NN "$ss\t$tem[0]\t$tem[1]\t$maf\t$frq1{$ss}\t$cs2type{$ss}\t$direction{$ss}\t$aa[0]\t$bb[0]\t$cs2allele{$ss}\n";


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





