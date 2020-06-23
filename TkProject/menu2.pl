
use Tk 800.000;
use subs qw/edit_menuitems file_menuitems help_menuitems/;

my $mw = MainWindow->new;
$mw->configure(-menu => my $menubar = $mw->Menu);

my $file = $menubar->cascade(
    -label => '~File', -menuitems => file_menuitems);

my $edit = $menubar->cascade(
    -label => '~Edit', -menuitems => edit_menuitems);

my $help = $menubar->cascade(
    -label => '~Help', -menuitems => help_menuitems);

map {$menubar->cascade( -label => '~' . $_->[0], -menuitems => $_->[1] )}
    ['File', file_menuitems],
    ['Edit', edit_menuitems],
    ['Help', help_menuitems];

sub edit_menuitems {
    [
        ['command', 'Preferences ...'],
    ];
}

sub help_menuitems {
    [
        ['command', 'Version', -command => sub {print "Version\n"}],
        '',
        ['command', 'About', -command => sub {print "About\n"}],
    ];
}

sub file_menuitems {

    # Create the menu items for the File menu.

    my($motif, $bisque) = (1, 0);
    my $new_image_format = 'png';
    [
        [qw/cascade ~New -accelerator Ctrl-n -menuitems/ =>
            [
                ['checkbutton', 'Strict Motif', -variable => \$motif],
                ['checkbutton', 'Bisque', -variable => \$bisque],
                [qw/command Widget/], '',
                [qw/cascade Image -tearoff 0 -menuitems/ =>
                    [
                        map ['radiobutton', $_, -variable => \$new_image_format],
                            qw/bmp ppm gif png jpg tif/,
                    ],
                ],
            ],
        ],                                                              '',
        [qw/command ~Open -accelerator Ctrl-o/],                        '',
        [qw/command ~Save -accelerator Ctrl-s/],
        [qw/command/, 'S~ave As ...', qw/-accelerator Ctrl-a/],         '',
        [qw/command ~Close -accelerator Ctrl-w/],                       '',
        [qw/command ~Quit -accelerator Ctrl-q -command/ => \&exit],
    ];
} # end file_menuitems


MainLoop;
