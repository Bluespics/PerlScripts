
use strict;
use warnings;
use DBI;
use strict;

my $latitude;
my $longitude;
my $placename;
my $placeaddress;
my $semtype;
my $starttime;
my $endtime;
my $startsecs;
my $endsecs;


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
    my $placeaddress = $fields[3];
    $placeaddress =~ s/\n/, /g;
    my $semtype = $fields[4];
    my $starttime = $fields[5];
    my $endtime = $fields[6];
    my $startsecs = $fields[7];
    my $endsecs = $fields[8];

    my $stmt = qq(INSERT INTO PLACES (ID, STARTSECONDS, ENDSECONDS, PLACENAME, ADDRESS, LATITUDE, LONGITUDE, STARTTIME, ENDTIME, SEMTYPE)
                    VALUES (NULL, $startsecs, $endsecs, $placename, $placeaddress, $latitude, $longitude, $starttime, $endtime, $semtype));
#    my $rv = $dbh->do($stmt) or die $DBI::errstr;
    $dbh->do($stmt);
}

close(FH);
print "Records created successfully\n";
$dbh->disconnect();
