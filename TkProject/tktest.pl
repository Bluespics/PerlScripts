
use Tk;
use strict;

# initial banner text. Entry is not read-only
my $str = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789";

my $mw = MainWindow->new;
my $lframe = $mw->Frame->pack(-fill => 'both',
    -side => 'left', -expand => 1);
my $lb = $lframe->Scrolled("Listbox", -scrollbars => "e",
    -height => 3)->pack(-fill => 'both', -expand => 1, -side => 'top');

$lb->insert('end', sort $mw->fontFamilies);

# Button that will pop the config widgets in and out
my $hidebutton = $mw->Button(-text => ">")->pack(-side => 'left',
    -fill => 'y');
$hidebutton->configure(-command =>
    sub {
        if ($hidebutton->cget(-text) eq ">") {
             $lframe->packForget; $hidebutton->configure(-text => "<")
         } else {
              $lframe->pack(-before => $hidebutton, -fill => 'both',
                -side => 'left', -expand => 1);
                $hidebutton->configure(-text => ">");
            }
    }, -font => "courier 8");

    my $entry = $mw->Entry(
                    -textvariable => \$str,
                    -width => 12,
                    -font => "{Comic Sans MS} 72",
                    -relief => 'raised',
                    -highlightthickness => 0,
                    )->pack(-expand => 1, -fill => 'x', -side => 'left');

    $lb->bind("", sub { $entry->configure(
        -font => "{". $lb->get($lb->curselection) . "} 72"); });

    my $repeat_id = $mw->repeat(300, \&shift_banner);

    my $f = $lframe->Frame->pack(-side => 'bottom', -fill => 'y');
    my $start_button;
    $start_button = $f->Button(-text => "Start",
        -command => sub {
            $repeat_id = $mw->repeat(300,\&shift_banner);
            $start_button->configure(-state => 'disabled'); },
            -state => 'disabled')->pack(-side => 'left', -padx => 3);
    my $stop_button = $f->Button(-text => "Stop", -command => sub {
        $repeat_id->cancel( );
        $start_button->configure(-state => 'normal'); }
    )->pack(-side => 'left', -padx => 3);

MainLoop;

# Causes text to be wrapped around in entry
sub shift_banner {
    my $newstr = substr($str, 1) . substr($str, 0, 1);
    $str = $newstr;
}
