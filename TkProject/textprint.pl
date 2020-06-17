
use POSIX 'acos';
use Tk;
use strict;

my $mw = MainWindow->new;
my $text = $mw->Text(qw/-width 40 -height 10/)->pack;

tie *STDOUT, ref $text, $text;

print "Hello Text World!\n";
printf "pi ~= %1.5f", acos(-1.0);

MainLoop;
