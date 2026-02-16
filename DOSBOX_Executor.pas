unit DOSBOX_Executor;

interface

uses Classes, SysUtils, Windows, Forms, Funcoes, Language, Unit1;

//------------------------------------------------------------------------------
// EXECUTOR PRINCIPAL
//------------------------------------------------------------------------------
procedure ExecutaJogoDOSBOX(
  id: Integer;
  SinglePlayer: Boolean;
  DebugMode: Boolean;
  UsaMouseWrapper: Boolean;
  CaminhoJogo: string;
  CaminhoExe: string;
  var GameExe: string;
  var Parametros: string;
  PortaIPX: string;
  IPRemoto: string;
  IniciarServidor: Boolean;
  IniciarCliente: Boolean;
  NumJogadores: string;
  Linhas: TStrings
);
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

implementation


var
  AutoExecWriter: procedure(const S: string);
  LinhasGlobal: TStrings;
  PosAutoExecGlobal: Integer;

procedure WriteAutoExecGlobal(const S: string);
begin
  if Assigned(LinhasGlobal) then
  begin
    LinhasGlobal.Insert(PosAutoExecGlobal, S);
    Inc(PosAutoExecGlobal);
  end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AUTOEXEC_BuildEngine_Base(CaminhoExe: string;SinglePlayer: Boolean;var Parametros: string;Linhas: TStrings);
begin
AutoExecWriter('cd "' + CaminhoExe + '"');

  if Parametros <> '' then
  Parametros := ' ' + Trim(Parametros);

  if not SinglePlayer then
    if not FileExists(CaminhoExe + 'commit.dat') then
    AutoExecWriter('echo Criando commit.dat padrão');

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AUTOEXEC_Blood(SinglePlayer: Boolean;DebugMode: Boolean;CaminhoExe: string;var GameExe: string;NumJogadores: string);
var
Arquivo_COMMIT: TStringList;
begin

  if not SinglePlayer then
  begin
  Arquivo_COMMIT := TStringList.Create;

    try
    Arquivo_COMMIT.LoadFromFile(CaminhoExe + 'commit.dat');

      if Arquivo_COMMIT[24] = '; - GAMECONNECTION - 4' then
      Arquivo_COMMIT.Delete(24);

    Arquivo_COMMIT[26] := 'NUMPLAYERS = ' + NumJogadores;
    Arquivo_COMMIT[33] := 'LAUNCHNAME = "' + GameExe + '"';

    Arquivo_COMMIT.SaveToFile(CaminhoExe + 'commit.dat');
    finally
    Arquivo_COMMIT.Free;
    end;

  end;

  if (not SinglePlayer) and DebugMode then
  begin
    if FileExists(CaminhoExe + 'cryptic.exe') then
    GameExe := 'cpmulti.exe'
    else
    GameExe := 'setup.exe';
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AUTOEXEC_Duke3D(SinglePlayer: Boolean;DebugMode: Boolean;CaminhoExe: string;var GameExe: string;var Parametros: string;NumJogadores: string);
var
Arquivo_COMMIT: TStringList;
begin

  if not SinglePlayer then
  begin
    Arquivo_COMMIT := TStringList.Create;

    try
    Arquivo_COMMIT.LoadFromFile(CaminhoExe + 'commit.dat');

      if Arquivo_COMMIT[24] = '; - GAMECONNECTION - 4' then
      Arquivo_COMMIT.Delete(24);

    Arquivo_COMMIT[26] := 'NUMPLAYERS = ' + NumJogadores;
    Arquivo_COMMIT[33] := 'LAUNCHNAME = "' + GameExe + '"';

    Arquivo_COMMIT.SaveToFile(CaminhoExe + 'commit.dat');
    finally
    Arquivo_COMMIT.Free;
    end;

  end;

  if (not SinglePlayer) and DebugMode then
  GameExe := 'setup.exe';

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AUTOEXEC_ShadowWarrior(
  Linhas: TStrings;
  SinglePlayer: Boolean;
  DebugMode: Boolean;
  CaminhoJogo: string;
  var GameExe: string;
  var Parametros: string;
  NumJogadores: string;
  SW_ExeDLC: string;
  SW_ArquivoCOPY: string
);
begin

  if SinglePlayer then
  begin
    //-------------------------------------------------------
    case EPI_Global_DLC of
      0,1: AutoExecWriter('@COPY sw.dat sw.exe');
      2:   AutoExecWriter('@COPY ' + SW_ArquivoCOPY + ' sw.exe');
      3: begin
         GameExe := SW_ExeDLC;
           if SW_ExeDLC = 'sw.exe' then
           AutoExecWriter('cd dragon');
         end;
    end;
    //-------------------------------------------------------
  end
  else
  begin

    case EPI_Global_DLC of
      1: AutoExecWriter('@COPY sw.dat sw.exe');
      2: AutoExecWriter('@COPY ' + SW_ArquivoCOPY + ' sw.exe');
    end;

    with TStringList.Create do
    try
    LoadFromFile(CaminhoJogo + 'commit.dat');

      if Strings[24] = '; - GAMECONNECTION - 4' then
      Delete(24);

    Strings[26] := 'NUMPLAYERS = ' + NumJogadores;

      if EPI_Global_DLC = 3 then
      Strings[33] := 'LAUNCHNAME = "' + SW_ExeDLC + '"'
      else
      Strings[33] := 'LAUNCHNAME = "' + GameExe + '"';

    SaveToFile(CaminhoJogo + 'commit.dat');
    finally
    Free;
    end;

  end;

  if (not SinglePlayer) and DebugMode then
  begin

    if EPI_Global_DLC = 3 then
    begin

      if SW_ExeDLC = 'sw.exe' then
      begin
      AutoExecWriter('cd dragon');
      GameExe := 'setup.exe';
      end
      else
      begin
      MessageBox(Application.Handle, pchar(Parametros), pchar(Lang_DGL(6)), MB_ICONINFORMATION+MB_OK);
      GameExe := 'commit.exe';
      end;

    end;

  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ExecutaJogoDOSBOX(
  id: Integer;
  SinglePlayer: Boolean;
  DebugMode: Boolean;
  UsaMouseWrapper: Boolean;
  CaminhoJogo: string;
  CaminhoExe: string;
  var GameExe: string;
  var Parametros: string;
  PortaIPX: string;
  IPRemoto: string;
  IniciarServidor: Boolean;
  IniciarCliente: Boolean;
  NumJogadores: string;
  Linhas: TStrings
);
var
  SW_ExeDLC: string;
  SW_ArquivoCOPY: string;
  i, idx: Integer;
  PosAutoExec: Integer;
  AutoExecExiste: Boolean;
begin
PosAutoExecGlobal := PosAutoExec; // índice calculado anteriormente
LinhasGlobal := Linhas;
AutoExecWriter := WriteAutoExecGlobal;


  //--------------------------------------------------
// GARANTE [autoexec] LIMPO E POSIÇÃO CORRETA
//--------------------------------------------------
PosAutoExec := -1;


for i := 0 to Linhas.Count - 1 do
  if Trim(Linhas[i]) = '[autoexec]' then
  begin
    // limpa conteúdo existente
    idx := i + 1;
    while (idx < Linhas.Count) and (Trim(Linhas[idx]) <> '') do
      Linhas.Delete(idx);

    PosAutoExec := i + 1; // posição correta após limpar
    Break;
  end;

if PosAutoExec = -1 then
begin
  AutoExecWriter('');
  AutoExecWriter('[autoexec]');
  PosAutoExec := Linhas.Count;
end;

  //--------------------------------------------------
  // SCRIPT DOSBOX
  //--------------------------------------------------
  if not DebugMode then
    AutoExecWriter('@ECHO OFF');

  if not DirectoryExists(CaminhoExe) then
    Exit;

  AutoExecWriter('mount c "' + CaminhoExe + '"');

  if id = 11 then
    AutoExecWriter('mount d "' + CaminhoJogo + '" -t cdrom');

  AutoExecWriter('c:');

  if not DebugMode then
    AutoExecWriter('cls');

  //--------------------------------------------------
  // REDE IPX
  //--------------------------------------------------
  if not SinglePlayer then
  begin
    if IniciarServidor then
      AutoExecWriter('ipxnet startserver ' + PortaIPX);

    if IniciarCliente then
      AutoExecWriter('ipxnet connect ' + IPRemoto + ' ' + PortaIPX);
  end;

  //--------------------------------------------------
  // IMGMOUNT ESPECÍFICOS
  //--------------------------------------------------
  case id of
    1: if FileExists(CaminhoExe + 'game.ins') then
         AutoExecWriter('imgmount d game.ins -t iso');

    2: if FileExists(CaminhoExe + 'const.gog') then
         AutoExecWriter('imgmount d "const.gog" -t iso -fs iso');

   10: if FileExists(CaminhoExe + 'GAME.DAT') then
         AutoExecWriter('imgmount d "..\GAME.DAT" -t iso');
  end;

  //------------------------------------------------------
  // BUILD ENGINE PIPELINE
  //------------------------------------------------------
  if id in [1,5,10] then
  begin
    if SinglePlayer then
    begin
      Seleciona_Fases;
      if Fecha_ESC then Exit;

      if id in [5,10] then
        Parametros := ' ' + Map_Global;
    end;

    AUTOEXEC_BuildEngine_Base(CaminhoExe, SinglePlayer, Parametros, Linhas);

    SW_ExeDLC := SW_DLC_Archive(2);
    SW_ArquivoCOPY := SW_DLC_Archive(1);

    case id of
      1: AUTOEXEC_Blood(SinglePlayer, DebugMode, CaminhoExe, GameExe, NumJogadores);
      5: AUTOEXEC_Duke3D(SinglePlayer, DebugMode, CaminhoExe, GameExe, Parametros, NumJogadores);
     10: AUTOEXEC_ShadowWarrior(Linhas, SinglePlayer, DebugMode, CaminhoJogo, GameExe, Parametros, NumJogadores, SW_ExeDLC, SW_ArquivoCOPY);
    end;

    if DebugMode and SinglePlayer then
      MessageBox(Application.Handle, pchar(Parametros), pchar(Lang_DGL(23)), MB_ICONINFORMATION+MB_OK);

    AutoExecWriter('nolfblim.com');

    if UsaMouseWrapper then
      AutoExecWriter('BMOUSE.EXE LAUNCH ' + GameExe + Parametros)
    else
      AutoExecWriter(GameExe + Parametros);
  end
  else
    AutoExecWriter(GameExe + Parametros);

  if not DebugMode then
    AutoExecWriter('exit');

end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.

