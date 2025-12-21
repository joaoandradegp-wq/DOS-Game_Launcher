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
    Label_VersaoWindows: TLabel;
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

//----------------------------------------------------------

{PEGAR A VERSÃO DO WINDOWS}
function GetWindowsVersion: string;
var 
VerInfo: TOsversionInfo; 
PlatformId, VersionNumber: string; 
Reg: TRegistry;
begin 
VerInfo.dwOSVersionInfoSize := SizeOf(VerInfo); 
GetVersionEx(VerInfo); 
// Detect platform 
Reg := TRegistry.Create; 
Reg.RootKey := HKEY_LOCAL_MACHINE; 
case VerInfo.dwPlatformId of 
VER_PLATFORM_WIN32s: 
begin 
// Registry (Huh? What registry?) 
PlatformId := 'Windows 3.1';
end;
VER_PLATFORM_WIN32_WINDOWS: 
begin 
// Registry 
Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion', False);
PlatformId := Reg.ReadString('ProductName');
VersionNumber := Reg.ReadString('VersionNumber');
end; 
VER_PLATFORM_WIN32_NT: 
begin 
// Registry 
Reg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion', False);
PlatformId := Reg.ReadString('ProductName');
VersionNumber := Reg.ReadString('CurrentVersion');
end; 
end; 
Reg.Free; 
Result := PlatformId + ' (version ' + VersionNumber + ')';
end;
//----------------------------------------------------------

{$R *.dfm}

procedure TForm5_About.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form5_About.Release;
Form5_About:=Nil;
end;

procedure TForm5_About.FormActivate(Sender: TObject);
begin
Form5_About.Caption:=UpperCase(Lang_DGL(20)+' '+Application.Title);
Label_VersaoWindows.Caption:=Copy(GetWindowsVersion,0,Pos('(',GetWindowsVersion)-1);
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
