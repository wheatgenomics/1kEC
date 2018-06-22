#!/usr/bin/perl -w

open MM,"res_data/introgression_file/allele_match_info" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$dat->{$tem[0]}->{$tem[1]}=$_;
}	
close MM;

@file=glob("/home/feihe/project/genome_mapping/res_data/emmerSNP_on_CS/emm*");


open NN,">tmpdir/res" or die "l";
foreach $in(@file){
	
	open MM,"$in" or die "l";
	while(<MM>){
		chomp;
		@tem=split/\t/;
		next if !exists $dat->{$tem[3]}->{$tem[4]};

		@tm=split/\t/,$dat->{$tem[3]}->{$tem[4]};

		if($tm[-3]."\t".$tm[-2] ne $tem[0]."\t".$tem[1]){
			print "w\t$_\n";
		}

	
		if($tm[-1] =~/diff/i  && $tem[-2] eq "+" ){
			#print NN "$_\t$dat->{$tem[3]}->{$tem[4]}\tN\n";
			#print "ww\t$_\n"
			$tm[-1]="SAME";
		}elsif($tm[-1] =~/same/i  && $tem[-2] eq "-" ){
			#print NN "$_\t$dat->{$tem[3]}->{$tem[4]}\tN\n";
			#print "ww\t$_\n"
			$tm[-1]="DIFF";
		}else{
			#print NN "$_\t$dat->{$tem[3]}->{$tem[4]}\tY\n";
			
		}
		$ll=join "\t",@tm;
		print NN "$ll\n";



	
	}
	close MM;





}

close NN;

