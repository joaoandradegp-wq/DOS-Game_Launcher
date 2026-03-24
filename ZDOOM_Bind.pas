unit ZDOOM_Bind;

interface

uses IniFiles, SysUtils, Forms, Unit1, DLC, Funcoes, Windows, ShellAPI, Language, Hexen_Class;

//--------------------------------------------------
{USADO EM CONFIGUREZDOOM}
//--------------------------------------------------
type
  TZDoomMode = (zmSinglePlayer, zmServer, zmClient);
    TZDoomOptions = record
    Mode: TZDoomMode;
    Map: string;
    HostPlayers: Integer;
    Port: string;
    JoinIP: string;
    IWad: string;
    SkinParams: string;
    ModParams: string;
    ConfigFile: string;
    WorkingDir: string;
    Executable: string;
    ExtraDMParams: string;
  end;
//--------------------------------------------------
//--------------------------------------------------
type
  TGameFlags = record
    TemFreelook: Boolean;
    TemCrouch: Boolean;
    TemJump: Boolean;
    UsaClasse: Boolean;
    UsaMapBackground: Boolean;
    UsaMapColorset: Boolean;
    UsaMapTime: Boolean;
    UsaMapLabel: Boolean;
  end;
//--------------------------------------------------
type
  TResolveDebugPlayers = function(DefaultPlayers: Integer): Integer;
//--------------------------------------------------
type
  TSelectMapFunc = function: string;
//--------------------------------------------------

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
function BlockIWAD(const Arquivo: string; Chave:Boolean): Boolean;
function SIGIL_DLC_Exists(DLC:Integer):Boolean;
function GetZDoomMode(IsSingle, IsServer: Boolean): TZDoomMode;
procedure ExecuteZDoom(const Opt: TZDoomOptions; Debug: Boolean);
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
procedure ConfigureZDoom(id: Integer; MouseAtivo,Debug: Boolean;
PlayerName, ConfigFile, IWADFile: String;
Mode: TZDoomMode;
Map: string;
HostPlayers: Integer;
Port,JoinIP: string;
DoomSkinIndex,DoomColorIndex,ScreenWidth,ScreenHeight: Integer;
ResolveDebugPlayers: TResolveDebugPlayers = nil; SelectMap: TSelectMapFunc = nil);
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------

implementation

const
CFG_vid_defwidth = 800;
CFG_vid_defheight = 600;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function BlockIWAD(const Arquivo: string; Chave:Boolean): Boolean;
var
i: Integer;
NomeArquivo: string;
const
Array_WAD: array[1..3] of string = ('sigil', 'plutonia', 'tnt');
begin
Result := False;
NomeArquivo := LowerCase(ExtractFileName(Arquivo));

  if Chave then
  begin
  //----------------------------------------------------
    for i := Low(Array_Games) to High(Array_Games) do
    begin
      if LowerCase(Array_Games[i][4]) = NomeArquivo then
      begin
      Result := True;
      Exit;
      end;
    end;
  //----------------------------------------------------
  end
  else
  begin
  //----------------------------------------------------
    {Evita usuários carregarem IWAD como MOD}
    for i := Low(Array_WAD) to High(Array_WAD) do
    begin
      if Pos(Array_WAD[i], NomeArquivo) > 0 then
      begin
      Result := True;
      Exit;
      end;
    end;
  //----------------------------------------------------
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function IsIWAD(const FileName: string): Boolean;
begin
Result := LowerCase(ExtractFileExt(FileName)) = '.wad';
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function SIGIL_DLC_Exists(DLC:Integer):Boolean;
var
Var_Pesquisa:TSearchRec;
begin

 case DLC of
 1: begin
      if FindFirst(Caminho_Global+'SIGIL_v*.wad',faAnyFile,Var_Pesquisa) = 0 then
      begin
      Result:=True;
      Array_SIGIL_DLC_Name[0]:=Var_Pesquisa.Name;
        if FindFirst(Caminho_Global+'SIGIL_SHREDS.wad',faAnyFile,Var_Pesquisa) = 0 then
        Array_SIGIL_DLC_Name[1]:=' -file '+Var_Pesquisa.Name;
      end;
    end;
 2: begin
      if FindFirst(Caminho_Global+'SIGIL_II_V*.wad',faAnyFile,Var_Pesquisa) = 0 then
      begin
      Result:=True;
      Array_SIGIL_DLC_Name[2]:=Var_Pesquisa.Name;
        if FindFirst(Caminho_Global+'SIGIL_II_MP3_V*.WAD',faAnyFile,Var_Pesquisa) = 0 then
        Array_SIGIL_DLC_Name[3]:=' -file '+Var_Pesquisa.Name;
      end;
 end
 else
 Result:=False;
 end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function GetZDoomMode(IsSingle, IsServer: Boolean): TZDoomMode;
begin
  if IsSingle then
  Result := zmSinglePlayer
  else if IsServer then
  Result := zmServer
  else
  Result := zmClient;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function GetPlayerSection(id: Integer): String;
begin
  case id of
    3,4,12,13: Result := 'Doom.Player';
    6:         Result := 'Heretic.Player';
    7:         Result := 'Hexen.Player';
  else
  Result := 'Doom.Player';
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function GetCVarSection(id: Integer): String;
begin
  case id of
    3,4,12,13: Result := 'Doom.ConsoleVariables';
    6:         Result := 'Heretic.ConsoleVariables';
    7:         Result := 'Hexen.ConsoleVariables';
  else
  Result := 'Doom.ConsoleVariables';
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function GetGameFlags(id: Integer): TGameFlags;
begin
FillChar(Result, SizeOf(Result), 0);

  case id of
    3,4: {DOOM}
    begin
    Result.TemFreelook := True;
    Result.TemCrouch   := True;
    Result.TemJump     := True;
    Result.UsaMapLabel := True;
    end;

    6: {HERETIC}
    begin
    Result.TemFreelook := True;
    Result.UsaMapBackground := True;
    Result.UsaMapColorset   := True;
    Result.UsaMapLabel := True;
    end;

    7: {HEXEN}
    begin
    Result.TemFreelook := True;
    Result.TemCrouch   := True;
    Result.TemJump     := True;
    Result.UsaClasse   := True;
    Result.UsaMapBackground := True;
    Result.UsaMapColorset   := True;
    Result.UsaMapTime  := True;
    end;

  end;
  
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function AspectRatio(W, H: Integer): Integer;
begin

  if (W * 9 = H * 16) then
  Result := 1
  else if (W * 3 = H * 4) then
  Result := 0
  else
  Result := 0;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ApplyGlobalSettings(Ini: TMemIniFile; id: Integer; Flags: TGameFlags; MouseAtivo, Debug: Boolean; IWADFile, PlayerName: String; ScreenWidth, ScreenHeight: Integer);
var
CVarSection,PlayerSection: String;
begin
CVarSection:=GetCVarSection(id);
PlayerSection:=GetPlayerSection(id);

Ini.WriteBool(CVarSection, 'fullscreen', not Debug);

  {CONFIGURAÇÃO DE VÍDEO}
  if Debug then
  begin
  Ini.WriteInteger(CVarSection, 'vid_aspect', 0);
  Ini.WriteBool   (CVarSection, 'vid_vsync', False);
  Ini.WriteInteger(CVarSection, 'vid_defwidth', CFG_vid_defwidth);
  Ini.WriteInteger(CVarSection, 'vid_defheight', CFG_vid_defheight);
  end
  else
  begin
  Ini.WriteInteger(CVarSection, 'vid_aspect', AspectRatio(ScreenWidth, ScreenHeight));
  Ini.WriteBool   (CVarSection, 'vid_vsync', True);
  Ini.WriteInteger(CVarSection, 'vid_defwidth', ScreenWidth);
  Ini.WriteInteger(CVarSection, 'vid_defheight', ScreenHeight);
  end;

Ini.WriteBool  (CVarSection,   'freelook', Flags.TemFreelook and MouseAtivo);
Ini.WriteBool  (CVarSection,   'use_mouse', MouseAtivo);
Ini.WriteString(CVarSection,   'mouse_sensitivity', '1.5');
Ini.WriteString(CVarSection,   'defaultiwad', ExtractFileName(IWADFile));
Ini.WriteBool  (CVarSection,   'queryiwad', False);
Ini.WriteString(CVarSection,   'language', 'enu');
Ini.WriteString(PlayerSection, 'name', Trim(PlayerName));

  if MouseAtivo then
  Ini.WriteInteger(PlayerSection, 'autoaim', 0)
  else
  Ini.WriteInteger(PlayerSection, 'autoaim', 35);

Ini.WriteInteger(CVarSection, 'screenblocks', 10);
Ini.WriteInteger(CVarSection, 'cl_maxdecals', 0);
Ini.WriteInteger(CVarSection, 'cl_rockettrails', 0);
Ini.WriteInteger(CVarSection, 'wipetype', 0);
Ini.WriteBool   (CVarSection, 'show_obituaries', False);
Ini.WriteBool   (CVarSection, 'screenshot_quiet', True);

  if Flags.UsaMapBackground then
  Ini.WriteInteger(CVarSection, 'am_drawmapback', 1)
  else
  Ini.WriteInteger(CVarSection, 'am_drawmapback', 0);

  if Flags.UsaMapColorset then
  Ini.WriteInteger(CVarSection, 'am_colorset', 3)
  else
  Ini.WriteInteger(CVarSection, 'am_colorset', 1);

  if Flags.UsaMapTime then
  Ini.WriteBool(CVarSection, 'am_showtime', True)
  else
  Ini.WriteBool(CVarSection, 'am_showtime', False);

  if Flags.UsaMapLabel then
  Ini.WriteInteger(CVarSection, 'am_showmaplabel', 1)
  else
  Ini.WriteInteger(CVarSection, 'am_showmaplabel', 0);

Ini.WriteBool   (CVarSection, 'am_showmonsters', False);
Ini.WriteBool   (CVarSection, 'am_showsecrets', False);
Ini.WriteInteger(CVarSection, 'am_rotate', 0);
Ini.WriteInteger(CVarSection, 'Gamma', 1);
Ini.WriteInteger(CVarSection, 'r_fakecontrast', 1);
Ini.WriteInteger(CVarSection, 'con_scaletext', 1);
Ini.WriteInteger(CVarSection, 'msg0color', 11);
Ini.WriteInteger(CVarSection, 'msg1color', 11);
Ini.WriteInteger(CVarSection, 'msg2color', 11);
Ini.WriteInteger(CVarSection, 'msg3color', 11);
Ini.WriteInteger(CVarSection, 'msg4color', 11);
Ini.WriteInteger(CVarSection, 'msgmidcolor', 11);
Ini.WriteBool   (CVarSection, 'cl_run', False);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ApplyBindings(Ini: TMemIniFile; Section: String; Flags: TGameFlags; MouseAtivo: Boolean);
begin
Ini.EraseSection(Section);

Ini.WriteString(Section, '1', 'slot 1');
Ini.WriteString(Section, '2', 'slot 2');
Ini.WriteString(Section, '3', 'slot 3');
Ini.WriteString(Section, '4', 'slot 4');
Ini.WriteString(Section, '5', 'slot 5');
Ini.WriteString(Section, '6', 'slot 6');
Ini.WriteString(Section, '7', 'slot 7');
Ini.WriteString(Section, '8', 'slot 8');
Ini.WriteString(Section, '9', 'slot 9');
Ini.WriteString(Section, '0', 'slot 0');

Ini.WriteString(Section, '-', 'sizedown');
Ini.WriteString(Section, 'Equals', 'sizeup');
Ini.WriteString(Section, 'tab', 'togglemap');
Ini.WriteString(Section, 't', 'messagemode');

  if MouseAtivo then
  begin
  Ini.WriteString(Section, 'w', '+forward');
  Ini.WriteString(Section, 'a', '+moveleft');
  Ini.WriteString(Section, 's', '+back');
  Ini.WriteString(Section, 'd', '+moveright');
  Ini.WriteString(Section, 'e', '+use');
  Ini.WriteString(Section, 'mouse1', '+attack');

    if Flags.TemCrouch then
    Ini.WriteString(Section, 'c', '+crouch');

    if Flags.TemJump then
    Ini.WriteString(Section, 'mouse2', '+jump');

  Ini.WriteString(Section, 'mwheelup', 'weapprev');
  Ini.WriteString(Section, 'mwheeldown', 'weapnext');
  end
  else
  begin
  Ini.WriteString(Section, 'ctrl', '+attack');
  Ini.WriteString(Section, 'shift', '+speed');
  Ini.WriteString(Section, 'alt', '+strafe');
  Ini.WriteString(Section, 'space', '+use');
  Ini.WriteString(Section, 'uparrow', '+forward');
  Ini.WriteString(Section, 'leftarrow', '+left');
  Ini.WriteString(Section, 'rightarrow', '+right');
  Ini.WriteString(Section, 'downarrow', '+back');
  end;

Ini.WriteString(Section, 'LeftBracket', 'invprev');
Ini.WriteString(Section, 'RightBracket', 'invnext');
Ini.WriteString(Section, 'enter', 'invuse');
Ini.WriteString(Section, 'pause', 'pause');
Ini.WriteString(Section, 'capslock', 'toggle cl_run');
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ApplyHexenClass(Ini: TMemIniFile; Classe: Integer);
begin
  case Classe of
    1: Ini.WriteString(GetPlayerSection(7), 'playerclass', 'Fighter');
    2: Ini.WriteString(GetPlayerSection(7), 'playerclass', 'Cleric');
    3: Ini.WriteString(GetPlayerSection(7), 'playerclass', 'Mage');
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ApplyDoomSkin(Ini: TMemIniFile; id: Integer; SinglePlayer: Boolean; SkinIndex, ColorIndex: Integer);
var
PlayerSection: String;
begin
PlayerSection := GetPlayerSection(id);
           
  if SinglePlayer then
  Exit;

  case SkinIndex of
    0: begin
       Ini.WriteString (PlayerSection, 'skin', 'base');
       Ini.WriteInteger(PlayerSection, 'colorset', ColorIndex);
       end;

    1: begin
       Ini.WriteString(PlayerSection, 'skin', 'Phobos');
       Ini.WriteString(PlayerSection, 'colorset', '-1');
       Ini.WriteString(PlayerSection, 'color', 'ff 50 00');
       end;
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureZDoom(id: Integer; MouseAtivo,Debug: Boolean;
PlayerName, ConfigFile, IWADFile: String;
//-------------------
Mode: TZDoomMode;
Map: string;
HostPlayers: Integer;
Port,JoinIP: string;
//-------------------
DoomSkinIndex,DoomColorIndex,ScreenWidth,ScreenHeight: Integer;
ResolveDebugPlayers: TResolveDebugPlayers = nil; SelectMap: TSelectMapFunc = nil);
var
    Ini: TMemIniFile;
  Flags: TGameFlags;
Section: String;
    Opt: TZDoomOptions;
begin
Flags := GetGameFlags(id);

  case id of
  3,4,12,13: Section := 'Doom.Bindings';
          6: Section := 'Heretic.Bindings';
          7: Section := 'Hexen.Bindings';
  else
  Section := 'Doom.Bindings';
  end;

  Ini := TMemIniFile.Create(ConfigFile);
  try
  ApplyGlobalSettings(Ini, id, Flags, MouseAtivo, Debug, IWADFile, PlayerName, ScreenWidth, ScreenHeight);
  ApplyBindings(Ini, Section, Flags, MouseAtivo);

    {HEXEN}
    if id = 7 then
    begin
    Application.CreateForm(TForm8_HexenClass, Form8_HexenClass);
    Form8_HexenClass.ShowModal;
    Form8_HexenClass.Free;

    //Application.CreateForm(TForm2_DLC, Form2_DLC);
    //Form2_DLC.ShowModal;
    //Form2_DLC.Free;

      if Fecha_ESC then
      Exit;

      if Flags.UsaClasse then
      ApplyHexenClass(Ini, EPI_Global_DLC);
    end;

  ApplyDoomSkin(Ini,id,Mode = zmSinglePlayer,DoomSkinIndex,DoomColorIndex);

  Ini.UpdateFile;
  finally
  Ini.Free;
  end;

//-----------------------------------------------------
// PREPARA EXECUÇÃO
//-----------------------------------------------------
Opt.ConfigFile    := ConfigFile;
Opt.IWad          := IWADFile;
Opt.WorkingDir    := ExtractFilePath(ConfigFile);
Opt.Executable    := ZDoom_EXE_Global;

  {DOOM II - SKIN PHOBOS}
  if Form1_DGL.combo_doom.ItemIndex = 1 then
  Opt.SkinParams:= ' -file ' + DoomSkin_Global;

  {DOOM II - ONE-HUMANITY}
  if ExtractFileExt(DoomMod_Global) = '.wad' then
  Opt.ModParams := '-file ' + '"'+ DoomMod_Global +'"';

Opt.ExtraDMParams := DoomDM_Global;
//-----------------------------------------------------

  {SELEÇÃO DE MAPA}
  if (Mode in [zmSinglePlayer, zmServer]) and (Map = '') and (Form1_DGL.RxBrutal.StateOn = False) then
  begin
    if Assigned(SelectMap) then
    Map := SelectMap;

    if Map = '' then
    Exit;
  end;

  {DOOM II - MOD DE FASE PARA COMEÇAR NA PRIMEIRA}
  if (id = 4) and (Form1_DGL.RxBrutal.StateOn) then
  Map := 'MAP01';

  {DEBUG MODE - SIMULAR MULTIPLAYER}
  if (Mode = zmServer) then
  begin
    if Debug and Assigned(ResolveDebugPlayers) then
    HostPlayers := ResolveDebugPlayers(HostPlayers);
  end;

{MODO DE JOGO - SINGLE, SERVER ou CLIENT}
Opt.Mode := Mode;

  case Mode of zmSinglePlayer:
  Opt.Map := Map;

    zmServer: begin
              Opt.Map := Map;
              Opt.HostPlayers := HostPlayers;
              Opt.Port := Port;
              end;

    zmClient: begin
              Opt.JoinIP := JoinIP;
              Opt.Port := Port;
              end;
  end;


{EXECUTA}
ExecuteZDoom(Opt, Debug);

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ExecuteZDoom(const Opt: TZDoomOptions; Debug: Boolean);
var
Parametros, BaseParams: string;
begin
Parametros := '';

  case Opt.Mode of
    zmSinglePlayer: Parametros := ' +map ' + Opt.Map;
          zmServer: Parametros :=
                    ' -host ' + IntToStr(Opt.HostPlayers) + Opt.ExtraDMParams +
                    ' -port ' + Trim(Opt.Port) +
                    ' +map ' + Opt.Map;
          zmClient: Parametros :=
                    ' -join ' + Trim(Opt.JoinIP) +
                    ' -port ' + Trim(Opt.Port);
  end;

  {WOLF3D}
  if IsIWAD(Opt.IWad) then
  BaseParams := '-iwad "' + Opt.IWad + '"'
  else
  BaseParams := '-file "' + Opt.IWad + '"';

  {DOOM - SIGIL}
  if (id = 3) and (BlockIWAD(Game_EXE_Global,True) = False) then
  BaseParams := BaseParams + ' -file ' +Game_EXE_Global;

  if Debug then
  MessageBox(0, PChar(' '+BaseParams +
                             ' ' + Opt.SkinParams +
                             ' ' + Opt.ModParams +
                    ' -config "' + Opt.ConfigFile + '"' + Parametros), PChar(Lang_DGL(13)), MB_OK);

{EXECUTA}
ShellExecute(0, 'open', PChar(Opt.Executable), PChar(BaseParams +
                                                     ' ' + Opt.SkinParams +
                                                     ' ' + Opt.ModParams +
                                            ' -config "' + Opt.ConfigFile + '"' + Parametros), PChar(Opt.WorkingDir), SW_NORMAL);

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.

