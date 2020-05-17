
use Image::ExifTool;
use Image::ExifTool::Location;
use File::List;

# Give the path
my $search = new File::List('E:\Music Photographs\Festivals 2007');
# Find all .JPG and .jpg in the path
my @files = @{$search->find("?i\.JPG\$")};

# Loop through all of the files
for(@files){
    $_ =~ s|/|\\|g;
    print("$_\n");
    my $path = $_;

    my $src = $path;

    my $exif = Image::ExifTool->new();

    # Set new values
    $exif->SetNewValue(Artist => 'Tony Winfield');
    $exif->SetNewValue(Copyright => 'Copyright 2007 - Tony Winfield. All rights reserved');
    $exif->SetNewValue(Creator => 'Tony Winfield');

    # Write new image
    $exif->WriteInfo($src);
}

print "Mission Complete";

closedir(DIR);
exit 0;
