
use Tk;

$mw = MainWindow->new(-title => "Main Window",
                    -height => '250',
                    -width => '400');
$text = $mw->Scrolled("Text")->pack();

MainLoop;
