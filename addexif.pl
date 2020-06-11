
use Image::ExifTool;
use File::List;
use strict;
use warnings;

# Input file directory
print "File directory:      ";
my $fdir = <STDIN>;
chomp $fdir;

# Give the path
my $search = new File::List("$fdir");

# Find all .JPG and .jpg in the path
my @files = @{$search->find("?i\.JPG\$")};

# Loop through all of the files
for(@files){
    $_ =~ s|/|\\|g;

    my $src = $_;

    my $exif = Image::ExifTool->new();

    # Set new fields

    $exif->SetNewValue(Artist => 'eSpares Ltd');
    $exif->SetNewValue(Copyright => 'Copyright eSpares Ltd - All rights reserved 2020');

    # Write new image
    $exif->WriteInfo($src);
}

print "Mission Complete";
