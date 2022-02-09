{Andrew Danson Shuffle Puck Ver. 1 1996}
{ Modified in 2012 for sanity!
 - redid indentation
 - Added more comments
 - reworked timer
}
program shuffle;

uses crt,graph,dos;
label 1,2,3,4; 
var	       
   redone				  : boolean; {does the score need to be redrawn}
   won					  : boolean; {has the player won?}
   key					  : char;    {current key press}
   keynum,ballspeed,sidespd		  : integer;
   {the ordinal version of the keypress and the ball vertical speed and horizontal speed}
   ballx,bally				  : integer; {the location of the ball}
   yourpaddlesize,comppaddlesize	  : integer; {the size of the paddles for player and computer}
   ypx,cpx				  : integer; {The location of the player paddle and computer paddle}
   name,lives,ives			  : string;
   {your name and strings for drawing the lives each player has}
   ylives				  : integer; {The players lives}
   clives				  : integer; {The computers lives}
   compspeed,maxx,ballvertdir,ballhoridir : integer;
   {The speed of the computer player, the maximum X, and direction values for the ball}
   cycles				  : integer; {cycles to wait for}
   count				  : integer; {counter for delay loop}


{ Gets the time in the same way that gwbasic timer function works }
function timer:single;
var result			: single;
   Hour, Minute, Second, Sec100	: word;
begin	   
   result:=0;
   GetTime(Hour, Minute, Second, Sec100);
   minute:=minute + (hour*60);
   second:=second + (minute*60);
   result:=second + (sec100 / 100);
   timer:=result;
end;

{initialises the game asking the player who they are and setting up everything}
procedure init;
var
   gd,gm : integer;
   nextt : single;
   c	 : single;
begin
   lowvideo;
   ballspeed:=4;
   nextt:=0;
   textcolor(lightblue);
   textbackground(blue);
   window (1,1,25,5);
   clrscr;
   writeln('	Shuffle Puck ver 1');
   writeln('by Andrew Danson 1996');
   write('what is your name ');
   readln(name);
   yourpaddlesize:=45;
   comppaddlesize:=40;
   ballx:=random(190)+10;
   bally:=random(90)+90;
   compspeed:=2;
   gd:=detect;
   gm:=9;
   initgraph(gd,gm,'');
   maxx:=getmaxx;
   ballspeed:=random(3)+1;
   if ballvertdir=1 then ballvertdir:=2 else ballvertdir:=1;
   ballhoridir:=random(3);
   sidespd:=random(2)+1;
   {work out how many delay(1) calls make up 1/100th of a second}
   c:=0;
   nextt:= timer + 1;
   while timer<nextt do
   begin
      delay(1);
      inc(c);
   end;
   c := c / 200;
   cycles := round(c);
end;

{draws the ball on screen}
procedure showball(x,y:integer);
begin
   setcolor(lightred);
   circle(x,y,3);
end;

{removes the ball from the screen}
procedure hideball(x,y:integer);
begin
   setcolor(black);
   circle(x,y,3);
end;

{draws your paddles on screen}
procedure showyourpaddle(x,size:integer);
begin
   setcolor(lightblue);
   rectangle(x,getmaxy-10,x+size,getmaxy-5);
end;

{hides your paddles on the screen}
procedure hideyourpaddle(x,size:integer);
begin
   setcolor(black);
   rectangle(x,getmaxy-10,x+size,getmaxy-5);
end;

{draws the computers paddle on screen}
procedure showcomppaddle;
begin
   setcolor(lightgreen);
   rectangle(cpx+10,5,cpx+comppaddlesize,10);
end;

{hides the computers paddle}
procedure hidecomppaddle;
begin
   setcolor(black);
   rectangle(cpx+10,5,cpx+comppaddlesize,10);
end;

{called when there is a bounce in the vertical direction}
procedure bunce;
begin
   sound(200);
   delay(2);
   nosound;
   ballspeed:=random(3)+1;
   if ballvertdir=1 then ballvertdir:=2 else ballvertdir:=1;
   ballhoridir:=random(3);
   sidespd:=random(2)+1;
end;

{checks the ball to see if it has gone of the top or bottom edge, or if it has hit a paddle
  I'm not sure what the local variable was for, looks like it is not needed.}
procedure checkball(budd:integer);
begin
   if bally<6 then
   begin
      sound(900);
      delay(50);
      nosound;
      clives:=clives-1;
      ballx:=random(190)+10;
      bally:=random(90)+90;
      redone:=true;
   end;
   if bally>getmaxy-5 then
   begin
      sound(500);
      delay(50);
      nosound;
      ylives:=ylives-1;
      ballx:=random(190)+10;
      bally:=random(90)+90;
      redone:=true;
    end;
   if bally>getmaxy-20 then if bally<getmaxy-5 then if ypx<ballx+5 then if ypx+yourpaddlesize>ballx-5 then
   begin
      bunce;
      bally:=bally-7
   end;
   if bally>6 then if bally<16 then if cpx<ballx then if cpx+comppaddlesize>ballx then
   begin
      bunce;
      bally:=bally+7
   end;
   
end;

{moves the ball and deals with bouncing of the vertical walls}
procedure ballmove;
begin
   hideball(ballx,bally);
   if ballvertdir=1 then bally:=bally-ballspeed else bally:=bally+ballspeed;
   if ballhoridir=1 then ballx:=ballx-sidespd else ballx:=ballx+sidespd;
   if ballx<10 then
   begin
      ballhoridir:=2;
      sound(100);
      delay(2);
      nosound;
   end;
   if ballx>200 then
   begin
      ballhoridir:=1;
      sound(100);
      delay(2);
      nosound;
   end;
   checkball(ballvertdir);
   showball(ballx,bally);
end;

{moves the computers paddle in a very simple way}
procedure computermove;
begin
   hidecomppaddle;
   if ballx<cpx+5 then cpx:=cpx-random(compspeed+2)-2-random(2);
   if ballx>cpx+comppaddlesize-5 then cpx:=cpx+random(compspeed-2)+2+random(2);
   showcomppaddle;
end;

{allows the player to move if they pressed a key}
procedure move;
begin
   key:=readkey;
   keynum:=ord(key);
   if keynum=75 then hideyourpaddle(ypx,yourpaddlesize);
   if keynum=77 then hideyourpaddle(ypx,yourpaddlesize);
   if upcase(key)='Q' then won:=true;
   if keynum=75 then ypx:=ypx-(yourpaddlesize-10);
   if keynum=77 then ypx:=ypx+(yourpaddlesize-10);
   if ypx<10 then ypx:=10;
   if ypx+yourpaddlesize>205 then ypx:=205-yourpaddlesize;
   showyourpaddle(ypx,yourpaddlesize);
end;

{main program}
begin;
   randomize;
   init;
2: clearviewport;
   if sidespd=0 then sidespd:=1;
   won:=false;
   clives:=4;
   setcolor(blue);
   ylives:=4;
   rectangle(2,0,210,getmaxy);
   settextstyle(triplexfont,horizdir,3);
   cpx:=ballx-1;
   outtextxy(220,3,name+' V`s The Computer');
   outtextxy(220,100,'Press Q to quit');
   ballx:=random(190)+10;
   bally:=random(90)+60;
   while not keypressed do
   begin
      computermove;
      showyourpaddle(ypx,yourpaddlesize);
   end;
1: 
   if keypressed then move;
   if ballspeed=0 then ballspeed:=1;
   {delay(3); replaced this delay with a better timer loop}
   for count:=0 to cycles do delay(1);
   if redone then
   begin
      redone:=false;
      setcolor(black);
      outtextxy(220,30,lives);
      outtextxy(220,55,ives);
   end;
   str(clives,lives);
   str(ylives,ives);
   setcolor(green);
   outtextxy(220,30,lives);
   setcolor(blue);
   outtextxy(220,55,ives);
   ballmove;
   computermove;
   if clives<=0 then won:=true;
   if ylives<=0 then won:=true;
   if not won then goto 1;
   while keypressed do
   begin
      key:=readkey;
   end;
   setcolor(red);
   if clives>ylives then
   begin
      outtextxy(200,200,'Ha Ha You Lost!');
   end
   else
   begin
      outtextxy(200,200,'Oh No You Won!');
   end;
   while not keypressed do
   begin
   end;
   outtextxy(200,220,'Do you wish to play again?');
3: 
   key:=readkey;
   if upcase(key)='N' then goto 4;
   if upcase(key)='Y' then goto 2;
   goto 3;
4: 
   closegraph;
   normvideo;
end.
