
use Time::Local;
use Image::ExifTool;
use Image::ExifTool::Location;
use DBI;

# Open Database
my $driver = "SQLite";
my $database = "camloc.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "Tony";
my $password = "pass";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;

print "Opened database successfully\n";

my $exifTool = new Image::ExifTool;
$exifTool->Options(Unknown => 1);
my $info = $exifTool->ImageInfo('E:\Photographs\Travel\Blackpool 25102017\IMG_7988.JPG');

my $exif = Image::ExifTool->new();
my $src = 'E:\Photographs\Travel\Blackpool 25102017\IMG_7988.JPG';
my $description = $exifTool->GetValue('CreateDate');

# Extract info from existing image
$exif->ExtractInfo($src);

#print $description;
my @fields = split ' ', $description;
my $date = $fields[0];
my $time = $fields[1];

print("$date\n");
print("$time\n");

my @str = split ':', $date;
my $year = $str[0];
my $mon = $str[1] - 1;
my $mday = $str[2];

my @tstr = split ':', $time;
my $hours = $tstr[0];
my $min = $tstr[1];
my $sec = $tstr[2];

$epoc = timelocal($sec, $min, $hours, $mday, $mon, $year);

print("$epoc\n");

my $sth = $dbh->prepare("SELECT LATITUDE, LONGITUDE
                        FROM PLACES
                        WHERE STARTSECONDS < $epoc AND ENDSECONDS > $epoc");
$sth->execute() or die $DBI::errstr;
# print "Number of rows found :" + $sth->rows;
while (my @row = $sth->fetchrow_array()) {
   my ($latitude, $longitude ) = @row;
   #my $latitude = $row[0];
   #my $longitude = $row[1];
   print "Latitude = $latitude, Longitude = $longitude\n";
   # Set location
   $exif->SetLocation($latitude, $longitude);
   # Set new values
   $exif->SetNewValue(Artist => 'Tony Winfield');
   $exif->SetNewValue(Copyright => 'Copyright '.$year.'-Tony Winfield. All rights reserved');
   $exif->SetNewValue(Creator => 'Tony Winfield');
   # Write new image
   $exif->WriteInfo($src);
}
$sth->finish();


$datestring = localtime($epoc);
print("$datestring\n");

$dbh->disconnect();
exit 0;
