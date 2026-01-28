unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, registry, WinSkinData, Buttons;

type
  TForm5_About = class(TForm)
    Panel_Lateral: TPanel;
    IMG_LOGO: TImage;
    IMG_TOPO: TImage;
    Linha: TBevel;
    MemoSIGIL: TMemo;
    SkinData_Buttons: TSkinData;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure MemoSIGILEnter(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5_About: TForm5_About;

implementation

uses Unit1, Language;

{$R *.dfm}

procedure TForm5_About.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form5_About.Release;
Form5_About:=Nil;
end;

procedure TForm5_About.FormActivate(Sender: TObject);
begin
Form5_About.Caption:=UpperCase(Lang_DGL(20)+' '+Application.Title);
MemoSIGIL.Text:=Lang_DGL(24);
end;

procedure TForm5_About.FormKeyPress(Sender: TObject; var Key: Char);
begin
//-----------------
if (key = #27) then
Close;
//-----------------
end;

procedure TForm5_About.MemoSIGILEnter(Sender: TObject);
begin
ActiveControl:=Nil;
end;

procedure TForm5_About.SpeedButton1Click(Sender: TObject);
begin
Close;
end;

end.
