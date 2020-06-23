
use Tk 800.000;

my $mw = MainWindow->new;

$mw->configure(-menu => my $menubar = $mw->Menu);
my $file = $menubar->cascade(-label => '~File');
my $edit = $menubar->cascade(-label => '~Edit');
my $help = $menubar->cascade(-label => '~Help');

my $new = $file->cascade(
    -label => 'New',
    -accelerator => 'Ctrl-n',
    -underline => 0,
);
$file->separator;
$file->command(
    -label => 'Open',
    -accelerator => 'Ctrl-o',
    -underline => 0,
);
$file->separator;
$file->command(
    -label => 'Save',
    -accelerator => 'Ctrl-s',
    -underline => 0,
);
$file->command(
    -label => 'Save As ...',
    -accelerator => 'Ctrl-a',
    -underline => 1,
);
$file->separator;
$file->command(
    -label => "Close",
    -accelerator => 'Ctrl-w',
    -underline => 0,
    -command => \&exit,
);
$file->separator;
$file->command(
    -label => "Quit",
    -accelerator => 'Ctrl-q',
    -underline => 0,
    -command => \&exit,
);

$edit->command(-label => 'Preferences ...');
$help->command(-label => 'Version', -command => sub {print "Version\n"});
$help->separator; $help->command(-label => 'About', -command => sub {print "About\n"});

my($motif, $bisque) = (1, 0);

foreach (['Strict Motif', \$motif], ['Bisque', \$bisque]) {
    $new->checkbutton(
    -label => $_->[0],
    -variable => $_->[1],
    );
}

my $vr = $new->cget(-menu)->entrycget('Bisque', -variable);
$$vr = 1;

$new->command(-label => 'Widget');
$new->separator;

my $new_image = $new->cascade(
    -label => 'Image',
    -menu => $new->cget(-menu)->Menu(-tearoff => 0),
);

my $new_image_format = 'png';
foreach (qw/bmp ppm gif png jpg tif/) {
    $new_image->radiobutton(
        -label => $_,
        -variable => \$new_image_format,
    );
}
MainLoop;
