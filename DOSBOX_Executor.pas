unit DOSBOX_Executor;

interface

uses Classes, SysUtils, Windows, Forms, Funcoes, Language, dosbox_bind,Unit1, ShellAPI, dialogs;

type
  TAddAutoExecProc = procedure(const S: string);


//------------------------------------------------------------------------------
// EXECUTOR PRINCIPAL
//------------------------------------------------------------------------------
procedure ExecutaJogoDOSBOX(
  id: Integer;
  SinglePlayer: Boolean;
  Debug: Boolean;
  MouseOn: Boolean;

  CaminhoJogo: string;
  CaminhoExe: string;
  GameExe: string;
  Parametros: string;

  IP_Porta: string;
  IP_Local: string;
  Servidor: Boolean;
  Cliente: Boolean;
  NumPlayers: string;

  Arq_DosBox: string
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
procedure AUTOEXEC_Blood(
  Linhas: TStringList;
  var PosAutoExec: Integer;
  SinglePlayer: Boolean;
  DebugMode: Boolean;
  CaminhoExe: string;
  var GameExe: string;
  NumJogadores: string);
var
  Arquivo_COMMIT: TStringList;
begin
  // MULTIPLAYER CONFIG
  if not SinglePlayer then
  begin
    Arquivo_COMMIT := TStringList.Create;
    try
      Arquivo_COMMIT.LoadFromFile(CaminhoExe + 'commit.dat');
      Arquivo_COMMIT.Values['NUMPLAYERS'] := NumJogadores;
      Arquivo_COMMIT.Values['LAUNCHNAME'] := '"' + GameExe + '"';
      Arquivo_COMMIT.SaveToFile(CaminhoExe + 'commit.dat');
    finally
      Arquivo_COMMIT.Free;
    end;
  end;

  // DEBUG MULTIPLAYER
  if (not SinglePlayer) and DebugMode then
  begin
    if FileExists(CaminhoExe + 'cryptic.exe') then
      GameExe := 'cpmulti.exe'
    else
      GameExe := 'setup.exe';
  end;

  // ESCREVE NO AUTOEXEC
  Linhas.Insert(PosAutoExec, 'echo Iniciando Blood...');
  Inc(PosAutoExec);

  Linhas.Insert(PosAutoExec, GameExe);
  Inc(PosAutoExec);
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
  Debug: Boolean;
  MouseOn: Boolean;

  CaminhoJogo: string;
  CaminhoExe: string;
  GameExe: string;
  Parametros: string;

  IP_Porta: string;
  IP_Local: string;
  Servidor: Boolean;
  Cliente: Boolean;
  NumPlayers: string;

  Arq_DosBox: string
);
var
Arquivo_DOSBOX_Fisico: TStringList;
i: Integer;
begin
  //--------------------------------------------------
  // 0) GARANTE CONF BASE
  //--------------------------------------------------
  if not FileExists(Arq_DosBox) then
    CopyFile(
      PChar(ExtractFilePath(DosBox_EXE_Global) + 'dosbox-0.74.conf'),
      PChar(Arq_DosBox),
      False
    );

  Arquivo_DOSBOX_Fisico := TStringList.Create;
  try
    //--------------------------------------------------
    // 1) CARREGA CONF
    //--------------------------------------------------
    Arquivo_DOSBOX_Fisico.LoadFromFile(Arq_DosBox);

for i := 0 to Arquivo_DOSBOX_Fisico.Count - 1 do
begin
  //--------------------------------------------------
  // APLICA CONFIGURAÇÕES DO DOSBOX + JOGO
  //--------------------------------------------------
  AplicaDOSBOX_Tudo(
    i,
    Arquivo_DOSBOX_Fisico,
    id,
    SinglePlayer,
    Debug,
    MouseOn,
    Trim(player_name.Text),
    NumPlayers
  );

  //--------------------------------------------------
  // AUTOEXEC ORIGINAL
  //--------------------------------------------------
  if Pos('[autoexec]', Arquivo_DOSBOX_Fisico[i]) = 1 then
  begin
    if Debug = False then
      Arquivo_DOSBOX_Fisico.Add('@ECHO OFF');

    if DirectoryExists(ExtractFilePath(Arq_DosBox)) then
      Arquivo_DOSBOX_Fisico.Add(
        'mount c "' + ExtractFilePath(Arq_DosBox) + '"'
      )
    else
      Exit;

    Arquivo_DOSBOX_Fisico.Add('SET BLASTER=A220 I7 D1 H5 T6');
    Arquivo_DOSBOX_Fisico.Add('C:');

    if Parametros <> '' then
      Arquivo_DOSBOX_Fisico.Add(GameExe + ' ' + Parametros)
    else
      Arquivo_DOSBOX_Fisico.Add(GameExe);

    Arquivo_DOSBOX_Fisico.Add('exit');

    Break;
  end;
end;


    //--------------------------------------------------
    // 3) SALVA CONF
    //--------------------------------------------------
    Arquivo_DOSBOX_Fisico.SaveToFile(Arq_DosBox);

  finally
    Arquivo_DOSBOX_Fisico.Free;
  end;

  //--------------------------------------------------
  // 4) EXECUTA DOSBOX
  //--------------------------------------------------
  ShellExecute(0,'open',PChar(DosBox_EXE_Global),PChar('-conf "' + Arq_DosBox + '"'),PChar(ExtractFilePath(Arq_DosBox)),SW_SHOWNORMAL);

end;



//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.

