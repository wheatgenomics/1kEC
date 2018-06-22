#!/usr/bin/perl -w

open MM,"/home/DNA/genome_data/wheat_genome/CS_Ref/iwgsc_refseqv1.0_all_chromosomes/161010_Chinese_Spring_v1.0_pseudomolecules_AGP.tsv" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	#next if $_!~/chr7D/;
	
	
	
	next if $_=~/^#|agp_chr/;
	
	
	#tem[0]=chr
	#tem[-1]=agp_end
	#tem[3]=cm
	$chr=$tem[0];
	$end=$tem[2];
	$cm=$tem[-1];
	
	
	next if $tem[5] =~/gap/ || $cm =~/NA/;
	$chr2lastContig{$chr}=0 if !exists $chr2lastContig{$chr};
	$chr2lastContig{$chr}=$end if $end>$chr2lastContig{$chr};
	
	if(!exists $info->{$chr}){
		push @{$info->{$chr}},$cm;
	}else{
		$i=@{$info->{$chr}};
		next if  $cm < $info->{$chr}->[$i-1];
		push @{$info->{$chr}},$cm;

	}
	print "$chr\t$end\t$cm\n";

	$chr->{$chr}->{$end}=$cm;
}
close MM;





foreach (keys %$chr){
	open TM,">xpclr_dir3/GeneticPosInfo_$_" or die "l";

	@tem=sort {$a <=> $b} keys %{$chr->{$_}};


	foreach $in(sort {$a <=> $b} keys %{$chr->{$_}}){
		print TM "$in\t$chr->{$_}->{$in}\n";
	}
	close TM
}

@file=glob("xpclr_dir3/GeneticPosInfo_*");
foreach $in(@file){
	next if $in =~/corrected|un/i;
	open MM,"$in" or die "l";
	@all=<MM>;
	close MM;
	@name=split /_/,$in;
	print "$name[-1]\n";
	@tem=split/\t/,$all[-1];
	#die "$name[-1]==\n" if !exists $chr2lastContig{$name[-1]};
	$all[-1]=$chr2lastContig{$name[-1]}."\t".$tem[1];

	@tem=split/\t/,$all[0];
	$tem[0]=1;
	$all[0]=$tem[0]."\t".$tem[1];
	
	open TM,">$in.corrected" or die "l";
	$ll=join "",@all;
	print TM "$ll";
	close TM;
	

}



