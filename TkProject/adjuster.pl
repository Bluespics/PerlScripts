
use Tk;
use Tk::Adjuster;

$mw = MainWindow->new(-title => "Adjuster example");

$leftf = $mw->Frame->pack(-side => 'left', -fill => 'y');
$adj = $mw->Adjuster(-widget => $leftf, -side => 'left')
    ->pack(-side => 'left', -fill => 'y');
$rightf = $mw->Frame->pack(-side => 'right', -fill => 'both', -expand => 1);

# Now put something into our frames.
$lb = $leftf->Scrolled('Listbox', -scrollbars => 'osoe')
    ->pack(-expand => 1, -fill => 'both');
$lb->insert('end', qw/normal bold italics code command email emphasis
            emphasisBold Filename FirstTerm KeyCode KeySymbol/);
$rightf->Scrolled('Text', -scrollbars => 'osoe')
    ->pack(-expand => 1, -fill => 'both');

MainLoop;
