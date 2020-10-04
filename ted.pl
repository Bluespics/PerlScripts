
use Tk;
use Tk::LineNumberText;

$mw = MainWindow->new;
$mw -> title("Ted - Tiny Editor");

my $menubar = $mw -> Menu(-type => 'menubar');
$mw -> configure(-menu => $menubar);
my $mfile = $menubar->cascade(-label => '~File', -tearoff => 0);
my $mhelp = $menubar->cascade(-label => '~Help', -tearoff => 0);

$mfile->command(-label => '~Open',
                -accelerator => 'Control+o',
                -command => \&open_file);
$mfile->separator;
$mfile->command(-label => '~Save',
                -accelerator => 'Control+s',
                -command => \&save_file);
$mfile->separator;
$mfile->command(-label => '~Clear',
                -accelerator => 'Control+c',
                -command => \&clear_screen);
$mfile->separator;
$mfile->command(-label => '~Close',
                -accelerator => 'Control+q',
                -command => \&exit);
$mhelp -> command(-label => '~About',
                -accelerator => 'Control+a',
                -command => \&display_about);

$mw -> bind('<Control-o>', [\&open_file]);
$mw -> bind('<Control-s>', [\&save_file]);
$mw -> bind('<Control-a>', [\&display_about]);
$mw -> bind('<Control-c>', [\&clear_screen]);
$mw -> bind('<Control-q>', [\&exit]);

my $types = [ ['Perl files', '.pl'],
              ['All Files',   '*'],];

$t = $mw->Scrolled("Text", -height => 35, -width => 130,
                    -tabs => [qw/0.35i 0.7i/],
                    -wrap => 'word',
                    -font=>['Courier',10],
                    -scrollbars => 'osoe')->pack(-side => 'bottom',
                    -fill => 'both', -expand => 1);

MainLoop;

sub open_file {
    clear_screen;
    my $filename = $mw->getOpenFile(-filetypes => $types,
                            -defaultextension => '.pl');
    open(FILE, $filename);
    foreach my $line (<FILE>){
        $t -> insert('end', $line);
    }
    close (FILE);
}

sub save_file {
    my $save = $mw->getSaveFile(-filetypes => $types,
                                -initialfile => $filename
                                -defaultextension => '.pl');
     open (FILE, ">$save");
     print FILE $t->get("1.0", "end");
     close (FILE);
     $t -> delete('1.0', 'end');
}

sub display_about {
    my $ftp_warn = $mw->messageBox(
      -title   => 'Ted - Tiny Editor',
      -message => "Author - Tony Winfield\n\nVersion 1.21 - 04/10/2020",
      -type    => 'OK',
#      -icon    => 'info',
    );

    if ( $ftp_warn eq 'OK' ) {
      exit;
  }
}

sub clear_screen {
    $t -> delete('1.0', 'end');
}
