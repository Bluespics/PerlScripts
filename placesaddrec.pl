
use strict;
use warnings;
use DBI;

my $driver = "SQLite";
my $database = "camloc.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "Tony";
my $password = "pass";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;

print "Opened database successfully\n";

open FH, '<', 'test4.txt' or die "Cannot open file $!";

while(my $line = <FH>){
    my @fields = split /\t/, $line;
    my $latitude = $fields[0];
    my $longitude = $fields[1];
    my $placename = $fields[2];
    $placename =~ s/^\s//;
    $placename = '"'.$placename.'"';
    my $placeaddress = $fields[3];
    next if($placeaddress eq '');
    $placeaddress =~ s/\n/, /g;
    my $semtype = $fields[4];
    my $starttime = $fields[5];
    $starttime = '"'.$starttime.'"';
    my $endtime = $fields[6];
    $endtime = '"'.$endtime.'"';
    my $startsecs = $fields[7];
    my $endsecs = $fields[8];

    my $stmt = qq(INSERT INTO PLACES (ID, STARTSECONDS, ENDSECONDS, PLACENAME, ADDRESS, LATITUDE, LONGITUDE, STARTTIME, ENDTIME)
                    VALUES (NULL, $startsecs, $endsecs, $placename, $placeaddress, $latitude, $longitude, $starttime, $endtime));
#    my $rv = $dbh->do($stmt) or die $DBI::errstr;
    $dbh->do($stmt);
}

close(FH);
print "Records created successfully\n";
$dbh->disconnect();
