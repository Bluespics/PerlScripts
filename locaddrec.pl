
use warnings;
use DBI;
use Time::Local;

# Initialise variables
$savelatitude = '0';
$savelongitude = '0';
$saveepoc = '0';
$recordno = 1;

# Open database
$driver = "SQLite";
$database = "photoloc.db";
$dsn = "DBI:$driver:dbname=$database";
$userid = "Tony";
$password = "pass";
$dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;

print "Opened database successfully\n";

# Open file
open FH, '<', 'split1.txt' or die "Cannot open file $!";

while(my $line = <FH>){
    # Split up line
    @fields = split / /, $line;
    $datetime = $fields[1];
    $datetime =~ s/Z//g;
    @str = split /T/, $datetime;
    $date = $str[0];
    $time = $str[1];
    $time =~ s/Z//g;

    # Breakdown date to components
    @dstr = split '-', $date;
    $year = $dstr[0];
    $mon = $dstr[1] - 1;
    $mday = $dstr[2];

    # Breakdown time to components
    @tstr = split ':', $time;
    $hours = $tstr[0];
    $min = $tstr[1];
    $sec = $tstr[2];

    # Short version of latitude and longitude to allow tolerance in matches
    $lontest = sprintf("%.3f", $fields[2]);
    $lattest = sprintf("%.3f", $fields[3]);

    # Exclude home, work and other places
    next if($lattest == 52.978 and $lontest == -1.199);
    next if($lattest == 52.977 and $lontest == -1.199);
    next if($lattest == 52.766 and $lontest == -0.869);
    next if($lattest == 52.977 and $lontest == -1.298);

    # Round latitude and longitude to 6 decimal places
    $longitude = sprintf("%.6f", $fields[2]);
    $latitude = sprintf("%.6f", $fields[3]);

    # Consolidate same locations
    next if($latitude == $savelatitude and $longitude == $savelongitude);

    # Get Epoch time
    $epoc = timelocal($sec, $min, $hours, $mday, $mon, $year);

    # Write to database
    if($recordno > 1){
        $stmt = qq(INSERT INTO LOCATION (ID, STARTSECONDS, ENDSECONDS, LATITUDE, LONGITUDE)
                        VALUES (NULL, $saveepoc, $epoc, $savelatitude, $savelongitude));
        $dbh->do($stmt);
    }

    # Overwrite saved values for next match test

    $recordno += 1;
    $savelatitude = $latitude;
    $savelongitude = $longitude;
    $saveepoc = $epoc;
    print("$recordno\n");
}

# Close down file and database and inform user
close(FH);
print "Records created successfully\n";
$dbh->disconnect();
