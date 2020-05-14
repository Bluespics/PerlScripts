
use warnings;
use strict;
use Spreadsheet::WriteExcel;

# Create a new workbook called simple.xls and add a worksheet
my $workbook = Spreadsheet::WriteExcel->new('simple.xls');
my $worksheet = $workbook->add_worksheet();

# The general syntax is write($row, $column, $token)
# Note that row and column are zero indexed.

# Write some text
$worksheet->write(0, 0, 'Hi Excel!');

# Write some numbers.
$worksheet->write(2, 0, 3);         # writes 3
$worksheet->write(3, 0, 3.00000);   # writes 3
$worksheet->write(4, 0, 3.00001);   # writes 3.00001
$worksheet->write(5, 0, 3.14159);   # An approximation

# write some formulas
$worksheet->write(7, 0, '=A3 + A6');
$worksheet->write(8, 0, '=IF(A5>3, "Yes", "No")');

# write a hyperlink
$worksheet->write(10, 0, '"http://www.perl.com/"');
