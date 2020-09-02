
use strict;
use warnings;
use Tk;
use WWW::YouTube::Download;

our $path = '';

my $mw = new MainWindow;        # Main Window
$mw -> title("YouTube Downloader");

my $menubar = $mw -> Menu(-type => 'menubar');
$mw -> configure(-menu => $menubar);
my $mfile = $menubar->cascade(-label => '~Download To', -tearoff => 0);
$mfile -> command(-label => '~Download Dir',
                -accelerator => 'Control+d',
                -command => \&open_dir);
$mfile -> command(-label => '~Clear',
                -accelerator => 'Control+c',
                -command => \&clear_screen);

$mw -> bind('<Control-d>', [\&open_dir]);
$mw -> bind('<Control-c>', [\&clear_screen]);

#my $frm_input = $mw -> Frame();
my $lab1 = $mw -> Label(-text => "File Path:     ");
my $ent1 = $mw -> Entry(-width => 80);
my $lab2 = $mw -> Label(-text => "You Tube url: (ctl-v)  ");
my $ent2 = $mw -> Entry(-width => 80);
my $but1 = $mw -> Button(-text => " Download ", -command => \&download_video);
my $ent3 = $mw -> Entry(-width => 80, -relief => 'flat', -foreground => 'red');
# Geometry Management

$lab1 -> grid(-row => 2, -column => 1, -sticky => "w",
            -ipadx => 10, -ipady => 10);
$ent1 -> grid(-row => 2, -column => 2,
            -padx => 20, - pady => 5);
$lab2 -> grid(-row => 3, -column => 1, -sticky => "w",
            -ipadx => 10, -ipady => 10);
$ent2 -> grid(-row => 3, -column => 2,
            -padx => 20, - pady => 10);
$but1 -> grid(-row => 4, -column => 1,
            -columnspan => 2,
            -ipadx => 30, -pady => 10);
$ent3 -> grid(-row => 5, -column => 1,
            -columnspan => 2,
            -padx => 20, -pady => 5);

MainLoop;

sub open_dir {
    my $open = $mw->chooseDirectory(-initialdir => '~',
                                        -title => 'Choose a directory');
    $ent1 -> insert('end', "$open") if $open;
}

sub clear_screen {
    $ent1 -> delete('0.0', 'end');
    $ent2 -> delete('0.0', 'end');
    $ent3 -> delete('0.0', 'end');
}

sub download_video {
    my $path = $ent1 -> get();
    my $fdir = $ent2 -> get();
    chdir $path;
    if ($fdir) {
        my $tube = WWW::YouTube::Download->new;
        my $video_id = $tube->video_id($fdir);
        $tube->download($video_id, { filename => "{title}" . '.' . "{suffix}" });
        $ent3 -> insert('0.0', "Mission Complete");
    }
}
