unit DOSBOX_Bind_FPS;

interface

uses Classes, SysUtils, Windows;

procedure Bind_FPS(
  id: Integer;
  Arquivo_DOSBOX_Fisico: TStrings;
  Arq_DosBox: string;
  Caminho_Global: string;
  SinglePlayer: Boolean;
  Servidor: Boolean;
  Cliente: Boolean;
  DebugMode: Boolean;
  MouseAtivo: Boolean;
  IP_Local: string;
  IP_Porta: string;
  NumPlayers: string;
  PlayerName: string;
  var Game_EXE_Global: string;
  var VarParametro_Global: string
);

implementation

procedure Bind_FPS(
  id: Integer;
  Arquivo_DOSBOX_Fisico: TStrings;
  Arq_DosBox: string;
  Caminho_Global: string;
  SinglePlayer: Boolean;
  Servidor: Boolean;
  Cliente: Boolean;
  DebugMode: Boolean;
  MouseAtivo: Boolean;
  IP_Local: string;
  IP_Porta: string;
  NumPlayers: string;
  PlayerName: string;
  var Game_EXE_Global: string;
  var VarParametro_Global: string
);
var
i: Integer;
Arquivo_COMMIT: TStringList;
begin

for i := 0 to Arquivo_DOSBOX_Fisico.Count-1 do
begin
if Pos('[autoexec]',Arquivo_DOSBOX_Fisico[i]) = 1 then
begin

  if not DebugMode then
    Arquivo_DOSBOX_Fisico.Add('@ECHO OFF');

  if DirectoryExists(ExtractFilePath(Arq_DosBox)) then
    Arquivo_DOSBOX_Fisico.Add('mount c "'+ExtractFilePath(Arq_DosBox)+'"')
  else
    Exit;

  Arquivo_DOSBOX_Fisico.Add('c:');

  if not DebugMode then
    Arquivo_DOSBOX_Fisico.Add('cls');

  if Servidor then
    Arquivo_DOSBOX_Fisico.Add('ipxnet startserver '+Trim(IP_Porta));

  if Cliente then
    Arquivo_DOSBOX_Fisico.Add('ipxnet connect '+Trim(IP_Local)+' '+Trim(IP_Porta));

  case id of
    1:
      if FileExists(Caminho_Global+'game.ins') then
        Arquivo_DOSBOX_Fisico.Add('imgmount D game.ins -t iso');

    10:
      if FileExists(Caminho_Global+'GAME.DAT') then
        Arquivo_DOSBOX_Fisico.Add('imgmount d "..\GAME.DAT" -t iso');
  end;

  if SinglePlayer then
  begin
    Seleciona_Fases;
    if Fecha_ESC then Exit;

    if (id = 5) or (id = 10) then
      VarParametro_Global := ' ' + Map_Global;
  end
  else
  begin
    Arquivo_COMMIT := TStringList.Create;
    Arquivo_COMMIT.LoadFromFile(Caminho_Global+'commit.dat');
    Arquivo_COMMIT[26] := 'NUMPLAYERS = ' + NumPlayers;
    Arquivo_COMMIT[33] := 'LAUNCHNAME = "'+Game_EXE_Global+'"';
    Arquivo_COMMIT.SaveToFile(Caminho_Global+'commit.dat');
    Arquivo_COMMIT.Free;
  end;

  Arquivo_DOSBOX_Fisico.Add('nolfblim.com');

  if MouseAtivo then
    Arquivo_DOSBOX_Fisico.Add('BMOUSE.EXE LAUNCH '+Game_EXE_Global+VarParametro_Global)
  else
    Arquivo_DOSBOX_Fisico.Add(Game_EXE_Global+VarParametro_Global);

  if not DebugMode then
    Arquivo_DOSBOX_Fisico.Add('Exit.');

  Break;
end;
end;

end;

end.

