
# Display Hello World program

use warnings;
use strict;
use Tk;

my $mw = MainWindow->new( -width => '400', -relief => 'flat', -height => '100', -title => 'Exif Updater', );
my $var1 = $mw->Entry( -width => '50', -relief => 'sunken', -state => 'normal', -justify => 'left', -text => 'Entry0', )->place( -x => 63, -y => 11);
my $var2 = $mw->Label( -pady => '1', -relief => 'flat', -padx => '1', -state => 'normal', -justify => 'center', -text => 'File Path', )->place( -x => 10, -y => 10);
my $var3 = $mw->Button( -pady => '1', -relief => 'raised', -padx => '1', -state => 'normal', -justify => 'center', -text => 'Run Program', )->place( -x => 18, -y => 60);

$mw->MainLoop();
