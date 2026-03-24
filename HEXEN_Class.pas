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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8_HexenClass: TForm8_HexenClass;

implementation

uses Unit1, DLC;

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

end.
