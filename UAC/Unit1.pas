unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellApi, pngimage, ExtCtrls, IdHTTP, WinInet;

type
  TForm1 = class(TForm)
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

//-----------------------------------------------------------------------------------------
function Language_WIN:String;
function CheckUrl(url: String):Boolean;
procedure Executar_WEB;
procedure Executar_DGL;
procedure RunAsAdmin(Const aFile:String; Const aParameters: String = ''; Handle: HWND = 0);
//-----------------------------------------------------------------------------------------

implementation

uses Language;

{$R *.dfm}

//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
function CheckUrl(url: String):Boolean;
var
hSession,hfile:hInternet;
dwindex,dwcodelen:dword;
dwcode:array[1..20] of char;
res:pchar;
begin

  if pos('http://', lowercase(url)) = 0 then
  url := 'http://' + url;

Result:=False;
hSession:=InternetOpen('InetURL:/1.0', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if assigned(hsession) then
  begin
  hfile:=InternetOpenUrl(hsession, pchar(url), nil, 0, INTERNET_FLAG_RELOAD, 0);
  dwIndex:=0;
  dwCodeLen:=10;
  HttpQueryInfo(hfile, HTTP_QUERY_STATUS_CODE, @dwcode, dwcodeLen, dwIndex);
  res:=pchar(@dwcode);
  Result:=(res = '200') or (res = '302');

    if assigned(hfile) then
    InternetCloseHandle(hfile);

  InternetCloseHandle(hsession);
  end;

  //-----------------------------------------------------------------------------------------------------------------------------
  if Result = False then
  begin
    case MessageBox(Application.Handle,pchar(Language_UAC(0)),pchar(Application.Title),MB_ICONQUESTION+MB_YESNO+MB_DEFBUTTON2) of
    idYes: Executar_WEB;
     idNo: Executar_DGL;
    end;
  end
  else
  Executar_DGL;
  //-----------------------------------------------------------------------------------------------------------------------------

end;
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
function Language_WIN:String;
var
ID:LangID;
Language:Array [0..100] of Char;
begin
ID:=GetSystemDefaultLangID;
VerLanguageName(ID,Language,100);
Result:=LowerCase(Copy(String(Language),0,3));
end;
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
procedure Executar_WEB;
begin
ShellExecute(0,Nil,pchar('https://sourceforge.net/projects/dosgamelauncher/files/latest/download'),Nil,Nil,0);
Application.Terminate;
end;
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
procedure Executar_DGL;
begin

  if not FileExists(ExtractFilePath(Application.ExeName)+'dos.ini') then
  RunAsAdmin('DOS_GAMES.exe','phobos')
  else
  ShellExecute(Application.handle,'open','DOS_GAMES.exe','phobos','',SW_SHOWNORMAL);

Application.Terminate;
end;
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
procedure RunAsAdmin(Const aFile:String; Const aParameters: String = ''; Handle: HWND = 0);
var
EXE:TShellExecuteInfo;
begin
FillChar(EXE,SizeOf(EXE),0);

EXE.cbSize:=SizeOf(EXE);
EXE.Wnd   :=Handle;
EXE.fMask :=SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
EXE.lpVerb:='runas';
EXE.lpFile:=PChar(aFile);
EXE.lpParameters:=PChar(aParameters);
EXE.nShow:=SW_SHOWNORMAL;

 if not ShellExecuteEx(@EXE) then
 RaiseLastOSError;

end;
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------

end.


