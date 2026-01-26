unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, RXCtrls, Animate, GIFCtrl;

type
  TForm5_Splash = class(TForm)
    Image1: TImage;
    rx_loading: TRxGIFAnimator;
    RxLabel1: TRxLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5_Splash: TForm5_Splash;

implementation

{$R *.dfm}

procedure TForm5_Splash.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Form5_Splash.Release;
Form5_Splash:=Nil;
end;

procedure TForm5_Splash.FormCreate(Sender: TObject);
begin
if Form1 <> nil then
rx_loading.Visible:=False;

ShellExecute(0,'open','check_update.exe',pchar(DGL_VERSAO_Global),nil,SW_HIDE);

end;

end.
