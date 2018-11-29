#!/usrbin/perl -w

open MM,"../1000EC/data/sample_for_populationStructureAnalysis.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	next if $tem[5] ne "lr" && $tem[5] ne "cul" ;
	$allacc{$tem[0]}=$tem[5];

}
close MM;







@file=glob("tmpdir/load/*_*");

foreach $in(@file){
	@name=split/_|\//,$in;
	next if !exists $allacc{$name[-1]};
	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		@tem=split/\t|\|/;
		$win=$tem[0]."\t".$tem[1]."\t".$tem[2];
		$dat->{$win}->{$name[-1]}->{$name[-2]}=$tem[3];
	}
}



@file=glob("tmpdir/fd/res2000/accession_based/out100SiteW.WS1_*");


foreach $in(@file){
	
	@name=split/group_|_|\./,$in;
	
	next if !exists $allacc{$name[-1]};
	print "$in\n";
	#get fd>0 window in each acc
	open MM,"$in" or die "l";
	while(<MM>){
		next if $_=~/scaffold/;
		chomp;
		@tem=split/,|\t/;
		
		
	if($name[-2] eq "WT"){
		#$cutoff=0.9122;
		#$cutoff=0.7815 
		$cutoff=0.5713;
	
	}elsif($name[-2] eq "WS1"){
		$cutoff=0.4656; #5%
		#$cutoff=0.3248; #10%
		#$cutoff=0.2184; #20%

	}elsif($name[-2] eq "WS2"){
		#$cutoff=0.7755;
		#$cutoff=0.6437;
		$cutoff=0.3973;

	}else{
		print "W\n";
	}

	#$cutoff=;
		
		#next if $tem[7] =~/nan/ || $tem[7]>1 || $tem[7]<0;
		
		if($tem[9] eq "nan" || $tem[9]>1 || $tem[9]<0){
			$tem[9]=0;
		}
		
		
		$tem[0]=&changeName2($tem[0]);
		#print TM "$tem[0]\t$tem[1]\t$tem[2]\n";
		#next if $tem[9]<$cutoff;	
		
		
		$win=$tem[0]."\t".$tem[1]."\t".$tem[2];
		if($tem[9]>$cutoff){
			$dat1->{$win}->{$name[-1]}=1;
		}else{
		
			$dat2->{$win}->{$name[-1]}=1;
		}
		
	}
	close MM;
	
}	
close NN;



use Parallel::ForkManager;

$pm = new Parallel::ForkManager(48);

open NN,">tmpdir/res1.south2" or die "l";
foreach $win(sort keys %$dat1){
	
	foreach $acc(sort keys %{$dat1->{$win}}){
		
		#dat->win->acc->type
		$d=$dat->{$win}->{$acc}->{'d'};
		$syn=$dat->{$win}->{$acc}->{'syn'};
		$nsyn=$dat->{$win}->{$acc}->{'nsyn'};

		print NN "$win\t$acc\t$allacc{$acc}\tI\t$d\t$syn\t$nsyn\n";

	}

}
close NN;

	
open NNN,">tmpdir/res2.south2" or die "l";
$pm = new Parallel::ForkManager(32);

foreach $win(sort keys %$dat2){
	
	foreach $acc(sort keys %{$dat2->{$win}}){
		
		#dat->win->acc->type
		$d=$dat->{$win}->{$acc}->{'d'};
		$syn=$dat->{$win}->{$acc}->{'syn'};
		$nsyn=$dat->{$win}->{$acc}->{'nsyn'};

		print NNN "$win\t$acc\t$allacc{$acc}\tNI\t$d\t$syn\t$nsyn\n";

	}

}



close NNN;
















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








