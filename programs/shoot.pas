{Andrew Danson Shoot Ver.1}
program shoot;
uses crt;
var
 yx,yy,ybx,yby,sc1:integer;
 cx,cy,cbx,cby,sc2:integer ;
 key:char;
 keynum,r,i:integer;
 name:string;
 en:boolean;
procedure bulletmove;
begin
 textcolor(blue);
 gotoxy(ybx,yby);
 write(' ');
 gotoxy(cbx,cby);
 write(' ');
 yby:=yby-1;
 cby:=cby+1;
 if yby=cy then
  if ybx=cx then sc1:=sc1+10;
 if cby=yy then
  if cbx=yx then sc2:=sc2+10;
 if yby=0 then
   begin
   yby:=yy-1;
   ybx:=yx;
   end;
 if cby=20 then
  begin
  cby:=cy;
  cbx:=cx;
  end;
 gotoxy(ybx,yby);
 write('|');
 textcolor(red);
 gotoxy(cbx,cby);
 write('|');
end;

procedure yourmove;
begin;
gotoxy(yx,yy);
write(' ');
keynum:=ord(key);
if keynum=72 then yy:=yy-1;
if keynum=80 then yy:=yy+1;
if keynum=75 then yx:=yx-1;
if keynum=77 then yx:=yx+1;
if yx=0 then yx:=1;
if yx=80 then yx:=79;
if yy=0 then yy:=1;
if yy=21 then yy:=20;
textcolor(lightblue);
gotoxy(yx,yy);
write('@');
end;

procedure computermove;
begin
r:=random(4);
gotoxy(cx,cy);
write(' ');
if r=1 then cx:=cx-1;
if r=2 then cx:=cx+1;
if r=3 then cy:=cy-1;
if r=4 then cy:=cy+1;
if cx=0 then cx:=1;
if cx=80 then cx:=79;
if cy=0 then cy:=1;
if cy=21 then cy:=20;
textcolor(lightred);
gotoxy(cx,cy);
write('@');
end;

procedure init;
begin
 i:=0;
 sc1:=0;
 sc2:=0;
 window(0,0,80,25);
 textbackground(blue);
 textcolor(lightblue);
 clrscr;
 writeln('Shoot Ver. 1 Andrew Danson 1996');
 write('What is your name?');
 read(name);
 textbackground(black);
 textcolor(black);
 clrscr;
 randomize;
 yx:=random(80);
 yy:=random(20);
 cx:=random(80);
 cy:=random(20);
 ybx:=yx;
 yby:=yy-1;
 cbx:=cx;
 cby:=cy;
 en:=false;
 bulletmove;
 computermove;
 yourmove;
end;

begin
init;
while not en do
 begin
 i:=i+1;
 if i=125 then bulletmove;
 if i=250 then
  begin
  computermove;
  i:=0;
  end;
 if keypressed then
  begin
  key:=readkey;
  if upcase(key)='Q' then en:=true;
  yourmove;
  end;
 textcolor(yellow);
 gotoxy(1,21);
 write(name,'`s score ');
 write(sc1);
 write(' computers score ');
 write(sc2);
 end;
textcolor(lightgray);
clrscr;
end.