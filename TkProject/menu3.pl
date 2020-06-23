
use Tk 800.000;
use subs qw/menubar_etal/;
use strict;

my $mw = MainWindow->new;
$mw->configure(-menu => my $menubar = $mw->Menu(-menuitems => menubar_etal));

MainLoop;

sub menubar_etal {
     [
        map ['cascade', $_->[0], -menuitems => $_->[1]],

            ['~File',
                [
                    [qw/cascade ~New -accelerator Ctrl-n -menuitems/ =>
                        [
                            ['checkbutton', 'Strict Motif'],
                            ['checkbutton', 'Bisque'],
                            [qw/command Widget/], '',
                            [qw/cascade Image -tearoff 0 -menuitems/ =>
                                [
                                    map ['radiobutton', $_],
                                        qw/bmp ppm gif png jpg tif/,
                                ],
                            ],
                        ],
                    ],                                                      '',
                    [qw/command ~Open -accelerator Ctrl-o/],                '',
                    [qw/command ~Save -accelerator Ctrl-s/],
                    [qw/command/, 'S~ave As ...', qw/-accelerator Ctrl-a/], '',
                    [qw/command ~Close -accelerator Ctrl-w/],               '',
                    [qw/command ~Quit -accelerator Ctrl-q -command/ => \&exit],
                ],
            ],

            ['~Edit',
                [
                    ['command', 'Preferences ...'],
                ],
            ],

            ['~Help',
                [
                    ['command', 'Version', -command => sub {print "Version\n"}],
                    '',
                    ['command', 'About', -command => sub {print "About\n"}],
                ],
            ],
    ];
} # end menubar_etal
