
use Image::ExifTool;
use Image::ExifTool::Location;
my $exifTool = new Image::ExifTool;
$exifTool->Options(Unknown => 1);
my $info = $exifTool->ImageInfo('E:\Photographs\Travel\Nuthall Christmas Lights 19122014\IMG_6955.JPG');
my $group = '';
my $tag;

open(OH, '>', 'sample.txt');

foreach $tag ($exifTool->GetFoundTags('Group0')) {
    if ($group ne $exifTool->GetGroup($tag)) {
        $group = $exifTool->GetGroup($tag);
        print "---- $group ----\n";
    }
    my $val = $info->{$tag};
    if (ref $val eq 'SCALAR') {
        if ($$val =~ /^Binary data/) {
            $val = "($$val)";
        } else {
            my $len = length($$val);
            $val = "(Binary data $len bytes)";
        }
    }
    printf("%-32s : %s\n", $exifTool->GetDescription($tag), $val);
}
