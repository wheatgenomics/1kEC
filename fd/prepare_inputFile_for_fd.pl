#!/usrbin/perl -w


#ancestry allele inferred by aligning(BLASTN) flanking sequence to multiple outgroup species
open MM,"result_data/res.ancestryAllele.estimate" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $_=~/^#/;
	next if $tem[1]<0.75;
	$snp2A{$tem[0]}=$tem[4];
}
close MM;
$n=@tem=keys %snp2A;
print "$n\n";


#allele frequency for the wheat landrace
open MM,"../1000EC/resultsData/1k_emmer_lr.frq" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $_=~/^#|^CHROM/;
	
	$id=$tem[0]."_".$tem[1];
	@aa=split/:/,$tem[4];
	@bb=split/:/,$tem[5];
	if($aa[1]>$bb[1]){
		$snp2major{$id}=$aa[0];
		$snp2minor{$id}=$bb[0];
	}else{
		$snp2major{$id}=$bb[0];
		$snp2minor{$id}=$aa[0];
	
	}

}
close MM;

#ancestry allele probablity from est-sfs
#Keightley and Jackson, Genetics 209: 897-906 (2018).
open MM,"result_data/sfs.all.LR" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $_=~/^#|^CHROM/;

	#use SNP sites where 75% outgroup species have the same allele
	next if !exists $snp2A{$tem[0]};
	
	#the minimum probability (that major allele is ancestry allele) 
	#if it is < 0.1, then use the minor allele as ancestry allele
	if($tem[2]<0.1){
		next if $snp2A{$tem[0]} ne $snp2minor{$tem[0]};
		$snp2a{$tem[0]}=$snp2minor{$tem[0]};
		$n1++;
	}
	#if it is > 0.0, then use the major allele as ancestry allele
	if($tem[2]>0.9){
		next if $snp2A{$tem[0]} ne $snp2major{$tem[0]};
		$snp2a{$tem[0]}=$snp2major{$tem[0]};
		$n2++;
	}
	
}
close MM;
$n=@tem=keys %snp2a;
print "$n\n";


print "$n1\t$n2\n";

open NN,">tmpdir/aa" or die "l";
foreach (sort keys %snp2a){
	print NN "$_\t$snp2a{$_}\n";
}
close NN;






#wild emmer sub population
open MM,"result_data/sampleList_emmerW.subPop" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$acc2id{$tem[0]}=$tem[5];
}
close MM;






#domesticated emmer sample list
$i=0;
open MM,"/home/feihe/project/1000genome/data/emmerVCF/sampleList_domesticated" or die "l";
while(<MM>){
	$i++;
	chomp;
	$acc2info{$_}="emmerD";
	$acc2id{$_}="emmerD".$i
}
close MM;

$acc2info{'ExomeCapture-TA-12197'}="outgroup";
$acc2id{'ExomeCapture-TA-12197'}="outgroup";



#vcf for shared SNP between emmer and wheat

$n1=$n2=$n3=0;
open MM,"/home/feihe/project/1000genome/1000EC/vcf/shared_SNPsites_with_otherDatasets/1k_emmer.vcf" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;



	if($_=~/^#CHROM/){
		@sample=@tem;
	}
	next if $_=~/^#/;
	@name=split/;/,$tem[2];
	next if !exists $snp2a{$name[1]};
	#next if $tem[0] ne 10;
	#next if $tem[1]<154356794 || $tem[1]>202602723;


	for($i=9;$i<@tem;$i++){
		
		#generate a pseudo-outgroup in the input file
		if($sample[$i] eq "ExomeCapture-TA-12197"){
			if($snp2a{$name[1]} eq $tem[3] ){
				$n1++;
				$tem[$i] = "0/0";
			}elsif($snp2a{$name[1]} eq $tem[4]){
				$n2++;
				$tem[$i] = "1/1";
			}else{
				$n3++;
				$tem[$i] = "./.";
			}
		
		}
		
		if($tem[$i] eq "1/1"){
			$dat->{$tem[0]}->{$tem[1]}->{$sample[$i]}=$tem[4];
		}elsif($tem[$i] eq "0/0"){
			$dat->{$tem[0]}->{$tem[1]}->{$sample[$i]}=$tem[3];
		}elsif($tem[$i] eq "0/1" || $tem[$i] eq "1/0"  ){
			$dat->{$tem[0]}->{$tem[1]}->{$sample[$i]}="R";
		}elsif($tem[$i] eq "./."){
			$dat->{$tem[0]}->{$tem[1]}->{$sample[$i]}="N";
		
		}else{
			print "w\n";
		}
		$allsample{$sample[$i]}=1;
	}
	

}
close MM;

print "$n1\t$n2\t$n3\n";


#generate input file for fd calculate
open NN,">tmpdir/fdInput2001" or die "l";
print NN "#scaffold\tposition";
foreach (sort keys %allsample){
	$acc2id{$_}=$_ if !exists $acc2id{$_};
	print NN "\t$acc2id{$_}";
}
print NN "\n";
foreach $cc(sort %$dat){
	foreach $pp(sort {$a<=>$b} keys %{$dat->{$cc}} ){
		print NN "$cc\t$pp";
		foreach (sort keys %allsample){
			print NN "\t$dat->{$cc}->{$pp}->{$_}";
		
		}
		print NN "\n";
	}

}
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





