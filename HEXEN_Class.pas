unit HEXEN_Class;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GraphicEx, ExtCtrls, pngimage, StdCtrls;

type
  TForm8_HexenClass = class(TForm)
    Select: TImage;
    S01: TImage;
    S02: TImage;
    S03: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure S01Click(Sender: TObject);
    procedure S02Click(Sender: TObject);
    procedure S03Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8_HexenClass: TForm8_HexenClass;

implementation

uses Unit1, DLC, Language;

{$R *.dfm}

procedure TForm8_HexenClass.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Form8_HexenClass.Release;
Form8_HexenClass:=Nil;
end;

procedure TForm8_HexenClass.FormKeyPress(Sender: TObject; var Key: Char);
begin

  if (key = #27) then
  begin
  Close;
  Fecha_ESC:=True;
  end;
  
end;

procedure TForm8_HexenClass.S01Click(Sender: TObject);
begin
EPI_Global_DLC:=1;
Close;
end;

procedure TForm8_HexenClass.S02Click(Sender: TObject);
begin
EPI_Global_DLC:=2;
Close;
end;

procedure TForm8_HexenClass.S03Click(Sender: TObject);
begin
EPI_Global_DLC:=3;
Close;
end;

procedure TForm8_HexenClass.FormActivate(Sender: TObject);
begin

  {PT-BR}
  if Language_Global = 0 then
  begin
  Label1.Left:=10;
  Label2.Left:=12;
  Label3.Left:=41;
  Label4.Left:=44;

  Label5.Left:=154;
  Label6.Left:=156;
  Label7.Left:=184;
  Label8.Left:=184;

  Label9.Left :=297;
  Label10.Left:=298;
  Label11.Left:=327;
  Label12.Left:=327;
  end;

//----------------------------
Label1.Caption :=Lang_DGL(33);
Label2.Caption :=Lang_DGL(34);
Label3.Caption :=Lang_DGL(35);
Label4.Caption :=Lang_DGL(36);
//----------------------------
Label5.Caption :=Lang_DGL(33);
Label6.Caption :=Lang_DGL(34);
Label7.Caption :=Lang_DGL(35);
Label8.Caption :=Lang_DGL(36);
//----------------------------
Label9.Caption :=Lang_DGL(33);
Label10.Caption:=Lang_DGL(34);
Label11.Caption:=Lang_DGL(35);
Label12.Caption:=Lang_DGL(36);
//----------------------------
end;

end.
