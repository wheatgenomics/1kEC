#!/usrbin/perl -w







#this is the first step of sampling WEP site for partitioning phenotypic variance







#get the length of chromosome
#determine chromosome tip
open MM,"/home/DNA/genomeData/wheat_genome/CS_Ref/161010_Chinese_Spring_v1.0_pseudomolecules.fasta.fai"  or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	#$chr2length{$tem[0]}=$tem[1];


	$p1=$tem[1]*0.2;
	$p2=$tem[1]*0.8;
	
	$tem[0]=&changeName1($tem[0]);
	$chr2p1{$tem[0]}=$p1;
	$chr2p2{$tem[0]}=$p2;
	
}
close MM;

#get the ancestry allele
open MM,"result_data2000/ancestry.allele" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $_=~/^#/;
	$ancestry{$tem[0]}=$tem[1];
}
close MM;






#get the allele freq.
$freq="/home/feihe/project/1000genome/1000EC/vcf/imputation/all.GP08.wheat784_freq.frq";
open NN,">tmpdir/info" or die "l";
open MM,"$freq" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $_=~/^CHROM|nan/;
	#next if $tem[1] > $chr2p1{$tem[0]} && $tem[1] <  $chr2p2{$tem[0]} ;
	@aa=split/:/,$tem[4];
	@bb=split/:/,$tem[5];
	

	$tem[0]=&changeName2($tem[0]);
	$ss=$tem[0]."_".$tem[1];
	

	next if !exists  $ancestry{$ss};
	#print "$ss\n";

	if($aa[0] eq $ancestry{$ss}){
		$snp2df{$ss}=$bb[1];
	}elsif($bb[0] eq  $ancestry{$ss}){
		$snp2df{$ss}=$aa[1];
	}else{
		print "$ss\n";
	}
	next;
	if($aa[1]>$bb[1]){
		$maf=$bb[1];
	}else{
		$maf=$aa[1];
	}
	next if $maf<0.01;
	
	$snp2maf{$ss}=$maf;
	print NN "$ss\t$maf\n";
}
close MM;
close NN;




open MM,"result_data/1k_emmer_China_freq.frq" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $_=~/^CHROM/;
	$tem[0]=&changeName2($tem[0]);
	$ss=$tem[0]."_".$tem[1];
	$shared{$ss}=1;
}
close MM;





#get the WEP allele
open MM,"../1000EC/introgression/wildEmmerPD_Allele/allele_table.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $_=~/^#/;
	$id=$tem[0]."_".$tem[1];

	next if !exists $ancestry{$id};
	next if $tem[11] eq $ancestry{$id};
	$ss=$tem[0]."_".$tem[1];
	$WEP{$ss}=1;
}	
close MM;





open MM,"/home/feihe/project/1000genome/1000EC/vcf/imputation/all_wheat784_maf01.bim" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	@name=split/_/,$tem[1];
	$ss=$name[0]."_".$tem[3];
	
	$id{$ss}=$tem[1];

}
close MM;



#generate the list of WEP SNP site and other shared SNP sites
open AA,">tmpdir/aa" or die "l";
open BB,">tmpdir/bb" or die "l";
foreach (sort keys %id){
	next if !exists $snp2df{$_};
	
	if(exists $WEP{$_}){
		print AA "$_\t$id{$_}\t$snp2df{$_}\n";
	}
	if(exists $shared{$_} && !exists $WEP{$_}){
		print BB "$_\t$id{$_}\t$snp2df{$_}\n";
	}

}
close BB;
close AA;





$igr="tmpdir/res.SNPfreq.WEP";
$desert="tmpdir/res.SNPfreq.WEPother";


`mv tmpdir/aa $igr`;
`mv tmpdir/bb $desert`;













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





