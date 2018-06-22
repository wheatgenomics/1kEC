#!/usr/bin/perl -w


print "reading SNP info\n";
open MM,"/home/feihe/project/genome_mapping/res_data/emmerSNP_on_CS/matched_SNP_all" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	
	
	$wheat2allele->{$tem[0]}->{$tem[1]}=$tem[3]."\t".$tem[4];
	@name=split/_/,$tem[2];
	
	$emmer2wheat_pos->{$name[1]}->{$name[2]}=$tem[0]."\t".$tem[1];
	
	$emmer2allele->{$tem[0]}->{$tem[1]}=$tem[3]."\t".$tem[4];
	$emmer_info->{$tem[0]}->{$tem[1]}=$tem[5];
}
close MM;





print "reading combined_dome.recode.vcf\n";

$n=0;
open MM,"/home/feihe/project/1000genome/data/emmerVCF/combined_dome.recode.vcf" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	if($_=~/^#CHROM/){
		@sample=@tem;
		next;
	}
	next if $_=~/^#/;


	next if !exists $emmer2wheat_pos->{$tem[0]}->{$tem[1]};
	
	@newpos=split/\t/,$emmer2wheat_pos->{$tem[0]}->{$tem[1]};
	$tem[0]=$newpos[0];
	$tem[1]=$newpos[1];
	@allele=split/\t/, $emmer2allele->{$tem[0]}->{$tem[1]};
	
	#print "$tem[3]=$tem[4]\n";
	if($emmer_info->{$tem[0]}->{$tem[1]} eq "Y"){
		for($i=9;$i<@tem;$i++){
			$allsample{$sample[$i]}=1;
			@aa=split/\/|:/,$tem[$i];
			if($allele[0] eq $tem[3] && $allele[1] eq $tem[4] ){
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
			}elsif($allele[0] eq $tem[4] && $allele[1] eq $tem[3]){
				
				$ll=join "\t",@aa;
				$ll=switch($ll);
				@aa=split/\t/,$ll;
				
				
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
			}else{
				$n++;
			}
		}
	}else{
		$tem[3]=~tr/ATGC/TACG/;
		$tem[3]=~tr/atgc/tacg/;
	
		$tem[4]=~tr/ATGC/TACG/;
		$tem[4]=~tr/atgc/tacg/;
		
	#	print "@allele\t$tem[3]:$tem[4]\n";

		for($i=9;$i<@tem;$i++){
			$allsample{$sample[$i]}=1;
			@aa=split/\/|:/,$tem[$i];
			
			if($allele[0] eq $tem[3] && $allele[1] eq $tem[4] ){
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
				
			}elsif($allele[0] eq $tem[4] && $allele[1] eq $tem[3]){
				$ll=join "\t",@aa;
				$ll=switch($ll);
				@aa=split/\t/,$ll;
				
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
			}else{
				$n++;
			}
		}
	}	

}
close MM;
print "bad=$n in dome emmer\n";

$n=0;
foreach (sort keys %$dat1){
	foreach $in(sort keys %{$dat1->{$_}}){
		$n++;
	}
}
print "n=$n in dome emmer\n";




print "reading combined_wild.recode.vcf\n";
$n=0;
open MM,"/home/feihe/project/1000genome/data/emmerVCF/combined_wild.recode.vcf" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	if($_=~/^#CHROM/){
		@sample=@tem;
		next;
	}
	next if $_=~/^#/;


	next if !exists $emmer2wheat_pos->{$tem[0]}->{$tem[1]};
	@newpos=split/\t/,$emmer2wheat_pos->{$tem[0]}->{$tem[1]};
	$tem[0]=$newpos[0];
	$tem[1]=$newpos[1];
	@allele=split/\t/, $emmer2allele->{$tem[0]}->{$tem[1]};
	
	if($emmer_info->{$tem[0]}->{$tem[1]} eq "Y"){
		for($i=9;$i<@tem;$i++){
			$allsample{$sample[$i]}=1;
			@aa=split/\/|:/,$tem[$i];
			if($allele[0] eq $tem[3] && $allele[1] eq $tem[4] ){
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
			
			}elsif($allele[0] eq $tem[4] && $allele[1] eq $tem[3]){
				
				$ll=join "\t",@aa;
				$ll=switch($ll);
				@aa=split/\t/,$ll;
				
				
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
			}else{
				$n++;
			}
		}
	}else{
		$tem[3]=~tr/ATGC/TACG/;
		$tem[3]=~tr/atgc/tacg/;
	
		$tem[4]=~tr/ATGC/TACG/;
		$tem[4]=~tr/atgc/tacg/;
		

		for($i=9;$i<@tem;$i++){
	
			if($allele[0] eq $tem[3] && $allele[1] eq $tem[4] ){
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
				
			}elsif($allele[0] eq $tem[4] && $allele[1] eq $tem[3]){
				$ll=join "\t",@aa;
				$ll=switch($ll);
				@aa=split/\t/,$ll;
				
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
				$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
			}else{
				$n++;
			}
		}
	}	

}
close MM;
print "bad=$n in wild emmer\n";




print "reading west.vcf\n";
$n=0;
open MM,"Jan09_2017/imputated_GT_overlap500/west.vcf" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	if($_=~/^#CHROM/){
		@sample=@tem;
		next;
	}
	next if $_=~/^#/;
	next if !exists $wheat2allele->{$tem[0]}->{$tem[1]};
	@allele=split/\t/, $wheat2allele->{$tem[0]}->{$tem[1]};
	for($i=9;$i<@tem;$i++){
		@aa=split/\|/,$tem[$i];
		if($allele[0] eq $tem[3] && $allele[1] eq $tem[4] ){
			$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
			$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
			
		}elsif($allele[0] eq $tem[4] && $allele[1] eq $tem[3]){
			$ll=join "\t",@aa;
			$ll=switch($ll);
			@aa=split/\t/,$ll;

			$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
			$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
		}else{
			$n++;
		
		}

		$allsample{$sample[$i]}=1;
	}

}
close MM;
print "bad=$n in wheat\n";

print "reading east.vcf\n";
$n=0;
open MM,"Jan09_2017/imputated_GT_overlap500/east.vcf" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	if($_=~/^#CHROM/){
		@sample=@tem;
		next;
	}
	next if $_=~/^#/;
	next if !exists $wheat2allele->{$tem[0]}->{$tem[1]};
	@allele=split/\t/, $wheat2allele->{$tem[0]}->{$tem[1]};
	for($i=9;$i<@tem;$i++){
		@aa=split/\|/,$tem[$i];
		if($allele[0] eq $tem[3] && $allele[1] eq $tem[4] ){
			$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
			$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
			
		}elsif($allele[0] eq $tem[4] && $allele[1] eq $tem[3]){
			$ll=join "\t",@aa;
			$ll=switch($ll);
			@aa=split/\t/,$ll;


			$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[0]}=$aa[0];
			$dat1->{$tem[0]}->{$tem[1]}->{$sample[$i]}->{$allele[1]}=$aa[1];
		}else{
			$n++;
		
		}

		$allsample{$sample[$i]}=1;
	}

}
close MM;
print "bad=$n in wheat\n";













open NN,">tmpdir/combined.vcf" or die "l";

@tem=sort keys %allsample;
$ll=join "\t",@tem;
print NN "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t$ll\n";

$n=0;
foreach $chr(sort keys %$dat1){
	foreach $pos(sort keys %{$dat1->{$chr}}){
		
		
		@allele=split/\t/,$wheat2allele->{$chr}->{$pos};
		
		undef @tem;
		foreach $in(sort keys %allsample){
			if(exists $dat1->{$chr}->{$pos}->{$in}->{$allele[0]}){
				$gt1=$dat1->{$chr}->{$pos}->{$in}->{$allele[0]};
				$gt2=$dat1->{$chr}->{$pos}->{$in}->{$allele[1]};
				$ll=$gt1."/".$gt2;
				push @tem,$ll;
			}else{
				#print "w\t$chr\t$pos\n";
				$n++;
				$ll="./.";
				push @tem,$ll;
			}
		
		}
		$ll=join "\t",@tem;
		$id=$chr."_".$pos;
		print NN "$chr\t$pos\t$id\t$allele[0]\t$allele[1]\t.\t.\t.\tGT\t$ll\n";
	}

}
close NN;
print "$n\n";










sub switch{
	my $line=$_[0];
	$line=~s/1/X/g;
	$line=~s/0/Y/g;
	
	$line=~s/X/0/g;
	$line=~s/Y/1/g;
	
	return $line;
}


