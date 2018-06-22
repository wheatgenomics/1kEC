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
	
	undef @order;
	foreach $pos(sort {$a<=>$b} keys %{$dat->{$chr}}){
		#print "$chr\t$pos\n";
		push @order,$pos;
			
	}

	for($i=1;$i<@order;$i++){
		next if !$order[$i];

		next if $dat->{$chr}->{$order[$i]} ne "-";
		next if exists $dat2->{$chr}->{$order[$i]};
		
		$check1=$check2=0;
		for($x=1;$x<7;$x++){
			for($y=1;$y<7;$y++){
				next if !$order[$i+$x]  || !$order[$i+$y] ;
				next if exists $dat2->{$chr}->{$order[$i]};
				

				if($dat->{$chr}->{$order[$i+$x]} =~/same/ && $dat->{$chr}->{$order[$i-$y]} =~/same/  ){
					$dat2->{$chr}->{$order[$i]}="same";
					$check1=1;
				}
	
				if($dat->{$chr}->{$order[$i+$x]} =~/diff/ && $dat->{$chr}->{$order[$i-$y]} =~/diff/  ){
					$dat2->{$chr}->{$order[$i]}="diff";
					$check2=1
				}

				if( $check2==1 && $check1==1){
					$dat2->{$chr}->{$order[$i]}="-";
				}
			}

		}
	
	
	}

}



open MM,"res_data/introgression_file/res_by_fei" or die "l";
while(<MM>){
	chomp;
	@tem=split/\t/;

	if($tem[-1] ne "-"){
		print NN "$_\n";
	}else{
		$tem[-1]=$dat2->{$tem[0]}->{$tem[1]} if exists $dat2->{$tem[0]}->{$tem[1]} ;
		$ll=join "\t",@tem;
		print NN "$ll\n";
	}

}	
close MM;






close NN;







