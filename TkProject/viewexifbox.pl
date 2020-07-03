
use Image::ExifTool;
use Image::ExifTool::Location;
use Tk;

my $mw = new MainWindow;   # Main MainWindow
$mw -> title("EXIF Information");

my $frm_name = $mw -> Frame();
my $lab = $frm_name -> Label(-text => "File Path: ");
my $ent = $frm_name -> Entry(-width => 110);

my $but = $mw -> Button(-text => "Get EXIF", -command => \&push_button);

my $textarea = $mw -> Frame();   # Creating another Frame
my $txt = $textarea -> Text(-width => 120, -height => 50);
my $srl_y = $textarea -> Scrollbar(-orient => 'v', -command => [yview => $txt]);
my $srl_x = $textarea -> Scrollbar(-orient => 'h', -command => [xview => $txt]);
$txt -> configure(-yscrollcommand => ['set',$srl_y],
                -xscrollcommand => ['set',$srl_x]);

#Geometry Management
$lab -> grid(-row => 1, -column => 1);
$ent -> grid(-row => 1, -column => 2, -columnspan => 3);
$frm_name -> grid(-row => 1, -column => 1, -columnspan => 4);

$but -> grid(-row => 4, -column => 1, -columnspan => 2);

$txt -> grid(-row => 1, -column => 1);
$srl_y -> grid(-row => 1, -column => 2, -sticky => "ns");
$srl_x -> grid(-row => 2, -column => 1, -sticky => "ew");
$textarea -> grid(-row => 5, -column => 1, -columnspan => 2);

MainLoop;

sub push_button {
    my $fdir = $ent -> get();

    my $exifTool = new Image::ExifTool;
    $exifTool->Options(Unknown => 1);
    my $info = $exifTool->ImageInfo($fdir);
    my $group = '';
    my $tag;

    foreach $tag ($exifTool->GetFoundTags('Group0')) {
        if ($group ne $exifTool->GetGroup($tag)) {
            $group = $exifTool->GetGroup($tag);
            $txt -> insert('end', "---- $group ----\n");
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
#        $exifTool->GetDescription($tag, $val);
#        $txt -> insert('end', "$tag    $val\n");
        $txt -> insert('end', "$linedata");
    }
}
