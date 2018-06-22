#!/usr/bin/perl -w


open MM,"Jan09_2017/v1/all.vcf.chrID" or die "l";
#open MM,"tmpdir/AllChr-NRGv0.3_SNPList.vcf.newCorr2" or die "l";
	while(<MM>){
		chomp;
		next if $_=~/^#/;
		@tem=split/\s|\t/;
		$data->{$tem[0]}->{$tem[1]}=$tem[2];
		$data2->{$tem[0]}->{$tem[1]}=$tem[3]."\t".$tem[4];
	}
close MM;



@file=glob("xpclr_dir3/chr*Interprolated_geneticMap");
foreach $in(@file){
	print "$in\n";
	@name=split/\.|\//,$in;
	print "$name[-2]\n";
	
	$id=&changeName($name[-2]);
	
	$new=$name[-2].".GeneticMap_forXPCLR" ;
	open MM,"$in" or die "l";
	open NN,">xpclr_dir3/$new" or die "l";
	while(<MM>){
		chomp;
		@tem=split/\s|\t/;
		$tem[1]=sprintf "%.10f",$tem[1];
		print NN "$data->{$name[-2]}->{$tem[0]}\t$id\t$tem[1]\t$tem[0]\t$data2->{$name[-2]}->{$tem[0]}\n";

	}
	close MM;
	close NN;


}



sub changeName{
		
		my $id=$_[0];
		

                $id=~s/^chr1A/1/;
                $id=~s/^chr1B/2/;
                $id=~s/^chr1D/3/;
                $id=~s/^chr2A/4/;
                $id=~s/^chr2B/5/;
                $id=~s/^chr2D/6/;
                $id=~s/^chr3A/7/;
                $id=~s/^chr3B/8/;
                $id=~s/^chr3D/9/;
                $id=~s/^chr4A/10/;
                $id=~s/^chr4B/11/;
                $id=~s/^chr4D/12/;
                $id=~s/^chr5A/13/;
                $id=~s/^chr5B/14/;
                $id=~s/^chr5D/15/;
                $id=~s/^chr6A/16/;
                $id=~s/^chr6B/17/;
                $id=~s/^chr6D/18/;
                $id=~s/^chr7A/19/;
                $id=~s/^chr7B/20/;
                $id=~s/^chr7D/21/;
                $id=~s/^chrUn/22/;
		return $id;

}
