
use Image::ExifTool;
use Image::ExifTool::Location;
use File::List;

my $search = new File::List('E:\Music Photographs\Festivals 2013\Newark 2013');
my @files = @{$search->find("?i\.JPG\$")};

for(@files){
    $_ =~ s|/|\\|g;
    print("$_\n");
    my $path = $_;

    my $src = $path;

    my $exif = Image::ExifTool->new();
    # Extract info from existing image
    $exif->ExtractInfo($src);

    # Set a new value for a tag
    my $tag = 'Copyright';
    my $newValue = '2013 Tony Winfield. All Rights Reserved';
    $exifTool->SetNewValue($tag, $newValue);
    # Write new image
    $exif->WriteInfo($src);
}

print "Mission Complete";

closedir(DIR);
exit 0;
