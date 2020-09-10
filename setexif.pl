
use Image::ExifTool;
use Image::ExifTool::Location;
use File::List;
use Tk;

our $path = '';

my $mw = new MainWindow;        # Main Window
$mw -> title("Add EXIF Information");

my $menubar = $mw -> Menu(-type => 'menubar');
$mw -> configure(-menu => $menubar);
my $mfile = $menubar->cascade(-label => '~File', -tearoff => 0);
$mfile -> command(-label => '~Open Dir',
                -accelerator => 'Control+o',
                -command => \&open_dir);
$mfile -> command(-label => '~Clear',
                -accelerator => 'Control+c',
                -command => \&clear_screen);
$mw -> bind('<Control-o>', [\&open_dir]);
$mw -> bind('<Control-c>', [\&clear_screen]);

#my $frm_input = $mw -> Frame();
my $lab1 = $mw -> Label(-text => "File Path:     ");
my $ent1 = $mw -> Entry(-width => 100);
my $lab2 = $mw -> Label(-text => "Photographer:   ");
my $ent2 = $mw -> Entry(-width => 100);
my $lab3 = $mw -> Label(-text => "Latitude:       ");
my $ent3 = $mw -> Entry(-width => 100);
my $lab4 = $mw -> Label(-text => "Longitude:      ");
my $ent4 = $mw -> Entry(-width => 100);
my $lab5 = $mw -> Label(-text => "Keywords:       ");
my $ent5 = $mw -> Entry(-width => 100);

my $but1 = $mw -> Button(-text => "Set EXIF", -command => \&push_button);
my $but2 = $mw -> Button(-text => "Clear All", -command => \&clear_screen);

my $textarea = $mw -> Frame();             # Create another Frame
my $txt = $textarea -> Text(-width => 100, -height => 20);
my $srl_y = $textarea -> Scrollbar(-orient => 'v', -command => [yview => $txt]);
my $srl_x = $textarea -> Scrollbar(-orient => 'h', -command => [xview => $txt]);
$txt -> configure(-yscrollcommand => ['set', $srl_y],
                -xscrollcommand => ['set', $srl_y]);
$txt -> tag(qw/configure color1 -foreground red/);
$txt -> tag(qw/configure color2 -foreground black/);

# Geometry Management

$lab1 -> grid(-row => 2, -column => 1, -sticky => "w",
            -ipadx => 5, -ipady => 5);
$ent1 -> grid(-row => 2, -column => 2);
$lab2 -> grid(-row => 3, -column => 1, -sticky => "w",
            -ipadx => 5, -ipady => 5);
$ent2 -> grid(-row => 3, -column => 2);
$lab3 -> grid(-row => 4, -column => 1, -sticky => "w",
            -ipadx => 5, -ipady => 5);
$ent3 -> grid(-row => 4, -column => 2);
$lab4 -> grid(-row => 5, -column => 1, -sticky => "w",
            -ipadx => 5, -ipady => 5);
$ent4 -> grid(-row => 5, -column => 2);
$lab5 -> grid(-row => 6, -column => 1, -sticky => "w",
            -ipadx => 5, -ipady => 5);
$ent5 -> grid(-row => 6, -column => 2);

$but1 -> grid(-row => 7, -column => 1);
$but2 -> grid(-row => 7, -column => 2, -sticky => 'w');

$txt -> grid(-row => 1, -column => 1);
$srl_y -> grid(-row => 1, -column => 2, -sticky => "ns");
$srl_x -> grid(-row => 2, -column => 1, -sticky => "ew");
$textarea -> grid(-row => 8, -column => 1, -columnspan => 2,
                -ipadx => 7, -ipady => 5);

MainLoop;

sub open_dir {
    my $open = $mw->chooseDirectory(-initialdir => '~',
                                        -title => 'Choose a directory');
    $ent1 -> insert('end', "$open") if $open;
}

sub clear_screen {
    $txt -> delete('1.0', 'end');
    $ent1 -> delete('0.0', 'end');
    $ent2 -> delete('0.0', 'end');
    $ent3 -> delete('0.0', 'end');
    $ent4 -> delete('0.0', 'end');
    $ent5 -> delete('0.0', 'end');
}

sub push_button {

    my $fdir = $ent1 -> get();
    my $photog = $ent2 -> get();
    my $latitude = $ent3 -> get();
    my $longitude = $ent4 -> get();
    my $keywords = $ent5 -> get();

    # Search the path
    my $search = new File::List($fdir);
    # Find all .JPG and .jpg in the path
    my @files = @{$search->find("?i\.JPG\$")};

    # Loop through all of the files
    foreach(@files){
        $_ =~ s|/|\\|g;

        $path = $_;

        my $src = $path;
        my $exif = Image::ExifTool->new();

        # Extract info from existing image
        $exif->ExtractInfo($src);

        # Get create date and camera model from file
        my $description = $exif->GetValue('CreateDate');
        my $model = $exif->GetValue('Model');

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
        if($photog) {
            $exif->SetNewValue(Artist => $photog);
            $exif->SetNewValue(Copyright => 'Copyright '. $year .' - ' . $photog . ' All rights reserved');
            $exif->SetNewValue(Creator => $photog);
        }

        if($keywords) {
            $keywords = $keywords . " " . $model;
            $exif->SetNewValue(Keywords => $keywords);
        }

        if($latitude) {
            # Set location in image file
            $exif->SetLocation($latitude, $longitude);
        }

        $txt -> insert('end', "$path\n");

        # Write new image
        $exif->WriteInfo($src);

    }
$txt -> insert('end',"Mission Complete\n", 'color1');
closedir(DIR);
}
