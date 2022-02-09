program graphic;


uses crt,graph;
var gd,gm:integer;
    x,y,zx,zy,ap,z:integer;
    size:word;
    p:pointer;
    sized:word;
    m:pointer;
    sizee:word;
    a:pointer;
    sizef:word;
    b:pointer;

procedure init;
begin
randomize;
gd:=detect;
initgraph(gd,gm,'');
x:=30;
y:=40;
setcolor(lightred);
circle(x,y,5);
line(x-5,y,x-10,y-5);
line(x+5,y,x+10,y-5);
size:=imagesize(x-11,y-6,x+11,y+6);
getmem(p,size);
getimage(x-11,y-6,x+11,y+6,p^);
clearviewport;
circle(x,y,5);
line(x-5,y,x-10,y+5);
line(x+5,y,x+10,y+5);
sized:=imagesize(x-11,y-6,x+11,y+6);
getmem(m,size);
getimage(x-11,y-6,x+11,y+6,m^);
clearviewport;
setcolor(green);
line(x,y,x+5,y);
line(x,y,x,y+2);
line(x+5,y,x+7,y+8);
line(x+7,y+8,x+10,y+10);
line(x+10,y+10,x+2,y+10);
line(x+2,y+10,x+2,y+2);
line(x+2,y+2,x,y+2);
sizee:=imagesize(x,y,x+11,y+11);
getmem(a,sizee);
getimage(x,y,x+11,y+11,a^);
clearviewport;
line(x,y,x+5,y);
line(x+5,y,x+5,y+8);
line(x+5,y+8,x+8,y+10);
line(x+8,y+10,x,y+10);
line(x,y+10,x+2,y+2);
line(x+2,y+2,x,y+2);
line(x,y+2,x,y);
sizef:=imagesize(x,y,x+11,y+11);
getmem(b,sizef);
getimage(x,y,x+11,y+11,b^);
clearviewport;
end;

procedure show;
begin
if z=0 then
   begin
   putimage(zx,zy,a^,xorput);
   end
   else
   begin
   putimage(zx,zy,b^,xorput);
   end;
if ap=0 then
   begin
   putimage(x,y,p^,xorput);
   end
   else
   begin
   putimage(x,y,m^,xorput);
   end;
end;

begin
init;
z:=0;
ap:=0;
x:=random(getmaxx);
y:=random(getmaxy);
zx:=random(getmaxx);
zy:=random(getmaxy);
show;
while not keypressed do
      begin
      delay(290);
      show;
      z:=z+1;
      ap:=ap+1;
      if z=2 then z:=0;
      if ap=2 then ap:=0;
      zx:=zx-2;
      if zx<3 then zx:=getmaxx-15;
      x:=x+2;
      if x>getmaxx-20 then x:=1;
      y:=y+2;
      if y>getmaxy-20 then y:=1;
      show;
      end;
freemem(p,size);
freemem(m,sized);
freemem(a,sizee);
freemem(b,sizef);
closegraph;
end.