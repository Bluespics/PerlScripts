
use Tk;
use Tk::ToolBar;
use Tk::BrowseEntry;

my $mw = MainWindow->new(-title => "Ted - Tiny Editor");

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

my $f = $mw->Frame->pack(-side => 'top',
                        -anchor => 'w');

my $tb1 = $f->ToolBar()->pack(-side => 'left');
$tb1->ToolButton(-image   => 'filenew22',
                 -tip     => 'New',
                 -command => \&clear_screen);
$tb1->ToolButton(-image   => 'fileopen22',
                 -tip     => 'Open',
                 -command => \&open_file);
$tb1->ToolButton(-image   => 'filesave22',
                 -tip     => 'Save',
                 -command => \&save_file);
$tb1->ToolButton(-image   => 'editdelete22',
                 -tip     => 'Exit',
                 -command => \&exit);
$tb1->separator;

my $family = 'Courier';
my $be = $f->BrowseEntry(-label => 'Family:', -variable => \$family,
            -browsecmd => \&apply_font)->pack(-fill => 'x', -side => 'left');
$be->insert('end', sort $mw->fontFamilies);

my $size = 10;
my $bentry = $f->BrowseEntry(-label => 'Size:', -variable => \$size,
            -browsecmd => \&apply_font)->pack(-side => 'left');
$bentry->insert('end', (3 .. 32));

my $weight = 'normal';
$f->Checkbutton(-onvalue => 'bold', -offvalue => 'normal',
            -text => 'Bold', -variable => \$weight,
            -command => \&apply_font)->pack(-side => 'left');

my $slant = 'roman';
$f->Checkbutton(-onvalue => 'italic', -offvalue => 'roman',
            -text => 'Italic', -variable => \$slant,
            -command => \&apply_font)->pack(-side => 'left');

my $underline = 0;
$f->Checkbutton(-text => 'Underline', -variable => \$underline,
            -command => \&apply_font)->pack(-side => 'left');

my $overstrike = 0;
$f->Checkbutton(-text => 'Overstrike', -variable => \$overstrike,
            -command => \&apply_font)->pack(-side => 'left');

$t = $mw->Scrolled("Text", -height => 35, -width => 130,
                    -tabs => [qw/0.35i 0.7i/],
                    -wrap => 'word',
                    -scrollbars => 'osoe')->pack(-side => 'bottom',
                    -fill => 'both', -expand => 1);

&apply_font;

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
                                -initialfile => $filename,
                                -defaultextension => '.pl');
     open (FILE, ">$save");
     print FILE $t->get("1.0", "end");
     close (FILE);
     $t -> delete('1.0', 'end');
}

sub display_about {
    my $ftp_warn = $mw->messageBox(
      -title   => 'Ted - Tiny Editor',
      -message => "Author - Tony Winfield\n\nVersion 1.40 - 06/10/2020",
      -type    => 'OK',
      -icon    => 'info',
    );

    if ( $ftp_warn eq 'OK' ) {
      exit;
  }
}

sub clear_screen {
    $t -> delete('1.0', 'end');
}

sub apply_font {
     # Specify all options for font in an anonymous array
     $t->configure(-font =>
        [-family => $family,
        -size => $size,
        -weight => $weight,
        -slant => $slant,
        -underline => $underline,
        -overstrike => $overstrike]);
}
