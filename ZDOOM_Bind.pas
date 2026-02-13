unit ZDOOM_Bind;

interface

uses IniFiles, SysUtils, Forms, Unit1, Unit2, Dialogs;

//----------------------------
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
//----------------------------

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
function GetCVarSection(id: Integer): String;
procedure ConfigureZDoom(id: Integer; MouseAtivo, Debug: Boolean; PlayerName, ConfigFile, IWADFile: String; SinglePlayer: Boolean; DoomSkinIndex: Integer; DoomColorIndex: Integer; ScreenWidth: Integer; ScreenHeight: Integer);
function AspectRatio(W, H: Integer): Integer;
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------

implementation

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
    3,4: // DOOM
    begin
    Result.TemFreelook := True;
    Result.TemCrouch   := True;
    Result.TemJump     := True;
    Result.UsaMapLabel := True;
    end;

    6: // HERETIC
    begin
    Result.TemFreelook := True;
    Result.UsaMapBackground := True;
    Result.UsaMapColorset   := True;
    Result.UsaMapLabel := True;
    end;

    7: // HEXEN
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

  // CONFIGURAÇÃO DE VÍDEO
  if Debug then
  begin
  Ini.WriteInteger(CVarSection, 'vid_aspect', 0);
  Ini.WriteBool   (CVarSection, 'vid_vsync', False);
  Ini.WriteInteger(CVarSection, 'vid_defwidth', 640);
  Ini.WriteInteger(CVarSection, 'vid_defheight', 480);
  end
  else
  begin
  Ini.WriteInteger(CVarSection, 'vid_aspect',AspectRatio(ScreenWidth, ScreenHeight));
  Ini.WriteBool   (CVarSection, 'vid_vsync', True);
  Ini.WriteInteger(CVarSection, 'vid_defwidth', ScreenWidth);
  Ini.WriteInteger(CVarSection, 'vid_defheight', ScreenHeight);
  end;

Ini.WriteBool  (CVarSection,   'freelook', Flags.TemFreelook and MouseAtivo);
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
procedure ApplyDoomSkin(Ini: TMemIniFile; SinglePlayer: Boolean; SkinIndex, ColorIndex: Integer);
var
PlayerSection: String;
begin
PlayerSection:=GetPlayerSection(id);

  if SinglePlayer then Exit;

  case SkinIndex of
    0:
    begin
      Ini.WriteString (PlayerSection, 'skin', 'base');
      Ini.WriteInteger(PlayerSection, 'colorset', ColorIndex);
    end;

    1:
    begin
      Ini.WriteString(PlayerSection, 'skin', 'Phobos');
      Ini.WriteString(PlayerSection, 'colorset', '-1');
      Ini.WriteString(PlayerSection, 'color', 'ff 50 00');
    end;
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureZDoom(id: Integer; MouseAtivo, Debug: Boolean; PlayerName, ConfigFile, IWADFile: String; SinglePlayer: Boolean; DoomSkinIndex: Integer; DoomColorIndex: Integer; ScreenWidth: Integer; ScreenHeight: Integer);
var
Ini: TMemIniFile;
Flags: TGameFlags;
Section: String;
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

    if id = 7 then
    begin
    Application.CreateForm(TForm2_DLC, Form2_DLC);
    Form2_DLC.ShowModal;
    Form2_DLC.Free;

      if Fecha_ESC then
      Exit;

      if Flags.UsaClasse then
      ApplyHexenClass(Ini, EPI_Global_DLC);
    end;

  ApplyDoomSkin(Ini, SinglePlayer, DoomSkinIndex, DoomColorIndex);

  Ini.UpdateFile;
  finally
  Ini.Free;
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.

