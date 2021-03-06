{ Huffman decoder: decompression unit that decodes files generated by the
huffenc unit.
   A Danson 2015}

unit huffdec;

interface

uses buffer;

const
   bits	: array[0..7] of byte = ( $80, $40, $20, $10, $08, $04, $02, $01 );

type
   treeNode = record
		 leftChild,rightChild : integer;
		 character	      : word;
	      end;		      
   tree	    = array[0..512] of treeNode;
   treeptr  = ^tree;
   decoder  = object
              hufftree : treeptr;
              hufftail : word;
              remaining: word; {the bytes to decode remaining in this block} 
              input    : reader;
              inbyte   : byte;
              bit      : byte;
              constructor open(infile:string);
              function readChar: char;
              function readLine:string;
              function eof:boolean;
              destructor close;
              end;

	      
implementation

type
   readerptr = ^reader;

function readWord(inp : readerPtr): word;
var
   ch1,ch2 : word;
begin
   ch1 := ord(inp^.readChar);
   ch2 := ord(inp^.readChar);
   readWord := (ch1 shl 8) or ch2;
end;

function readTree(hft : treeptr; var t:  word;  inp: readerptr):integer;
var
   index : word;
begin
   if inp^.eof then exit;
   hft^[t].character := readWord(inp);
   index:= t;
   inc(t);
   if (hft^[index].character and $F000) = $F000 then
   begin
      hft^[index].leftChild := readTree(hft,t,inp);
      hft^[index].rightChild := readTree(hft,t,inp);
   end;
   readTree := index;
end;
	      
constructor decoder.open(infile:string);
var
   sig : string[4];
   i   : word;
begin
   input.open(infile);
   {Check the input has the HUFF signature.}
   sig := '';
   for i:=1 to 4 do
      sig := sig + input.readchar;
   if not(sig = 'HUFF') then
      begin
	 writeln('Not a Huffman coded file');
	 halt(1);
      end;
   new(hufftree);
   hufftail := 0;
   remaining := readTree(hufftree, hufftail, addr(input));
   remaining := readWord(addr(input));
   inbyte := ord(input.readChar);
   bit := 0;
end;

function decoder.readChar: char;
var
   found : boolean;
   inbit : boolean; 
   index : word;
begin
   index:=0; {root of the huff tree}
   found := false;
   while not(found) do
   begin
      {read the new bit}
      if bit=8 then
      begin
	 inbyte := ord(input.readChar);
	 bit := 0;
      end;
      inbit := false;
      if (inbyte and bits[bit]) > 0 then inbit:= true;
      inc(bit);
      {move down the tree and see if we have hit a leaf}
      if inbit then
	 index := huffTree^[index].rightChild
      else
	 index := huffTree^[index].leftChild;
      if (huffTree^[index].character and $F000) = $0000 then found := true;
   end;
   {found the character!}
   {check if we've reached the end of the block!}
   {then read the new tree if we are at the end.}
   readChar := chr(huffTree^[index].character and $FF);
   if remaining>0 then dec(remaining);
   if ((remaining=0) and not(input.eof)) then
   begin
      hufftail := 0;
      remaining := readTree(hufftree, hufftail, addr(input));
      remaining := readWord(addr(input));
      inbyte := ord(input.readChar);
      bit := 0;
   end;
end;

function decoder.readLine:string;
var
   result : string;
   i	  : char;
begin
   i := self.readChar;
   if ((i = chr(10)) or (i=chr(13))) then i := self.readChar;
   result := '';
   
   while not( (i=chr(10)) or (i=chr(13)) or self.eof) do
   begin
      result := result + i;
      i:= self.readChar;
   end;
   readline := result;
end;

function decoder.eof:boolean;
begin
   eof := false;
   if ((remaining = 0) and (input.eof)) then eof := true;
end;

destructor decoder.close;
begin
   input.close;
   dispose(hufftree);
end;

end.
