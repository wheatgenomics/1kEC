#!/usr/bin/perl -w





open MM,"/home/feihe/genome_data/wheat_genome/CS_Ref/161010_Chinese_Spring_v1.0_pseudomolecules.fasta.fai"  or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$id=$tem[0];
	#$id=changeName1($tem[0]);
	$chr2length{$id}=$tem[1];
	print "$id\t$tem[1]\n";
}
close MM;


open NN,">tmpdir/res" or die "l";
open MM,"/home/DNA/genome_data/wheat_genome/CS_Ref/iwgsc_refseqv1.0_all_chromosomes/161010_Chinese_Spring_v1.0_pseudomolecules_AGP.tsv" or die "l";
while(<MM>){
	next if $_=~/agp_end|^#/;
	chomp;
	@tem=split/\t/;

	#next if $tem[0]=~/D|Un/;
	next if $tem[5] eq "gap"  || $tem[0]=~/un/i;
	next if $tem[-1] eq "NA";
	next if $tem[-1] == 0;

	$mm=($tem[2]-$tem[1])/2+$tem[1];
	print NN "$tem[0]\t$tem[1]\t$tem[2]\t$mm\t$tem[-1]\n";

}
close MM;
close NN;


`rm tmpdir/res.*`;
foreach $in(keys %chr2length){

	$new="tmpdir/res.$in";
	`grep $in tmpdir/res > $new`;

}





@file=glob("tmpdir/res.chr*");

`rm tmpdir/recombRate_*`;
foreach $in(@file){
	next if $in =~/Un/;
	undef @all;
	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		push @all,$_;
	}
	close MM;
	@name=split/\./,$in;
	$new="tmpdir/recombRate_$name[-1]";
	open NN,">$new" or die "l";
	#print NN "position COMBINED_rate(cM/Mb) Genetic_Map(cM)\n";
	
	
	@aa=split/\t/,$all[0];
	
	if($aa[3] ==0 ){
	
		print "=$in\n$_\n";
		die;
	}
	$rr=$aa[4]/$aa[3];
	$rr=$rr*10**6;
	print NN "$all[0]\t$rr\n";
	for($i=1;$i<@all;$i++){
		@aa=split/\t/,$all[$i-1];
		@bb=split/\t/,$all[$i];
		next if $bb[3] eq $aa[3];
		$rr=($bb[4]-$aa[4])/($bb[3]-$aa[3]);
		$rr=$rr*10**6;
		
		$rr=0 if $rr<0;
		print NN "$all[$i]\t$rr\n";
		
	}
	close NN;

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





