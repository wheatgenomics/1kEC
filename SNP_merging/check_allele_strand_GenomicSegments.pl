#!/usr/bin/perl -w

open MM,"res_data/introgression_file/res_by_fei" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;
	$dat->{$tem[0]}->{$tem[1]}=$tem[-1];
}	
close MM;


open NN,">tmpdir/res" or die "l";
foreach $chr(sort keys %$dat){
	
	$n=0;
	$check=0;
	undef @rec1;
	#undef @rec2;
	foreach $pos(sort {$a<=>$b} keys %{$dat->{$chr}}){
		#print "$chr\t$pos\n";
		
		#$check=0;
		$check=1 if $dat->{$chr}->{$pos}  =~/diff/;
		$check=2 if $dat->{$chr}->{$pos}  =~/same/;
		
		$n=@rec1-1;
		push @rec1,$check;
		if($n==0){
			print NN "$chr\t$pos\t$check\n";
			push @rec3,$pos;
			next;
		}
		
		if($check ne $rec1[$n]  ){
			print NN "$chr\t$pos\t$check\t$n\n";
			push @rec3,$pos;

		}
		



	}


}
close NN;



open NN,">tmpdir/aa" or die "l";
for($i=1;$i<@rec3;$i++){

	if($rec3[$i-1]<$rec3[$i]){
		$dd=$rec3[$i]-$rec3[$i-1];
		print NN "$dd\n";
	}



}
close NN;







