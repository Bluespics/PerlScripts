
use strict;
use warnings;
use Tk;
use WWW::YouTube::Download;

our $path = '';

my $txt1;
Tk::CmdLine::SetArguments(qw(-geometry +410+300));

my $mw = new MainWindow;        # Main Window
$mw -> title("YouTube Downloader");

my $menubar = $mw -> Menu(-type => 'menubar');
$mw -> configure(-menu => $menubar);
my $mfile = $menubar->cascade(-label => '~Save', -tearoff => 0);
# my $minfo = $menubar->cascade(-label => '~Info');
my $mhelp = $menubar->cascade(-label => '~Help', -tearoff => 0);

$mfile -> command(-label => '~Save To',
                -accelerator => 'Control+d',
                -command => \&open_dir);
$mfile -> command(-label => '~Clear',
                -accelerator => 'Control+c',
                -command => \&clear_screen);

$mhelp -> command(-label => '~About',
                -accelerator => 'Control+a',
                -command => \&display_about);

$mw -> bind('<Control-d>', [\&open_dir]);
$mw -> bind('<Control-c>', [\&clear_screen]);

#my $frm_input = $mw -> Frame();
my $lab1 = $mw -> Label(-text => "File Path:     ",
                        -font => ['ariel', '9', 'normal']);
my $ent1 = $mw -> Entry(-width => 80,
                        -font => ['ariel', '8', 'normal']);
my $but2 = $mw -> Button(-text => " Choose Dir ",
                        -command => \&open_dir);
my $lab2 = $mw -> Label(-text => "You Tube url:  ",
                        -font => ['ariel', '9', 'normal']);
my $ent2 = $mw -> Entry(-textvariable=>\$txt1, -width => 80,
                        -font => ['ariel', '8', 'normal']);
my $but1 = $mw -> Button(-text => " Download ",
                        -command => \&download_video);
my $ent3 = $mw -> Entry(-width => 40,
                        -relief => 'flat',
                        -background => 'grey95',
                        -foreground => 'red',
                        -font => ['ariel', '9', 'normal']);

# Geometry Management

$lab1 -> grid(-row => 2, -column => 1, -sticky => "w",
            -ipadx => 10, -ipady => 10);
$ent1 -> grid(-row => 2, -column => 2,
            -padx => 10, - pady => 5);
$but2 -> grid(-row => 2, -column => 3,
            -padx => 10, -pady => 5);
$lab2 -> grid(-row => 3, -column => 1, -sticky => "w",
            -ipadx => 10, -ipady => 10);
$ent2 -> grid(-row => 3, -column => 2,
            -padx => 20, - pady => 10);
$but1 -> grid(-row => 4, -column => 1,
            -columnspan => 2,
            -ipadx => 50, -pady => 10);
$ent3 -> grid(-row => 5, -column => 1,
            -columnspan => 2,
            -padx => 20, -pady => 10);

add_edit_popup($mw, $ent2);

MainLoop;

sub open_dir {
    my $open = $mw->chooseDirectory(-initialdir => 'C:',
                                        -title => 'Choose a directory');
    $ent1 -> insert('end', "$open") if $open;
}

sub clear_screen {
    $ent1 -> delete('0.0', 'end');
    $ent2 -> delete('0.0', 'end');
    $ent3 -> delete('0.0', 'end');
}

sub display_about {
    my $ftp_warn = $mw->messageBox(
      -title   => 'You Tube Downloader',
      -message => "Author - Tony Winfield\n\nVersion 1.01 - 26/09/2020",
      -type    => 'OK',
      -icon    => 'info',
    );

    if ( $ftp_warn eq 'OK' ) {
      exit;
  }
}
#
# Adds a right-click Edit popup menu to a widget.
#
sub add_edit_popup
{
  my ($mw, $obj) = @_;
  my $menu = $mw->Menu(-tearoff=>0, -menuitems=>[
    [qw/command Paste/, -command=>['clipboardPaste', $obj]]
  ]);
  $obj->menu($menu);
  $obj->bind('<3>', ['PostPopupMenu', Ev('X'), Ev('Y'), ]);
  return $obj;
}

sub download_video {
    my $path = $ent1 -> get();
    my $fdir = $ent2 -> get();
    $ent3 -> insert('0.0', '   Sorry Download Failed - Format Not Supported');
    chdir $path;
    if ($fdir) {
        my $tube = WWW::YouTube::Download->new;
        my $video_id = $tube->video_id($fdir);
        my $vtitle = $tube->get_title($video_id);
        my $fmtlist = $tube->get_fmt($video_id);

        $vtitle =~ s/[^a-zA-Z0-9 ,]//g;
        $tube->download($video_id, { filename => "$vtitle" . '.' . "{suffix}" });
#        $tube->download($video_id, { filename => "$vtitle" . '.' . "mp3" });
        $ent3 -> delete('0.0', 'end');
        $ent3 -> insert('0.0', '                          Download Complete');
        $ent2 -> delete('0.0', 'end');
        }
}
