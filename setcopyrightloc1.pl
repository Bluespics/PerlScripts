
use Time::Local;
use Image::ExifTool;
use Image::ExifTool::Location;
use File::List;
use DBI;

# Open Database
my $driver = "SQLite";
my $database = "camloc.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "Tony";
my $password = "pass";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;

print "Opened database successfully\n";

# Give the path
my $search = new File::List('E:\Photographs\Travel\Black Country Museum 21082016');
# Find all .JPG and .jpg in the path
my @files = @{$search->find("?i\.JPG\$")};

# Loop through all of the files
for(@files){
    $_ =~ s|/|\\|g;

    print("$_\n");
    my $path = $_;

    my $src = $path;
    my $exif = Image::ExifTool->new();

    # Get create date from file
    my $description = $exif->GetValue('CreateDate');
    # Extract info from existing image
    $exif->ExtractInfo($src);

    print("$description\n");
    my @fields = split ' ', $description;
    my $date = $fields[0];
    my $time = $fields[1];

    # Breakdown date to components
    my @str = split ':', $date;
    my $year = $str[0];
    my $mon = $str[1] - 1;
    my $mday = $str[2];

    # Breakdown time to components
    my @tstr = split ':', $time;
    my $hours = $tstr[0];
    my $min = $tstr[1];
    my $sec = $tstr[2];

    # Get Epoch time
    $epoc = timelocal($sec, $min, $hours, $mday, $mon, $year);

    # Query database for location
    my $sth = $dbh->prepare("SELECT LATITUDE, LONGITUDE
                            FROM PLACES
                            WHERE STARTSECONDS < $epoc AND ENDSECONDS > $epoc");
    $sth->execute() or die $DBI::errstr;
    # print "Number of rows found :" + $sth->rows;
    while (my @row = $sth->fetchrow_array()) {
       my ($latitude, $longitude ) = @row;

       # Set location in image file
       $exif->SetLocation($latitude, $longitude);

       # Set new values. Use create year in copyright.
       $exif->SetNewValue(Artist => 'Tony Winfield');
       $exif->SetNewValue(Copyright => 'Copyright '.$year.' - Tony Winfield. All rights reserved');
       $exif->SetNewValue(Creator => 'Tony Winfield');

       # Write new image
       $exif->WriteInfo($src);
       print("$src\n");
       print("$latitude $longitude\n");
   }
   $sth->finish();
}

print "Mission Complete";
$dbh->disconnect();
closedir(DIR);
exit 0;
