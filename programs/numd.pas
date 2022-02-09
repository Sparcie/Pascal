{Numdrop A.Danson 1997}
{ modified in 2012: A J Danson
  corrected indenting
  added comments
  changed to better timer (to be similar to gwbasic version)
  changed scoring and levels.
}

program Numd;

uses crt,dos;

var
   map			: array[1..11,1..20] of integer; {the game map.}
   currentx,currenty	: integer; { the current pieces location }
   currentp,i,c		: integer; { the current piece and some general purpose variables}
   key			: char;    { the last keypress }
   score,oldscore,level	: integer; { current score, what the score was last cycle, and the level }
   quit,en		: boolean; { quit : has the user quit the game en: is the current game over }
   gap			: single; { the gap in seconds between the movements. }
   nextm		: single; { The time the next movement should happen at }

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

{ Initialise everything }
procedure init;
begin
   oldscore:=0;
   quit:=false;
   en:=false;
   i:=0;
   c:=0;
   randomize;
   while i<21 do
   begin
      c:=c+1;
      if c=11 then
      begin
	 c:=1;
	 i:=i+1;
      end;
      map[c,i]:=0
   end;
   map[11,20]:=0;
   gap:=0.7;
   currentx:=5;
   currenty:=1;
   currentp:=random(15)+1;
   score:=0;
   level:=1;
   nextm:=0;
end;

{ displays a title author and date, waiting for a user keypress }
procedure intro;
begin
   textbackground(red);
   clrscr;
   window(20,10,60,15);
   textcolor(white);
   textbackground(blue);
   clrscr;
   gotoxy(15,1);
   writeln('Num Drop');
   writeln('A.Danson 1997');
   while not keypressed do
   begin
   end;
end;

{ called when the user presses the down key or when the piece needs to be moved down the screen}
procedure movedown;
var mp : integer;
begin  
   textcolor(black);
   gotoxy(currentx,currenty);
   write(chr(178));
   currenty:=currenty+1;
   mp:=map[currentx,currenty];
   if mp>0 then
   begin
      if mp<currentp then
      begin
	 map[currentx,currenty]:=currentp;
	 textcolor(currentp);
	 gotoxy(currentx,currenty);
	 write(chr(178));
	 score:=score+((currentp-mp) * level);
	 currenty:=1;
	 currentx:=5;
	 currentp:=random(15)+1;
	 sound(70);
	 delay(40);
	 nosound;
      end;
   end;
   if currenty=20 then
   begin
      map[currentx,currenty]:=currentp;
      textcolor(currentp);
      gotoxy(currentx,currenty);
      write(chr(178));
      currenty:=1;
      currentx:=5;
      currentp:=random(15)+1;
   end;
   mp:=map[currentx,currenty+1];
   if mp>currentp then
   begin
      if currenty=2 then en:=true;
      map[currentx,currenty]:=currentp;
      textcolor(currentp);
      gotoxy(currentx,currenty);
      write(chr(178));
      currenty:=1;
      currentx:=5;
      currentp:=random(15)+1;
   end;
   textcolor(currentp);
   gotoxy(currentx,currenty);
   write(chr(178));
end;

{ Move to bottom }
procedure moveToBottom;
begin
   while (currenty>1) do moveDown;
end;

{ displays the basics on screen for gameplay }
procedure initdisplay;
begin
   window(34,3,54,10);
   textcolor(blue);
   textbackground(brown);
   clrscr;
   writeln('Score ',score);
   writeln('Level ',level);
   writeln('Keys');
   writeln('j = left');
   writeln('l = right');
   writeln('space = drop');
   writeln('q = quit');
   window(1,1,6,16);
   textbackground(black);
   clrscr;
   i:=0;
   while i<15 do
   begin
      i:=i+1;
      textcolor(i);
      write(chr(178));
      write('=');
      writeln(i);
   end;
   textbackground(lightcyan);
   window(19,2,30,23);
   clrscr;
   textbackground(black);
   window(20,3,29,22);
   clrscr;
   window(20,3,30,22);
end;

{ moves the piece left, called when the user presses the left key }
procedure left;
begin
   textcolor(black);
   gotoxy(currentx,currenty);
   write(chr(178));
   if currentx>1 then
   begin
      if map[currentx-1,currenty]=0 then currentx:=currentx-1;
   end;
   textcolor(currentp);
   gotoxy(currentx,currenty);
   write(chr(178));
end;

{ moves the piece right, called when the user presses the right key }
procedure right;
begin
   textcolor(black);
   gotoxy(currentx,currenty);
   write(chr(178));
   if currentx<10 then
   begin
      if map[currentx+1,currenty]=0 then currentx:=currentx+1;
   end;
   textcolor(currentp);
   gotoxy(currentx,currenty);
   write(chr(178));
end;

{ Asks the user if they want to play again }
procedure newgameq;
begin
   window(30,10,44,13);
   textbackground(green);
   textcolor(red);
   clrscr;
   write('Do you wish to play again?');
   while not keypressed do
   begin
   end;
   key:=readkey;
   if key='y' then
   begin
      init;
      initdisplay;
   end;
   if key='n' then quit:=true;
end;

{ redsiplays the score panel. }
procedure rescore;
begin
   window(34,3,54,10);
   textcolor(blue);
   textbackground(brown);
   clrscr;
   writeln('Score ',score);
   writeln('Level ',level);
   writeln('Keys');
   writeln('j = left');
   writeln('l = right');
   writeln('space = drop');
   writeln('q = quit');
   window(20,3,30,22);
   textbackground(black);
end;

{main program}
begin
   init;
   intro;
   initdisplay;
   while not quit do
   begin
      while not en do
      begin
	 while timer<nextm do
	 begin
	    
	    if keypressed then
	    begin
	       key:=readkey;
	       if key='j' then left;
	       if key='l' then right;
	       if key='q' then en:=true;
	       if key=',' then movedown;
	       if key=' ' then moveToBottom;
	    end;
	    
	 end;
	 nextm := timer + gap;
	 if keypressed then
	 begin
	    key:=readkey;
	    if key='j' then left;
	    if key='l' then right;
	    if key='q' then en:=true;
	    if key=',' then movedown;
	    if key=' ' then moveToBottom;
	 end;
	 movedown;
	 if score>(level*level*100) then
	 begin
	    i:=0 ;
	    c:=0;
	    while i<20000 do
	    begin
	       i:=i+1;
	       sound(i);
	    end;
	    nosound;
	    score:=score+1;
	    level:=level+1;
	    gap:= gap * 0.8;
	 end;
	 if oldscore<score then
	 begin
	    oldscore:=score;
	    rescore;
	 end;
      end;
      newgameq;
   end;
   init;
   window(1,1,80,25);
   textbackground(black);
   textcolor(lightgray);
   clrscr
end.
