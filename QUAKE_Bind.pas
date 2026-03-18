unit QUAKE_Bind;

interface

uses
  Classes, SysUtils, StrUtils, ShellAPI, Forms, Windows, Dialogs,
  Unit1, DLC, Funcoes, Language;

//--------------------------------------------------
type
  TModoEntrada = (meTeclado, meMouse, meAmbos);
//--------------------------------------------------
const
  { AUTOEXEC BASE }
  QUAKE_AUTOEXEC_BASE: array[0..7] of string = (
    'bind w "+forward"',
    'bind a "+moveleft"',
    'bind s "+back"',
    'bind d "+moveright"',
    'bind MOUSE1 "+attack"',
    'bind MOUSE2 "+jump"',
    'sensitivity "5.000000"',
    '+mlook'
  );

  { QUAKEWORLD }
  QW_SERVER_EXE = 'qwsv.exe';
  QW_CLIENT_EXE = 'qwcl.exe';

  { RESOLUÇÃO - JANELA E FULLSCREEN }
  q_width = 1024;
  q_height = 768;
//--------------------------------------------------

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaQuakeClassic(
  const Caminho_Global: string;
  const Debug: Boolean;
  const CheckSingle: Boolean;
  const CheckServidor: Boolean;
  const CheckCliente: Boolean;
  const NameFunAtivo: Boolean;
  const PlayerName: string;
  const CoolStuff_Global: string;
  const ComboColorIndex: Integer;
  const ContPlayerText: string;
  const AppTitle: string;
  const IdGameConfig: string;
  var VarParametro_Global: string;
  out Cancelado: Boolean
);
//------------------------------------------------------------------------------
procedure AplicaQuakeSingle(id: Integer; EhDeathMatch: Boolean);
procedure AplicaQuakeWorldDM(ServerDedicado: Boolean);
procedure QUAKE_Bind_Spasm (id: Integer; DeathmatchAtivo, ServerDedicado: Boolean);
function  Quake_Color(Cor:Integer):Integer;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

implementation

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaQuakeClassic(
  const Caminho_Global: string;
  const Debug: Boolean;
  const CheckSingle: Boolean;
  const CheckServidor: Boolean;
  const CheckCliente: Boolean;
  const NameFunAtivo: Boolean;
  const PlayerName: string;
  const CoolStuff_Global: string;
  const ComboColorIndex: Integer;
  const ContPlayerText: string;
  const AppTitle: string;
  const IdGameConfig: string;
  var VarParametro_Global: string;
  out Cancelado: Boolean
);
var
AutoExec: TStringList;
Quake_Folder: string;
i: Integer;
begin
Cancelado := False;
VarParametro_Global := VarParametro_Global + ' -noserial';

  Application.CreateForm(TForm2_DLC, Form2_DLC);
  try
  Form2_DLC.ShowModal;
  finally
  Form2_DLC.Free;
  end;

  if Fecha_ESC then
  begin
  Cancelado := True;
  Exit;
  end;

  if not CheckCliente then
  begin
  Seleciona_Fases;
    if Fecha_ESC then
    Exit;

    if debug then
    VarParametro_Global := VarParametro_Global + ' +map ' + Map_Global + ' -window ' + '-width '+IntToStr(q_width)+' -height ' + IntToStr(q_height)
    else
    VarParametro_Global := VarParametro_Global + ' +map ' + Map_Global + ' -fullscreen ' + '-width '+IntToStr(q_width)+' -height ' + IntToStr(q_height);
  end
  else
  begin
    if debug then
    VarParametro_Global := VarParametro_Global + ' -window ' + '-width '+IntToStr(q_width)+' -height ' + IntToStr(q_height)
    else
    VarParametro_Global := VarParametro_Global + ' -fullscreen ' + '-width '+IntToStr(q_width)+' -height ' + IntToStr(q_height);
  end;


  case EPI_Global_DLC of
  2: Quake_Folder := 'hipnotic\';
  3: Quake_Folder := 'rogue\';
  else
  Quake_Folder := 'id1\';
  end;

  AutoExec := TStringList.Create;
  try
    for i := Low(QUAKE_AUTOEXEC_BASE) to High(QUAKE_AUTOEXEC_BASE) do
    AutoExec.Add(QUAKE_AUTOEXEC_BASE[i]);

  AutoExec.Add('name ' + Trim(PlayerName));
  AutoExec.Add('color ' + IntToStr(ComboColorIndex));

  if CheckServidor then
  begin
  AutoExec.Add('hostname DGL '+PlayerName);
  AutoExec.Add('maxplayers '+ContPlayerText);
  AutoExec.Add('coop 1');
  AutoExec.Add('teamplay off');
  AutoExec.Add('skill 1');
  AutoExec.Add('fraglimit none');
  AutoExec.Add('timelimit none');
  AutoExec.Add('pausable 0');
  end
  else
    if CheckCliente then
    AutoExec.Add('connect '+Form1_DGL.ip_local.Text);

  {QUAKE - APENAS O NAMEFUN}
  if NameFunAtivo then
  AutoExec.Add('exec '+Copy(CoolStuff_Global,7,Pos('.scr',CoolStuff_Global)-3));

  AutoExec.Add('clear');
  AutoExec.Add('echo ' + AppTitle);

  AutoExec.SaveToFile(IncludeTrailingPathDelimiter(Caminho_Global) + Quake_Folder + 'autoexec.cfg');
  finally
  AutoExec.Free;
  end;

  {DEBUG}
  if (Form1_DGL.menu_debug.Checked = True) then
  MessageBox(Application.Handle,PChar(IncludeTrailingPathDelimiter(Caminho_Global)
                                      + #13#13 + Game_EXE_Global
                                      + #13    + Quake_Folder
                                      + #13#13 + VarParametro_Global
                                      + #13#13 + Map_Global
                                      + #13    + CoolStuff_Global),
                                PChar(Lang_DGL(23)),MB_ICONINFORMATION + MB_OK);

  {EXECUTÁVEL GLOBAL}
  ShellExecute(Form1_DGL.Handle,'open',PChar(IncludeTrailingPathDelimiter(Caminho_Global) + Game_EXE_Global),
                                       PChar(VarParametro_Global),
                                       PChar(Caminho_Global),SW_NORMAL);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaQuakeSingle(id: Integer; EhDeathMatch: Boolean);
var
Cancelado: Boolean;
begin

  if EhDeathMatch then
  Exit;

  AplicaQuakeClassic(
    Caminho_Global,
    Form1_DGL.menu_debug.Checked,
    Form1_DGL.check_single.Checked,
    Form1_DGL.check_servidor.Checked,
    Form1_DGL.check_cliente.Checked,
    Form1_DGL.RxOpcoes.StateOn,
    Form1_DGL.player_name.Text,
    CoolStuff_Global,
    Form1_DGL.combo_color.ItemIndex,
    Form1_DGL.cont_player.Text,
    Application.Title,
    Array_Games[id][6],
    VarParametro_Global,
    Cancelado);

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaQuakeWorldDM(ServerDedicado: Boolean);
var
ArquivoCFG: TStringList;
i: Integer;
Config_Game_Global: string;
Encontrou: Boolean;
QWPath, ClientExe, ServerExe, ClientParams, ServerParams: string;
begin
Config_Game_Global := IncludeTrailingPathDelimiter(Caminho_Global) + 'qw\config.cfg';

  if FileExists(Config_Game_Global) then
  begin
  ArquivoCFG := TStringList.Create;
    try
    ArquivoCFG.LoadFromFile(Config_Game_Global);
    Encontrou := False;

      for i := 0 to ArquivoCFG.Count - 1 do
        if Trim(LowerCase(ArquivoCFG[i])) = 'exec autoexec.cfg' then
        begin
        Encontrou := True;
        Break;
        end;

        if not Encontrou then
        ArquivoCFG.Add('exec autoexec.cfg');

    ArquivoCFG.SaveToFile(Config_Game_Global);
    finally
    ArquivoCFG.Free;
    end;
  end;

  //--------------------------------------------------------
  Nome_DLC_Global := 'QuakeWorld';
  QWPath    := IncludeTrailingPathDelimiter(Caminho_Global);
  ClientExe := QWPath + QW_CLIENT_EXE;
  ServerExe := QWPath + QW_SERVER_EXE;
  //--------------------------------------------------------

  {SERVER}
  if Form1_DGL.check_servidor.Checked then
  begin
  Seleciona_Fases;

    if Fecha_ESC then
    Exit;

  ServerParams := '+map ' + Map_Global;

  {DEBUG - SERVER}
  if (Form1_DGL.menu_debug.Checked) and (ServerDedicado = True) then
  MessageBox(Application.Handle,pchar(ServerParams),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);


  {SERVER}
  if ServerDedicado = False then
  ShellExecute(Form1_DGL.Handle,'open',PChar(ServerExe),
                                       PChar(ServerParams),
                                       PChar(QWPath),SW_HIDE)
  {SERVER DEDICADO}
  else
  ShellExecute(Form1_DGL.Handle,'open',PChar(ServerExe),
                                       PChar(ServerParams),
                                       PChar(QWPath),SW_NORMAL);
  end;

  {CLIENTE}
  ClientParams := '+name "' + Trim(Form1_DGL.player_name.Text) + '" ' +
                  '+color ' + IntToStr(Form1_DGL.combo_color.ItemIndex);

  {DEBUG}
  if Form1_DGL.menu_debug.Checked then
  ClientParams := '-startwindowed ' + ClientParams;

  {SERVER - CONNECT HOST 127.0.0.1}
  if Form1_DGL.check_servidor.Checked then
  ClientParams := ClientParams + ' +connect 127.0.0.1'
  else
    if Trim(Form1_DGL.ip_local.Text) <> '' then
    ClientParams := ClientParams + ' +connect ' + Trim(Form1_DGL.ip_local.Text);

  {DEBUG - CLIENT}
  if Form1_DGL.menu_debug.Checked and (ServerDedicado = False) then
  MessageBox(Application.Handle,pchar(ServerParams+#13+ClientParams),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);

  {SERVER}
  if ServerDedicado = False then
  ShellExecute(Form1_DGL.Handle,'open',PChar(ClientExe),PChar(ClientParams),PChar(QWPath),SW_NORMAL);

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure QUAKE_Bind_Spasm(id: Integer; DeathmatchAtivo, ServerDedicado: Boolean);
begin

  if DeathmatchAtivo then
  AplicaQuakeWorldDM(ServerDedicado)
  else
  AplicaQuakeSingle(id, DeathmatchAtivo);
  
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function Quake_Color(Cor:Integer):Integer;
begin

 case Cor of
   0: Result:=0;
  17: Result:=1;
  34: Result:=2;
  51: Result:=3;
  68: Result:=4;
  85: Result:=5;
 102: Result:=6;
 119: Result:=7;
 136: Result:=8;
 153: Result:=9;
 170: Result:=10;
 187: Result:=11;
 204: Result:=12;
 221: Result:=13;
 else
 Result:=0
 end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.
