
use Image::ExifTool;
use Image::ExifTool::Location;
use File::List;

my $src = 'E:\Music Photographs\Festivals 2010\Newark 2010\Alex McKown\NEW10AMB007.JPG';

my $exif = Image::ExifTool->new();
# Extract info from existing image
$exif->ExtractInfo($src);

# Set new values
$exif->SetNewValue(Artist => 'Tony Winfield');
$exif->SetNewValue(Copyright => '© 2011-Tony Winfield-All rights reserved');
$exif->SetNewValue(Creator => 'Tony Winfield');

# Write new image
$exif->WriteInfo($src);

print "Mission Complete";

exit 0;
