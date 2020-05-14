
use strict;
use warnings;
use DBI;
use strict;

my $driver = "SQLite";
my $database = "camloc.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "Tony";
my $password = "pass";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;

print "Opened database successfully\n";

open FH, '<', 'test.txt' or die "Cannot open file $!";

while(my $line = <FH>){
    $line =~ s/T/ /;
    $line =~ s/Z//;
    my @fields = split / /, $line;
    my $findid = $fields[1] . $fields[2];
    $findid =~ s/-//g;
    $findid =~ s/://g;
    my $date = $fields[1];
    my $time = $fields[2];
    my $datetime = $date . ' ' . $time;
    my $lattest = sprintf("%.3f", $fields[3]);
    my $lontest = sprintf("%.3f", $fields[4]);
    next if(($lattest == 52.978) && ($lontest == -1.199));
    my $secgps = sprintf("%.6f", $fields[3]);
    my $firgps = sprintf("%.6f", $fields[4]);

    my $stmt = qq(INSERT INTO LOCTRACK (ID, FINDID, DATETIME, LATITUDE, LONGITUDE)
                    VALUES (NULL, "$findid", "$datetime", $firgps, $secgps));
#    my $rv = $dbh->do($stmt) or die $DBI::errstr;
    $dbh->do($stmt);
}

close(FH);
print "Records created successfully\n";
$dbh->disconnect();
