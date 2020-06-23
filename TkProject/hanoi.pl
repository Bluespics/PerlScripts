
use Tk;
use Tk::Dialog;
use subs qw/do_hanoi fini hanoi init move_ring/;
use strict;

my $canvas; # the Hanoi playing field
my @colors; # 24 graduated ring colors
my $fly_y; # canvas Y-coord along which rings fly
my $max_rings; # be nice and keep @colors count-consistent
my $num_moves; # total ring moves
my %pole; # tracks pole X-coord and ring count
my %ring; # tracks ring canvas ID, width and pole
my $ring_base; # canvas Y-coord of base of ring pile
my $ring_spacing; # pixels between adjacent rings
my $stopped; # 1 IFF simulation is stopped
my $velocity; # pixel delta the rings move while flying
my $version = '1.0, 2000/06/14';

# Main.

my $mw = MainWindow->new(-use => $Plugin::brinfo{xwindow_id});
init;
MainLoop;

sub do_hanoi {

    # Initialize for a new simulation.

    my($n) = @_; # number of rings

    return unless $stopped;

    $stopped = 0; # start ...
    $num_moves = 0; # ... new simulation

    my $ring_height = 26;
    $ring_spacing = 0.67 * $ring_height;

    my $ring_width = 96 + $n * 12;

    my $canvas_width = 3 * $ring_width + 4 * 12;
    my $canvas_height = $ring_spacing * $n + $fly_y + 2 * $ring_height;

    $ring_base = $canvas_height - 32;

    # Remove all rings from the previous run and resize the canvas.

    for (my $i = 0; $i < $max_rings; $i++) {
        $canvas->delete($ring{$i, 'id'}) if defined $ring{$i, 'id'};
    }
    $canvas->configure(-width => $canvas_width, -height => $canvas_height);

    # Initialize the poles: no rings, updated X coordinate.

    for (my $i = 0; $i < 3; $i++) {
        $pole{$i, 'x'} = ($i * $canvas_width / 3) + ($ring_width / 2) + 8;
        $pole{$i, 'ring_count'} = 0;
    }

    # Initialize the rings: canvas ID, pole number, and width.

    for (my $i = 0; $i < $n; $i++) {
        my $color = '#' . $colors[$i % 24];
        my $w = $ring_width - ($i * 12);
        my $y = $ring_base - $i * $ring_spacing;
        my $x = $pole{0, 'x'} - $w / 2;
        my $r = $n - $i;
        $ring{$r, 'id'} = $canvas->createOval(
                $x, $y, $x + $w, $y + $ring_height,
                -fill => $color, -outline => 'black', -width => 1,
            );
        $ring{$r, 'width'} = $w;
        $ring{$r, 'pole'} = 0;
        $pole{0, 'ring_count'}++;
    }

    # Start the simulation.

    $mw->update;
    hanoi $n, 0, 2, 1;
    $stopped = 1;
} # end do_hanoi

sub hanoi {

    # Recursively move rings until complete or stopped by the user.

    my($n, $from, $to, $work) = @_;

    return if $n <=0 or $stopped;

    hanoi $n - 1, $from, $work, $to;
    move_ring $n, $to unless $stopped;
    hanoi $n - 1, $work, $to, $from;
}

sub init {

    $fly_y = 32; # Y-coord rings use to fly between poles
    $stopped = 1;
    my $stop = sub {$stopped = 1};
    my $about = $mw->Dialog(
        -title => 'About tkhanoi',
        -bitmap => 'info',
        -default_button => 'OK',
        -buttons => ['OK'],
        -text => "tkhanoi version $version\n\n" .
                "r - run simulation\n" .
                "s - stop simulation\n" .
                "q - quit program\n",
        -wraplength => '6i',
    );

    # Menubar and menubuttons.

    $mw->title("Towers of Hanoi");
    $mw->configure(-menu => my $menubar = $mw->Menu);

    my $file = $menubar->cascade(-label => 'File');
    $file->command(-label => '~Quit', -command => \&fini,-accelerator => 'q');

    my $game = $menubar->cascade(-label => 'Game');
    $game->command(-label => '~Run', -command => sub {}, -accelerator => 'r');
    $game->command(-label => '~Stop', -command => $stop, -accelerator => 's');

    my $help = $menubar->cascade(-label => 'Help');
    $help->command(-label => 'About', -command => sub {$about->Show});

    my $info = $mw->Frame->pack;

    # Number of rings scale.

    my $rframe = $info->Frame(qw/-borderwidth 2 -relief raised/);
    my $rlabel = $rframe->Label(-text => 'Number of Rings');
    my $rscale = $rframe->Scale(
        qw/-orient horizontal -from 1 -to 24 -length 200/,
    );
    $rscale->set(4);
    $game->cget(-menu)->entryconfigure('Run',
        -command => sub {do_hanoi $rscale->get},
    );

    $rframe->pack(qw/-side left/);
    $rscale->pack(qw/-side right -expand 1 -fill x/);
    $rlabel->pack(qw/-side left/);

    # Ring velocity scale.

    my $vframe = $info->Frame(qw/-borderwidth 2 -relief raised/);
    my $vlabel = $vframe->Label(-text => 'Ring Velocity %');
    my $vscale = $vframe->Scale(
        qw/-orient horizontal -from 0 -to 100 -length 200/,
        -command => sub {$velocity = shift},
    );
    $vscale->set(2);

    $vframe->pack(qw/-side left/);
    $vscale->pack(qw/-side right -expand 1 -fill x/);
    $vlabel->pack(qw/-side left/);

    # The simulation is played out on a canvas.

    $canvas = $mw->Canvas(qw/-relief sunken/);
    $canvas->pack(qw/-expand 1 -fill both/);
    $canvas->createWindow(40, 10, -window =>
        $canvas->Label(-textvariable => \$num_moves, -foreground => 'blue'),
    );

    # Each ring has a unique color, hopefully.

    @colors = (qw/
        ffff0000b000 ffff00006000 ffff40000000 ffff60000000
        ffff80000000 ffffa0000000 ffffc0000000 ffffe0000000
        ffffffff0000 d000ffff0000 b000ffff0000 9000ffff0000
        6000ffff3000 0000ffff6000 0000ffff9000 0000ffffc000
        0000ffffffff 0000e000ffff 0000c000ffff 0000a000ffff
        00008000ffff 00006000ffff 00004000ffff 00000000ffff
    /);

    $max_rings = 24;
    warn "Too few colors for $max_rings rings!" if $max_rings > $#colors + 1;

    # Global key bindings that emulate menu commands.

    $mw->bind('' => sub {do_hanoi $rscale->get});
    $mw->bind('' => \&fini);
    $mw->bind('' => $stop);
} # end init

sub fini {
    $mw->destroy;
}

sub move_ring {

    # Move ring $n - its bounding box coordinates - to pole $to.

    my($n, $to) = @_;

    $num_moves++;
    my $r = $ring{$n, 'id'};
    my($x0, $y0, $x1, $y1) = map {int($_ + 0.5)} $canvas->coords($r);

    # Float the ring upwards to the flying Y-coordinate, and decrement
    # this pole's count.

    my $delta;
    while ($y0 > $fly_y) {
        $delta = $y0 - $fly_y > $velocity ? $velocity : $y0 - $fly_y;
        $canvas->coords($r, $x0, $y0 -= $delta, $x1, $y1 -= $delta);
        $mw->update;
    }
    $pole{$ring{$n, 'pole'}, 'ring_count'}--;

    # Determine the target X coordinate based on destination pole, and
    # fly the ring over to the new pole. The first while moves rings
    # left-to-right, the second while moves rings right-to-left.

    my $x = $pole{$to, 'x'} - $ring{$n, 'width'} / 2;

    while ($x0 < $x) {
        $delta = $x - $x0 > $velocity ? $velocity : $x - $x0;
        $canvas->coords($r, $x0 += $delta, $y0, $x1 += $delta, $y1);
        $mw->update;
    }

    while ($x0 > $x) {
        $delta = $x0 - $x > $velocity ? $velocity : $x0 - $x;
        $canvas->coords($r, $x0 -= $delta, $y0, $x1 -= $delta, $y1);
        $mw->update;
    }

    # Determine ring's target Y coordinate, based on the destination
    # pole's ring count, and float the ring down.

    my $y = $ring_base - $pole{$to, 'ring_count'} * $ring_spacing;

    while ($y0 < $y) {
        $delta = $y - $y0 > $velocity ? $velocity : $y - $y0;
        $canvas->coords($r, $x0, $y0 += $delta, $x1, $y1 += $delta);
        $mw->update;
    }

    $pole{$to, 'ring_count'}++;
    $ring{$n, 'pole'} = $to;
} # end move_ring
