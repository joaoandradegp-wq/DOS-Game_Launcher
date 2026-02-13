unit ZDOOM_Bind;

interface

uses Teclado_Mouse;

//---------------------
type
TGameFlags = record
  TemFreelook: Boolean;
  TemCrouch: Boolean;
  TemJump: Boolean;
  UsaClasse: Boolean;
end;
//---------------------

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
function GetGameFlags(id: Integer): TGameFlags;
procedure ApplyGlobalZDoomSettings(Ini: TMemIniFile; id: Integer; MouseAtivo: Boolean);
procedure ZDOOM_Controle_Teclado(Ini: TMemIniFile; Section: String);
procedure ZDOOM_Controle_Mouse(Ini: TMemIniFile; Section: String; Flags: TGameFlags);
procedure AplicaZDOOMOpcoes(Ini: TMemIniFile; id: Integer; MouseAtivo: Boolean);
procedure AplicaHexenClass(Ini: TMemIniFile);
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------

implementation

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
function GetGameFlags(id: Integer): TGameFlags;
begin
  case id of
    3: Result := (TemFreelook: True; TemCrouch: True; TemJump: True; UsaClasse: False);
    6: Result := (TemFreelook: True; TemCrouch: False; TemJump: False; UsaClasse: False);
    7: Result := (TemFreelook: True; TemCrouch: False; TemJump: False; UsaClasse: True);
12,13: Result := (TemFreelook: False; TemCrouch: False; TemJump: False; UsaClasse: False);
  else
  Result := Default(TGameFlags);
  end;

end;
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
procedure ApplyGlobalZDoomSettings(Ini: TMemIniFile; id: Integer; MouseAtivo: Boolean);
var Flags: TGameFlags;
begin
Flags := GetGameFlags(id);

Ini.WriteBool('GlobalSettings', 'vid_fullscreen', not menu_debug.Checked);
Ini.WriteBool('GlobalSettings', 'vid_vsync', not menu_debug.Checked);

  if menu_debug.Checked then
  begin
  Ini.WriteInteger('GlobalSettings', 'vid_defwidth', 640);
  Ini.WriteInteger('GlobalSettings', 'vid_defheight', 480);
  end
  else
  begin
  Ini.WriteInteger('GlobalSettings', 'vid_defwidth', Screen.Width);
  Ini.WriteInteger('GlobalSettings', 'vid_defheight', Screen.Height);
  end;

Ini.WriteBool   ('GlobalSettings', 'freelook', Flags.TemFreelook and RxControle.StateOn);
Ini.WriteInteger('GlobalSettings', 'mouse_sensitivity', 150);
Ini.WriteString ('GlobalSettings', 'save_dir', Caminho_Global);
Ini.WriteString ('GlobalSettings', 'defaultiwad', ExtractName(Array_Games[id][4]));
Ini.WriteBool   ('GlobalSettings', 'queryiwad', False);
Ini.WriteString ('GlobalSettings', 'language', 'enu');

  if MouseAtivo then
  Ini.WriteInteger('GlobalSettings', 'autoaim', 0)
  else
  Ini.WriteInteger('GlobalSettings', 'autoaim', 35);

end;
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
procedure ZDOOM_Controle_Teclado(Ini: TMemIniFile; Section: String);
begin
  Ini.WriteString(Section, 'ctrl', '+attack');
  Ini.WriteString(Section, 'shift', '+speed');
  Ini.WriteString(Section, 'alt', '+strafe');
  Ini.WriteString(Section, 'space', '+use');
  Ini.WriteString(Section, 'capslock', 'toggle cl_run');
  Ini.WriteString(Section, 'uparrow', '+forward');
  Ini.WriteString(Section, 'leftarrow', '+left');
  Ini.WriteString(Section, 'rightarrow', '+right');
  Ini.WriteString(Section, 'downarrow', '+back');
end;
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
procedure ZDOOM_Controle_Mouse(Ini: TMemIniFile; Section: String; Flags: TGameFlags);
begin
  Ini.WriteString(Section, 'mouse1', '+attack');
  Ini.WriteString(Section, 'mwheelup', 'weapprev');
  Ini.WriteString(Section, 'mwheeldown', 'weapnext');

  Ini.WriteString(Section, 'w', '+forward');
  Ini.WriteString(Section, 'a', '+moveleft');
  Ini.WriteString(Section, 's', '+back');
  Ini.WriteString(Section, 'd', '+moveright');
  Ini.WriteString(Section, 'e', '+use');

  if Flags.TemCrouch then
  Ini.WriteString(Section, 'c', '+crouch');

  if Flags.TemJump then
  Ini.WriteString(Section, 'mouse2', '+jump');

end;
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
procedure AplicaZDOOMOpcoes(Ini: TMemIniFile; id: Integer; MouseAtivo: Boolean);
var Section: String;
Flags: TGameFlags;
begin
Flags := GetGameFlags(id);

  case id of
      3: Section := 'Doom.Bindings';
      6: Section := 'Heretic.Bindings';
      7: Section := 'Hexen.Bindings';
  11,12: Section := 'Doom.Bindings';
  end;

  Ini.WriteString(Section, 'tab', 'togglemap');
  Ini.WriteString(Section, 't', 'messagemode');
  Ini.WriteString(Section, '-', 'sizedown');
  Ini.WriteString(Section, 'Equals', 'sizeup');

  if MouseAtivo then
  ZDOOM_Controle_Mouse(Ini, Section, Flags)
  else
  ZDOOM_Controle_Teclado(Ini, Section);

end;
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
procedure AplicaHexenClass(Ini: TMemIniFile);
begin
Application.CreateForm(TForm2_DLC, Form2_DLC);
Form2_DLC.ShowModal;
Form2_DLC.Free;

  if Fecha_ESC then Exit;

  case EPI_Global_DLC of
  1: Ini.WriteString('GlobalSettings', 'playerclass', 'Fighter');
  2: Ini.WriteString('GlobalSettings', 'playerclass', 'Cleric');
  3: Ini.WriteString('GlobalSettings', 'playerclass', 'Mage');
  end;
end;
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
procedure ConfigureZDoom(id: Integer);
var Ini: TMemIniFile;
    Flags: TGameFlags;
begin
  Flags := GetGameFlags(id);

  Ini := TMemIniFile.Create(Config_Game_Global);
  try
    ApplyGlobalZDoomSettings(Ini, id);
    ApplyGameBindings(Ini, id);

    if Flags.UsaClasse then
      ApplyHexenClass(Ini);

    Ini.WriteString('GlobalSettings', 'name', Trim(player_name.Text));

    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
end.
