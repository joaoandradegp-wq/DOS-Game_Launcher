program DGL_UAC;

uses
  Forms,
  SysUtils,
  Windows,
  Wininet,
  ShellAPI,
  Unit1 in 'Unit1.pas' {Form1},
  Language in 'Language.pas';

{$R *.res}

var
App_Aberto:HWND;

begin

 if not FileExists('DOS_GAMES.exe') then
 Halt;

  Application.Initialize;
  App_Aberto:=FindWindow(Nil,PChar('DOS GAME LAUNCHER 1.9'));

  if App_Aberto = 0 then
  begin
  Application.Title:='DOS GAME LAUNCHER';
  Application.CreateForm(TForm1, Form1);
  Form1.Show;
  Form1.Update;

    if InternetCheckConnection('http://www.google.com/',1,0) then
    CheckUrl('http://updatedgl19.blogspot.com/')
    else
    Executar_DGL;

  end
  else
  MessageBox(Application.Handle,pchar(Language_UAC(1)),pchar('DOS GAME LAUNCHER'),MB_ICONINFORMATION+MB_OK);

end.
