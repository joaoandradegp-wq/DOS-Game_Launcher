unit Splash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, RXCtrls, Animate, GIFCtrl, ShellAPI,
  GraphicEx, jpeg;

type
  TForm5_Splash = class(TForm)
    Image1: TImage;
    rx_loading: TRxGIFAnimator;
    RxLabel1: TRxLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5_Splash: TForm5_Splash;

implementation

uses Unit1, Language;

{$R *.dfm}

procedure TForm5_Splash.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Form5_Splash.Release;
Form5_Splash:=Nil;
end;

procedure TForm5_Splash.FormCreate(Sender: TObject);
begin
RxLabel1.Caption:=Lang_DGL(37);
RxLabel1.Left:=(ClientWidth-RxLabel1.Width) div 2;
rx_loading.Left:=(ClientWidth-rx_loading.Width) div 2;

if Form1_DGL <> nil then
rx_loading.Visible:=False;

if FileExists('check_update.exe') then
ShellExecute(0,'open','check_update.exe',pchar(DGL_VERSAO_Global),nil,SW_HIDE);

end;

procedure TForm5_Splash.FormActivate(Sender: TObject);
begin
rx_loading.Visible:=True;
end;

end.
