#!/usrbin/perl -w



#Direct count of introgressed allele
#step2
#extract freq. in different pop and different genomic regions.





open MM,"introgression/wildEmmerPD_Allele/allele_table.txt" or die "l";
#open MM,"res_data/introgression_file/allele_introgressedAllele.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $_=~/^#/;
	next if $tem[-1] ne "derivedAllele";
	

	$type->{&changeName1($tem[0])}->{$tem[1]}=$tem[10];
	#next if $tem[0]!~/chr4A/;
	#next if $tem[1]<178000000  || $tem[1]>180000000 ;
	$n++;
	$snp->{&changeName1($tem[0])}->{$tem[1]}=$tem[10]; #introgessed and derived allele
	#print "$tem[0]\t$tem[1]\t$tem[10]\n";
	#print NN "$tem[0]\t$tem[1]\n";
}
close MM;


@file=glob("tmpdir/psr920_groupFreq_*.frq");


foreach $in(@file){
	@name=split/\.|_/,$in;
	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		next if $_=~/^CHROM/;
		@tem=split/\t/;
		
		#next if $tem[0] ne 10;
		#next if  $tem[1]<178810682 || $tem[1]>179310682;
		#next if $tem[1]<175002939 || $tem[1]>181706753;
		#next if $tem[0] eq 10 && $tem[1]>175002939 && $tem[1]<181706753;
		
		
		@aa=split/:/,$tem[4];
		@bb=split/:/,$tem[5];

		$vv="-";

		#only consider iAllele
		if(!exists $type->{$tem[0]}->{$tem[1]}){
		#	print "$tem[0]\t$tem[1]\n";
		#	die;
			next;
		}
		
		#determin which allele is the iAllele
		if($type->{$tem[0]}->{$tem[1]} eq "ref"){
			$vv=$aa[1];
		}
		if($type->{$tem[0]}->{$tem[1]} eq "alt"){
			$vv=$bb[1];
		}
		
		#the freq. of iAllele in each pop
		$dat->{$tem[0]."\t".$tem[1]}->{$name[-2]}=$vv;
	
	}
	$group{$name[-2]}=1;
	close MM;


}


#push @oo,"EurIberian";
#push @oo,"EurWest";
#push @oo,"EurNorth";
#push @oo,"EurBalkans";
#push @oo,"EurEast";
push @oo,"Europe"; 
push @oo,"Turkey"; #turkey
push @oo,"MiddleEast";
#push @oo,"AsiaCentral";
push @oo,"AsiaIndia";
push @oo,"AsiaEast";


#output the freq. of iAllele near psr920 in different pop
open NN,">tmpdir/res1" or die "l";
open FF,">tmpdir/aa" or die "l";
print NN "chr\tposition\ttype";
foreach $in(@oo){
	$in1=$in;
	$in1 ="Turkey" if $in eq "MiddleEast2";
	print NN "\t$in1";
}
print NN "\n";
foreach (sort keys %$dat){
	@tem=split/\t/,;

	#if( $tem[0] eq 10 && $tem[1]>175002939 && $tem[1]<181706753){ #5Mb window around psr920
	if( $tem[0] eq 10 && $tem[1]>178810682 && $tem[1]<179310682){ #500kb window around psr920
		print NN "$_\tpsr920";
		foreach $in(@oo){
			print NN "\t$dat->{$_}->{$in}";
			print FF "$in\t$dat->{$_}->{$in}\n";
		}
		print NN "\n";
	}
}
close NN;
close FF;


#output the freq. of all iAllele in different pop
open NN,">tmpdir/res2" or die "l";
print NN "chr\tposition\tallele_type";
foreach $in(@oo){
	$in1=$in;
	$in1 ="Turkey" if $in eq "MiddleEast2";
	print NN "\t$in1";
}
print NN "\n";


foreach (sort keys %$dat){
	@tem=split/\t/,;
	#if( $tem[0] eq 10 && $tem[1]>175002939 && $tem[1]<181706753){
	if( $tem[0] eq 10 && $tem[1]>178810682 && $tem[1]<179310682){ #500kb window around psr920
	
	}else{
		
		print NN "$_\tother";
		foreach $in(@oo){
			print NN "\t$dat->{$_}->{$in}";
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





