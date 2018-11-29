#!/usr/bin/perl -w




#calculate FI(freq. of introgresison) for each window













$sp{'WT'}=1;
$sp{'WS1'}=1;
$sp{'WS2'}=1;
foreach (sort keys %sp){
	print "$_\n";
}





open MM,"../1000EC/data/1kEC_sample_information_updated02022018.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	#next if $tem[5] ne "lr" ;
	next if $tem[0] =~/accession/;
	next if $tem[1] eq "AVS" && $_=~/AUSTRALIA/;
	next if $_=~ /outgroup/;
	#$acc2imp{$tem[0]}=$tem[5];
	

	if($tem[5]=~/lr|cul|unknown/i && $tem[4] eq "Triticum aestivum subsp. aestivum"){
		$acc{$tem[0]}=1;
	}
	if( $tem[4] =~/compactum|macha|spelta|sphaerococcum/  ){
		$acc{$tem[0]}=1;
	}

}
close MM;










@file=glob("tmpdir/fd/res2000/accession_based/out100SiteW.WS2_*");


foreach $in(@file){
	#print "$in\n";
	@name=split/group_|_|\./,$in;
	
	next if !exists $acc{$name[-1]}; #ignore Australia AVS lines
	if($name[-2] eq "WT"){
		$cutoff=0.9122;
		#$cutoff=0.7815 
		#$cutoff=0.5713;
	
	}elsif($name[-2] eq "WS1"){
		$cutoff=0.4656; #5%
		#$cutoff=0.3248; #10%
		#$cutoff=0.2184; #20%

	}elsif($name[-2] eq "WS2"){
		$cutoff=0.7755;
		#$cutoff=0.6437;
		#$cutoff=0.3973;

	}else{
		print "W\n";
	}

	





	#print "$in\n" if exists $rec{$name[-1]};
	$rec{$name[-1]}=1;

	$n1++;
	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		@tem = split /,/;
		next if $_=~/^sca/;
		$tem[0]=&changeName2($tem[0]);

		next if $tem[5]<10;#ignore windows with few SNP. 



		$allwin{$tem[0]."\t".$tem[1]."\t".$tem[2]}++;
		
		next if $tem[8]<0;
		next if $tem[9] eq "nan"; #ignore windows where fd is 'nan'.
		next if $tem[9] >1 || $tem[9]<0; #ignore windows where fd is not in the range of [0,1]
		
		next if $tem[9]<$cutoff;

		$fdwin{$tem[0]."\t".$tem[1]."\t".$tem[2]}++; #count freq. of fd positive window
		$fdwin2->{$tem[0]."\t".$tem[1]."\t".$tem[2]}->{$name[-2]}++;
		
		$dat->{$name[-1]."\t".$tem[0]."\t".$tem[1]."\t".$tem[2]}=$tem[9];
	}
	close MM;


}
close NN;
print "\n$n1 acc\n";
$n=@tem=keys %rec;
print "real acc=$n\n";



#output freq. of introgression
open NN,">tmpdir/aa" or die "l";
open FF,">tmpdir/info" or die "l";
foreach (sort keys %allwin){
	@tem=split/\t/;
	print FF "$tem[0]\t$tem[1]\t$tem[2]\t$fdwin{$_}\n" if  exists $fdwin{$_};
	print FF "$tem[0]\t$tem[1]\t$tem[2]\t0\n" if  !exists $fdwin{$_};
	

	if(exists $fdwin2->{$_}){
		undef @aa;
		foreach $pp(sort keys %sp){
			if(exists $fdwin2->{$_}->{$pp}){
				$vv=$fdwin2->{$_}->{$pp};
			}else{
				$vv=0;
			}
			push @aa,$vv;
		}
		$ll=join "\t",@aa;
		print NN "$_\t$ll\n";
	}else{
		print NN "$_\t0\t0\t0\n";
	}


}
close FF;
close NN;






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





