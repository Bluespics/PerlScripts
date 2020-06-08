
use Image::ExifTool;
use Image::ExifTool::Location;
use File::List;

my $src = 'E:\Music Photographs\Festivals 2010\Newark 2010\Alex McKown\NEW10AMB007.JPG';

my $exif = Image::ExifTool->new();
# Extract info from existing image
$exif->ExtractInfo($src);

# Set new values
$exif->SetNewValue(Artist => 'Tony Winfield');
$exif->SetNewValue(Copyright => 'Copyright 2010-Tony Winfield. All rights reserved');
$exif->SetNewValue(Creator => 'Tony Winfield');
$exif->SetNewValue(Keywords => 'Newark Alex McKown Band Blues Festival 2010');

my $latitude = "51.2013587";
my $longitude = "-4.1143607";

# Set location"
$exif->SetLocation($latitude, $longitude);


# Write new image
$exif->WriteInfo($src);

print "Mission Complete";

exit 0;
