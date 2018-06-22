#!/usrbin/perl -w

open MM,"res_data/sampleList_referenceWheat" or die "l";
while(<MM>){
	chomp;
	#$acc2info{$_}="wheatRef";
}
close MM;


$i=0;
open MM,"/home/DNA/shared_project/1000EC/data/1kEC_sample_information.txt" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	#next if $tem[5] eq "lr" || $_=~/accession/;
	next if $_=~/accession/;
	
	#next if $tem[4] eq "Triticum aestivum subsp. aestivum";
	$i++;
	$acc2info{$tem[0]}=1;
	$acc2id{$tem[0]}=$tem[0];
}
close MM;



$i=0;
open MM,"res_data/GEOgroup_introgression/group_Turkey" or die "l";
while(<MM>){
	chomp;
	$i++;
	#$acc2info{$_}="LrTurkey";
	#$acc2id{$_}="LrTurkey".$i;
}
close MM;

open MM,"res_data/GEOgroup_introgression/group_MiddleEast" or die "l";
close MM;

$i=0;
open MM,"data/emmerVCF/sampleList_wild" or die "l";
while(<MM>){
	chomp;
	$i++;
	$acc2info{$_}="emmerW";
	$acc2id{$_}="emmerW".$i;
}
close MM;

$i=0;
open MM,"data/emmerVCF/sampleList_domesticated" or die "l";
while(<MM>){
	$i++;
	chomp;
	$acc2info{$_}="emmerD";
	$acc2id{$_}="emmerD".$i
}
close MM;

$acc2info{'ExomeCapture-TA-12197'}="outgroup";
$acc2id{'ExomeCapture-TA-12197'}="outgroup";

open MM,"/home/DNA/shared_project/1000EC/vcf/shared_SNPsites_with_otherDatasets/1k_emmer.vcf" or die "l";
#open MM,"res_data/introgression_file/out_intergression.vcf" or die "l";
#open MM,"res_data/introgression_file/beagleOut/all.vcf" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	if($_=~/^#CHROM/){
		@sample=@tem;


	}
	next if $_=~/^#/;
	#next if $tem[0] ne "17";
	
	for($i=9;$i<@tem;$i++){
		next if !exists $acc2info{$sample[$i]};
		if($tem[$i] eq "1/1"){
			$dat->{$tem[0]}->{$tem[1]}->{$sample[$i]}=$tem[4];
		}elsif($tem[$i] eq "0/0"){
			$dat->{$tem[0]}->{$tem[1]}->{$sample[$i]}=$tem[3];
		}else{
			$dat->{$tem[0]}->{$tem[1]}->{$sample[$i]}="N";
		
		}
		$allsample{$sample[$i]}=1;
	}
	

}
close MM;


#open NN,">tmpdir/fdInput.chr6B.turkey" or die "l";
open NN,">tmpdir/fdInput.allacc" or die "l";
print NN "#scaffold\tposition";
foreach (sort keys %allsample){
	
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


die;
open NN,">tmpdir/fdInput.chr6B.turkey.popInfo" or die "l";
foreach (sort keys %acc2info){
	next if !exists $allsample{$_};
	$g2s->{$acc2info{$_}}->{$acc2id{$_}}=1;
}
foreach (sort keys %$g2s){
	@tem=sort keys %{$g2s->{$_}};
	$ll=join ",",@tem;
	print NN "$_\t[$ll]\n";

}
close NN;




