
use Audio::Play::MPG123;
use Tk;
use Tk::PNG;
use subs qw/build_player start_play edit_menuitems file_menuitems help_menuitems init play/;
our ($c, , @info, $infov, $mw, $paus, $phand, $play, $player, $timev, $v);
use strict;

$v = '-0.97';

$player = Audio::Play::MPG123->new;
$phand = $player->IN;

$mw = MainWindow->new;
$mw->configure(-menu => my $menubar = $mw->Menu);
map {$menubar->cascade( -label => '~' . $_->[0], -menuitems => $_->[1] )}
    ['File', file_menuitems],
    ['Edit', edit_menuitems],
    ['Help', help_menuitems];


build_player;

MainLoop;

sub build_player {

     $c = $mw->Canvas(
        -width => 1,
        -height => 1,
        -background => 'dark slate gray',
    )->pack;
    my $itunes = $c->Photo(-file => 'images/itunes.gif');
    $c->createImage(0, 0,
        -image => $itunes,
        -tag => 'itunes',
        -anchor => 'nw',
    );
    $c->configure(-width => $itunes->width, -height => $itunes->height);

    $paus = $c->Photo(-file => 'images/paus.gif');
    $play = $c->Photo(-file => 'images/play.gif');

    $c->createImage(80, 40, -image => $play, -tag => 'play-image');
    $c->bind('play-image', '<1>' => \&pause);

    my $green = '#d5dac1';
    my $font = 'courier 12';

    my $f = $c->Frame(
        -width => 250,
        -height => 50,
        -background => $green,
        -relief => 'sunken',
        -borderwidth => 3,
    );
    $f->packPropagate(0);
    $c->createWindow(170, 20, -anchor => 'nw', -window => $f);

    $infov = '';
    my $info = $f->Label(
        -textvariable => \$infov,
        -font => $font,
        -background => $green,
    );
    $info->pack(-side => 'top');

    $timev = 'Elapsed Time: 0:00';
    my $time = $f->Label(
        -textvariable => \$timev,
        -font => $font,
        -background => $green,
    );
    $time->pack(-side => 'top');

    my $f2 = $c->Frame(
        -width => 570,
        -height => 280,
        -background => $green,
        -relief => 'sunken',
        -borderwidth => 3,
    );
    $f2->packPropagate(0);
    $c->createWindow(15, 85, -anchor => 'nw', -window => $f2);

    my $mpgs = $f2->Scrolled('Listbox')->pack(-fill => 'y', -expand => 1);
    foreach my $mpg (<*.mpg>, <*.mp3>) {
        $mpgs->insert('end', $mpg);
    }
    $mpgs->bind('<1>' => sub {play $mpgs->get( $mpgs->nearest($Tk::event->y) )});
} # end build_player

sub pause {
    $player->pause;
    $c->itemconfigure('play-image',
        -image => ($player->state == 1) ? $paus : $play
    );
}

sub edit_menuitems {
    [
        ['command', 'Preferences ...', -command => sub {$mw->bell}],
    ];
}

sub file_menuitems {
    [
        [
            qw/cascade ~Play -menuitems/ =>
            [
                [qw/command ~File... -command/ => \&play_file],
                [qw/command ~URL... -command/ => \&play_url],
            ],
        ],
        [qw/command ~Quit -command/ => \&exit],
    ];
}

sub help_menuitems {
    [
        ['command', 'Version', -command => sub {print "Version $v\n"}],
        '',
        ['command', 'About', -command => sub {print "Playing songs\n"}],
    ];
}

sub play_file {
    play $mw->getOpenFile(-title => 'Pick A Song');
}

sub play_url { # for now
    my $song = 'http://www.lehigh.edu/sol0/beat.mpg';;
    play $song;
}

sub play {
    my $song = shift;
    print "song=$song!\n";
    if (defined $song) {
        $player->load($song);
        @info = map {$player->$_} qw/title artist album/;
        start_play;
    }
}

sub ctm {
    my $s = shift;
    my $m = int($s / 60);
    sprintf("%02d:%02d", $m, $s - $m * 60);
}

sub start_play {

    my $info_tid = $mw->repeat(5000 => sub {
        $infov = $info[0];
        unshift @info, pop @info;
    });

    my $time_tid = $mw->repeat(1000 => sub {
        my(@toks) = split ' ', $player->stat;
        $timev = sprintf( "Elapsed Time: %s of %s\n",
            &ctm($toks[3]), &ctm($toks[3] + $toks[4]) );
    });

    my $in_hand = sub { $player->poll(0);
    $mw->update;
    if ($player->state == 0) {
        $player->stop;
        $mw->fileevent(\$phand, 'readable' => '');
        $mw->afterCancel($info_tid);
        $mw->afterCancel($time_tid);
    }
};
$mw->fileevent(\$phand, 'readable' => $in_hand);

}
