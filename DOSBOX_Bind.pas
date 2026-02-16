unit DOSBOX_Bind;

interface

uses Classes, SysUtils, Teclado_Mouse, Funcoes;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
const
  GAME_BLOOD       = 1;
  GAME_CONSTRUCTOR = 2;
  GAME_DUKE3D      = 5;
  GAME_ROT         = 9;
  GAME_SHADOW      = 10;
  GAME_WARCRAFT2   = 11;

  GROUP_BUILD_ENGINE: array[0..2] of Integer = (GAME_BLOOD, GAME_DUKE3D, GAME_SHADOW);

//------------------------------------------------------------------------------
// DOSBOX BASE
//------------------------------------------------------------------------------
const DOSBOX_Config_Geral: array[0..4] of TRegra = (
  (Chave:'aspect=';    Valor:'aspect=true'),
  (Chave:'scaler=';    Valor:'scaler=normal2x'),
  (Chave:'core=';      Valor:'core=dynamic'),
  (Chave:'cycles=';    Valor:'cycles=max 105%'),
  (Chave:'prebuffer='; Valor:'prebuffer=20')
);

const DOSBOX_Config_BuildEngine: array[0..1] of TRegra = (
  (Chave:'fullresolution='; Valor:'fullresolution=0x0'),
  (Chave:'machine=';        Valor:'machine=vesa_nolfb')
);

const DOSBOX_Mem_Default: array[0..0] of TRegra = (
  (Chave:'memsize='; Valor:'memsize=64')
);

const DOSBOX_Mem_Constructor: array[0..0] of TRegra = (
  (Chave:'memsize='; Valor:'memsize=32')
);
//------------------------------------------------------------------------------
// SOM
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

const DOSBOX_Som_Padrao: array[0..2] of TRegra = (
  (Chave: 'FXVolume = ';  Valor: 'FXVolume = 220'),
  (Chave: 'MixRate = ';   Valor: 'MixRate = 44000'),
  (Chave: 'NumVoices = '; Valor: 'NumVoices = 32')
);

const DOSBOX_Duke: array[0..0] of TRegra = (
  (Chave: 'NumVoices = '; Valor: 'NumVoices = 8')
);

const DOSBOX_Shadow: array[0..4] of TRegra = (
  (Chave: 'FXVolume = '; Valor: 'FXVolume = 160'),
  (Chave: 'MixRate = ';  Valor: 'MixRate = 22000'),
  (Chave: 'NumVoices = ';Valor: 'NumVoices = 32'),
  (Chave: 'FxOn = ';     Valor: 'FxOn = 1'),
  (Chave: 'MusicOn = ';  Valor: 'MusicOn = 1')
);
//------------------------------------------------------------------------------
// CONTROLES
//------------------------------------------------------------------------------
const DOSBOX_Controle_Teclado: array[0..1] of TRegra = (
  (Chave: 'ControllerType = ';   Valor: 'ControllerType = 0'),
  (Chave: 'ExternalFilename = '; Valor: 'ExternalFilename = "EXTERNAL.EXE"')
);

const DOSBOX_Controle_Mouse: array[0..5] of TRegra = (
  (Chave: 'ControllerType = ';       Valor: 'ControllerType = 3'),
  (Chave: 'ExternalFilename = ';     Valor: 'ExternalFilename = "BMOUSE.EXE"'),
  (Chave: 'MouseAiming = ';          Valor: 'MouseAiming = 0'),
  (Chave: 'MouseAimingFlipped = ';   Valor: 'MouseAimingFlipped = 0'),
  (Chave: 'MouseButton1 = ';         Valor: 'MouseButton1 = "Jump"'),
  (Chave: 'MouseButton2 = ';         Valor: 'MouseButton2 = ""')
);

const DOSBOX_Mouse_Blood: array[0..1] of TRegra = (
  (Chave: 'MouseButton0 = '; Valor: 'MouseButton0 = "Weapon_Fire"'),
  (Chave: 'MouseButton2 = '; Valor: 'MouseButton2 = "Weapon_Special_Fire"')
);

const DOSBOX_Mouse_Default: array[0..0] of TRegra = (
  (Chave: 'MouseButton0 = '; Valor: 'MouseButton0 = "Fire"')
);

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaDOSBOX_Tudo(i: Integer; Linhas: TStrings; GameID: Integer; SinglePlayer: Boolean; DebugMode: Boolean; MouseAtivo: Boolean; NomeJogador: string; NumJogadores: string);
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

implementation

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function GameInGroup(GameID: Integer; const Grupo: array of Integer): Boolean;
var
j: Integer;
begin
Result := False;

  for j := Low(Grupo) to High(Grupo) do
    if Grupo[j] = GameID then
    begin
    Result := True;
    Exit;
    end;
    
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaConfigDOSBOX(i: Integer; Linhas: TStrings; GameID: Integer; SinglePlayer: Boolean; DebugMode: Boolean);
begin
AplicaRegras(i, DOSBOX_Config_Geral, Linhas);

  if Pos('fullscreen=', Linhas[i]) = 1 then
  begin
    if (not SinglePlayer) and ((GameID = GAME_ROT) or (GameID = GAME_WARCRAFT2)) then
    Linhas[i] := 'fullscreen=false'
    else
    Linhas[i] := 'fullscreen=' + BoolToStr(not DebugMode);
  end;

  if GameInGroup(GameID, GROUP_BUILD_ENGINE) then
  AplicaRegras(i, DOSBOX_Config_BuildEngine, Linhas);

  if Pos('output=', Linhas[i]) = 1 then
  begin
    if ProcessExists('igfxTray.exe') then
    Linhas[i] := 'output=opengl'
    else
    Linhas[i] := 'output=overlay';
  end;

  if GameID = GAME_CONSTRUCTOR then
  AplicaRegras(i, DOSBOX_Mem_Constructor, Linhas)
  else
  AplicaRegras(i, DOSBOX_Mem_Default, Linhas);

  if Pos('ipx=', Linhas[i]) = 1 then
  begin
    if SinglePlayer then
    Linhas[i] := 'ipx=false'
    else
    Linhas[i] := 'Enable=1'+#13#10+'Connection=1'+#13#10+'ipx=true';
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaOpcoesJogo(i: Integer; Linhas: TStrings; GameID: Integer; SinglePlayer: Boolean; MouseAtivo: Boolean; NomeJogador: string; NumJogadores: string);
begin

  case GameID of
  //------------------------------------------------------------------------------
    GAME_BLOOD:
      if Pos('MouseAim = ', Linhas[i]) = 1 then
      begin
        if MouseAtivo then
        Linhas[i] := 'MouseAim = 1'
        else
        Linhas[i] := 'MouseAim = 0';
      end;
  //------------------------------------------------------------------------------
    GAME_CONSTRUCTOR:
    begin
      if Pos('TextLanguage=', Linhas[i]) = 1 then
        if GetLanguageWin = 'por' then
        Linhas[i] := 'TextLanguage=5'
        else
        Linhas[i] := 'TextLanguage=0';

      if not SinglePlayer then
      begin
        if Pos('PlayerName=', Linhas[i]) = 1 then
        Linhas[i] := 'PlayerName=' + Trim(NomeJogador);

        if Pos('GameName=', Linhas[i]) = 1 then
        Linhas[i] := 'GameName=' + Trim(NomeJogador);
      end;
    end;
  //------------------------------------------------------------------------------
    GAME_DUKE3D:
    begin
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
    GAME_ROT:
      if not SinglePlayer then
      begin
        if Pos('CODENAME', Linhas[i]) = 1 then
        Linhas[i] := 'CODENAME            ' + Trim(NomeJogador);

        if Pos('NUMPLAYERS', Linhas[i]) = 1 then
        Linhas[i] := 'NUMPLAYERS          ' + Trim(NumJogadores);
      end;
  //------------------------------------------------------------------------------
    GAME_SHADOW:
    begin
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
  end;
  
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaDOSBOX_Tudo(i: Integer; Linhas: TStrings; GameID: Integer; SinglePlayer: Boolean; DebugMode: Boolean; MouseAtivo: Boolean; NomeJogador: string; NumJogadores: string);
begin
AplicaConfigDOSBOX(i, Linhas, GameID, SinglePlayer, DebugMode);

  if MouseAtivo then
  begin
  AplicaRegras(i, DOSBOX_Controle_Mouse, Linhas);

    if GameID = GAME_BLOOD then
    AplicaRegras(i, DOSBOX_Mouse_Blood, Linhas)
    else
    AplicaRegras(i, DOSBOX_Mouse_Default, Linhas);

  end
  else
  AplicaRegras(i, DOSBOX_Controle_Teclado, Linhas);
  AplicaRegras(i, DOSBOX_Som_Comum, Linhas);

  //------------------------------------------------------------------------------
  case GameID of
    GAME_DUKE3D: AplicaRegras(i, DOSBOX_Duke, Linhas);
    GAME_SHADOW: AplicaRegras(i, DOSBOX_Shadow, Linhas);
  else
  AplicaRegras(i, DOSBOX_Som_Padrao, Linhas);
  end;
  //------------------------------------------------------------------------------

AplicaOpcoesJogo(i, Linhas, GameID, SinglePlayer, MouseAtivo, NomeJogador, NumJogadores);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.

