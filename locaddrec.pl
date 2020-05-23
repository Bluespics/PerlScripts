
use warnings;
use DBI;
use Time::Local;

$savelatitude = '0';
$savelongitude = '0';
$saveepoc = '0';
$recordno = 1;

$driver = "SQLite";
$database = "photoloc.db";
$dsn = "DBI:$driver:dbname=$database";
$userid = "Tony";
$password = "pass";
$dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;

print "Opened database successfully\n";

open FH, '<', 'split2.txt' or die "Cannot open file $!";

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

    # Round latitude and longitude to 6 decimal places
    $longitude = sprintf("%.6f", $fields[2]);
    $latitude = sprintf("%.6f", $fields[3]);

    next if($latitude == $savelatitude and $longitude == $savelongitude);

    # Get Epoch time
    $epoc = timelocal($sec, $min, $hours, $mday, $mon, $year);

    if($recordno > 1){
        $stmt = qq(INSERT INTO LOCATION (ID, STARTSECONDS, ENDSECONDS, LATITUDE, LONGITUDE)
                        VALUES (NULL, $saveepoc, $epoc, $savelatitude, $savelongitude));
        $dbh->do($stmt);
    }

    $recordno += 1;
    $savelatitude = $latitude;
    $savelongitude = $longitude;
    $saveepoc = $epoc;
    print("$recordno\n");
}

close(FH);
print "Records created successfully\n";
$dbh->disconnect();
