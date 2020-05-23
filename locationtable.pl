
use DBI;
use strict;

my $driver = "SQLite";
my $database = "photoloc.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "Tony";
my $password = "pass";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;

print "Opened database successfully\n";

my $stmt = qq(CREATE TABLE LOCATION
    (ID INTEGER PRIMARY KEY AUTOINCREMENT,
        STARTSECONDS      INT,
        ENDSECONDS        INT,
        LATITUDE          REAL,
        LONGITUDE         REAL););

my $rv = $dbh->do($stmt);
if($rv < 0){
    print $DBI::errstr;
}else{
    print "Table created successfully\n";
}
$dbh->disconnect();
