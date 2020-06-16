
use Tk;

$mw = MainWindow->new( );
$mw->title("One Scrollbar/Three Listboxes");
$mw->Button(-text => "Exit",
            -command => sub { exit })->pack(-side => 'bottom');

$scroll = $mw->Scrollbar( );
# Anonymous array of the three Listboxes
$listboxes = [ $mw->Listbox(), $mw->Listbox(), $mw->Listbox( ) ];
# This method is called when one Listbox is scrolled with the keyboard
# It makes the Scrollbar reflect the change, and scrolls the other lists
sub scroll_listboxes {
    my ($sb, $scrolled, $lbs, @args) = @_;
    $sb->set(@args); # tell the Scrollbar what to display
    my ($top, $bottom) = $scrolled->yview( );
    foreach $list (@$lbs) {
        $list->yviewMoveto($top); # adjust each lb
    }
}

# Configure each Listbox to call &scroll_listboxes
foreach $list (@$listboxes) {
    $list->configure(-yscrollcommand => [ \&scroll_listboxes, $scroll,
                                            $list, $listboxes ]);
}

# Configure the Scrollbar to scroll each Listbox
$scroll->configure(-command => sub { foreach $list (@$listboxes) {
                                            $list->yview(@_);
                                        }});

# Pack the Scrollbar and Listboxes
$scroll->pack(-side => 'left', -fill => 'y');
foreach $list (@$listboxes) {
    $list->pack(-side => 'left');
    $list->insert('end', "one", "two", "three", "four", "five", "six",
                        "seven", "eight", "nine", "ten", "eleven");
}

MainLoop;
