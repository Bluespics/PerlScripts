
use Image::Magick;

$q = Image::Magick->new;
$q->Set(size=>'100x100', 'pixel[50,50]'=>'255,0,0');
$q->ReadImage('xc:white');
