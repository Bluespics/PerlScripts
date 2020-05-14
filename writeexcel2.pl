
use warnings;
use strict;
use Spreadsheet::WriteExcel;

# Create a new excel file
my $filename = "report.xlsx";
my $workbook = Excel::Writer::XLSX->new($filename);

# Add a worksheet
my $worksheet1 = $workbook->add_worksheet('PERL');

# Define the format and add it to the $worksheet
my $format = $workbook->add_format(
center_across => 1,
bold => 1,
size => 10,
border => 4,
color => 'black',
bg_color => 'cyan',
border_color => 'black',
align => 'vcenter',
);

# Change width for only first column
$worksheet1->set_column(0,0,20);

# write a formatted and unformatted string, row and set_column
# notation
$worksheet1->write(0,0, "PERL FLAVOURS", $format);
$worksheet1->write(1,0, "Active State PERL");
$worksheet1->write(2,0, "Strawberry PERL");
$worksheet1->write(3,0, "Vennila PERL");

print("Worksheet complete!");
