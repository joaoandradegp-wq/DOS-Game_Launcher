unit Splash;

interface

uses
  Windows, SysUtils, Forms, ExtCtrls, ShellAPI, Vcl.StdCtrls,
  Vcl.WinXCtrls, Vcl.Imaging.jpeg, System.Classes, Vcl.Controls;

type
  TForm5_Splash = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FIndicator: TActivityIndicator;
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
Label1.Caption:=Lang_DGL(37);
Label1.Left:=(ClientWidth-Label1.Width) div 2;

FIndicator := TActivityIndicator.Create(Self);
FIndicator.Parent := Self;
FIndicator.IndicatorSize := aisMedium;
FIndicator.Left := (ClientWidth - FIndicator.Width) div 2;
FIndicator.Top  := ClientHeight - FIndicator.Height - MulDiv(50, CurrentPPI, 96);
FIndicator.Animate := True;

   if FileExists('check_update.exe') then
   ShellExecute(0,'open','check_update.exe',pchar(DGL_VERSAO_Global),nil,SW_HIDE);

end;

end.
