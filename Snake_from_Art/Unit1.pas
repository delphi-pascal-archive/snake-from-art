unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, Menus, ComCtrls, XPMan;

type
 TSegment=class(TImage)
  public
  Direction:byte;
 end;

 TSegments=array of TSegment;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Area: TImage;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    Wall: TImage;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    LenPlus: TImage;
    StatusBar1: TStatusBar;
    XPManifest1: TXPManifest;
    N8: TMenuItem;
    function  CreateSegment(Pos:TPoint; Dir:byte):TSegment;
    procedure Init;
    procedure AddSegments(Quantity:integer);
    procedure FormCreate(Sender: TObject);
    procedure MoveSegments(var Segments:TSegments);
    procedure ChangeDirection(var Segments:TSegments; Key:Word);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LoadMap(FileName:string);
    function Collision(Segment:TSegment):integer;
    procedure FindMaps;
    procedure ItemClick(Sender:TObject);
    procedure NewGame(FileName:string);
    procedure N4Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure RandomAddSeg;
    procedure N8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Snake: TSegments;
  Map:array [0..19,0..19] of byte;
  Maps:array of string;
  olddir,newdir:byte;
implementation

{$R *.dfm}
{$R Data.res}

procedure TForm1.NewGame(FileName:string);
var
flag:boolean;
i:integer;
begin
Timer1.Interval:=500;
Timer1.Enabled:=false;
StatusBar1.Panels[1].Text:='Скорость: 0.1';
Area.Canvas.FillRect(Area.Canvas.ClipRect);
SetLength(Snake,0);
 OldDir:=1;
 NewDir:=1;
LenPlus.Picture.Bitmap.LoadFromResourceName(Hinstance,'PLUS');
Wall.Picture.Bitmap.LoadFromResourceName(Hinstance,'WALL');

repeat
flag:=true;
 for i:=0 to ComponentCount-1 do begin
  if (Components[i] is TImage) and (TImage(Components[i]).Name<>'Area') and (TImage(Components[i]).Name<>'Wall') and (TImage(Components[i]).Name<>'LenPlus') then begin
   TImage(Components[i]).Free;
   flag:=false;
   break;
  end;
 end;
until flag=true;
LoadMap(FileName);
AddSegments(3);
application.ProcessMessages;
RandomAddSeg;
Timer1.Enabled:=true;
end;

procedure TForm1.FindMaps;
var
DirInfo: TSearchRec;
Item:TMenuItem;
r : Integer;
begin
SetLength(Maps,0);
r := FindFirst(ExtractFilePath(ParamStr(0))+'Maps\*.dat', FaAnyfile, DirInfo);
while r = 0 do begin
if ((DirInfo.Attr and FaDirectory<>FaDirectory) and (DirInfo.Attr and FaVolumeId<>FaVolumeID)) then
 SetLength(Maps,Length(Maps)+1);
 Maps[High(Maps)]:=DirInfo.Name;

  item:=TMenuItem.Create(MainMenu1);
  item.Caption:=DirInfo.Name;
  item.OnClick:=ItemClick;
  MainMenu1.Items[0].Items[0].Add(item);

 r := FindNext(DirInfo);
end;
SysUtils.FindClose(DirInfo);
end;

procedure TForm1.ItemClick(Sender:TObject);
begin
NewGame('Maps\'+Maps[(Sender as TMenuItem).MenuIndex]);
end;

function TForm1.Collision(Segment:TSegment):integer;
var
i:integer;
begin
for i:=0 to ComponentCount-1 do begin
 if (Components[i] is TImage)                                      and
    (TImage(Components[i]).Tag=1)                                  and
    (TImage(Components[i]).ComponentIndex<>Segment.ComponentIndex) and
    (TImage(Components[i]).Left=Segment.Left)                      and
    (TImage(Components[i]).Top=Segment.Top)                        then begin
   Result:=1;
   exit;
 end;
end;
 Result:=Map[Segment.Left div 15,Segment.Top div 15];
end;

procedure TForm1.LoadMap(FileName:string);
var
x,y:integer;
begin
 AssignFile(input,FileName);
 Reset(input);
 for y:=0 to 19 do begin
  for x:=0 to 19 do begin
   Readln(Map[x,y]);
   if Map[x,y]=1 then begin Area.Canvas.Draw(x*15,y*15,Wall.Picture.Graphic);
   end;
  end;
 end;
 CloseFile(input);
end;

procedure TForm1.Init;
begin
Form1.DoubleBuffered:=true;
FindMaps;
end;

procedure TForm1.AddSegments(Quantity:integer);
var
i:integer;
Pos:TPoint;
begin
For i:=1 to Quantity do begin
 SetLength(Snake,Length(Snake)+1);
 if Length(Snake)=1 then begin
  Snake[High(Snake)]:=CreateSegment(Point(150,150),1);
 end else begin
  Pos:=Point(Snake[High(Snake)-1].left,Snake[High(Snake)-1].Top);
  case Snake[High(Snake)-1].Direction of
   1:  Snake[High(Snake)]:= CreateSegment(Point(Pos.X+15,Pos.Y),Snake[High(Snake)-1].Direction);
   2:  Snake[High(Snake)]:= CreateSegment(Point(Pos.X,Pos.Y+15),Snake[High(Snake)-1].Direction);
   3:  Snake[High(Snake)]:= CreateSegment(Point(Pos.X-15,Pos.Y),Snake[High(Snake)-1].Direction);
   4:  Snake[High(Snake)]:= CreateSegment(Point(Pos.X,Pos.Y-15),Snake[High(Snake)-1].Direction);
  end;
 end;
end;
StatusBar1.Panels[0].Text:='Длина: '+inttostr(Length(Snake));
end;

procedure TForm1.MoveSegments(var Segments:TSegments);
var
key:word;
i:integer;
begin
for i:=High(Segments) downto 1 do Segments[i].Direction:=Segments[i-1].Direction;
 for i:=0 to High(Segments) do begin
  case Segments[i].Direction of
   1: Segments[i].Left:=Segments[i].Left-15;
   2: Segments[i].Top:=Segments[i].Top-15;
   3: Segments[i].Left:=Segments[i].Left+15;
   4: Segments[i].Top:=Segments[i].Top+15;
  end;
 end;
 if OldDir<>NewDir then begin
 case NewDir of
  1: key:=vk_Left;
  2: key:=vk_up;
  3: key:=vk_right;
  4: key:=vk_down;
 end;
 changedirection(Segments,key);
end;
olddir:=Segments[0].Direction;
if Collision(Segments[0])=1 then begin
 Timer1.Enabled:=false;
 showmessage('Вы проиграли.');
 Randomize;
 NewGame('Maps\'+Maps[Random(Length(Maps))]);
end else
if Collision(Segments[0])=2 then begin
 AddSegments(1);
 RandomAddSeg;
 Timer1.Interval:=Timer1.Interval-10;
 if Timer1.Interval=0 then Timer1.Interval:=10;
 StatusBar1.Panels[1].Text:='Скорость: '+floattostr(10-Timer1.interval/50);
end;
end;

function TForm1.CreateSegment(Pos:TPoint; Dir:byte):TSegment;
var
 Segment:TSegment;
begin
 Segment:=TSegment.Create(Self);
 with Segment do begin
  Autosize:=true;
  Transparent:=true;
  Left:=Pos.X;
  Top:=Pos.Y;
  Direction:=Dir;
  Tag:=1;
  Picture.Bitmap.LoadFromResourceName(Hinstance,'Segment');
  Parent:=Form1;
 end;
Result:=Segment;
end;

procedure TForm1.RandomAddSeg;
var
flag:boolean;
x,y:integer;
begin
Randomize;
for y:=0 to 19 do begin
 for x:=0 to 19 do begin
  if Map[x,y]=2 then begin
   Map[x,y]:=0;
   Area.Canvas.FillRect(Rect(x*15,y*15,x*15+15,y*15+15));
  end;
 end;
end;
 application.ProcessMessages;
repeat
 x:=random(19);
 y:=random(19);
 if Map[x,y]=0 then begin
 Area.Canvas.Draw(x*15,y*15,LenPlus.Picture.Graphic);
  Map[x,y]:=2;
  flag:=true;
 end else flag:=false;
until flag=true;
end;

procedure TForm1.ChangeDirection(var Segments:TSegments; Key:Word);
begin
with Segments[0] do begin
if (Key=vk_Left) and (direction=2) then begin
 Left:=Left-15;
 Top:=Top+15;
 Direction:=1;
end else
if (Key=vk_Left) and (direction=4) then begin
 Left:=Left-15;
 Top:=Top-15;
 Direction:=1;
end else
if (Key=vk_Right) and (direction=2) then begin
 Left:=Left+15;
 Top:=Top+15;
 Direction:=3;
end else
if (Key=vk_Right) and (direction=4) then begin
 Left:=Left+15;
 Top:=Top-15;
 Direction:=3;
end else
if (Key=vk_Down) and (direction=1) then begin
 Left:=Left+15;
 Top:=Top+15;
 Direction:=4;
end else
if (Key=vk_Down) and (direction=3) then begin
 Left:=Left-15;
 Top:=Top+15;
 Direction:=4;
end else
if (Key=vk_up) and (direction=1) then begin
 Left:=Left+15;
 Top:=Top-15;
 Direction:=2;
end else
if (Key=vk_up) and (direction=3) then begin
 Left:=Left-15;
 Top:=Top-15;
 Direction:=2;
end;
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Init;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
MoveSegments(Snake);
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case key of
 vk_left:  newdir:=1;
 vk_right: newdir:=3;
 vk_up:    newdir:=2;
 vk_down:  newdir:=4;
end;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
Form1.Close;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
Showmessage('Автор программы:  Бышин Артем'+#13#10+
            'Версия программы: 1.0');
end;

procedure TForm1.N8Click(Sender: TObject);
begin
 NewGame('Maps\'+Maps[Random(Length(Maps))]);
end;

end.
