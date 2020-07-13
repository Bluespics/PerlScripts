
use strict;
use warnings;
use Tk;
use Tk::JPEG;

my $message;
my $playerno;
my $player1;
my $player2;
my $player_piece;
my $current_player = 0;
my $winner = 0;
my $but1;
my $but2;
my $but3;
my $but4;
my $but5;
my $but6;
my $but7;
my $but8;
my $but9;
my $b1 = 0;
my $b2 = 0;
my $b3 = 0;
my $b4 = 0;
my $b5 = 0;
my $b6 = 0;
my $b7 = 0;
my $b8 = 0;
my $b9 = 0;
my $gono = 0;

my $mw = new MainWindow;   # Main MainWindow
$mw -> title("Noughts and Crosses");

my $ent_frm = $mw -> Frame();
my $mess_frm = $mw -> Frame();
my $init_frm = $mw -> Frame();
my $but_frm = $mw -> Frame();

my $lab1 = $ent_frm -> Label(-text => "Player 1   ( X ) : ") -> grid(
    my $ent1 = $ent_frm -> Entry());

my $lab2 = $ent_frm -> Label(-text => "Player 2:  ( O ) : ") -> grid(
    my $ent2 = $ent_frm -> Entry());

my $startbut = $init_frm -> Button(-text => "Start Game", -command => \&start_game) -> grid(
    my $clearbut = $init_frm -> Button(-text => "Clear", -command => \&clear_board));

my $lab3 = $mess_frm -> Label(-text => $message,
                            -foreground => 'blue',
                            -font => ['ariel', '18', 'bold']) -> grid();

$but1 = $but_frm->Button(-text => '   ',
                        -relief => 'solid',
                        -borderwidth => 10,
                        -foreground => 'red',
                        -font => ['ariel', '48', 'bold'],
                        -command => \&pick_but1)->grid(

    $but2 = $but_frm->Button(-text => '   ',
                            -relief => 'solid',
                            -borderwidth => 10,
                            -foreground => 'red',
                            -font => ['ariel', '48', 'bold'],
                            -command => \&pick_but2),

    $but3 = $but_frm->Button(-text => '   ',
                            -relief => 'solid',
                            -borderwidth => 10,
                            -foreground => 'red',
                            -font => ['ariel', '48', 'bold'],
                            -command => \&pick_but3),
                            -sticky => 'nsew');

$but4 = $but_frm->Button(-text => '   ',
                        -relief => 'solid',
                        -borderwidth => 10,
                        -foreground => 'red',
                        -font => ['ariel', '48', 'bold'],
                        -command => \&pick_but4)->grid(

    $but5 = $but_frm->Button(-text => '   ',
                            -relief => 'solid',
                            -borderwidth => 10,
                            -foreground => 'red',
                            -font => ['ariel', '48', 'bold'],
                            -command => \&pick_but5),

    $but6 = $but_frm->Button(-text => '   ',
                            -relief => 'solid',
                            -borderwidth => 10,
                            -foreground => 'red',
                            -font => ['ariel', '48', 'bold'],
                            -command => \&pick_but6),
                            -sticky => 'nsew');

$but7 = $but_frm->Button(-text => '   ',
                        -relief => 'solid',
                        -borderwidth => 10,
                        -foreground => 'red',
                        -font => ['ariel', '48', 'bold'],
                        -command => \&pick_but7)->grid(

    $but8 = $but_frm->Button(-text => '   ',
                            -relief => 'solid',
                            -borderwidth => 10,
                            -foreground => 'red',
                            -font => ['ariel', '48', 'bold'],
                            -command => \&pick_but8),

    $but9 = $but_frm->Button(-text => '   ',
                            -relief => 'solid',
                            -borderwidth => 10,
                            -foreground => 'red',
                            -font => ['ariel', '48', 'bold'],
                            -command => \&pick_but9),
                            -sticky => 'nsew');


#Geometry Management
$ent_frm -> grid(-row => 1, -column => 1,
                -ipadx => 10, -ipady => 10, -sticky => 'w');
$init_frm -> grid(-row => 3, -column => 1,
                -ipadx => 10, -ipady => 10);
$mess_frm -> grid(-row => 4, -column => 1,
                -ipadx => 10, -ipady => 10);
$but_frm -> grid(-row => 5, -column => 1,
                -ipadx => 30, -ipady => 30);

MainLoop;

sub start_game{
    $playerno = 1 + int rand(2);
    $player1 = $ent1 -> get();
    $player2 = $ent2 -> get();
    if($player1 eq ''){
        $player1 = "Player 1";
    }
    if($player2 eq ''){
        $player2 = "Player 2";
    }
    &game_message;
}

sub game_message{
    my $current_player = $playerno;
    if($current_player == 1){
        $message = "$player1 to go";
        $player_piece = "X";
    }else{
        $message = "$player2 to go";
        $player_piece = "O"
    }
    $lab3 -> configure(-text => $message);
}

sub pick_but1{
    $but1 -> configure(-text => $player_piece);
    $b1 = $playerno;
    &check_complete;
}

sub pick_but2{
    $but2 -> configure(-text => $player_piece);
    $b2 = $playerno;
    &check_complete;
}

sub pick_but3{
    $but3 -> configure(-text => $player_piece);
    $b3 = $playerno;
    &check_complete;
}

sub pick_but4{
    $but4 -> configure(-text => $player_piece);
    $b4 = $playerno;
    &check_complete;
}

sub pick_but5{
    $but5 -> configure(-text => $player_piece);
    $b5 = $playerno;
    &check_complete;
}

sub pick_but6{
    $but6 -> configure(-text => $player_piece);
    $b6 = $playerno;
    &check_complete;
}

sub pick_but7{
    $but7 -> configure(-text => $player_piece);
    $b7 = $playerno;
    &check_complete;
}

sub pick_but8{
    $but8 -> configure(-text => $player_piece);
    $b8 = $playerno;
    &check_complete;
}

sub pick_but9{
    $but9 -> configure(-text => $player_piece);
    $b9 = $playerno;
    &check_complete;
}

sub check_complete{
    if($b1 > 0 and $b1 == $b2 and $b1 == $b3){
        $winner = $b1;
    }elsif($b4 > 0 and $b4 == $b5 and $b4 == $b6){
        $winner = $b4;
    }elsif($b7 > 0 and $b7 == $b8 and $b7 == $b9){
        $winner = $b7;
    }elsif($b1 > 0 and $b1 == $b4 and $b1 == $b7){
        $winner = $b1;
    }elsif($b2 > 0 and $b2 == $b5 and $b2 == $b8){
        $winner = $b2;
    }elsif($b3 > 0 and $b3 == $b6 and $b3 == $b9){
        $winner = $b3;
    }elsif($b1 > 0 and $b1 == $b5 and $b1 == $b9){
        $winner = $b1;
    }elsif($b3 > 0 and $b3 == $b5 and $b3 == $b7){
        $winner = $b3;
    }else{
        &switch_player;
    }

    if($winner > 0){
        &end_game;
    }else{
        &game_message;
    }

    $gono += 1;
    if($gono == 9){
        $message = "The game is a draw";
        $lab3 -> configure(-text => $message);
    }
}

sub switch_player{
    if($playerno == 1){
        $playerno = 2;
    }else{
        $playerno = 1;
    }
}

sub end_game{
    if($playerno == 1){
        $message = "$player1 has WON !";
    }else{
        $message = "$player2 has WON !";
    }
    $lab3 -> configure(-text => $message);

}

sub clear_board{

}
