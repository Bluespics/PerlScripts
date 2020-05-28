
use Image::ExifTool;
use Image::ExifTool::Location;
use File::List;

# Input file directory
print "File directory:      \n";
$fdir = <STDIN>;
chomp $fdir;

# Input Latitude and Longitude
print "Latitude:            \n";
$latitude = <STDIN>;
chomp $latitude;
print "Longitude:           \n";
$longitude = <STDIN>;
chomp $longitude;

# Search the path
my $search = new File::List($fdir);
# Find all .JPG and .jpg in the path
my @files = @{$search->find("?i\.JPG\$")};

# Loop through all of the files
for(@files){
    $_ =~ s|/|\\|g;

    print("$_\n");
    my $path = $_;

    my $src = $path;
    my $exif = Image::ExifTool->new();

    # Extract info from existing image
    $exif->ExtractInfo($src);

    # Get create date from file
    my $description = $exif->GetValue('CreateDate');

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

    # Set new values. Use create year in copyright.
    $exif->SetNewValue(Artist => 'Tony Winfield');
    $exif->SetNewValue(Copyright => 'Copyright '. $year .' - Tony Winfield. All rights reserved');
    $exif->SetNewValue(Creator => 'Tony Winfield');

    # Set location in image file
    $exif->SetLocation($latitude, $longitude);

    # Write new image
    $exif->WriteInfo($src);
    print("$src\n");
    print("$latitude $longitude\n");
}

print "Mission Complete";
closedir(DIR);
exit 0;
