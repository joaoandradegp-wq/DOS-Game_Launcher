unit NO_DOSBOX_Bind;

interface

uses
  Classes, SysUtils, Forms,
  Windows, Unit1, Funcoes, Language,
  IniFiles, Messages;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure DOSBOX_Bind_WAR2(
  HandleApp: HWND;
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  PlayerName: string
);
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

implementation

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Warcraft2MenuSetup(Servidor, Cliente: Boolean);
begin
Sleep(300);

{MULTIPLAYER}
SendChar('M');      
Sleep(400);

{NETWORK}
SendKey(VK_RETURN);
Sleep(400);

{IPX}
SendKey(VK_DOWN);
SendKey(VK_DOWN);
SendKey(VK_RETURN);

Sleep(400);

  if Servidor then
  SendChar('C');

  if Cliente then
  begin
  SendKey(VK_DOWN);
  Sleep(200);
  SendKey(VK_RETURN);
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure SkipWarcraftIntro;
var
T: DWORD;
begin
T := GetTickCount;

  while GetTickCount - T < 5000 do
  begin
  SendKey(VK_RETURN);
  Sleep(300);
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AfterDOSBoxStart(WindowName: string; IDGame: Integer; Servidor, Cliente, menu_debug: Boolean);
var
hGame: HWND;
begin

  if menu_debug then
  Exit;

hGame := WaitForWindowLike(WindowName, 10000);

  if hGame = 0 then
  Exit;

ShowWindow(hGame, SW_RESTORE);
SetForegroundWindow(hGame);
SetActiveWindow(hGame);

Sleep(1000);

  if IDGame = 11 then
  begin
  SkipWarcraftIntro;
  Sleep(1500);
  SendKey(VK_ESCAPE);
  Sleep(400);
  Warcraft2MenuSetup(Servidor, Cliente);
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureWarcraft2CFG(Ini: TMemIniFile; const Config_Game_Global: string; const CheckSingle: Boolean; const PlayerName: string);
begin
Ini.WriteString ('', 'cdpath' , 'd:\');
Ini.WriteInteger('', 'mscroll', 0);
Ini.WriteInteger('', 'intro'  , Ord(CheckSingle));
Ini.WriteString ('', 'name'   , PlayerName);

Ini.UpdateFile;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureDOSBoxCONF(
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  Parametros: string;
  var Arq_DosBox: string
);
var
L: TStringList;
i: Integer;
begin
Arq_DosBox := CaminhoJogo + LowerCase(ChangeFileExt(Game_EXE_Global,'')) + '_dosbox.conf';

CopyFile(PChar(ExtractFilePath(DosBox_EXE_Global)+'dosbox-0.74.conf'),PChar(Arq_DosBox),False);

L := TStringList.Create;
L.LoadFromFile(Arq_DosBox);

ReplaceLinePrefix(L,'fullscreen=','fullscreen='+BoolToStr(not menu_debug,True));
ReplaceLinePrefix(L,'fullresolution=','fullresolution=desktop');

  if menu_debug then
  ReplaceLinePrefix(L,'windowresolution=','windowresolution=1024x768');
  
  {NÃO TEM PLACA DE VÍDEO - INTEL e NVIDIA}
  if ProcessExists('igfxTray.exe') or ProcessExists('NVIDIA Overlay.exe') then
  ReplaceLinePrefix(L,'output=','output=opengl')
  else
  ReplaceLinePrefix(L,'output=','output=overlay');

ReplaceLinePrefix(L,'memsize=','memsize=64');
ReplaceLinePrefix(L,'aspect=','aspect=true');
ReplaceLinePrefix(L,'scaler=','scaler=normal2x');
ReplaceLinePrefix(L,'core=','core=dynamic');
ReplaceLinePrefix(L,'cycles=','cycles=max');
ReplaceLinePrefix(L,'prebuffer=','prebuffer=20');

  //--------------------------------
  {IPX}
  //--------------------------------
  for i := 0 to L.Count-1 do
  begin
    if Pos('ipx=', L[i]) = 1 then
    begin
      if check_single then
      L[i] := 'ipx=false'
      else
      L[i] := 'Enable=1'    +#13#10+
              'Connection=1'+#13#10+
              'ipx=true';
    end;
  end;
  //--------------------------------

  for i := 0 to L.Count-1 do
    if Pos('[autoexec]',L[i]) = 1 then
    begin
      if not menu_debug then
      L.Add('@ECHO OFF');

      if DirectoryExists(ExtractFilePath(CaminhoJogo)) then
      L.Add('mount c "'+IncludeTrailingPathDelimiter(CaminhoJogo)+'"')
      else
      MessageBox(Application.Handle,PChar(Lang_DGL(8)+':'+#13#13+ExtractFilePath(Arq_DosBox)),PChar(Application.Title),MB_ICONERROR+MB_OK);

    L.Add('mount d "'+ExtractFilePath(Application.ExeName)+Array_Games[id][3]+'" -t cdrom');
    L.Add('c:');

      if not menu_debug then
      L.Add('cls');

      if check_servidor then
      L.Add('ipxnet startserver '+ip_porta);

      if check_cliente then
      L.Add('ipxnet connect '+ip_local+' '+ip_porta);

    L.Add(Game_EXE_Global+Parametros);

      if not menu_debug then
      L.Add('Exit.');

    Break;
    end;

    {SINGLE PLAYER + DEBUG}
    if check_single and menu_debug then
    MessageBox(Application.Handle,pchar(Game_EXE_Global+#13+Parametros),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);

L.SaveToFile(Arq_DosBox);
L.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure DOSBOX_Bind_WAR2(
  HandleApp: HWND;
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  PlayerName: string
);
var
Parametros: string;
Arq_DosBox: string;
Ini: TMemIniFile;
begin

  {CFG}
  Ini := TMemIniFile.Create(CaminhoJogo+'war2.ini');
  try
  ConfigureWarcraft2CFG(Ini, '', check_single, PlayerName);
  finally
  Ini.Free;
  end;

{DOSBOX CONF}
ConfigureDOSBoxCONF(DosBox_EXE_Global,CaminhoJogo,Game_EXE_Global,menu_debug,check_single,check_servidor,check_cliente,ip_porta,ip_local,Parametros,Arq_DosBox);

{RUN}
RunDOSBox(HandleApp, DosBox_EXE_Global, Arq_DosBox);

{POST START}
AfterDOSBoxStart('SDL_app', id, check_servidor, check_cliente, menu_debug);

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.
