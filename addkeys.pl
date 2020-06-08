
use Image::ExifTool;
use Image::ExifTool::Location;
use File::List;

# Input file directory
print "File directory:      ";
$fdir = <STDIN>;
chomp $fdir;

@fields = split ' ', $fdir;

# Give the path
$search = new File::List("$fdir");

# Find all .JPG and .jpg in the path
@files = @{$search->find("?i\.JPG\$")};

# Loop through all of the files
for(@files){
    $_ =~ s|/|\\|g;

    $path = $_;

    $src = $path;
    $exif = Image::ExifTool->new();

    next if($src !~ m{^.*(jpg?g|JPG)$});
    # Extract info from existing image
    $exif->ExtractInfo($src);

    # Get camera model from file
    $model = $exif->GetValue('Model');

    $str = $src;

    # Split the file path to use as keys

    $str =~ s|\\|/|g;
    my @fields = split('/', $str);

    # If field is just Travel don't use it

    if($fields[-3] eq 'Travel') {
        $keys = $fields[-2] . ' ' . $model;
    }else{
        $keys = $fields[-2] . ' ' . $fields[-3] . ' ' . $model;
    }
    $keys =~ s|(\d{8})\b||;

    if($fields[-4] =~ /^Festivals/){
        $keys = $keys . ' Festival Blues Music UK'
    }
    print("$src\n");
    print("$keys\n");

    # Set new values. Use create year in copyright.
    $exif->SetNewValue(Keywords => $keys);

    # Write new image
    $exif->WriteInfo($src);
}

print "Mission Complete";

closedir(DIR);
exit 0;
