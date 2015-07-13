#! /usr/bin/perl

use Modern::Perl;
use lib::gitroot qw/:lib/;
use RomanYusufkhanovFindIndex;
use Data::Dumper;

my @array;

for ( my $i = 0; $i < 1000000; $i++ ) {
    my $value = int rand 100000000;
    push @array, $value;
}

my @sorted_array = sort { $a <=> $b } @array;
my $search_value = int rand 100000000;

# my @sorted_array = ( 16, 33, 44, 53, 58, 72, 76, 77, 82, 90 );
# my $search_value = 90;

# say Dumper \@sorted_array;
# say $search_value;

my $finder = RomanYusufkhanovFindIndex->new();

my ( $index, $step ) = $finder->find( \@sorted_array, $search_value );

say sprintf "Search: %u, Found: %u, Index: %u, Step: %u", $search_value, $sorted_array[$index], $index, $step;
