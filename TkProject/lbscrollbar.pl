
use Tk;
$mw = MainWindow->new;
$mw->title("Entry");
$f = $mw->Frame( )->pack(-side => 'top', -expand => 1, -fill => 'both');
$xscroll = $f->Scrollbar(-orient => 'horizontal');
$yscroll = $f->Scrollbar( );
$lb = $f->Listbox(-width => 50, -height => 12,
                -yscrollcommand => ['set', $yscroll],
                -xscrollcommand => ['set', $xscroll]);
$xscroll->configure(-command => ['xview', $lb]);
$yscroll->configure(-command => ['yview', $lb]);
$xscroll->pack(-side => 'bottom', -fill => 'x');
$yscroll->pack(-side => 'right', -fill => 'y');
$lb->pack(-side => 'bottom', -fill => 'both', -expand => 1);


MainLoop;
