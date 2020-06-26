
use Tk;
use Tk::LabFrame;
use strict;

my $mw = MainWindow->new(-title => 'LabFrame example');
my $lf = $mw->LabFrame(-label => "This is the label of a LabFrame",
    -labelside => 'acrosstop')->pack;
$lf->Text(qw/-width 80 -height 20/)->pack;

MainLoop;
