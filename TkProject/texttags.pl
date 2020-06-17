
use Tk;
$mw = MainWindow->new;

$t = $mw->Text()->pack( );
$t->tagConfigure('bold', -font => "Courier 24 bold");
$t->tagConfigure('blue', -foreground => "blue");
$t->tagConfigure('bigred', -foreground => "red", -spacing2 => 6);
$t->insert('end', "This is some normal text\n");
$t->insert('end', "This is some bold text\n", 'bold');
$t->insert('end', "This is some blue text\n", 'blue');
$t->insert('end', "This is big red text\n", 'bigred');

MainLoop;
