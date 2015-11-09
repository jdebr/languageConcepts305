######################################### 	
#    CSCI 305 - Programming Lab #1		
#										
#    Joseph DeBruycker			
#  	 jd.debr@gmail.com		
#										
#########################################


# Pragmas to help development
use strict;
use warnings;
use diagnostics;


# Name
my $name = "Joseph DeBruycker";
my $partner = "Casper the Friendly Programming Ghost";
print "\nCSCI 305 Lab 1 submitted by $name \nand $partner.\n\n";


# Checks for the argument, fail if none given
if($#ARGV != 0) {
    print STDERR "You must specify the file name as the argument.\n";
    exit 4;
}


# Opens the file and assign it to handle INFILE
open(INFILE, $ARGV[0]) or die "Cannot open $ARGV[0]: $!.\n";


# Variable Definitions
my $title;
my %bigrams;
######PERSONAL TEST VARIABLE################
my $counter = 0;
############################################


# This loops through each line of the file
while(my $line = <INFILE>) {
	
	# Extract song title
	if($line =~ m/.*<SEP>(.*)/){
		$title = $1;
	}
	
	# Clean up superfluous text in title
	$title =~ s/\(.*//;
	$title =~ s/\[.*//;
	$title =~ s/\{.*//;
	$title =~ s/\\.*//;
	$title =~ s/\/.*//;
	$title =~ s/_.*//;
	$title =~ s/-.*//;
	$title =~ s/:.*//;
	$title =~ s/".*//;
	$title =~ s/`.*//;
	$title =~ s/\+.*//;
	$title =~ s/=.*//;
	$title =~ s/\*.*//;
	$title =~ s/feat\..*//;
	
	# Delete punctuation
	$title =~ s/[\?¡!¿\.;&\$\@%#\|]+//g;
		
	# Discard entries containing non-English characters
	if ($title !~ m/[^\s\w']/){
		
		#convert to lowercase
		$title = lc $title;
			
		# Delete stop words
		$title =~ s/\b(a|an|and|by|for|from|in|of|on|or|out|the|to|with)\b//g;
		
		# Delete white space at the start of title to prevent errors in bigram structure
		$title =~ s/^\s+//;
		
		#####PERSONAL TEST LINES########
		#print "$title \n";
		#print " \n$counter $title \n";
		#$counter++;
		################################
		
		# Split title into words and store bigrams in a hash of hashes with outer
		# key being the first word of the bigram, the inner key being the second
		# word and the inner value being the number of occurrences of that bigram
		my @words = split /\s+/, $title;
		for(my $i = 0; $i < $#words; $i++){
			my $firstword = $words[$i];
			my $secondword = $words[$i+1];
			
			##########PERSONAL TEST LINES######################
			#print "$firstword AND $secondword are a bigram\n";
			###################################################
			
			if(exists $bigrams{$firstword}{$secondword}){
				($bigrams{$firstword}{$secondword})++;
			} else {
				$bigrams{$firstword}{$secondword} = 1;
			}
		}	
	}	
}


# Close the file handle
close INFILE; 


# At this point (hopefully) you will have finished processing the song 
# title file and have populated your data structure of bigram counts.
print "File parsed. Bigram model built.\n\n";


# A subroutine that takes a seed word and finds the word that most often follows it 
# in the dataset, or uses a 2nd parameter to get something further down the list
sub mcw{

	# Get number of arguments
	my $n = scalar(@_);
	
	# Sort all the bigrams of the seed word in descending order of number of occurrences
	my @sortedbigrams = sort { $bigrams{$_[0]}{$b} <=> $bigrams{$_[0]}{$a} } keys %{$bigrams{$_[0]}};
	
	if ($n == 1){
		# Return first value in sorted list if only one argument passed
		return $sortedbigrams[0];
	} else {
		# Return value further down the list based on 2nd argument
		return $sortedbigrams[$_[1]];
	}
}

	
# Initialize user control loop with a seed word or exit
print "Enter a word [Enter 'q' to quit]: ";
my $input = <STDIN>;
chomp($input);
$input = lc $input;
print "\n";	


# Main control loop
while ($input ne "q"){

	# Use seed word to generate a song title (no longer than 20 words)
	my @songtitle;
	push @songtitle, $input;
	my $check = mcw($input);  #$check is next word to possibly add to title
	my $lastword = $input;  #$lastword is the last word added to the title
	my $titleLength = 1;
	
	# Loop to create the title using calls to mcw()
	while((defined $check)){ #&& ($titleLength < 20)){  ###REMOVED THE 20 WORD RESTRICTION***
		
		# Check for repetition in song title that will lead to loops
		my $isRepetition;  # Boolean flag value
		my $repetitionCount = 0;  # Tracks how far down the list of bigrams we go to avoid repetition
		do{
			$isRepetition = 0;
			foreach my $word (@songtitle){
				
				# If you find repetition, set flag
				if ($check eq $word){
					$isRepetition = 1;
				} 
			}
			
			# If repetition was found, get next most common word from bigram hash and check again
			if ($isRepetition){
				$repetitionCount++;
				$check = mcw($lastword, $repetitionCount );
			}
		} while ($isRepetition);
		
		# Add unrepeated words to songtitle
		push @songtitle, $check;
		$titleLength++;
		$lastword = $check;
		$check = mcw($check);
	}
	
	# Print song title
	print join(" ", @songtitle);
	
	######PRINT OTHER INFORMATION ABOUT BIGRAMS############
	#my @sortedbigrams = sort { $bigrams{$input}{$a} <=> $bigrams{$input}{$b} } keys %{$bigrams{$input}};
	#print "\n\n";
	#foreach my $x (@sortedbigrams){
	#	print "$x  -  ";
	#	print $bigrams{$input}{$x};
	#	print "\n";
	#}
	#my $bcount = @sortedbigrams;
	#print "\n  $bcount unique bigrams";
	#######################################################
	
	# Continue user control loop or quit
	print "\n\nEnter next word ['q' to quit]: ";
	$input = <STDIN>;
	chomp($input);
	$input = lc $input;
	print "\n";
}

