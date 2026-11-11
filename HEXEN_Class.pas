unit HEXEN_Class;

interface

uses
  Forms, ExtCtrls, StdCtrls, Vcl.Imaging.pngimage, System.Classes, Vcl.Controls;

type
  TForm8_HexenClass = class(TForm)
    Select: TImage;
    S01: TImage;
    S02: TImage;
    S03: TImage;
    P_Speed: TLabel;
    P_Armor: TLabel;
    P_Magic: TLabel;
    P_Strength: TLabel;
    M_Speed: TLabel;
    M_Armor: TLabel;
    M_Magic: TLabel;
    M_Strength: TLabel;
    W_Strength: TLabel;
    W_Magic: TLabel;
    W_Armor: TLabel;
    W_Speed: TLabel;
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

uses Unit1, Language;

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
//--------------------------------
W_Speed.Caption    :=Lang_DGL(33);
W_Armor.Caption    :=Lang_DGL(34);
W_Magic.Caption    :=Lang_DGL(35);
W_Strength.Caption :=Lang_DGL(36);
//--------------------------------
P_Speed.Caption    :=Lang_DGL(33);
P_Armor.Caption    :=Lang_DGL(34);
P_Magic.Caption    :=Lang_DGL(35);
P_Strength.Caption :=Lang_DGL(36);
//--------------------------------
M_Speed.Caption    :=Lang_DGL(33);
M_Armor.Caption    :=Lang_DGL(34);
M_Magic.Caption    :=Lang_DGL(35);
M_Strength.Caption :=Lang_DGL(36);
//--------------------------------
end;

end.
