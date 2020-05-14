
use DBI;
use strict;

my $driver = "SQLite";
my $database = "camloc.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "Tony";
my $password = "pass";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;

print "Opened database successfully\n";

my $stmt = qq(CREATE TABLE LOCTRACK
    (ID INTEGER PRIMARY KEY AUTOINCREMENT,
        FINDID      INT     NOT NULL,
        DATETIME    TEXT    NOT NULL,
        LATITUDE    REAL    NOT NULL,
        LONGITUDE   REAL    NOT NULL););

my $rv = $dbh->do($stmt);
if($rv < 0){
    print $DBI::errstr;
}else{
    print "Table created successfully\n";
}
$dbh->disconnect();
