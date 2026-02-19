unit DOSBOX_Bind_FPS;

interface

uses
  Windows, ShellAPI, SysUtils, Classes, Funcoes, Unit1;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure DOSBOX_Bind_FPS_Blood(
  HandleApp: HWND;
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer
);
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

implementation

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
const
ID_MouseAnalogX = 8112;
ID_MouseAnalogY = 20312;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ReplaceLinePrefix(L: TStringList; const Prefix, NewValue: string);
var i: Integer;
begin
  for i := 0 to L.Count-1 do
    if Pos(Prefix, L[i]) = 1 then
    L[i] := NewValue;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureBloodCFG(
  CaminhoJogo: string;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer;
  var Parametros: string
);
var
CFG: TStringList;
Arq: string;
begin
Arq := CaminhoJogo + 'blood.cfg';
CFG := TStringList.Create;
CFG.LoadFromFile(Arq);

ReplaceLinePrefix(CFG,'ScreenMode =','ScreenMode = 1');
ReplaceLinePrefix(CFG,'ScreenWidth =','ScreenWidth = 640');
ReplaceLinePrefix(CFG,'ScreenHeight =','ScreenHeight = 480');

ReplaceLinePrefix(CFG,'Size =','Size = 1');
ReplaceLinePrefix(CFG,'Gamma =','Gamma = 0');
ReplaceLinePrefix(CFG,'Detail =','Detail = 4');
ReplaceLinePrefix(CFG,'AimReticle =','AimReticle = 1');

ReplaceLinePrefix(CFG,'FXDevice =','FXDevice = 0');
ReplaceLinePrefix(CFG,'MusicDevice =','MusicDevice = 7');
ReplaceLinePrefix(CFG,'FXVolume =','FXVolume = 220');
ReplaceLinePrefix(CFG,'MusicVolume =','MusicVolume = 200');
ReplaceLinePrefix(CFG,'NumVoices =','NumVoices = 32');
ReplaceLinePrefix(CFG,'MixRate =','MixRate = 44000');
ReplaceLinePrefix(CFG,'NumChannels =','NumChannels = 2');
ReplaceLinePrefix(CFG,'NumBits =','NumBits = 16');
ReplaceLinePrefix(CFG,'MidiPort =','MidiPort = 0x330');
ReplaceLinePrefix(CFG,'BlasterAddress =','BlasterAddress = 0x220');
ReplaceLinePrefix(CFG,'BlasterType =','BlasterType = 6');
ReplaceLinePrefix(CFG,'BlasterInterrupt =','BlasterInterrupt = 7');
ReplaceLinePrefix(CFG,'BlasterDma8 =','BlasterDma8 = 1');
ReplaceLinePrefix(CFG,'BlasterDma16 =','BlasterDma16 = 5');
ReplaceLinePrefix(CFG,'BlasterEmu =','BlasterEmu = 0x620');
ReplaceLinePrefix(CFG,'ReverseStereo =','ReverseStereo = 0');

  if RxControle_Mouse then
  begin
  ReplaceLinePrefix(CFG,'ControllerType =','ControllerType = 3');
  ReplaceLinePrefix(CFG,'ExternalFilename =','ExternalFilename = "BMOUSE.EXE"');
  ReplaceLinePrefix(CFG,'MouseAim =','MouseAim = 1');
  ReplaceLinePrefix(CFG,'MouseAiming =','MouseAiming = 0');
  ReplaceLinePrefix(CFG,'MouseAimingFlipped =','MouseAimingFlipped = 0');
  ReplaceLinePrefix(CFG,'MouseButton0 =','MouseButton0 = "Weapon_Fire"');
  ReplaceLinePrefix(CFG,'MouseButton1 =','MouseButton1 = "Jump"');
  ReplaceLinePrefix(CFG,'MouseButton2 =','MouseButton2 = "Weapon_Special_Fire"');
  ReplaceLinePrefix(CFG,'Move_Forward =','Move_Forward = "W" "N/A"');
  ReplaceLinePrefix(CFG,'Move_Backward =','Move_Backward = "S" "N/A"');
  ReplaceLinePrefix(CFG,'Strafe_Left =','Strafe_Left = "A" "N/A"');
  ReplaceLinePrefix(CFG,'Strafe_Right =','Strafe_Right = "D" "N/A"');
  ReplaceLinePrefix(CFG,'Jump =','Jump = "Space" "N/A"');
  ReplaceLinePrefix(CFG,'Crouch =','Crouch = "C" "N/A"');
  ReplaceLinePrefix(CFG,'Open =','Open = "E" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_Fire =','Weapon_Fire = "LCtrl" "RCtrl"');
  ReplaceLinePrefix(CFG,'Weapon_Special_Fire =','Weapon_Special_Fire = "X" "N/A"');
  ReplaceLinePrefix(CFG,'Map_Toggle =','Map_Toggle = "M" "N/A"');
  end
  else
  begin
  ReplaceLinePrefix(CFG,'ControllerType =','ControllerType = 0');
  ReplaceLinePrefix(CFG,'ExternalFilename =','ExternalFilename = "EXTERNAL.EXE"');
  ReplaceLinePrefix(CFG,'MouseAim =','MouseAim = 0');
  ReplaceLinePrefix(CFG,'Move_Forward =','Move_Forward = "Up" "N/A"');
  ReplaceLinePrefix(CFG,'Move_Backward =','Move_Backward = "Down" "N/A"');
  ReplaceLinePrefix(CFG,'Turn_Left =','Turn_Left = "Left" "N/A"');
  ReplaceLinePrefix(CFG,'Turn_Right =','Turn_Right = "Right" "N/A"');
  ReplaceLinePrefix(CFG,'Strafe =','Strafe = "LAlt" "RAlt"');
  ReplaceLinePrefix(CFG,'Jump =','Jump = "A" "N/A"');
  ReplaceLinePrefix(CFG,'Crouch =','Crouch = "Z" "N/A"');
  ReplaceLinePrefix(CFG,'Open =','Open = "Space" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_Fire =','Weapon_Fire = "LCtrl" "RCtrl"');
  ReplaceLinePrefix(CFG,'Weapon_Special_Fire =','Weapon_Special_Fire = "X" "N/A"');
  ReplaceLinePrefix(CFG,'Map_Toggle =','Map_Toggle = "Tab" "N/A"');
  ReplaceLinePrefix(CFG,'Mouse_Aiming =','Mouse_Aiming = "U" "N/A"');
  ReplaceLinePrefix(CFG,'Toggle_Crosshair =','Toggle_Crosshair = "I" "N/A"');
  end;

  if Mouse_Global > 0 then
  begin
  ReplaceLinePrefix(CFG,'MouseAnalogScale0 =','MouseAnalogScale0 = '+IntToStr(ID_MouseAnalogX+Mouse_Global));
  ReplaceLinePrefix(CFG,'MouseAnalogScale1 =','MouseAnalogScale1 = -'+IntToStr(ID_MouseAnalogY+Mouse_Global));
  end;

  if not check_single then
  begin
  ReplaceLinePrefix(CFG,'NumberPlayers =','NumberPlayers = '+NumPlayers);
  ReplaceLinePrefix(CFG,'PlayerName =','PlayerName = "'+PlayerName+'"');
  end;

  if RxControle_Mouse and check_single then
  Parametros := ' -noaim -ini PHOBOS.ini'
  else if RxControle_Mouse then
  Parametros := ' -noaim'
  else if check_single then
  Parametros := ' -ini PHOBOS.ini'
  else
  Parametros := ' -ini BLOOD.ini -broadcast';

CFG.SaveToFile(Arq);
CFG.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureCommit(CaminhoJogo, NumPlayers, ExeNome: string);
var L: TStringList;
begin
L := TStringList.Create;
L.LoadFromFile(CaminhoJogo+'commit.dat');

  if L[24] = '; - GAMECONNECTION - 4' then
  L.Delete(24);

L[26] := 'NUMPLAYERS = '+NumPlayers;
L[33] := 'LAUNCHNAME = "'+ExeNome+'"';

L.SaveToFile(CaminhoJogo+'commit.dat');
L.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureDOSBoxCONF(
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  RxControle_Mouse: Boolean;
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
ReplaceLinePrefix(L,'machine=','machine=vesa_nolfb');
ReplaceLinePrefix(L,'memsize=','memsize=64');
ReplaceLinePrefix(L,'aspect=','aspect=true');
ReplaceLinePrefix(L,'core=','core=dynamic');
ReplaceLinePrefix(L,'cycles=','cycles=max 105%');

  for i := 0 to L.Count-1 do
    if Pos('[autoexec]',L[i]) = 1 then
    begin
      if not menu_debug then
      L.Add('@ECHO OFF');

    L.Add('mount c "'+IncludeTrailingPathDelimiter(CaminhoJogo)+'"');
    L.Add('c:');

      if check_servidor then
      L.Add('ipxnet startserver '+ip_porta);

      if check_cliente then
      L.Add('ipxnet connect '+ip_local+' '+ip_porta);

    L.Add('nolfblim.com');

      if RxControle_Mouse then
      L.Add('BMOUSE.EXE LAUNCH '+Game_EXE_Global+Parametros)
      else
      L.Add(Game_EXE_Global+Parametros);

      if not menu_debug then
      L.Add('exit');

    Break;
  end;
L.SaveToFile(Arq_DosBox);
L.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure RunDOSBox(HandleApp: HWND; DosBox_EXE_Global, Arq_DosBox: string);
begin
ShellExecute(HandleApp,'open',PChar(DosBox_EXE_Global),PChar('-conf '+ExtractFileName(Arq_DosBox)),PChar(ExtractFilePath(Arq_DosBox)),SW_NORMAL);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure DOSBOX_Bind_FPS_Blood(
  HandleApp: HWND;
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer
);
var
Parametros: string;
Arq_DosBox: string;
begin
  //--------------------------------------------------
  // 0) SELEÇÃO DE EPISÓDIO / FASE (LÓGICA ORIGINAL)
  //--------------------------------------------------
  if check_single then
  begin
  Seleciona_Fases;

  if Fecha_ESC then
  Exit;
  end;

//--------------------------------------------------
// 1) CONFIGURA blood.cfg
//--------------------------------------------------
ConfigureBloodCFG(CaminhoJogo,RxControle_Mouse,check_single,NumPlayers,PlayerName,Mouse_Global,Parametros);

  //--------------------------------------------------
  // 2) COMMIT.DAT (APENAS MULTIPLAYER)
  //--------------------------------------------------
  if not check_single then
  ConfigureCommit(CaminhoJogo, NumPlayers, Game_EXE_Global);

//--------------------------------------------------
// 3) CONF DO DOSBOX
//--------------------------------------------------
ConfigureDOSBoxCONF(DosBox_EXE_Global,CaminhoJogo,Game_EXE_Global,menu_debug,RxControle_Mouse,check_single,check_servidor,check_cliente,ip_porta,ip_local,Parametros,Arq_DosBox);

//--------------------------------------------------
// 4) EXECUTA
//--------------------------------------------------
RunDOSBox(HandleApp, DosBox_EXE_Global, Arq_DosBox);

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.

