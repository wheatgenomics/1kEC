#!/usr/bin/perl -w





#this is the third step for sampling WEP site 

#for each freq. class, use all WEP site 
#use the same number of non-WEP site, repeat=100 times





#$igr="tmpdir/res.SNPfreq.hot.2";
#$desert="tmpdir/res.SNPfreq.desert.2";


$igr="tmpdir/res.SNPfreq.WEP.2";
#$desert="tmpdir/res.SNPfreq.WEPotherAll.2";
$desert="tmpdir/res.SNPfreq.WEPother.2";


`mv tmpdir/res.SNP*random*  ~/garbage `;

open MM,"$igr" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$nWEP++;
}
close MM;



open MM,"$desert" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$desert{$tem[0]}=$tem[1];
}
close MM;


@sss=keys %desert;
for($i=0;$i<100;$i++){
	
	print "$i\n";
	$n=0;
	undef %rec;
	while($n<$nWEP){
		$rr=int rand @sss;
		$rec{$sss[$rr]}=1;
		$n=@tem=keys %rec;
	}
	

	
	$new="tmpdir/gcta/other/WEPother.random$i";
	open NN,">$new" or die "l";
	foreach $ss(sort keys %rec){
		print NN "$ss\n";
	}
	close NN;

}



















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





