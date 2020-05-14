
use warnings;

open FH, '<', '2020apr.txt' or die "Cannot open file $!";
open OH, '>>', 'test4.txt';

my $process_line = 0;
my $latitude = '';
my $longtitude = '';
my $placename = '';
my $placeaddress = '';
my $semtype = '';
my $startsecs = '';
my $endsecs = '';
my $starttime = '';
my $endtime = '';
my $line = '';

while ($line = <FH>) {
    if($line =~ 'placeVisit'){
        $process_line = 1;
    }
    if($line =~ 'otherCandidateLocations'){
        $process_line = 0;
    }
    if($process_line == 1){
        $line =~ s/,\s$/\n/;
        $line =~ s|"||g;
        my $str = substr($line,0,1);
        next if($str eq "}");
        my @fields = split(/:/, $line);
        my $field_name = $fields[0];
        my $field_value = $fields[1];

        if($field_name =~ 'imestampMs'){
            my $new_value = substr($field_value,1,10);
            my $datestring = localtime($new_value);
        }

        if($field_name =~ 'E7'){
            $new_value = $field_value / 10000000;
            $field_value = ("$new_value\n");
        }
        our $char = chomp($field_value);
        if($field_name =~ 'latitudeE7'){
            $latitude = $field_value;
        }
        if($field_name =~ 'longitudeE7'){
            $longtitude = $field_value;
        }
        if($field_name =~ 'name'){
            $placename = $field_value;
        }
        if($field_name =~ 'address'){
            $field_value =~ s/^\s+//;
            $placeaddress = '"'.$field_value.'"';
        }
        if($field_name =~ 'semanticType'){
            $semtype = $field_value;
        }
        if($field_name =~ 'startTimestampMs'){
            $startsecs = substr($field_value,1,10);
            $starttime = localtime($startsecs);
        }
        if($field_name =~ 'endTimestampMs'){
            $endsecs = substr($field_value,1,10);
            $endtime = localtime($endsecs);
            print OH ("$latitude\t$longtitude\t$placename\t$placeaddress\t$semtype\t$starttime\t$endtime\t$startsecs\t$endsecs\n");
            $placename = '';
            $placeaddress = '';
            $semtype = '';
        }
    }
}
close(FH);
close(OH);
print("Mission2 Complete!\n");
