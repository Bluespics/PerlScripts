
use strict;
use warnings;
use Tk;
use Tk::JPEG;
use Image::ExifTool;
use Image::ExifTool::Location;
use Image::Size;
use Math::Round;

my $mw = new MainWindow;   # Main MainWindow
$mw -> title("Display JPEG");

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
my $txt = $textarea -> Text(-width => 90, -height => 50);
my $srl_y = $textarea -> Scrollbar(-orient => 'v', -command => [yview => $txt]);
my $srl_x = $textarea -> Scrollbar(-orient => 'h', -command => [xview => $txt]);
$txt -> configure(-yscrollcommand => ['set',$srl_y],
                -xscrollcommand => ['set',$srl_x]);
$txt -> tag(qw/configure color1 -foreground blue/);
$txt -> tag(qw/configure color2 -foreground black/);

my $photo_obj = $mw->Photo(-file => '' );
my $photo_obj_scaled = $mw->Photo(-file => '' );

my $display = $mw->Label(-width => 600,
                           -height => 700,
			   -image => $photo_obj_scaled);

#Geometry Management
$lab -> grid(-row => 1, -column => 1);
$ent -> grid(-row => 1, -column => 2);
$frm_name -> grid(-row => 1, -column => 1);
$display -> grid(-row => 5, -column => 1, -columnspan => 2,
                -ipadx => 7, -ipady => 5);

$txt -> grid(-row => 1, -column => 1);
$srl_y -> grid(-row => 1, -column => 2, -sticky => "ns");
$srl_x -> grid(-row => 2, -column => 1, -sticky => "ew");
$textarea -> grid(-row => 5, -column => 3, -columnspan => 2,
                -ipadx => 7, -ipady => 5);


MainLoop;

sub clear_screen {
    $txt -> delete('1.0', 'end');
    $ent -> delete('0.0', 'end');
    $photo_obj = $mw->Photo(-file => '' );
    $photo_obj_scaled = $mw->Photo(-file => '' );
    $display->configure(-image => $photo_obj_scaled);
}

sub open_file {
    clear_screen;
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

    my $filename = $fdir;
    my $size;
    my $orientation;
    $photo_obj->blank; #clear out old jpg
    $photo_obj_scaled->blank;
    my ($h,$w) = ($mw->height, $mw->width);
    #
    # how to scale the pic?

    #Tk can only zoom or shrink by a factor, so
    #you need to determine the size of the image
    #then decide whether it needs shrinking or zooming.
    #but Tk itself won't get the size of the image without
    #external modules like Image::Info

    # First get width and height
    my $imgwidth;
    my $imgheight;
    my $calcval;
    my $imgfactor;
    ($imgwidth, $imgheight) = imgsize($filename);
    # Find biggest dimension
    if($imgwidth > $imgheight){
        $calcval = $imgwidth;
    }else{
        $calcval = $imgheight
    }
    # Calculate the scaling factor
    $imgfactor = round($calcval / 680);

    $photo_obj->read($filename);
    $photo_obj_scaled->copy($photo_obj, -subsample => $imgfactor, $imgfactor);

    $display->configure(-image => $photo_obj_scaled);

}
