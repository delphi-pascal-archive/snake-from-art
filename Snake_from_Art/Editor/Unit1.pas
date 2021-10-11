unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, ComCtrls, ToolWin, XPMan;

type
  TForm1 = class(TForm)
    Map: TImage;
    Wall: TImage;
    Empty: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    XPManifest1: TXPManifest;
    procedure MapMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
   procedure SaveMap;
    procedure SpeedButton1Click(Sender: TObject);
    procedure LoadMap;
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  SnakeMap:array [0..19,0..19] of byte;
implementation

{$R *.dfm}

procedure TForm1.SaveMap;
var
x,y:integer;
begin
AssignFile(output,'OutMap.dat');
Rewrite(output);
for y:=0 to 19 do begin
 for x:=0 to 19 do begin
  Writeln(SnakeMap[x,y]);
 end;
end;
CloseFile(output);
end;

procedure TForm1.LoadMap;
var
x,y:integer;
begin
 AssignFile(input,'InMap.dat');
 Reset(input);
 for y:=0 to 19 do begin
  for x:=0 to 19 do begin
   Readln(SnakeMap[x,y]);
   if SnakeMap[x,y]=1 then begin Map.Canvas.Draw(x*15,y*15,Wall.Picture.Graphic);
   end;
  end;
 end;
 CloseFile(input);
end;

procedure TForm1.MapMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
x:=(x div 15)*15;
y:=(y div 15)*15;
if Shift=[ssLeft] then begin
 Map.Canvas.Draw(x,y,Wall.Picture.Graphic);
 SnakeMap[x div 15,y div 15]:=1;
end else
if Shift=[ssRight] then begin
 Map.Canvas.Draw(x,y,Empty.Picture.Graphic);
 SnakeMap[x div 15,y div 15]:=0;
end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
SaveMap;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
LoadMap;
end;

end.
