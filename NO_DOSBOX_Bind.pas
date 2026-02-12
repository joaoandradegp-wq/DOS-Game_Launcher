unit NO_DOSBOX_Bind;

interface

uses Classes, SysUtils, StrUtils, ShellAPI, Forms, Windows, dialogs, Unit1, Unit2, Teclado_Mouse, Funcoes, Language;

//------------------------------------------------------------------------------
const
  {VIDEO - DEBUG}
  QUAKE_VIDEO_DEBUG: array[0..2] of TRegra = (
    (Chave:'vid_fullscreen'; Valor:'vid_fullscreen "0"'),
    (Chave:'vid_height';     Valor:'vid_height "768"'),
    (Chave:'vid_width';      Valor:'vid_width "1024"')
  );

  {VIDEO - NORMAL}
  QUAKE_VIDEO_NORMAL: array[0..2] of TRegra = (
    (Chave:'vid_fullscreen'; Valor:'vid_fullscreen "1"'),
    (Chave:'vid_height';     Valor:'vid_height "1024"'),
    (Chave:'vid_width';      Valor:'vid_width "1280"')
  );

  {AUTOEXEC BASE}
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
//------------------------------------------------------------------------------
const
  QW_EXEC_AUTOEXEC   = 'exec autoexec.cfg';
  QW_LINE_MLOOK      = '+mlook';
  QW_LINE_CLEAR      = 'clear';
  QW_LINE_ECHO       = 'echo ';
  QW_LINE_CONNECT    = 'connect ';
  QW_PARAM_WINDOWED  = ' -startwindowed';
  QW_PARAM_NAME      = '+name ';
  QW_PARAM_COLOR     = ' +color ';
  QW_FOLDER          = 'qw\';
  QW_CONFIG_FILE     = 'config.cfg';
  QW_AUTOEXEC_FILE   = 'autoexec.cfg';
  QW_SERVER_EXE      = 'qwsv.exe';
  QW_CLIENT_EXE      = 'qwcl.exe';
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaQuakeClassic(
  const Caminho_Global: string;
  const Nome_DLC_Global: string;
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
  const IdGameConfig: string; // Array_Games[id][6]
  var VarParametro_Global: string;
//  var Quake_Folder: string;
  out Cancelado: Boolean
);
procedure AplicaQuakeSingle(id: Integer; EhDeathMatch: Boolean);
procedure AplicaQuake(id: Integer; DeathmatchAtivo: Boolean);
procedure AplicaQuakeWorldDM;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

implementation

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaQuakeClassic(
  const Caminho_Global: string;
  const Nome_DLC_Global: string;
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
  const IdGameConfig: string; // Array_Games[id][6]
  var VarParametro_Global: string;
//  var Quake_Folder: string;
  out Cancelado: Boolean
);
var
  Config: TStringList;
  AutoExec: TStringList;
  Quake_Folder: String;
  i,p: Integer;
begin
  Cancelado := False;

  VarParametro_Global := ' -noserial';
  Quake_Folder := '';

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

  if (not FileExists(Caminho_Global+'game.cue')  and (EPI_Global_DLC = 1)) or
     (not FileExists(Caminho_Global+'gamea.cue') and (EPI_Global_DLC = 2)) or
     (not FileExists(Caminho_Global+'gamed.cue') and (EPI_Global_DLC = 3)) then
    VarParametro_Global := VarParametro_Global + ' -nocdaudio';

  if not CheckCliente then
  begin
  Seleciona_Fases;
    if Fecha_ESC then
    begin
    Cancelado := True;
    Exit;
    end;
  VarParametro_Global := VarParametro_Global + ' +map ' + Map_Global;
  end;

  case AnsiIndexStr(Nome_DLC_Global,['','Scourge of Armagon','Dissolution of Eternity']) of
    0: Quake_Folder := 'id1\';
    1: Quake_Folder := 'hipnotic\';                   nao ta alterando o quake_folder, precisa ver
    2: Quake_Folder := 'rogue\';
  end;

  {PATCH config.cfg}
  Config := TStringList.Create;
  try
  Config.LoadFromFile(Caminho_Global + Quake_Folder + IdGameConfig);

    for i := 0 to Config.Count - 1 do
    begin
      if Debug then
      AplicaRegras(i, QUAKE_VIDEO_DEBUG, Config)
      else
      AplicaRegras(i, QUAKE_VIDEO_NORMAL, Config);
    end;

  Config.SaveToFile(Caminho_Global + Quake_Folder + IdGameConfig);
  showmessage(Caminho_Global + Quake_Folder + IdGameConfig) ;
  finally
  Config.Free;
  end;

  if Debug then
  MessageBox(Application.Handle, PChar(VarParametro_Global), PChar(Lang_DGL(23)), MB_ICONINFORMATION + MB_OK);

  {AUTOEXEC}
  AutoExec := TStringList.Create;
  try
    for i := Low(QUAKE_AUTOEXEC_BASE) to High(QUAKE_AUTOEXEC_BASE) do
    AutoExec.Add(QUAKE_AUTOEXEC_BASE[i]);

      if CheckSingle then
      AutoExec.Add('name Ranger')
      else
      begin
        if CheckServidor then
        begin
        AutoExec.Add('hostname DGL');
        AutoExec.Add('maxplayers ' + ContPlayerText);
        AutoExec.Add('coop 1');
        AutoExec.Add('teamplay off');
        AutoExec.Add('skill 1');
        AutoExec.Add('fraglimit none');
        AutoExec.Add('timelimit none');
        AutoExec.Add('pausable 0');
        end
        else
        AutoExec.Add('connect DGL');

      if NameFunAtivo then
      begin
      p := Pos('.scr', CoolStuff_Global);
        if p > 0 then
        AutoExec.Add('exec ' + Copy(CoolStuff_Global,7,Pos('.scr',CoolStuff_Global)-3));
      end
      else
      AutoExec.Add('name ' + Trim(PlayerName));

    AutoExec.Add('color ' + IntToStr(ComboColorIndex));
    end;

  AutoExec.Add('clear');
  AutoExec.Add('echo ' + AppTitle);

  AutoExec.SaveToFile(IncludeTrailingPathDelimiter(Caminho_Global) + Quake_Folder + 'autoexec.cfg');
  finally
  AutoExec.Free;
  end;
  
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
    Nome_DLC_Global,
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
//    Quake_Folder,
    Cancelado
  );

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaQuake(id: Integer; DeathmatchAtivo: Boolean);
begin

  if DeathmatchAtivo then
  AplicaQuakeWorldDM
  else
  AplicaQuakeSingle(id, DeathmatchAtivo);

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure AplicaQuakeWorldDM;
var
Arquivo: TStringList;
QW_Server: string;
QW_WinMode: string;
QW_Server_Debug: Integer;
Config_Game_Global: string;
begin

QW_Server := Caminho_Global + QW_SERVER_EXE;
Nome_DLC_Global := 'QuakeWorld';
Game_EXE_Global := QW_CLIENT_EXE;

  if Form1_DGL.menu_debug.Checked then
  begin
  QW_WinMode := QW_PARAM_WINDOWED;
  QW_Server_Debug := SW_NORMAL;
  end
  else
  begin
  QW_WinMode := '';
  QW_Server_Debug := SW_HIDE;
  end;

  Config_Game_Global := Caminho_Global + QW_FOLDER + QW_CONFIG_FILE;

  Arquivo := TStringList.Create;
  try
  Arquivo.LoadFromFile(Config_Game_Global);

    if (Arquivo.Count = 0) or (Arquivo[Arquivo.Count-1] <> QW_EXEC_AUTOEXEC) then
    Arquivo.Add(QW_EXEC_AUTOEXEC);

  Arquivo.SaveToFile(Config_Game_Global);
  finally
  Arquivo.Free;
  end;

  Arquivo := TStringList.Create;
  try
  Arquivo.Add(QW_LINE_MLOOK);
  Arquivo.Add(QW_LINE_CONNECT + Form1_DGL.ip_local.Text);
  Arquivo.Add(QW_LINE_CLEAR);
  Arquivo.Add(QW_LINE_ECHO + Application.Title);

  Arquivo.SaveToFile(ExtractFilePath(Config_Game_Global) + QW_AUTOEXEC_FILE);
  finally
  Arquivo.Free;
  end;

  if not Form1_DGL.RXOpcoes.StateOn then
  CoolStuff_Global := QW_PARAM_NAME + Trim(Form1_DGL.player_name.Text);

  VarParametro_Global := QW_WinMode + ' ' + CoolStuff_Global + QW_PARAM_COLOR + IntToStr(Form1_DGL.combo_color.ItemIndex);

  if Form1_DGL.check_servidor.Checked then
  begin
  Seleciona_Fases;

    if Fecha_ESC then
    Exit;

    if Form1_DGL.menu_debug.Checked then
    MessageBox(Application.Handle, PChar(VarParametro_Global + #13#13 + Map_Global), PChar(Lang_DGL(23)), MB_ICONINFORMATION + MB_OK);

    if Form1_DGL.RxQuakeServer.StateOn then
    begin
    Config_Tela(False);
    Form1_DGL.btn_start.Caption := Lang_DGL(5);

    ShellExecute(Form1_DGL.Handle, 'open', PChar(QW_Server), PChar('+map ' + Map_Global), PChar(ExtractFilePath(QW_Server)), SW_MAXIMIZE);

    Form1_DGL.Timer_MonitoraAPP.Enabled := True;
    Exit;
    end
    else
    ShellExecute(Form1_DGL.Handle, 'open', PChar(QW_Server), PChar('+map ' + Map_Global), PChar(ExtractFilePath(QW_Server)), QW_Server_Debug);
  end;

  if (not Form1_DGL.menu_debug.Checked) and Form1_DGL.check_cliente.Checked then
  Contagem_Iniciar;

ShellExecute(Form1_DGL.Handle, 'open', PChar(ExtractFilePath(QW_Server) + Game_EXE_Global), PChar(VarParametro_Global), PChar(ExtractFilePath(QW_Server)), SW_NORMAL);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.
