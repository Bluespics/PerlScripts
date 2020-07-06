
use Image::ExifTool;
use Image::ExifTool::Location;
use Tk;

my $mw = new MainWindow;   # Main MainWindow
$mw -> title("EXIF Information");

my $menubar = $mw -> Menu(-type => 'menubar');
$mw -> configure(-menu => $menubar);
my $mfile = $menubar->cascade(-label => '~File', -tearoff => 0);
$mfile->command(-label => '~Open',
                -accelerator => 'Control+o',
                -command => \&open_file);
$mfile->command(-label => '~Clear',
                -accelerator => 'Control+c',
                -command => \&clear_screen);
$mw -> bind('<Control-o>', [\&open_file]);
$mw -> bind('<Control-c>', [\&clear_screen]);

my $types = [ ['JPG files', '.jpg'],
              ['All Files',   '*'],];

my $frm_name = $mw -> Frame();
my $lab = $frm_name -> Label(-text => "File Path: ");
my $ent = $frm_name -> Entry(-width => 110);

my $textarea = $mw -> Frame();   # Creating another Frame
my $txt = $textarea -> Text(-width => 120, -height => 50);
my $srl_y = $textarea -> Scrollbar(-orient => 'v', -command => [yview => $txt]);
my $srl_x = $textarea -> Scrollbar(-orient => 'h', -command => [xview => $txt]);
$txt -> configure(-yscrollcommand => ['set',$srl_y],
                -xscrollcommand => ['set',$srl_x]);
$txt -> tag(qw/configure color1 -foreground blue/);
$txt -> tag(qw/configure color2 -foreground black/);

#Geometry Management
$menubar -> grid(-row => 1, -column => 1);
$lab -> grid(-row => 1, -column => 1);
$ent -> grid(-row => 1, -column => 2, -columnspan => 3);
$frm_name -> grid(-row => 1, -column => 1, -columnspan => 4);

$txt -> grid(-row => 1, -column => 1);
$srl_y -> grid(-row => 1, -column => 2, -sticky => "ns");
$srl_x -> grid(-row => 2, -column => 1, -sticky => "ew");
$textarea -> grid(-row => 5, -column => 1, -columnspan => 2,
                -ipadx => 7, -ipady => 5);

MainLoop;

sub clear_screen {
    $txt -> delete('1.0', 'end');
    $ent -> delete('0.0', 'end');
}

sub open_file {
    my $open = $mw->getOpenFile(-filetypes => $types,
                            -defaultextension => '.jpg');
    $ent -> insert('end', "$open") if $open;

    my $fdir = $ent -> get();

    my $exifTool = new Image::ExifTool;
    $exifTool->Options(Unknown => 1);
    my $info = $exifTool->ImageInfo($fdir);
    my $group = '';
    my $tag;

    foreach $tag ($exifTool->GetFoundTags('Group0')) {
        if ($group ne $exifTool->GetGroup($tag)) {
            $group = $exifTool->GetGroup($tag);
            $txt -> insert('end', "---- $group ----\n", 'color1');
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

        my $linedata = sprintf("%-32s : %s\n", $exifTool->GetDescription($tag), $val);
        $txt -> insert('end', "$linedata");
    }
}
