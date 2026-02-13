unit DOSBOX_Bind;

interface

uses Classes, SysUtils, Teclado_Mouse, Funcoes;

//------------------------------------------------------------------------------
const DOSBOX_Video: array[0..2] of TRegra = (
  (Chave: 'ScreenMode = ';   Valor: 'ScreenMode = 1'),
  (Chave: 'ScreenWidth = ';  Valor: 'ScreenWidth = 640'),
  (Chave: 'ScreenHeight = '; Valor: 'ScreenHeight = 480')
);
//------------------------------------------------------------------------------
const DOSBOX_Som_Comum: array[0..11] of TRegra = (
  (Chave: 'FXDevice = ';          Valor: 'FXDevice = 0'),
  (Chave: 'MusicDevice = ';       Valor: 'MusicDevice = 7'),
  (Chave: 'MusicVolume = ';       Valor: 'MusicVolume = 200'),
  (Chave: 'NumChannels = ';       Valor: 'NumChannels = 2'),
  (Chave: 'NumBits = ';           Valor: 'NumBits = 16'),
  (Chave: 'MidiPort = ';          Valor: 'MidiPort = 0x330'),
  (Chave: 'BlasterAddress = ';    Valor: 'BlasterAddress = 0x220'),
  (Chave: 'BlasterType = ';       Valor: 'BlasterType = 6'),
  (Chave: 'BlasterInterrupt = ';  Valor: 'BlasterInterrupt = 7'),
  (Chave: 'BlasterDma8 = ';       Valor: 'BlasterDma8 = 1'),
  (Chave: 'BlasterDma16 = ';      Valor: 'BlasterDma16 = 5'),
  (Chave: 'BlasterEmu = ';        Valor: 'BlasterEmu = 0x620')
);
//------------------------------------------------------------------------------
const DOSBOX_Som_Padrao: array[0..2] of TRegra = (
  (Chave: 'FXVolume = ';  Valor: 'FXVolume = 220'),
  (Chave: 'MixRate = ';   Valor: 'MixRate = 44000'),
  (Chave: 'NumVoices = '; Valor: 'NumVoices = 32')
);
//------------------------------------------------------------------------------
const DOSBOX_Duke: array[0..0] of TRegra = (
  (Chave: 'NumVoices = '; Valor: 'NumVoices = 8')
);
//------------------------------------------------------------------------------
const DOSBOX_Shadow: array[0..4] of TRegra = (
  (Chave: 'FXVolume = '; Valor: 'FXVolume = 160'),
  (Chave: 'MixRate = ';  Valor: 'MixRate = 22000'),
  (Chave: 'NumVoices = ';Valor: 'NumVoices = 32'),
  (Chave: 'FxOn = ';     Valor: 'FxOn = 1'),
  (Chave: 'MusicOn = ';  Valor: 'MusicOn = 1')
);
//------------------------------------------------------------------------------
const DOSBOX_Controle_Teclado: array[0..1] of TRegra = (
  (Chave: 'ControllerType = ';   Valor: 'ControllerType = 0'),
  (Chave: 'ExternalFilename = '; Valor: 'ExternalFilename = "EXTERNAL.EXE"')
);
//------------------------------------------------------------------------------
const DOSBOX_Controle_Mouse_Base: array[0..5] of TRegra = (
  (Chave: 'ControllerType = ';       Valor: 'ControllerType = 3'),
  (Chave: 'ExternalFilename = ';     Valor: 'ExternalFilename = "BMOUSE.EXE"'),
  (Chave: 'MouseAiming = ';          Valor: 'MouseAiming = 0'),
  (Chave: 'MouseAimingFlipped = ';   Valor: 'MouseAimingFlipped = 0'),
  (Chave: 'MouseButton1 = ';         Valor: 'MouseButton1 = "Jump"'),
  (Chave: 'MouseButton2 = ';         Valor: 'MouseButton2 = ""')
);
//------------------------------------------------------------------------------
const DOSBOX_Mouse_Blood: array[0..1] of TRegra = (
  (Chave: 'MouseButton0 = '; Valor: 'MouseButton0 = "Weapon_Fire"'),
  (Chave: 'MouseButton2 = '; Valor: 'MouseButton2 = "Weapon_Special_Fire"')
);
//------------------------------------------------------------------------------
const DOSBOX_Mouse_Padrao: array[0..0] of TRegra = (
  (Chave: 'MouseButton0 = '; Valor: 'MouseButton0 = "Fire"')
);
//------------------------------------------------------------------------------
const Blood_Options_Base: array[0..4] of TRegra = (
  (Chave:'Size = ';        Valor:'Size = 1'),
  (Chave:'Gamma = ';       Valor:'Gamma = 0'),
  (Chave:'Detail = ';      Valor:'Detail = 4'),
  (Chave:'AimReticle = ';  Valor:'AimReticle = 1'),
  (Chave:'MouseAim = ';    Valor:'')  // valor dinâmico
);
//------------------------------------------------------------------------------
const Constructor_Config_Base: array[0..1] of TRegra = (
  (Chave:'AlwaysShowFlic='; Valor:'AlwaysShowFlic=No'),
  (Chave:'CDFlics=';        Valor:'CDFlics=No')
);
//------------------------------------------------------------------------------
const Duke3D_Config_Base: array[0..6] of TRegra = (
  (Chave: 'Shadows = ';     Valor: 'Shadows = 1'),
  (Chave: 'Password = ';    Valor: 'Password = ""'),
  (Chave: 'Detail = ';      Valor: 'Detail = 1'),
  (Chave: 'Tilt = ';        Valor: 'Tilt = 1'),
  (Chave: 'ScreenSize = ';  Valor: 'ScreenSize = 4'),
  (Chave: 'ScreenGamma = '; Valor: 'ScreenGamma = 0'),
  (Chave: 'Crosshairs = ';  Valor: 'Crosshairs = 1')
);
//------------------------------------------------------------------------------
const ShadowWarrior_Config_Base: array[0..4] of TRegra = (
  (Chave: 'BorderNum = ';   Valor: 'BorderNum = 1'),
  (Chave: 'Brightness = ';  Valor: 'Brightness = 1'),
  (Chave: 'Shadows = ';     Valor: 'Shadows = 1'),
  (Chave: 'Crosshair = ';   Valor: 'Crosshair = 1'),
  (Chave: 'MouseInvert = '; Valor: 'MouseInvert = 1')
);
//------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
procedure AplicaBloodOpcoes(i: Integer; Linhas: TStrings; MouseAtivo: Boolean);
function ParametrosBlood(MouseAtivo, SinglePlayer: Boolean): string;
procedure AplicaConstructor_Linguagem(i: Integer; Linhas: TStrings);
procedure AplicaConstructor_Multiplayer(i: Integer; Linhas: TStrings; SinglePlayer: Boolean; NomeJogador: string);
procedure AplicaConstructor(i: Integer; Linhas: TStrings; SinglePlayer: Boolean; NomeJogador: string);
procedure AplicaDukeOpcoes(i: Integer; Linhas: TStrings; MouseAtivo: Boolean);
procedure AplicaROTOpcoes(i: Integer; Linhas: TStrings; SinglePlayer: Boolean; NomeJogador: string; NumJogadores: string);
procedure AplicaShadowWarriorOpcoes(i: Integer; Linhas: TStrings; MouseAtivo: Boolean; SinglePlayer: Boolean);
//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------

implementation

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaBloodOpcoes(i: Integer; Linhas: TStrings; MouseAtivo: Boolean);
begin
  AplicaRegras(i, Blood_Options_Base, Linhas);

  if Pos('MouseAim = ', Linhas[i]) = 1 then
  begin
    if MouseAtivo then
      Linhas[i] := 'MouseAim = 1'
    else
      Linhas[i] := 'MouseAim = 0';
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function ParametrosBlood(MouseAtivo, SinglePlayer: Boolean): string;
begin
  Result := '';

  if MouseAtivo then
    Result := Result + ' -noaim';

  if SinglePlayer then
    Result := Result + ' -ini PHOBOS.ini'
  else
    Result := Result + ' -ini BLOOD.ini -broadcast';
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaConstructor_Linguagem(i: Integer; Linhas: TStrings);
begin
  if Pos('TextLanguage=', Linhas[i]) = 1 then
  begin
    if GetLanguageWin = 'por' then
      Linhas[i] := 'TextLanguage=5'
    else
      Linhas[i] := 'TextLanguage=0';
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaConstructor_Multiplayer(i: Integer; Linhas: TStrings; SinglePlayer: Boolean; NomeJogador: string);
begin
  if SinglePlayer then Exit;

  if Pos('PlayerName=', Linhas[i]) = 1 then
    Linhas[i] := 'PlayerName=' + NomeJogador;

  if Pos('GameName=', Linhas[i]) = 1 then
    Linhas[i] := 'GameName=' + NomeJogador;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaConstructor(i: Integer; Linhas: TStrings; SinglePlayer: Boolean; NomeJogador: string);
begin
  AplicaRegras(i, Constructor_Config_Base, Linhas);
  AplicaConstructor_Linguagem(i, Linhas);
  AplicaConstructor_Multiplayer(i, Linhas, SinglePlayer, NomeJogador);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaDukeOpcoes(i: Integer; Linhas: TStrings; MouseAtivo: Boolean);
begin
  AplicaRegras(i, Duke3D_Config_Base, Linhas);

  if Pos('GameMouseAiming = ', Linhas[i]) = 1 then
  begin
    if MouseAtivo then
      Linhas[i] := 'GameMouseAiming = 1'
    else
      Linhas[i] := 'GameMouseAiming = 0';
  end;

  if Pos('AimingFlag = ', Linhas[i]) = 1 then
  begin
    if MouseAtivo then
      Linhas[i] := 'AimingFlag = 1'
    else
      Linhas[i] := 'AimingFlag = 0';
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaROTOpcoes(i: Integer; Linhas: TStrings; SinglePlayer: Boolean; NomeJogador: string; NumJogadores: string);
begin
  if SinglePlayer then Exit;

  if Pos('CODENAME', Linhas[i]) = 1 then
    Linhas[i] := 'CODENAME            ' + NomeJogador;

  if Pos('NUMPLAYERS', Linhas[i]) = 1 then
    Linhas[i] := 'NUMPLAYERS          ' + NumJogadores;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaShadowWarriorOpcoes(i: Integer; Linhas: TStrings; MouseAtivo: Boolean; SinglePlayer: Boolean);
begin
  AplicaRegras(i, ShadowWarrior_Config_Base, Linhas);

  if not SinglePlayer then
  begin
    if Pos('NetGameType = ', Linhas[i]) = 1 then
      Linhas[i] := 'NetGameType = 2';

    if Pos('NetMonsters = ', Linhas[i]) = 1 then
      Linhas[i] := 'NetMonsters = 2';

    if Pos('NetHurtTeammate = ', Linhas[i]) = 1 then
      Linhas[i] := 'NetHurtTeammate = 2';
  end;

  if Pos('AutoAim = ', Linhas[i]) = 1 then
  begin
    if MouseAtivo then
      Linhas[i] := 'AutoAim = 0'
    else
      Linhas[i] := 'AutoAim = 1';
  end;

  if Pos('MouseAimingOn = ', Linhas[i]) = 1 then
  begin
    if MouseAtivo then
      Linhas[i] := 'MouseAimingOn = 1'
    else
      Linhas[i] := 'MouseAimingOn = 0';
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.
 