
use Time::Local;
use Image::ExifTool;
use Image::ExifTool::Location;
use File::List;
use DBI;

# Open Database
my $driver = "SQLite";
my $database = "photoloc.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "Tony";
my $password = "pass";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;

print "Opened database successfully\n";

# Input file directory
print "File directory:      ";
$fdir = <STDIN>;
chomp $fdir;

# Give the path
$search = new File::List("$fdir");

# Find all .JPG and .jpg in the path
@files = @{$search->find("?i\.JPG\$")};

# Loop through all of the files
for(@files){
    $_ =~ s|/|\\|g;

    print("$_\n");
    $path = $_;

    $src = $path;
    $exif = Image::ExifTool->new();

    next if($src !~ m{^.*(jpg?g|JPG)$});

    # Extract info from existing image
    $exif->ExtractInfo($src);

    # Get create date and camera model from file
    $description = $exif->GetValue('CreateDate');
    $model = $exif->GetValue('Model');

    $keystr = $src;

    # Split the file path to use as keys

    $keystr =~ s|\\|/|g;
    my @kfields = split('/', $keystr);

    # If field is just Travel don't use it

    if($kfields[-3] eq 'Travel') {
        $keys = $kfields[-2] . ' ' . $model;
    }else{
        $keys = $kfields[-2] . ' ' . $kfields[-3] . ' ' . $model;
    }
    $keys =~ s|(\d{8})\b||;

    # If the field contains "Festivals" add the keywords

    if($kfields[-4] =~ /^Festivals/){
        $keys = $keys . ' Festival Blues Music UK'
    }

    print("$description\n");
    print("$keys\n");
    
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

    next if($mon < 0);

    # Get Epoch time
    $epoc = timelocal($sec, $min, $hours, $mday, $mon, $year);

    # Query database for location
    my $sth = $dbh->prepare("SELECT LATITUDE, LONGITUDE
                            FROM LOCATION
                            WHERE STARTSECONDS < $epoc AND ENDSECONDS > $epoc");
    $sth->execute() or die $DBI::errstr;
    # print "Number of rows found :" + $sth->rows;
    while (my @row = $sth->fetchrow_array()) {
       my ($latitude, $longitude ) = @row;

       # Set new values. Use create year in copyright.
       $exif->SetNewValue(Artist => 'Tony Winfield');
       $exif->SetNewValue(Copyright => 'Copyright '. $year .' - Tony Winfield. All rights reserved');
       $exif->SetNewValue(Creator => 'Tony Winfield');
       $exif->SetNewValue(Keywords => $keys);

       # Set location in image file
       $exif->SetLocation($latitude, $longitude);

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
