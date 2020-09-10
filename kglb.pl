
use Tk;
use Math::Round;

# Show Celsius/Fahrenheit equivalence using scales.
$top = MainWindow->new(-title => 'Weight Converter');

#$kg_val = 0;
#compute_kg();
#---------------------- kg Scale -------------------------------
$top->Scale(-orient => 'horizontal',
            -from => 0,                             # From 0 pounds
            -to => 220,                             # To 220 pounds
            -tickinterval => 20,
            -label => 'Pounds',
            -font => '-adobe-helvetica-medium-r-normal'
                        . '--10-100-75-75-p-56-iso8859-1',
            -length => 300,                         # in pixels
            -variable => \$lb_val,                  # global variable
            -command => \&compute_kg                # Change kilos
            )->pack(-side => 'top',
                    -fill => 'x');

#---------------------- lb Scale ----------------------------
$top->Scale(-orient => 'horizontal',
            -from => 0,                            # From 0 kg
            -to => 100,                             # To 100 kg
            -tickinterval => 10,                    # tick every 10 kg
            -label => 'Kilos',
            -font => '-adobe-helvetica-medium-r-normal'
                        . '--10-100-75-75-p-56-iso8859-1',
            -length => 300,                         # In pixels
            -variable => \$kg_val,                  # global variable
            -command => \&compute_lb                # Change pounds
            )->pack(-side => 'top',
                    -fill => 'x',
                    -pady => '5');

$box_frm = $top->Frame()->pack(-side => 'bottom');
$box_frm->Label(-text => 'Kg',
                -font => '-adobe-helvetica-medium-r-normal'
                    . '--10-100-75-75-p-56-iso8859-1',)->pack(-side => 'left');
$ent1 = $box_frm->Entry(-textvariable => $kg_val)->pack(-side => 'left');
$box_frm->Label(-text => '   Stone',
                -font => '-adobe-helvetica-medium-r-normal'
                    . '--10-100-75-75-p-56-iso8859-1',)->pack(-side => 'left');
$ent2 = $box_frm->Entry(-textvariable => $st_val)->pack(-side => 'left');
$box_frm->Label(-text => 'lb',
                -font => '-adobe-helvetica-medium-r-normal'
                    . '--10-100-75-75-p-56-iso8859-1',)->pack(-side => 'left');
$ent3 = $box_frm->Entry(-textvariable => $lb_val)->pack(-side => 'left',
                                                        -pady => '10',
                                                        -padx => '10');


sub compute_lb {
    # The lb scale's slider automatically moves when this
    # $lb_val is changed
    $lb_val = round($kg_val * 2.205);
    $st_val = round($lb_val / 14);
    $rem_val = $lb_val % 14;
    $ent1 -> configure(-text => $kg_val);
    $ent2 -> configure(-text => $st_val);
    $ent3 -> configure(-text => $rem_val);
}

sub compute_kg {
    $kg_val = round($lb_val / 2.205);
    $st_val = round($lb_val / 14);
    $rem_val = $lb_val % 14;
    $ent1 -> configure(-text => $kg_val);
    $ent2 -> configure(-text => $st_val);
    $ent3 -> configure(-text => $rem_val);
}

MainLoop();
