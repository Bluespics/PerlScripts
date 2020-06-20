
use Tk;
use Image::ExifTool;
use Image::ExifTool::Location;
use File::List;

my $mw = MainWindow->new( -title => "Exif Update", -relief => 'flat');

# Create a Frame at the bottom of the window to use 'form' in
$f = $mw->Frame(-borderwidth => 2, -relief => 'groove')
        ->pack(-side => 'bottom', -expand => 1, -fill =>'both');

# Display the Button in the default position to start
$button = $f->Button(-padx => 40, -text => "Go!", -command => \&mainprocess)->grid;


# Use grid to create the Entry widgets to take our options:
$f1 = $mw->Frame->pack(-side => 'top', -fill => 'x');

$f1->Label(-text => 'Directory')->grid($f1->Entry(-width => '80', -textvariable => \$fdir),
        -sticky => 'w', -padx => 10, -pady => 10);

$f1->Label(-text => 'Latitude')->grid($f1->Entry(-width => '80', -textvariable => \$lat),
        -sticky => 'w', -padx => 10, -pady => 10);

$f1->Label(-text => 'Longitude')->grid($f1->Entry(-width => '80', -textvariable => \$long),
        -sticky => 'w', -padx => 10, -pady => 10);

$f1->Label(-text => 'Keywords')->grid($f1->Entry(-width => '80', -textvariable => \$keys),
        -sticky => 'w', -padx => 10, -pady => 10);


$mw->MainLoop();

sub mainprocess
{
    # Search the path
    my $search = new File::List($fdir);
    # Find all .JPG and .jpg in the path
    my @files = @{$search->find("?i\.JPG\$")};

    # Loop through all of the files
    for(@files){
        $_ =~ s|/|\\|g;

        my $path = $_;

        my $src = $path;
        my $exif = Image::ExifTool->new();

        # Extract info from existing image
        $exif->ExtractInfo($src);

        # Get create date from file
        my $description = $exif->GetValue('CreateDate');

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
        $exif->SetNewValue(Keywords => $keys);

        # Set location in image file
        $exif->SetLocation($lat, $long);

        # Write new image
        $exif->WriteInfo($src);


    }

    closedir(DIR);
    exit 0;
}
