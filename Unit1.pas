unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, RXCtrls, StdCtrls, Mask, ToolEdit, ComCtrls, RXSwitch,
  pngextra, IdBaseComponent, IdComponent, IdIPWatch, ExtCtrls, abfControls,
  ImgList, pngimage, ShellAPI, RxGIF, AppEvnts, abfAppProps, Animate,
  GIFCtrl, IdRawBase, IdRawClient, IdIcmpClient, ScktComp, IdUDPBase,
  IdUDPClient, OleCtrls, SHDocVw, Buttons, abfComponents, RxCombos,
  RXSlider, WinSkinData, rxAnimate, rxGIFCtrl, StrUtils;

type
//------------------------------------
Campos = Array[1..8] of String;
//------------------------------------

var
//--------------------------------
id:Integer;
Map_Global,Nome_DLC_Global:String;
//--------------------------------
{VARIÁVEIS GLOBAIS}
//------------------------------------------------------------------------
IP_Externo_Global,IP_Interno_Global:String;
Caminho_Global,Pasta_INI_Global,DosBox_EXE_Global,ZDoom_EXE_Global:String;
DoomSkin_Global,DoomMod_Global,DoomDM_Global,Game_EXE_Global:String;
EPI_Global_DLC,CAP_Global_DLC,Language_Global:Integer;
Config_Game_Global,VarParametro_Global:String;

Array_SIGIL_DLC_Name: Array [0..4] of String;
//Array_SIGIL_DLC_Name[0] - WAD SIGIL
//Array_SIGIL_DLC_Name[1] - MP3 SIGIL
//Array_SIGIL_DLC_Name[2] - WAD SIGIL 2
//Array_SIGIL_DLC_Name[3] - MP3 SIGIL 2
//------------------------------------------------------------------------

//----------------------
{QUAKEWORLD}
//----------------------
CoolStuff_Global:String;
Fecha_ESC:Boolean;
//----------------------

//--------------------------------
{DEFAULT STEAM  13112}
{DEFAULT STEAM -39312}
//--------------------------------
Mouse_Global:Integer;
MouseAnalogX,MouseAnalogY:Integer;
//--------------------------------

type
  TForm1_DGL = class(TForm)
    check_servidor: TRadioButton;
    check_cliente: TRadioButton;
    MainMenu1: TMainMenu;
    Menu_Arquivo: TMenuItem;
    Menu_Sair: TMenuItem;
    RxCheckListBox1: TRxCheckListBox;
    StatusBar1: TStatusBar;
    GroupIP: TGroupBox;
    ip_local: TEdit;
    ip_internet: TEdit;
    Lista_Imagens: TImageList;
    Panel_Status: TPanel;
    IMG_STATUS: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Panel_Icones: TPanel;
    img_game: TabfImage;
    check_single: TRadioButton;
    Menu_Debug: TMenuItem;
    linha02: TBevel;
    linha01: TBevel;
    abfImage1: TabfImage;
    gif_dos: TRxGIFAnimator;
    Menu_Sobre: TMenuItem;
    ip_porta: TEdit;
    Label3: TLabel;
    Timer_MonitoraAPP: TTimer;
    loading_panel: TPanel;
    img_ing: TImage;
    Wav: TabfWav;
    Menu_Firewall: TMenuItem;
    Menu_Site: TMenuItem;
    Menu_Opcoes: TMenuItem;
    Menu_Ajuda: TMenuItem;
    N1: TMenuItem;
    RxControle: TRxSwitch;
    RxSense: TRxSwitch;
    Label_Controle: TLabel;
    Label_Sense: TLabel;
    PopupMenu1: TPopupMenu;
    popup_pasta: TMenuItem;
    config_menu: TMenuItem;
    Label_Brutal: TLabel;
    RxBrutal: TRxSwitch;
    LoadingMod: TOpenDialog;
    RxOpcoes: TRxSwitch;
    Label_Opcoes: TLabel;
    btn_start: TSpeedButton;
    SkinData_Buttons: TSkinData;
    Panel_Player: TPanel;
    combo_color: TComboBox;
    cont_seta: TUpDown;
    cont_player: TEdit;
    player_name: TEdit;
    Label_Name: TLabel;
    Refresh_Internet: TSpeedButton;
    Refresh_Lan: TSpeedButton;
    RxDM: TRxSwitch;
    Label_DM: TLabel;
    img_por: TImage;
    popup_qw: TMenuItem;
    popup_sa: TMenuItem;
    popup_de: TMenuItem;
    menu_linha: TMenuItem;
    popup_commit: TMenuItem;
    RxQuakeServer: TRxSwitch;
    Label_QuakeServer: TLabel;
    combo_doom: TComboBox;
    procedure Menu_SairClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure check_servidorClick(Sender: TObject);
    procedure check_clienteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RxCheckListBox1StateChange(Sender: TObject; Index: Integer);
    procedure check_singleClick(Sender: TObject);
    procedure Menu_DebugClick(Sender: TObject);
    procedure ip_localKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Menu_SobreClick(Sender: TObject);
    procedure RxCheckListBox1Click(Sender: TObject);
    procedure RxCheckListBox1DblClick(Sender: TObject);
    procedure ip_portaKeyPress(Sender: TObject; var Key: Char);
    procedure ip_portaChange(Sender: TObject);
    procedure Timer_MonitoraAPPTimer(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure Menu_FirewallClick(Sender: TObject);
    procedure ip_localKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ip_localKeyPress(Sender: TObject; var Key: Char);
    procedure combo_colorDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Menu_SiteClick(Sender: TObject);
    procedure ip_portaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RxControleEnter(Sender: TObject);
    procedure RxBrutalEnter(Sender: TObject);
    procedure PNGButton1Click(Sender: TObject);
    procedure RxControleOn(Sender: TObject);
    procedure RxControleOff(Sender: TObject);
    procedure RxBrutalOn(Sender: TObject);
    procedure RxBrutalOff(Sender: TObject);
    procedure RxSenseOn(Sender: TObject);
    procedure popup_pastaClick(Sender: TObject);
    procedure config_menuClick(Sender: TObject);
    procedure RxCheckListBox1Exit(Sender: TObject);
    procedure RxOpcoesOn(Sender: TObject);
    procedure RxOpcoesEnter(Sender: TObject);
    procedure btn_startClick(Sender: TObject);
    procedure cont_playerEnter(Sender: TObject);
    procedure Refresh_LanClick(Sender: TObject);
    procedure Refresh_InternetClick(Sender: TObject);
    procedure RxDMEnter(Sender: TObject);
    procedure RxSenseEnter(Sender: TObject);
    procedure RxDMOff(Sender: TObject);
    procedure RxDMOn(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RxOpcoesOff(Sender: TObject);
    procedure RxCheckListBox1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure popup_qwClick(Sender: TObject);
    procedure popup_saClick(Sender: TObject);
    procedure popup_deClick(Sender: TObject);
    procedure popup_commitClick(Sender: TObject);
    procedure player_nameChange(Sender: TObject);
    procedure RxQuakeServerEnter(Sender: TObject);
    procedure RxQuakeServerOn(Sender: TObject);
    procedure RxQuakeServerOff(Sender: TObject);
    procedure combo_doomChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  Arquivo_DOSBOX_Fisico:TStringList;
  end;

var
Form1_DGL: TForm1_DGL;

//-----------------------------------
{DADOS DOS GAME LAUNCHER - VARIÁVEIS}
DGL_EXE_Global,
DGL_RAIZ_Global,
DGL_VERSAO_Global,
DGL_BLOG_Global:String;
//-----------------------------------

const

Array_Games: Array[1..13] of Campos =
(  {1}  {2}                                      {3}                {4}            {5}            {6}                   {7}      {8}
  ('01','Blood - One Unit Whole Blood'          ,'DOS\BLOOD\'      ,'commit.exe'  ,'cryptic.exe' ,'BLOOD.cfg'          ,'DOSBOX','213' ),
  ('02','Constructor'                           ,'DOS\CONSTRUCTOR\','game.exe'    ,'game.exe'    ,'SETTINGS\SYSTEM.ini','DOSBOX','213' ),
  ('03','DooM - The Ultimate DooM'              ,'DOS\DOOM\'       ,'doom.wad'    ,'doom.wad'    ,'doom.ini '          ,'ZDOOM' ,'5029'),
  ('04','DooM II - Hell on Earth'               ,'DOS\DOOM2\'      ,'doom2.wad'   ,'doom2.wad'   ,'doom2.ini'          ,'ZDOOM' ,'5029'),
  ('05','Duke Nukem 3D - Atomic Edition'        ,'DOS\DUKE3D\'     ,'commit.exe'  ,'duke3d.exe'  ,'duke3d.cfg'         ,'DOSBOX','213' ),
  ('06','Heretic - Shadow of the Serpent Riders','DOS\HERETIC\'    ,'heretic.wad' ,'heretic.wad' ,'Heretic.ini'        ,'ZDOOM' ,'5029'),
  ('07','HeXen - Beyond Heretic'                ,'DOS\HEXEN\'      ,'hexen.wad'   ,'hexen.wad'   ,'hexen.ini'          ,'ZDOOM' ,'5029'),
  ('08','Quake'                                 ,'DOS\QUAKE\'      ,'quake.exe'   ,'quake.exe'   ,'config.cfg'         ,'DOSBOX','213' ),
  ('09','Rise of the Triad - Dark War'          ,'DOS\ROTT\'       ,'setup.exe'   ,'rott.exe'    ,'setup.rot'          ,'DOSBOX','213' ),
  ('10','Shadow Warrior'                        ,'DOS\SW\'         ,'commit.exe'  ,'sw.exe'      ,'SW.cfg'             ,'DOSBOX','213' ),
  ('11','Warcraft II - Beyond the Dark Portal'  ,'DOS\WAR2\'       ,'war2.exe'    ,'war2.exe'    ,'war2.ini'           ,'DOSBOX','213' ),
  ('12','Wolfenstein 3D'                        ,'DOS\WOLF3D\'     ,'Wolf3D.pk7'  ,'Wolf3D.pk7'  ,'Wolf3D.ini'         ,'ZDOOM' ,'5029'),
  ('13','Wolfenstein 3D - Spear of Destiny'     ,'DOS\WOLF3D\'     ,'SoD.pk7'     ,'SoD.pk7'     ,'SoD.ini'            ,'ZDOOM' ,'5029')
);

{PADRÃO MOUSE - BLOOD E DUKE NUKEM}
ID_MouseAnalogX = 8112;
ID_MouseAnalogY = 20312;

{PADRÃO MOUSE - SHADOW WARRIOR}
SW_MouseAnalogX = 26112;
SW_MouseAnalogY = 52312;

implementation

uses IniFiles, Funcoes, About, Unit3, Unit4, Unit6, Language, Unit2, Unit5;

var
Arquivo_INI:TIniFile;

{$R *.dfm}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function PT_MessageDlg( Topo_Caixa:String; Msg: string; AType: TMsgDlgType; AButtons:
  TMsgDlgButtons; IndiceHelp: LongInt; DefButton: TMOdalResult = mrNone): Word;
var
I:Integer;
Mensagem:TForm;
begin
Mensagem:=CreateMessageDialog(Msg,AType,Abuttons);
Mensagem.HelpContext:=IndiceHelp;

  with Mensagem do
  begin

    for i := 0 to ComponentCount - 1 do
    begin
      if (Components[i] is TButton) then
      begin
        if (TButton(Components[i]).ModalResult = DefButton) then
        begin
          ActiveControl:=TWincontrol(Components[i]);
        end;
      end;
    end;

    if Atype = mtConfirmation then
    Caption:=Lang_DGL(25)
    else
    if AType = mtWarning then
    Caption:=Lang_DGL(26)
    else
    if AType = mtError then
    Caption:=Lang_DGL(27)
    else
    if AType = mtInformation then
    Caption:=Lang_DGL(28)
    else
    if AType = mtCustom then
    Caption:=Topo_Caixa;

  end;

TButton(Mensagem.FindComponent('YES'   )).Caption:=Lang_DGL(29);
TButton(Mensagem.FindComponent('NO'    )).Caption:=Lang_DGL(30);
TButton(Mensagem.FindComponent('CANCEL')).Caption:=Lang_DGL(31);

Result:=Mensagem.ShowModal;
Mensagem.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function pingIp( host: String): Boolean;
var
IdICMPClient:TIdICMPClient;
begin
  Try
  IdICMPClient:=TIdICMPClient.Create(nil);
  IdICMPClient.Host:=host;
  IdICMPClient.Port:=StrToInt(Trim(Form1_DGL.ip_porta.Text));
  IdICMPClient.ReceiveTimeout:=500;
  IdICMPClient.Ping;
  Result:=(IdICMPClient.ReplyStatus.BytesReceived > 0 );
  Finally
  IdICMPClient.Free;
  end
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TForm1_DGL.FormActivate(Sender: TObject);
var
i:Integer;
begin
//-----------------------------------------------------------------------------------
DosBox_EXE_Global:=ExtractFilePath(Application.ExeName)+'CONFIG\bin\DOSBox.exe';
 ZDoom_EXE_Global:=ExtractFilePath(Application.ExeName)+'CONFIG\bin\zdoom\zdoom.exe';
Pasta_INI_Global :=ExtractFilePath(Application.ExeName)+'CONFIG\ini\';
//-----------------------------------------------------------------------------------
DoomSkin_Global:=Pasta_INI_Global+'\data\PHSKIN.WAD';

Form1_DGL.Caption:=Application.Title;
Wav.FileName:=ExtractFilePath(Application.ExeName)+'CONFIG\bin\st_button.wav';

  {VERIFICA SE OS JOGOS ESTÃO NA PASTA CORRETAMENTE VERIFICANDO O .EXE}
  for i:=1 to Length(Array_Games) do
  begin
  Deleta_Lixo(Array_Games[i][3],Array_Games[i][5],Array_Games[i][4]);
  //-----------------------------------------------------------------
  RxCheckListBox1.Items.Add(UpperCase(Array_Games[i][2]));
  //-----------------------------------------------------------------
    if not FileExists(ExtractFilePath(Application.ExeName)+Array_Games[i][3]+Array_Games[i][5]) then
    RxCheckListBox1.EnabledItem[i-1]:=False;
  //-----------------------------------------------------------------
  end;

 //---------------------------------------------------------------------------
 {CARREGA DO ARQUIVO .INI O NOME DO JOGADOR SALVO ANTERIORMENTE}
 //---------------------------------------------------------------------------
 Arquivo_INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'dos.ini');

 if not FileExists(ExtractFilePath(Application.ExeName)+'dos.ini') then
 begin
 player_name.Text:=UsuarioLogado;
 //----------------------------------------
 Firewall('CONFIG\bin\','DOSBox.exe');
 Firewall('CONFIG\bin\zdoom\','zdoom.exe');
 Firewall('DOS\QUAKE\','qwcl.exe');
 Firewall('DOS\QUAKE\','qwsv.exe');
 //----------------------------------------
 end
 else
 player_name.Text:=Arquivo_INI.ReadString('DOS','PLAYER_NAME','');
 //---------------------------------------------------------------------------

Panel_Icones.SetFocus;
end;

procedure TForm1_DGL.Menu_SairClick(Sender: TObject);
begin
Close;
end;

procedure TForm1_DGL.check_singleClick(Sender: TObject);
begin
//------------------------------------------------------
Funcao_Config_Opcoes;
//------------------------------------------------------
end;

procedure TForm1_DGL.check_servidorClick(Sender: TObject);
begin
//------------------------------------------------------
Funcao_Config_Opcoes;
//------------------------------------------------------
end;

procedure TForm1_DGL.check_clienteClick(Sender: TObject);
begin
//------------------------------------------------------
Funcao_Config_Opcoes;
//------------------------------------------------------
end;

procedure TForm1_DGL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 //------------------------------------------------------------------------------------------
 if Length(Trim(player_name.Text)) > 0 then
 Arquivo_INI.WriteString('DOS','PLAYER_NAME',Trim(player_name.Text));
 //------------------------------------------------------------------------------------------
Arquivo_INI.Free;
Application.Terminate;
end;

procedure TForm1_DGL.RxCheckListBox1StateChange(Sender: TObject;
  Index: Integer);
begin
//------------------------------
id:=RxCheckListBox1.ItemIndex+1;
//------------------------------
Caminho_Global:=ExtractFilePath(Application.ExeName)+Array_Games[id][3];
Funcao_Config_Opcoes;
end;

procedure TForm1_DGL.Menu_DebugClick(Sender: TObject);
var
i:Integer;
begin
//------------------------------
RxCheckListBox1.Clear;
img_game.Picture.Graphic:=Nil;
StatusBar1.Panels[1].Text:='';
IMG_STATUS.Picture:=Nil;
gif_dos.Visible:=True;
//------------------------------
label_name.Enabled :=False;
player_name.Enabled:=False;
cont_player.Enabled:=False;
cont_seta.Enabled  :=False;
//------------------------------
ip_local.Text      :='0.0.0.0';
ip_local.Enabled   :=False;
ip_internet.Text   :='0.0.0.0';
ip_internet.Enabled:=False;
ip_porta.Text      :='0';
ip_porta.Enabled   :=False;
//------------------------------
check_single.Enabled    :=False;
check_servidor.Enabled  :=False;
check_cliente.Enabled   :=False;
Refresh_Lan.Enabled     :=False;
Refresh_Internet.Enabled:=False;
//------------------------------
combo_color.Visible:=False;
combo_doom.Visible :=False;
//-------------------------------
RxControle.Visible       :=False;
Label_Controle.Visible   :=False;
RxSense.Visible          :=False;
Label_Sense.Visible      :=False;
RxBrutal.Visible         :=False;
Label_Brutal.Visible     :=False;
RxOpcoes.Visible         :=False;
Label_Opcoes.Visible     :=False;
RxDM.Visible             :=False;
Label_DM.Visible         :=False;
RxQuakeServer.Visible    :=False;
Label_QuakeServer.Visible:=False;
//-------------------------------
btn_start.Enabled :=False;
Panel_Icones.SetFocus;
//-------------------------------

//------------------------------------------------------------------------------------------------
{DEBUG MODE}
//------------------------------------------------------------------------------------------------
if menu_debug.Checked = True then
begin
StatusBar1.Panels[1].Text:=Application.ExeName;
Lista_Imagens.GetBitmap(3,IMG_STATUS.Picture.Bitmap);

  for i:=1 to Length(Array_Games) do
  begin
  RxCheckListBox1.Items.Add(Array_Games[i][1]+' ; '+Array_Games[i][3]+' ; '+Array_Games[i][4]+' ; '+Array_Games[i][5]+' ; '+Array_Games[i][6]);
    if not FileExists(ExtractFilePath(Application.ExeName)+Array_Games[i][3]+Array_Games[i][5]) then
    RxCheckListBox1.EnabledItem[i-1]:=False;
  end;
//------------------------------------------------------------------------------------------------
end
else
begin
//------------------------------------------------------------------------------------------------
{VOLTA AO NORMAL}
//------------------------------------------------------------------------------------------------
  for i:=1 to Length(Array_Games) do
  begin
  RxCheckListBox1.Items.Add(UpperCase(Array_Games[i][2]));
    if not FileExists(ExtractFilePath(Application.ExeName)+Array_Games[i][3]+Array_Games[i][5]) then
    RxCheckListBox1.EnabledItem[i-1]:=False;
  end;
//------------------------------------------------------------------------------------------------
end;

end;

procedure TForm1_DGL.ip_localKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//------------------------------------
if (check_cliente.Checked = True) then
begin
  if Key = VK_RETURN then
  Refresh_Lan.OnClick(Sender);
end;
//------------------------------------
end;

procedure TForm1_DGL.Menu_SobreClick(Sender: TObject);
begin
Application.CreateForm(TForm5_About, Form5_About);
Form5_About.ShowModal;
Form5_About.Free;
end;

procedure TForm1_DGL.RxCheckListBox1Click(Sender: TObject);
begin
RxCheckListBox1.Checked[RxCheckListBox1.ItemIndex]:=True;
end;

procedure TForm1_DGL.RxCheckListBox1DblClick(Sender: TObject);
begin
 //---------------------------------------------------------------------------------------------------
 if (check_single.Checked = True) and (btn_start.Enabled = True) and (Menu_Debug.Checked = False) then
 btn_startClick(Sender);
 //---------------------------------------------------------------------------------------------------
end;

procedure TForm1_DGL.ip_portaKeyPress(Sender: TObject; var Key: Char);
begin
 //--------------------------------
 if not (key in ['0'..'9',#8]) then
 key:=#0;
 //--------------------------------
end;

procedure TForm1_DGL.ip_portaChange(Sender: TObject);
begin

 if (Length(Trim(ip_porta.Text)) = 0) and (ip_porta.Focused = True)
 or (Trim(ip_porta.Text) = '0') then
 begin
   {QUANDO O FOCO ESTIVER NO CAMPO}
   if ActiveControl = ip_porta then
   begin
   //--------------------------------
   {PORTAS DE REDE DEFAULT}
   //--------------------------------
   ip_porta.Text:=Array_Games[id][8];
   ip_porta.SelectAll;
   //--------------------------------
   end;
 end;

end;

procedure TForm1_DGL.Timer_MonitoraAPPTimer(Sender: TObject);
begin
Timer_MonitoraAPP.Interval:=1000;

 if not (AppAberto(Array_Games[id][7]+'.exe') or AppAberto('qwcl.exe') or AppAberto('qwsv.exe') or AppAberto('Winquake.exe') or AppAberto('Glquake.exe')) then
 begin
 Form1_DGL.ClientHeight:=461;
 Form1_DGL.ClientWidth:=633;
 Form1_DGL.Left:=(Screen.Width  div 2)-(Form1_DGL.Width  div 2);
 Form1_DGL.Top :=(Screen.Height div 2)-(Form1_DGL.Height div 2);

  //--------------------------------------------------------------------
  {DEBUG MODE - DOSBOX}
  //--------------------------------------------------------------------
  if menu_debug.Checked = False then
  Deleta_Lixo(Array_Games[id][3],Array_Games[id][5],Array_Games[id][4]);
  //--------------------------------------------------------------------
                                    
  //-----------------------------------
  {QUAKEWORLD - SERVIDOR}
  //-----------------------------------
  if (id = 8) then
  Fecha_EXE(Caminho_Global+'qwsv.exe');
  //-----------------------------------

 btn_start.Caption:=Lang_DGL(14);
 Config_Tela(True);
 Timer_MonitoraAPP.Enabled:=False;
 Timer_MonitoraAPP.Interval:=5000;
 end;

end;

procedure TForm1_DGL.FormDblClick(Sender: TObject);
begin
Form1_DGL.ClientHeight:=461;
Form1_DGL.ClientWidth:=633;
end;

procedure TForm1_DGL.Menu_FirewallClick(Sender: TObject);
begin
  Try
  Firewall('CONFIG\bin\','DOSBox.exe');
  Firewall('CONFIG\bin\zdoom\','zdoom.exe');
  Firewall('DOS\QUAKE\','qwcl.exe');
  Firewall('DOS\QUAKE\','qwsv.exe');
  Finally
  MessageBox(Application.Handle,pchar(Language.Lang_DGL(17)),pchar(Application.Title),MB_ICONINFORMATION+MB_OK);
  end;
end;

procedure TForm1_DGL.ip_localKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//---------------------------------------------------------------------------
if (check_cliente.Checked = True) and (Key <> VK_RETURN) then
begin
 //--------------------------------
 {DEBUG MODE}
 //--------------------------------
 if menu_debug.Checked = False then
 begin
 StatusBar1.Panels[1].Text:='';
 IMG_STATUS.Picture:=Nil;
 end;
 //--------------------------------
 btn_start.Enabled:=False;
 //--------------------------------
 if (Length(Trim(ip_local.Text)) = 0) or (Copy(ip_local.Text,1,1) = '0') then
 Refresh_Lan.Enabled:=False
 else
 Refresh_Lan.Enabled:=True;
end;
//---------------------------------------------------------------------------
end;

procedure TForm1_DGL.ip_localKeyPress(Sender: TObject; var Key: Char);
begin
 //----------------------------------
 if (key in [#32]) then
 key:=#0;
 //----------------------------------
end;

procedure TForm1_DGL.combo_colorDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
 //----------------------------------
 {ZDOOM - CORES DO COMBOBOX}
 //----------------------------------
 with Control as TComboBox,Canvas do
 begin
 Brush.Color:=StrToInt(Items[Index]);
 FillRect(Rect);
 InflateRect(Rect,-2,-2);
 Brush.Color:=StrToInt(Items[Index]);
 FillRect(Rect);
 end;
 //----------------------------------
end;

procedure TForm1_DGL.Menu_SiteClick(Sender: TObject);
begin
ShellExecute(Handle,'open','http://phobosfreeware.blogspot.com','','',1);
end;

procedure TForm1_DGL.ip_portaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//---------------------------------------------------------------------------
if (check_cliente.Checked = True) and (Key <> VK_RETURN) then
begin
 //--------------------------------
 {DEBUG MODE}
 //--------------------------------
 if menu_debug.Checked = False then
 begin
 StatusBar1.Panels[1].Text:='';
 IMG_STATUS.Picture:=Nil;
 end;
 //--------------------------------
 btn_start.Enabled:=False;
 //--------------------------------
 if (Length(Trim(ip_local.Text)) = 0) or (Copy(ip_porta.Text,1,1) = '0') then
 Refresh_Lan.Enabled:=False
 else
 Refresh_Lan.Enabled:=True;
end;
//---------------------------------------------------------------------------
end;

procedure TForm1_DGL.PNGButton1Click(Sender: TObject);
begin
Application.CreateForm(TForm6_Mouse, Form6_Mouse);
Form6_Mouse.ShowModal;
Form6_Mouse.Free;
end;

procedure TForm1_DGL.RxControleOn(Sender: TObject);
begin
 {BLOOD + DUKE NUKEM 3D + SHADOW WARRIOR}
 if (id = 1) or (id = 5) or (id = 10) then
 begin
 RxSense.Visible:=True;
 Label_Sense.Visible:=True;
 end;
Label_Controle.Caption:='MOUSE';
end;

procedure TForm1_DGL.RxBrutalOn(Sender: TObject);
begin
LoadingMod.FileName:='';
LoadingMod.InitialDir:=Caminho_Global;

 if LoadingMod.Execute then
 DoomMod_Global:=LoadingMod.FileName;

 if Length(DoomMod_Global) = 0 then
 RxBrutal.StateOn:=False;

end;

procedure TForm1_DGL.RxControleOff(Sender: TObject);
begin
RxSense.Visible:=False;
Label_Sense.Visible:=False;
Label_Controle.Caption:=Lang_DGL(18);
end;

procedure TForm1_DGL.RxBrutalOff(Sender: TObject);
begin
DoomMod_Global:='';
end;

procedure TForm1_DGL.RxSenseOn(Sender: TObject);
begin
Application.CreateForm(TForm6_Mouse, Form6_Mouse);
Form6_Mouse.ShowModal;
Form6_Mouse.Free;
end;

procedure TForm1_DGL.popup_pastaClick(Sender: TObject);
begin
ShellExecute(Application.Handle,'open',pchar(Caminho_Global),nil,nil,SW_SHOWNORMAL);
end;

procedure TForm1_DGL.config_menuClick(Sender: TObject);
var
Caminho_Conf:String;
begin

  if (id = 8) then
  Caminho_Conf:=ExtractFilePath(Application.ExeName)+Array_Games[id][3]+'id1/'+Array_Games[id][6]
  else
  Caminho_Conf:=ExtractFilePath(Application.ExeName)+Array_Games[id][3]+Array_Games[id][6];

WinExec(PChar('Notepad.exe '+Caminho_Conf),sw_shownormal);
end;

procedure TForm1_DGL.RxCheckListBox1Exit(Sender: TObject);
begin
RxCheckListBox1.PopupMenu:=Nil;
end;

procedure TForm1_DGL.RxOpcoesOn(Sender: TObject);
begin
Application.CreateForm(TForm3_QuakeWorld, Form3_QuakeWorld);
Form3_QuakeWorld.ShowModal;
Form3_QuakeWorld.Free;
end;

procedure TForm1_DGL.RxOpcoesEnter(Sender: TObject);
begin
ActiveControl:=Nil;
end;

procedure TForm1_DGL.btn_startClick(Sender: TObject);
var
Arq_DosBox,QW_Server,QW_WinMode,Var_Bindings,Quake_Folder,Quake_EXE:String;
i,j,Modo_Game,QW_Server_Debug:Integer;
Arquivo_COMMIT:TStringList;
begin
Config_Game_Global:=Caminho_Global+Array_Games[id][6];
VarParametro_Global:='';
Nome_DLC_Global:='';
Fecha_ESC:=False;

//----------------------------------------------------------------------------------------------
if (player_name.Enabled = True) and (Length(Trim(player_name.Text)) = 0) then
begin
MessageBox(Application.Handle,pchar(Lang_DGL(1)),pchar(Application.Title),MB_ICONWARNING+MB_OK);
player_name.SetFocus;
Exit;
end;
//----------------------------------------------------------------------------------------------

 //---------------------------------
 {SINGLE PLAYER OU MULTIPLAYER}
 //---------------------------------
 if check_single.Checked = True then
 Game_EXE_Global:=Array_Games[id][5]
 else
 Game_EXE_Global:=Array_Games[id][4];
 //---------------------------------

{ARQUIVO DE CONFIGURAÇÃO DE CADA JOGO}
case id of
 //------------------------------------------------------------------------
 {BLOOD + CONSTRUCTOR + DUKE NUKEM 3D + RISE OF THE TRIAD + SHADOW WARRIOR}
 //------------------------------------------------------------------------
 1,2,5,9,10:
           begin
           Arquivo_DOSBOX_Fisico:=TStringList.Create;
           Arquivo_DOSBOX_Fisico.LoadFromFile(Config_Game_Global);

             for i:=0 to Arquivo_DOSBOX_Fisico.Count-1 do
             begin
               //-------------------------------------------------------------
               {RxControle.StateOn - INÍCIO}
               //-------------------------------------------------------------
               if RxControle.StateOn = False then
               begin
                 //--------------------------------------------------------
                 //BLOOD - TECLADO
                 //--------------------------------------------------------
                 if (id = 1) then
                 begin
                   if Pos('Move_Forward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Forward = "Up" "N/A"';
                   if Pos('Move_Backward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Backward = "Down" "N/A"';
                   if Pos('Turn_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Left = "Left" "N/A"';
                   if Pos('Turn_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Right = "Right" "N/A"';
                   if Pos('Turn_Around = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Around = "N/A" "N/A"';
                   if Pos('Strafe = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe = "LAlt" "RAlt"';
                   if Pos('Strafe_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Left = "N/A" "N/A"';
                   if Pos('Strafe_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Right = "N/A" "N/A"';
                   if Pos('Jump = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Jump = "A" "N/A"';
                   if Pos('Crouch = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Crouch = "Z" "N/A"';
                   if Pos('Run = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Run = "LShift" "RShift"';
                   if Pos('AutoRun = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='AutoRun = "CapLck" "N/A"';
                   if Pos('Open = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Open = "Space" "N/A"';
                   if Pos('Weapon_Fire = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_Fire = "LCtrl" "RCtrl"';
                   if Pos('Weapon_Special_Fire = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_Special_Fire = "X" "N/A"';
                   if Pos('Aim_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Up = "N/A" "N/A"';
                   if Pos('Aim_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Down = "N/A" "N/A"';
                   if Pos('Aim_Center = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Center = "N/A" "N/A"';
                   if Pos('Look_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Up = "N/A" "N/A"';
                   if Pos('Look_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Down = "N/A" "N/A"';
                   if Pos('Tilt_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Tilt_Left = "N/A" "N/A"';
                   if Pos('Tilt_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Tilt_Right = "N/A" "N/A"';
                   if Pos('Weapon_1 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_1 = "1" "N/A"';
                   if Pos('Weapon_2 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_2 = "2" "N/A"';
                   if Pos('Weapon_3 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_3 = "3" "N/A"';
                   if Pos('Weapon_4 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_4 = "4" "N/A"';
                   if Pos('Weapon_5 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_5 = "5" "N/A"';
                   if Pos('Weapon_6 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_6 = "6" "N/A"';
                   if Pos('Weapon_7 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_7 = "7" "N/A"';
                   if Pos('Weapon_8 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_8 = "8" "N/A"';
                   if Pos('Weapon_9 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_9 = "9" "N/A"';
                   if Pos('Weapon_10 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_10 = "0" "N/A"';
                   if Pos('Inventory_Use = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Use = "Enter" "N/A"';
                   if Pos('Inventory_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Left = "[" "N/A"';
                   if Pos('Inventory_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Right = "]" "N/A"';
                   if Pos('Map_Toggle = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map_Toggle = "Tab" "N/A"';
                   if Pos('Map_Follow_Mode = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map_Follow_Mode = "F" "N/A"';
                   if Pos('Shrink_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Shrink_Screen = "-" "N/A"';
                   if Pos('Enlarge_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Enlarge_Screen = "=" "N/A"';
                   if Pos('Send_Message = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Send_Message = "T" "N/A"';
                   if Pos('See_Coop_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='See_Coop_View = "K" "N/A"';
                   if Pos('See_Chase_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='See_Chase_View = "F7" "N/A"';
                   if Pos('Mouse_Aiming = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Mouse_Aiming = "U" "N/A"';
                   if Pos('Toggle_Crosshair = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Toggle_Crosshair = "I" "N/A"';
                   if Pos('Next_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Next_Weapon = "N/A" "N/A"';
                   if Pos('Previous_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Previous_Weapon = "N/A" "N/A"';
                   if Pos('Holster_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Holster_Weapon = "N/A" "N/A"';
                   if Pos('Show_Opponents_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Show_Opponents_Weapon = "W" "N/A"';
                   if Pos('BeastVision = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='BeastVision = "B" "N/A"';
                   if Pos('CrystalBall = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='CrystalBall = "C" "N/A"';
                   if Pos('JumpBoots = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='JumpBoots = "J" "N/A"';
                   if Pos('MedKit = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='MedKit = "M" "N/A"';
                   if Pos('ProximityBombs = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='ProximityBombs = "P" "N/A"';
                   if Pos('RemoteBombs = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='RemoteBombs = "R" "N/A"';
                 end;
                 //--------------------------------------------------------
                 //DUKE NUKEM 3D - TECLADO
                 //--------------------------------------------------------
                 if (id = 5) then
                 begin
                   if Pos('Move_Forward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Forward = "Up" ""';
                   if Pos('Move_Backward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Backward = "Down" ""';
                   if Pos('Turn_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Left = "Left" ""';
                   if Pos('Turn_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Right = "Right" ""';
                   if Pos('Strafe = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe = "LAlt" "RAlt"';
                   if Pos('Fire = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Fire = "LCtrl" "RCtrl"';
                   if Pos('Open = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Open = "Space" ""';
                   if Pos('Run = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Run = "LShift" "RShift"';
                   if Pos('AutoRun = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='AutoRun = "CapLck" ""';
                   if Pos('Jump = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Jump = "A" ""';
                   if Pos('Crouch = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Crouch = "Z" ""';
                   if Pos('Look_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Up = "" ""';
                   if Pos('Look_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Down = "" ""';
                   if Pos('Look_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Left = "" ""';
                   if Pos('Look_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Right = "" ""';
                   if Pos('Strafe_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Left = "," ""';
                   if Pos('Strafe_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Right = "." ""';
                   if Pos('Aim_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Up = "" ""';
                   if Pos('Aim_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Down = "" ""	';
                   if Pos('Weapon_1 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_1 = "1" ""';
                   if Pos('Weapon_2 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_2 = "2" ""';
                   if Pos('Weapon_3 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_3 = "3" ""';
                   if Pos('Weapon_4 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_4 = "4" ""';
                   if Pos('Weapon_5 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_5 = "5" ""';
                   if Pos('Weapon_6 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_6 = "6" ""';
                   if Pos('Weapon_7 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_7 = "7" ""';
                   if Pos('Weapon_8 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_8 = "8" ""';
                   if Pos('Weapon_9 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_9 = "9" ""';
                   if Pos('Weapon_10 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_10 = "0" ""';
                   if Pos('Inventory = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory = "Enter" ""';
                   if Pos('Inventory_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Left = "[" ""';
                   if Pos('Inventory_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Right = "]" ""';
                   if Pos('Holo_Duke = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Holo_Duke = "H" ""';
                   if Pos('Jetpack = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Jetpack = "J" ""';
                   if Pos('NightVision = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='NightVision = "N" ""';
                   if Pos('MedKit = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='MedKit = "M" ""';
                   if Pos('TurnAround = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='TurnAround = "" ""';
                   if Pos('SendMessage = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='SendMessage = "T" ""';
                   if Pos('Map = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map = "Tab" ""';
                   if Pos('Shrink_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Shrink_Screen = "-" ""';
                   if Pos('Enlarge_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Enlarge_Screen = "=" ""';
                   if Pos('Center_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Center_View = "" ""';
                   if Pos('Holster_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Holster_Weapon = "" ""';
                   if Pos('Show_Opponents_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Show_Opponents_Weapon = "W" ""';
                   if Pos('Map_Follow_Mode = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map_Follow_Mode = "F" ""';
                   if Pos('See_Coop_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='See_Coop_View = "K" ""';
                   if Pos('Mouse_Aiming = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Mouse_Aiming = "U" ""';
                   if Pos('Toggle_Crosshair = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Toggle_Crosshair = "I" ""';
                   if Pos('Steroids = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Steroids = "R" ""';
                   if Pos('Quick_Kick = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Quick_Kick = "`" ""';
                   if Pos('Next_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Next_Weapon = "" ""';
                   if Pos('Previous_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Previous_Weapon = "" ""';
                 end;
                 //--------------------------------------------------------
                 //SHADOW WARRIOR - TECLADO
                 //--------------------------------------------------------
                 if (id = 10) then
                 begin
                   if Pos('Move_Forward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Forward = "Up" ""';
                   if Pos('Move_Backward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Backward = "Down" ""';
                   if Pos('Turn_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Left = "Left" ""';
                   if Pos('Turn_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Right = "Right" ""';
                   if Pos('Strafe = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe = "LAlt" "RAlt"';
                   if Pos('Fire = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Fire = "LCtrl" "RCtrl"';
                   if Pos('Open = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Open = "Space" ""';
                   if Pos('Run = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Run = "LShift" "RShift"';
                   if Pos('AutoRun = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='AutoRun = "CapLck" ""';
                   if Pos('Jump = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Jump = "A" ""';
                   if Pos('Crouch = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Crouch = "Z" ""';
                   if Pos('Look_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Up = "" ""';
                   if Pos('Look_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Down = "" ""';
                   if Pos('Strafe_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Left = "," ""';
                   if Pos('Strafe_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Right = "." ""';
                   if Pos('Aim_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Up = "" ""';
                   if Pos('Aim_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Down = "" ""';
                   if Pos('Weapon_1 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_1 = "1" ""';
                   if Pos('Weapon_2 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_2 = "2" ""';
                   if Pos('Weapon_3 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_3 = "3" ""';
                   if Pos('Weapon_4 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_4 = "4" ""';
                   if Pos('Weapon_5 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_5 = "5" ""';
                   if Pos('Weapon_6 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_6 = "6" ""';
                   if Pos('Weapon_7 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_7 = "7" ""';
                   if Pos('Weapon_8 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_8 = "8" ""';
                   if Pos('Weapon_9 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_9 = "9" ""';
                   if Pos('Weapon_10 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_10 = "0" ""';
                   if Pos('Inventory = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory = "Enter" ""';
                   if Pos('Inventory_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Left = "[" ""';
                   if Pos('Inventory_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Right = "]" ""';
                   if Pos('Med_Kit = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Med_Kit = "M" ""';
                   if Pos('Smoke_Bomb = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Smoke_Bomb = "S" ""';
                   if Pos('Night_Vision = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Night_Vision = "N" ""';
                   if Pos('Gas_Bomb = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Gas_Bomb = "G" ""';
                   if Pos('Flash_Bomb = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Flash_Bomb = "F" ""';
                   if Pos('Caltrops = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Caltrops = "C" ""';
                   if Pos('TurnAround = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='TurnAround = "" ""';
                   if Pos('SendMessage = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='SendMessage = "T" ""';
                   if Pos('Map = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map = "Tab" ""';
                   if Pos('Shrink_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Shrink_Screen = "-" ""';
                   if Pos('Enlarge_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Enlarge_Screen = "=" ""';
                   if Pos('Center_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Center_View = "" ""';
                   if Pos('Holster_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Holster_Weapon = "" ""';
                   if Pos('Map_Follow_Mode = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map_Follow_Mode = "F" ""';
                   if Pos('See_Co_Op_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='See_Co_Op_View = "K" ""';
                   if Pos('Mouse_Aiming = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Mouse_Aiming = "U" ""';
                   if Pos('Toggle_Crosshair = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Toggle_Crosshair = "I" ""';
                   if Pos('Next_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Next_Weapon = "" ""';
                   if Pos('Previous_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Previous_Weapon = "" ""';
                 end;
               end
               else
               begin
                 //--------------------------------------------------------
                 //BLOOD - MOUSE
                 //--------------------------------------------------------
                 if (id = 1) then
                 begin
                   if Pos('Move_Forward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Forward = "W" "N/A"';
                   if Pos('Move_Backward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Backward = "S" "N/A"';
                   if Pos('Turn_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Left = "N/A" "N/A"';
                   if Pos('Turn_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Right = "N/A" "N/A"';
                   if Pos('Turn_Around = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Around = "N/A" "N/A"';
                   if Pos('Strafe = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe = "N/A" "N/A"';
                   if Pos('Strafe_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Left = "A" "N/A"';
                   if Pos('Strafe_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Right = "D" "N/A"';
                   if Pos('Jump = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Jump = "Space" "N/A"';
                   if Pos('Crouch = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Crouch = "C" "N/A"';
                   if Pos('Run = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Run = "LShift" "RShift"';
                   if Pos('AutoRun = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='AutoRun = "CapLck" "N/A"';
                   if Pos('Open = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Open = "E" "N/A"';
                   if Pos('Weapon_Fire = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_Fire = "LCtrl" "RCtrl"';
                   if Pos('Weapon_Special_Fire = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_Special_Fire = "X" "N/A"';
                   if Pos('Aim_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Up = "N/A" "N/A"';
                   if Pos('Aim_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Down = "N/A" "N/A"';
                   if Pos('Aim_Center = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Center = "N/A" "N/A"';
                   if Pos('Look_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Up = "N/A" "N/A"';
                   if Pos('Look_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Down = "N/A" "N/A"';
                   if Pos('Tilt_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Tilt_Left = "N/A" "N/A"';
                   if Pos('Tilt_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Tilt_Right = "N/A" "N/A"';
                   if Pos('Weapon_1 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_1 = "1" "N/A"';
                   if Pos('Weapon_2 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_2 = "2" "N/A"';
                   if Pos('Weapon_3 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_3 = "3" "N/A"';
                   if Pos('Weapon_4 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_4 = "4" "N/A"';
                   if Pos('Weapon_5 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_5 = "5" "N/A"';
                   if Pos('Weapon_6 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_6 = "6" "N/A"';
                   if Pos('Weapon_7 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_7 = "7" "N/A"';
                   if Pos('Weapon_8 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_8 = "8" "N/A"';
                   if Pos('Weapon_9 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_9 = "9" "N/A"';
                   if Pos('Weapon_10 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_10 = "0" "N/A"';
                   if Pos('Inventory_Use = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Use = "Enter" "N/A"';
                   if Pos('Inventory_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Left = "[" "N/A"';
                   if Pos('Inventory_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Right = "]" "N/A"';
                   if Pos('Map_Toggle = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map_Toggle = "M" "N/A"';
                   if Pos('Map_Follow_Mode = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map_Follow_Mode = "N/A" "N/A"';
                   if Pos('Shrink_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Shrink_Screen = "-" "N/A"';
                   if Pos('Enlarge_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Enlarge_Screen = "=" "N/A"';
                   if Pos('Send_Message = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Send_Message = "T" "N/A"';
                   if Pos('See_Coop_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='See_Coop_View = "K" "N/A"';
                   if Pos('See_Chase_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='See_Chase_View = "N/A" "N/A"';
                   if Pos('Mouse_Aiming = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Mouse_Aiming = "U" "N/A"';
                   if Pos('Toggle_Crosshair = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Toggle_Crosshair = "N/A" "N/A"';
                   if Pos('Next_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Next_Weapon = "N/A" "N/A"';
                   if Pos('Previous_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Previous_Weapon = "N/A" "N/A"';
                   if Pos('Holster_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Holster_Weapon = "N/A" "N/A"';
                   if Pos('Show_Opponents_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Show_Opponents_Weapon = "N/A" "N/A"';
                   if Pos('BeastVision = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='BeastVision = "N/A" "N/A"';
                   if Pos('CrystalBall = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='CrystalBall = "N/A" "N/A"';
                   if Pos('JumpBoots = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='JumpBoots = "N/A" "N/A"';
                   if Pos('MedKit = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='MedKit = "N/A" "N/A"';
                   if Pos('ProximityBombs = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='ProximityBombs = "N/A" "N/A"';
                   if Pos('RemoteBombs = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='RemoteBombs = "N/A" "N/A"';
                 end;
                 //--------------------------------------------------------
                 //DUKE NUKEM 3D - MOUSE
                 //--------------------------------------------------------
                 if (id = 5) then
                 begin
                   if Pos('Move_Forward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Forward = "W" ""';
                   if Pos('Move_Backward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Backward = "S" ""';
                   if Pos('Turn_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Left = "" ""';
                   if Pos('Turn_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Right = "" ""';
                   if Pos('Strafe = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe = "" ""';
                   if Pos('Fire = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Fire = "LCtrl" "RCtrl"';
                   if Pos('Open = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Open = "E" ""';
                   if Pos('Run = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Run = "LShift" "RShift"';
                   if Pos('AutoRun = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='AutoRun = "CapLck" ""';
                   if Pos('Jump = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Jump = "Space" ""';
                   if Pos('Crouch = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Crouch = "C" ""';
                   if Pos('Look_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Up = "" ""';
                   if Pos('Look_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Down = "" ""';
                   if Pos('Look_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Left = "" ""';
                   if Pos('Look_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Right = "" ""';
                   if Pos('Strafe_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Left = "A" ""';
                   if Pos('Strafe_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Right = "D" ""';
                   if Pos('Aim_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Up = "" ""';
                   if Pos('Aim_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Down = "" ""';
                   if Pos('Weapon_1 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_1 = "1" ""';
                   if Pos('Weapon_2 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_2 = "2" ""';
                   if Pos('Weapon_3 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_3 = "3" ""';
                   if Pos('Weapon_4 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_4 = "4" ""';
                   if Pos('Weapon_5 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_5 = "5" ""';
                   if Pos('Weapon_6 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_6 = "6" ""';
                   if Pos('Weapon_7 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_7 = "7" ""';
                   if Pos('Weapon_8 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_8 = "8" ""';
                   if Pos('Weapon_9 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_9 = "9" ""';
                   if Pos('Weapon_10 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_10 = "0" ""';
                   if Pos('Inventory = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory = "I" ""';
                   if Pos('Inventory_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Left = "[" ""';
                   if Pos('Inventory_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Right = "]" ""';
                   if Pos('Holo_Duke = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Holo_Duke = "" ""';
                   if Pos('Jetpack = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Jetpack = "" ""';
                   if Pos('NightVision = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='NightVision = "" ""';
                   if Pos('MedKit = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='MedKit = "" ""';
                   if Pos('TurnAround = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='TurnAround = "" ""';
                   if Pos('SendMessage = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='SendMessage = "T" ""';
                   if Pos('Map = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map = "M" ""';
                   if Pos('Shrink_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Shrink_Screen = "-" ""';
                   if Pos('Enlarge_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Enlarge_Screen = "=" ""';
                   if Pos('Center_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Center_View = "" ""';
                   if Pos('Holster_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Holster_Weapon = "" ""';
                   if Pos('Show_Opponents_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Show_Opponents_Weapon = "" ""';
                   if Pos('Map_Follow_Mode = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map_Follow_Mode = "" ""';
                   if Pos('See_Coop_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='See_Coop_View = "K" ""';
                   if Pos('Mouse_Aiming = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Mouse_Aiming = "U" ""';
                   if Pos('Toggle_Crosshair = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Toggle_Crosshair = "" ""';
                   if Pos('Steroids = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Steroids = "" ""';
                   if Pos('Quick_Kick = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Quick_Kick = "`" ""';
                   if Pos('Next_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Next_Weapon = "" ""';
                   if Pos('Previous_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Previous_Weapon = "" ""';
                 end;
                 //--------------------------------------------------------
                 //SHADOW WARRIOR - MOUSE
                 //--------------------------------------------------------
                 if (id = 10) then
                 begin
                   if Pos('Move_Forward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Forward = "W" ""';
                   if Pos('Move_Backward = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Move_Backward = "S" ""';
                   if Pos('Turn_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Left = "" ""';
                   if Pos('Turn_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Turn_Right = "" ""';
                   if Pos('Strafe = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe = "" ""';
                   if Pos('Fire = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Fire = "LCtrl" "RCtrl"';
                   if Pos('Open = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Open = "E" ""';
                   if Pos('Run = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Run = "LShift" "RShift"';
                   if Pos('AutoRun = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='AutoRun = "CapLck" ""';
                   if Pos('Jump = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Jump = "Space" ""';
                   if Pos('Crouch = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Crouch = "C" ""';
                   if Pos('Look_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Up = "" ""';
                   if Pos('Look_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Look_Down = "" ""';
                   if Pos('Strafe_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Left = "A" ""';
                   if Pos('Strafe_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Strafe_Right = "D" ""';
                   if Pos('Aim_Up = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Up = "" ""';
                   if Pos('Aim_Down = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Aim_Down = "" ""';
                   if Pos('Weapon_1 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_1 = "1" ""';
                   if Pos('Weapon_2 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_2 = "2" ""';
                   if Pos('Weapon_3 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_3 = "3" ""';
                   if Pos('Weapon_4 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_4 = "4" ""';
                   if Pos('Weapon_5 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_5 = "5" ""';
                   if Pos('Weapon_6 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_6 = "6" ""';
                   if Pos('Weapon_7 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_7 = "7" ""';
                   if Pos('Weapon_8 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_8 = "8" ""';
                   if Pos('Weapon_9 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_9 = "9" ""';
                   if Pos('Weapon_10 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Weapon_10 = "0" ""';
                   if Pos('Inventory = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory = "I" ""';
                   if Pos('Inventory_Left = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Left = "[" ""';
                   if Pos('Inventory_Right = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Inventory_Right = "]" ""';
                   if Pos('Med_Kit = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Med_Kit = "" ""';
                   if Pos('Smoke_Bomb = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Smoke_Bomb = "" ""';
                   if Pos('Night_Vision = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Night_Vision = "" ""';
                   if Pos('Gas_Bomb = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Gas_Bomb = "" ""';
                   if Pos('Flash_Bomb = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Flash_Bomb = "" ""';
                   if Pos('Caltrops = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Caltrops = "" ""';
                   if Pos('TurnAround = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='TurnAround = "" ""';
                   if Pos('SendMessage = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='SendMessage = "T" ""';
                   if Pos('Map = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map = "M" ""';
                   if Pos('Shrink_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Shrink_Screen = "-" ""';
                   if Pos('Enlarge_Screen = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Enlarge_Screen = "=" ""';
                   if Pos('Center_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Center_View = "" ""';
                   if Pos('Holster_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Holster_Weapon = "" ""';
                   if Pos('Map_Follow_Mode = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Map_Follow_Mode = "" ""';
                   if Pos('See_Co_Op_View = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='See_Co_Op_View = "K" ""';
                   if Pos('Mouse_Aiming = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Mouse_Aiming = "U" ""';
                   if Pos('Toggle_Crosshair = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Toggle_Crosshair = "" ""';
                   if Pos('Next_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Next_Weapon = "" ""';
                   if Pos('Previous_Weapon = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='Previous_Weapon = "" ""';
                 end;
               //------------------------------------------------------------------------------
               end;
               //------------------------------------------------------------------------------
               {RxControle.StateOn - FIM}
               //------------------------------------------------------------------------------

               //------------------------------------------------------------------------------
               {BLOOD + DUKE NUKEM 3D + SHADOW WARRIOR}
               //------------------------------------------------------------------------------
               if (id = 1) or (id = 5) or (id = 10) then
               begin
                 //-------------------------------------------------------------
                 {SCREEN SETUP - RESOLUÇÃO 640x480 VESA 2.0}
                 //-------------------------------------------------------------
                 if Pos('ScreenMode = '  ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='ScreenMode = 1';
                 if Pos('ScreenWidth = ' ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='ScreenWidth = 640';
                 if Pos('ScreenHeight = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='ScreenHeight = 480';
                 //-------------------------------------------------------------

                 //-------------------------------------------------------------
                 {SOUND SETUP}
                 //-------------------------------------------------------------
                 if Pos('FXDevice = '   ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='FXDevice = 0';
                 if Pos('MusicDevice = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='MusicDevice = 7'; //Wave Blaster

                 if Pos('FXVolume = '   ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 begin
                   {SHADOW WARRIOR}
                   if (id = 10) then
                   Arquivo_DOSBOX_Fisico[i]:='FXVolume = 160'
                   {BLOOD + DUKE NUKEM 3D}
                   else
                   Arquivo_DOSBOX_Fisico[i]:='FXVolume = 220';
                 end;
                 if Pos('MusicVolume = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='MusicVolume = 200';
                 if Pos('NumVoices = '  ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 begin
                   {DUKE NUKEM 3D}
                   if (id = 5) then
                   Arquivo_DOSBOX_Fisico[i]:='NumVoices = 8'
                   {BLOOD + SHADOW WARRIOR}
                   else
                   Arquivo_DOSBOX_Fisico[i]:='NumVoices = 32';
                 end;
                 if Pos('NumChannels = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='NumChannels = 2';
                 if Pos('NumBits = '    ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='NumBits = 16';
                 if Pos('MixRate = '    ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 begin
                   {SHADOW WARRIOR}
                   if (id = 10) then
                   Arquivo_DOSBOX_Fisico[i]:='MixRate = 22000'
                   {BLOOD + DUKE NUKEM 3D}
                   else
                   Arquivo_DOSBOX_Fisico[i]:='MixRate = 44000';
                 end;
                 if Pos('MidiPort = '        ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='MidiPort = 0x330';
                 if Pos('BlasterAddress = '  ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='BlasterAddress = 0x220';
                 if Pos('BlasterType = '     ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='BlasterType = 6';
                 if Pos('BlasterInterrupt = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='BlasterInterrupt = 7';
                 if Pos('BlasterDma8 = '     ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='BlasterDma8 = 1';
                 if Pos('BlasterDma16 = '    ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='BlasterDma16 = 5';
                 if Pos('BlasterEmu = '      ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='BlasterEmu = 0x620';
                 if Pos('ReverseStereo = '   ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='ReverseStereo = 0';

                   {SHADOW WARRIOR - [Options]}
                   if (id = 10) then
                   begin
                     if Pos('FxOn = '   ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                     Arquivo_DOSBOX_Fisico[i]:='FxOn = 1';
                     if Pos('MusicOn = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                     Arquivo_DOSBOX_Fisico[i]:='MusicOn = 1';
                   end;
                 //-------------------------------------------------------------

                 //-----------------------------------------------------------------
                 {Controls}
                 //-----------------------------------------------------------------
                 if RxControle.StateOn = False then
                 begin
                   if Pos('ControllerType = '  ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='ControllerType = 0';
                   if Pos('ExternalFilename = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='ExternalFilename = "EXTERNAL.EXE"';
                 end
                 else
                 begin
                   if Pos('ControllerType = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='ControllerType = 3';
                   if Pos('ExternalFilename = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='ExternalFilename = "BMOUSE.EXE"';
                   if Pos('MouseAiming = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='MouseAiming = 0';
                   if Pos('MouseAimingFlipped = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='MouseAimingFlipped = 0';
                   if Pos('MouseButton1 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='MouseButton1 = "Jump"';
                   if Pos('MouseButton0 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   begin
                     {BLOOD}
                     if (id = 1) then
                     Arquivo_DOSBOX_Fisico[i]:='MouseButton0 = "Weapon_Fire"'
                     {DUKE NUKEM 3D + SHADOW WARRIOR}
                     else
                     Arquivo_DOSBOX_Fisico[i]:='MouseButton0 = "Fire"';
                   end;
                   if Pos('MouseButton2 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   begin
                     {BLOOD}
                     if (id = 1) then
                     Arquivo_DOSBOX_Fisico[i]:='MouseButton2 = "Weapon_Special_Fire"'
                     {DUKE NUKEM 3D + SHADOW WARRIOR}
                     else
                     Arquivo_DOSBOX_Fisico[i]:='MouseButton2 = ""';
                   end;
                 end;
                 //-----------------------------------------------------------------

                 //--------------------------------------------------------------------------------------
                 {DEFINE A SENSIBILIDADE DO MOUSE - "VALOR PADRÃO" + "VALOR NOVO"}
                 //--------------------------------------------------------------------------------------
                 if (Mouse_Global > 0) then
                 begin
                   if Pos('MouseAnalogScale0 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='MouseAnalogScale0 = ' +IntToStr(MouseAnalogX+Mouse_Global);
                   if Pos('MouseAnalogScale1 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='MouseAnalogScale1 = -'+IntToStr(MouseAnalogY+Mouse_Global);
                 end;
                 //--------------------------------------------------------------------------------------

                 //----------------------------------------------------------------------
                 {SERVIDOR OU CLIENTE - ONLINE}
                 //----------------------------------------------------------------------
                 if (check_single.Checked = False) then
                 begin
                   if Pos('NumberPlayers = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='NumberPlayers = '+cont_player.Text;
                   if Pos('PlayerName'      ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='PlayerName = "'+Trim(player_name.Text)+'"';
                 end;
                 //----------------------------------------------------------------------

               end;
               //------------------------------------------------------------------------------
               {BLOOD}
               //------------------------------------------------------------------------------
               if (id = 1) then
               begin

                 if (RxControle.StateOn = True) and (check_single.Checked = True) then
                 VarParametro_Global:=' -noaim -ini PHOBOS.ini'
                 else
                 begin
                   if RxControle.StateOn = True then
                   VarParametro_Global:=' -noaim';
                   if check_single.Checked = True then
                   VarParametro_Global:=' -ini PHOBOS.ini'
                   else
                   VarParametro_Global:=' -ini BLOOD.ini -broadcast';
                 end;

                 if Pos('Size = ' ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='Size = 1';
                 if Pos('Gamma = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='Gamma = 0';
                 if Pos('Detail = '  ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='Detail = 4';

                 //--------------------------------------------------------
                 {OPTIONS}
                 //--------------------------------------------------------
                 if Pos('MouseAim = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 begin
                   if RxControle.StateOn = True then
                   Arquivo_DOSBOX_Fisico[i]:='MouseAim = 1'
                   else
                   Arquivo_DOSBOX_Fisico[i]:='MouseAim = 0';
                 end;
                 if Pos('AimReticle = ' ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='AimReticle = 1';
                 //--------------------------------------------------------

               end;
               //------------------------------------------------------------------------------
               {CONSTRUCTOR}
               //------------------------------------------------------------------------------
               if (id = 2) then
               begin
                 if Pos('TextLanguage='  ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 begin
                   if (GetLanguageWin = 'por') then
                   Arquivo_DOSBOX_Fisico[i]:='TextLanguage=5'
                   else
                   Arquivo_DOSBOX_Fisico[i]:='TextLanguage=0';
                 end;
                 if Pos('AlwaysShowFlic=',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='AlwaysShowFlic=No';
                 if Pos('CDFlics='       ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='CDFlics=No';

                 //---------------------------------------------------------------
                 {SERVIDOR OU CLIENTE - ONLINE}
                 //---------------------------------------------------------------
                 if (check_single.Checked = False) then
                 begin
                   if Pos('PlayerName='    ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='PlayerName='+Trim(player_name.Text);
                   if Pos('GameName='      ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='GameName='  +Trim(player_name.Text);
                 end;
                 //---------------------------------------------------------------

               end;

               //------------------------------------------------------------------------------
               {DUKE NUKEM 3D}
               //------------------------------------------------------------------------------
               if (id = 5) then
               begin

                 if Pos('Shadows = '    ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='Shadows = 1';
                 if Pos('Password = '   ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='Password = ""';
                 if Pos('Detail = '     ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='Detail = 1';
                 if Pos('Tilt = '       ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='Tilt = 1';
                 if Pos('ScreenSize = ' ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='ScreenSize = 4';
                 if Pos('ScreenGamma = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='ScreenGamma = 0';

                 if RxControle.StateOn = True then
                 begin
                   if Pos('GameMouseAiming = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='GameMouseAiming = 1';
                   if Pos('AimingFlag = '     ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='AimingFlag = 1';
                 end
                 else
                 begin
                   if Pos('GameMouseAiming = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='GameMouseAiming = 0';
                   if Pos('AimingFlag = '     ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='AimingFlag = 0';
                 end;

                 if Pos('Crosshairs = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='Crosshairs = 1';

               end;
               //------------------------------------------------------------------------------
               {RISE OF THE TRIAD}
               //------------------------------------------------------------------------------
               if (id = 9) then
               begin

                 //------------------------------------------------------------------------
                 {SERVIDOR OU CLIENTE - ONLINE}
                 //------------------------------------------------------------------------
                 if (check_single.Checked = False) then
                 begin
                   if Pos('CODENAME'  ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='CODENAME            '+Trim(player_name.Text);
                   if Pos('NUMPLAYERS',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='NUMPLAYERS          '+cont_player.Text;
                 end;
                 //------------------------------------------------------------------------

               end;

               //------------------------------------------------------------------------------
               {SHADOW WARRIOR}
               //------------------------------------------------------------------------------
               if (id = 10) then
               begin
                 //----------------------------------------------------------
                 {OPTIONS}
                 //----------------------------------------------------------
                 if Pos('BorderNum = ' ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='BorderNum = 1';
                 if Pos('Brightness = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='Brightness = 1';
                 if Pos('Shadows = '   ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='Shadows = 1';
                 if Pos('Crosshair = ' ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='Crosshair = 1';

                 if check_single.Checked = False then
                 begin
                   if Pos('NetGameType = '    ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='NetGameType = 2';
                   if Pos('NetMonsters = '    ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='NetMonsters = 2';
                   if Pos('NetHurtTeammate = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='NetHurtTeammate = 2';
                 end;

                 if RxControle.StateOn = True then
                 begin
                   if Pos('AutoAim = '   ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='AutoAim = 0';
                   if Pos('MouseAimingOn = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='MouseAimingOn = 1';
                 end
                 else
                 begin
                   if Pos('AutoAim = '   ,Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='AutoAim = 1';
                   if Pos('MouseAimingOn = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                   Arquivo_DOSBOX_Fisico[i]:='MouseAimingOn = 0';
                 end;

                 if Pos('MouseInvert = 0',Arquivo_DOSBOX_Fisico[i]) = 1 then
                 Arquivo_DOSBOX_Fisico[i]:='MouseInvert = 1';
                 //----------------------------------------------------------

               end;
               //------------------------------------------------------------------------------
             end;

           Arquivo_DOSBOX_Fisico.SaveToFile(Config_Game_Global);
           Arquivo_DOSBOX_Fisico.Free;
           end;

   8:
    begin
    //------------------------------------------------------------------------------
    {QUAKE - INÍCIO}
    //------------------------------------------------------------------------------
      if (RxDM.StateOn = False) then
      begin
      VarParametro_Global:=' -noserial';
      Quake_Folder:='';

      Application.CreateForm(TForm2_DLC, Form2_DLC);
      Form2_DLC.ShowModal;
      Form2_DLC.Free;
                      
        //----------------------
        if Fecha_ESC = True then
        Exit;
        //----------------------

        if (not FileExists(Caminho_Global+'game.cue')  and (EPI_Global_DLC = 1)) or
           (not FileExists(Caminho_Global+'gamea.cue') and (EPI_Global_DLC = 2)) or
           (not FileExists(Caminho_Global+'gamed.cue') and (EPI_Global_DLC = 3)) then
        VarParametro_Global:=VarParametro_Global+' -nocdaudio';

        if (check_cliente.Checked = False) then
        begin
        Seleciona_Fases;
          //----------------------
          if Fecha_ESC = True then
          Exit;
          //----------------------
        VarParametro_Global:=VarParametro_Global+' +map '+Map_Global;
        end;

        //-----------------------------------------------------------------------------------------------------
        {DEBUG MODE}
        //-----------------------------------------------------------------------------------------------------
        if (menu_debug.Checked = True) then
        MessageBox(Application.Handle,pchar(VarParametro_Global),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);
        //-----------------------------------------------------------------------------------------------------

        case AnsiIndexStr(Nome_DLC_Global,['','Scourge of Armagon','Dissolution of Eternity']) of
        0: Quake_Folder:='id1\';
        1: Quake_Folder:='hipnotic\';
        2: Quake_Folder:='rogue\';
        end;

      Arquivo_DOSBOX_Fisico:=TStringList.Create;
      Arquivo_DOSBOX_Fisico.LoadFromFile(Caminho_Global+Quake_Folder+Array_Games[id][6]);
                        
        for i:=0 to Arquivo_DOSBOX_Fisico.Count-1 do
        begin

          {Winquake.exe e Glquake.exe}
          if Pos('_vid_default_mode_win "',Arquivo_DOSBOX_Fisico[i]) = 1 then
          begin
            if menu_debug.Checked = False then
            Arquivo_DOSBOX_Fisico[i]:='_vid_default_mode_win "4.000000"'
            else
            Arquivo_DOSBOX_Fisico[i]:='_vid_default_mode_win "3.000000"';
          end;

          {DOSBox}
          if Pos('_vid_default_mode "',Arquivo_DOSBOX_Fisico[i]) = 1 then
          begin
            if menu_debug.Checked = False then
            Arquivo_DOSBOX_Fisico[i]:='_vid_default_mode "12.000000"'
            else
            Arquivo_DOSBOX_Fisico[i]:='_vid_default_mode "0.000000"';
          end;

        end;

      Arquivo_DOSBOX_Fisico.SaveToFile(Caminho_Global+Quake_Folder+Array_Games[id][6]);
      Arquivo_DOSBOX_Fisico.Free;
                  
      //------------------------------------------------------------
      Arquivo_DOSBOX_Fisico:=TStringList.Create;
      Arquivo_DOSBOX_Fisico.Add('bind w "+forward"'     );
      Arquivo_DOSBOX_Fisico.Add('bind a "+moveleft"'    );
      Arquivo_DOSBOX_Fisico.Add('bind s "+back"'        );
      Arquivo_DOSBOX_Fisico.Add('bind d "+moveright"'   );
      Arquivo_DOSBOX_Fisico.Add('bind MOUSE1 "+attack"' );
      Arquivo_DOSBOX_Fisico.Add('bind MOUSE2 "+jump"'   );
      Arquivo_DOSBOX_Fisico.Add('sensitivity "5.000000"');
      Arquivo_DOSBOX_Fisico.Add('+mlook');

        {SINGLE PLAYER}
        if (check_single.Checked = True) then
        Arquivo_DOSBOX_Fisico.Add('name Ranger')
        else
        {SERVIDOR E CLIENTE}
        begin
          {SERVIDOR}
          if (check_servidor.Checked = True) then
          begin
          Arquivo_DOSBOX_Fisico.Add('hostname DGL');
          Arquivo_DOSBOX_Fisico.Add('maxplayers '+cont_player.Text);
          Arquivo_DOSBOX_Fisico.Add('coop 1');
          Arquivo_DOSBOX_Fisico.Add('teamplay off');
          Arquivo_DOSBOX_Fisico.Add('skill 1');
          Arquivo_DOSBOX_Fisico.Add('fraglimit none');
          Arquivo_DOSBOX_Fisico.Add('timelimit none');
          Arquivo_DOSBOX_Fisico.Add('pausable 0');
          end
          else
          {CLIENTE}
          Arquivo_DOSBOX_Fisico.Add('connect DGL');

          //----------------------------------------------------------------------------------------
          {QUAKE - APENAS O NAMEFUN}
          //----------------------------------------------------------------------------------------
          if RxOpcoes.StateOn = True then
          Arquivo_DOSBOX_Fisico.Add('exec '+Copy(CoolStuff_Global,7,Pos('.scr',CoolStuff_Global)-3))
          else
          Arquivo_DOSBOX_Fisico.Add('name '+Trim(player_name.Text));
          //----------------------------------------------------------------------------------------

        Arquivo_DOSBOX_Fisico.Add('color '+IntToStr(combo_color.ItemIndex));
        end;

      Arquivo_DOSBOX_Fisico.Add('clear');
      Arquivo_DOSBOX_Fisico.Add('echo '+Application.Title);
      Arquivo_DOSBOX_Fisico.SaveToFile(Caminho_Global+Quake_Folder+'autoexec.cfg');
      Arquivo_DOSBOX_Fisico.Free;
      end
      {QUAKE - FIM}
      //------------------------------------------------------------------------------
      else
      begin
      //-----------------------------------------------------------------------------------------------------------------------
      {QUAKEWORLD - INÍCIO - DEATHMATCH}
      //-----------------------------------------------------------------------------------------------------------------------
      QW_Server:=Caminho_Global+'qwsv.exe';
      Nome_DLC_Global:='QuakeWorld';
      Game_EXE_Global:='qwcl.exe';

        //---------------------------------
        {DEBUG MODE}
        //---------------------------------
        if (menu_debug.Checked = True) then
        begin
        QW_WinMode:=' -startwindowed';
        QW_Server_Debug:=SW_NORMAL;
        end
        else
        begin
        QW_WinMode:='';
        QW_Server_Debug:=SW_HIDE;
        end;
        //---------------------------------

      //-----------------------------------------------------
      Config_Game_Global:=Caminho_Global+'qw\config.cfg';

      Arquivo_DOSBOX_Fisico:=TStringList.Create;
      Arquivo_DOSBOX_Fisico.LoadFromFile(Config_Game_Global);
        if not (Arquivo_DOSBOX_Fisico[Arquivo_DOSBOX_Fisico.Count-1] = 'exec autoexec.cfg') then
        Arquivo_DOSBOX_Fisico.Add('exec autoexec.cfg');
      Arquivo_DOSBOX_Fisico.SaveToFile(Config_Game_Global);
      Arquivo_DOSBOX_Fisico.Free;

      Arquivo_DOSBOX_Fisico:=TStringList.Create;
      Arquivo_DOSBOX_Fisico.Add('+mlook');
      Arquivo_DOSBOX_Fisico.Add('connect '+ip_local.Text);
      Arquivo_DOSBOX_Fisico.Add('clear');
      Arquivo_DOSBOX_Fisico.Add('echo '+Application.Title);
      Arquivo_DOSBOX_Fisico.SaveToFile(ExtractFilePath(Config_Game_Global)+'autoexec.cfg');
      Arquivo_DOSBOX_Fisico.Free;
      //-----------------------------------------------------

        if RXOpcoes.StateOn = False then
        CoolStuff_Global:='+name '+Trim(Form1_DGL.player_name.Text);

      //----------------------------------------------------------------------------------------------
      {NAMEFUN E SKIN}
      //----------------------------------------------------------------------------------------------
      VarParametro_Global:=QW_WinMode+' '+CoolStuff_Global+' +color '+IntToStr(combo_color.ItemIndex);
      //----------------------------------------------------------------------------------------------

        //-----------------------------------------------------------------------------------------------------------------------
        {QUAKEWORLD - SERVIDOR - EXECUTA JUNTO O ARQUIVO .EXE DO SERVIDOR QUAKEWORLD}
        //-----------------------------------------------------------------------------------------------------------------------
        if (check_servidor.Checked = True) then
        begin
        Seleciona_Fases;

          //----------------------
          if Fecha_ESC = True then
          Exit;
          //----------------------

          //-----------------------------------------------------------------------------------------------------------------------
          {DEBUG MODE - SERVIDOR}
          //-----------------------------------------------------------------------------------------------------------------------
          if (menu_debug.Checked = True) then
          MessageBox(Application.Handle,pchar(VarParametro_Global+#13#13+Map_Global),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);
          //-----------------------------------------------------------------------------------------------------------------------

          //-----------------------------------------------------------------------------------------------------------------------
          {SERVIDOR DEDICADO - QUAKEWORLD}
          //-----------------------------------------------------------------------------------------------------------------------
          if (RxQuakeServer.StateOn = True) then
          begin
          Config_Tela(False);
          btn_start.Caption:=Lang_DGL(5);
          ShellExecute(Handle,'open',pchar(QW_Server),pchar('+map '+Map_Global),pchar(ExtractFilePath(QW_Server)),SW_MAXIMIZE);
          Timer_MonitoraAPP.Enabled:=True;
          Exit;
          end
          else
          ShellExecute(Handle,'open',pchar(QW_Server),pchar('+map '+Map_Global),pchar(ExtractFilePath(QW_Server)),QW_Server_Debug);
          //-----------------------------------------------------------------------------------------------------------------------

        end;

      //---------------------------------------------------------------------
      {QUAKE/QUAKEWORLD - CONTAGEM PRA INICIAR - CLIENTE}
      //---------------------------------------------------------------------
      if (menu_debug.Checked = False) and (check_cliente.Checked = True) then
      Contagem_Iniciar;
      //---------------------------------------------------------------------
      
      ShellExecute(Handle,'open',pchar(ExtractFilePath(QW_Server)+Game_EXE_Global),pchar(VarParametro_Global),pchar(ExtractFilePath(QW_Server)),SW_NORMAL);
      Exit;
      end;
      {QUAKEWORLD - FIM - DEATHMATCH}
      //-----------------------------------------------------------------------------------------------------------------------

    //-----------------------------------------------------------------------------------------------------------------------
    {DEBUG MODE - QUAKE/QUAKEWORLD - CLIENTE}
    //-----------------------------------------------------------------------------------------------------------------------
    if (menu_debug.Checked = True) and (check_cliente.Checked = True) then
    MessageBox(Application.Handle,pchar(VarParametro_Global+#13#13+Map_Global),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);

    Config_Tela(False);
    btn_start.Caption:=Lang_DGL(5);

    Timer_MonitoraAPP.Enabled:=True;
    //-----------------------------------------------------------------------------------------------------------------------
    end;

  11:
    begin
    //------------------------------------------------------------------------------
    {WARCRAFT II}
    //------------------------------------------------------------------------------
    Arquivo_DOSBOX_Fisico:=TStringList.Create;
    Arquivo_DOSBOX_Fisico.LoadFromFile(Config_Game_Global);

     for i:=0 to Arquivo_DOSBOX_Fisico.Count-1 do
     begin
      if Pos('cdpath=',Arquivo_DOSBOX_Fisico[i]) = 1 then
      Arquivo_DOSBOX_Fisico[i]:='cdpath=d:\';
      if Pos('mscroll=',Arquivo_DOSBOX_Fisico[i]) = 1 then
      Arquivo_DOSBOX_Fisico[i]:='mscroll=0';

      if Pos('intro=',Arquivo_DOSBOX_Fisico[i]) = 1 then
      begin
       if (check_single.Checked = True) then
       Arquivo_DOSBOX_Fisico[i]:='intro=1'
       else
       Arquivo_DOSBOX_Fisico[i]:='intro=0';
      end;

      if Pos('name=',Arquivo_DOSBOX_Fisico[i]) = 1 then
      begin
       if (check_single.Checked = False) then
       Arquivo_DOSBOX_Fisico[i]:='name='+Trim(player_name.Text);
      end;

     end;

    Arquivo_DOSBOX_Fisico.SaveToFile(Config_Game_Global);
    Arquivo_DOSBOX_Fisico.Free;
    //------------------------------------------------------------------------------
    end;

  3,4,6,7,12,13:
    begin
    //------------------------------------------------------------------------------
    {DOOM + DOOM 2 + HERETIC + HEXEN + WOLFENSTEIN 3D + SPEAR OF DESTINY}
    //------------------------------------------------------------------------------
    Arquivo_DOSBOX_Fisico:=TStringList.Create;
    Arquivo_DOSBOX_Fisico.LoadFromFile(Config_Game_Global);

     case id of
     3,4,12,13: begin
                Var_Bindings:='Doom';

                  {SELECIONA QUAL ARQUIVO WAD VAI CARREGAR PARA CONECTAR A UM JOGO CRIADO}
                  if (id = 3) and (check_cliente.Checked = True) then
                  begin
                  Application.CreateForm(TForm2_DLC, Form2_DLC);
                  Form2_DLC.ShowModal;
                  Form2_DLC.Free;
                    //----------------------
                    if Fecha_ESC = True then
                    Exit;
                    //----------------------
                  end;
                  
                end;
             6: Var_Bindings:='Heretic';
             7: Var_Bindings:='Hexen';
     end;

     for i:=0 to Arquivo_DOSBOX_Fisico.Count-1 do
     begin
       //-----------------------------------------------------------------------
       {[GlobalSettings]}
       //-----------------------------------------------------------------------
       if Pos('vid_tft=true'      ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='vid_tft=false';
       if Pos('m_use_mouse='      ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='m_use_mouse=0';
       if Pos('show_messages=',Arquivo_DOSBOX_Fisico[i]) = 1 then
       begin
         {WOLFENSTEIN 3D + SPEAR OF DESTINY}
         if (id = 12) or (id = 13) then
         Arquivo_DOSBOX_Fisico[i]:='show_messages=false'
         else
         Arquivo_DOSBOX_Fisico[i]:='show_messages=true';
       end;
       if Pos('mouse_sensitivity=',Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='mouse_sensitivity=1.5';
       if Pos('use_mouse='        ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='use_mouse='+BoolToStr(RxControle.StateOn);
       if Pos('fullscreen='       ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='fullscreen='+BoolToStr(not menu_debug.Checked);
       //----------------------------------------------------------
       {DEBUG MODE}
       //----------------------------------------------------------
       if (menu_debug.Checked = True) then
       begin
         if Pos('vid_aspect=',Arquivo_DOSBOX_Fisico[i]) = 1 then
         Arquivo_DOSBOX_Fisico[i]:='vid_aspect=0';
         if Pos('vid_vsync=',Arquivo_DOSBOX_Fisico[i]) = 1 then
         Arquivo_DOSBOX_Fisico[i]:='vid_vsync=false';
         if Pos('vid_defheight=',Arquivo_DOSBOX_Fisico[i]) = 1 then
         Arquivo_DOSBOX_Fisico[i]:='vid_defheight=480';
         if Pos('vid_defwidth=',Arquivo_DOSBOX_Fisico[i]) = 1 then
         Arquivo_DOSBOX_Fisico[i]:='vid_defwidth=640';
       end
       else
       begin
         if Pos('vid_aspect=',Arquivo_DOSBOX_Fisico[i]) = 1 then
         Arquivo_DOSBOX_Fisico[i]:='vid_aspect='+IntToStr(AspectRatio(Screen.Width,Screen.Height));
         if Pos('vid_vsync=',Arquivo_DOSBOX_Fisico[i]) = 1 then
         Arquivo_DOSBOX_Fisico[i]:='vid_vsync=True';
         
         if Pos('vid_defheight=',Arquivo_DOSBOX_Fisico[i]) = 1 then
         Arquivo_DOSBOX_Fisico[i]:='vid_defheight='+IntToStr(Screen.Height);
         if Pos('vid_defwidth=',Arquivo_DOSBOX_Fisico[i]) = 1 then
         Arquivo_DOSBOX_Fisico[i]:='vid_defwidth='+IntToStr(Screen.Width);
       end;
       //----------------------------------------------------------
       if Pos('Gamma=',Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='Gamma=1';
       if Pos('r_fakecontrast=0',Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='r_fakecontrast=1';
       if Pos('screenshot_quiet=false',Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='screenshot_quiet=true';
       if Pos('freelook=',Arquivo_DOSBOX_Fisico[i]) = 1 then
       begin
         {WOLFENSTEIN 3D + SPEAR OF DESTINY}
         if (id = 12) or (id = 13) then
         Arquivo_DOSBOX_Fisico[i]:='freelook=false'
         else
         Arquivo_DOSBOX_Fisico[i]:='freelook='+BoolToStr(RxControle.StateOn);
       end;
       if Pos('cl_run=true'   ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='cl_run=false';
       if Pos('save_dir='     ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='save_dir='+Caminho_Global;
       if Pos('longsavemessages=true',Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='longsavemessages=false';
       if Pos('defaultiwad='  ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='defaultiwad='+ExtractName(Array_Games[id][4]);
       if Pos('queryiwad=true',Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='queryiwad=false';
       if Pos('screenblocks=' ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='screenblocks=10';
       if Pos('menu_screenratios=',Arquivo_DOSBOX_Fisico[i]) = 1 then
       begin
         case AspectRatio(Screen.Width,Screen.Height) of
           {16:9}
           1: Arquivo_DOSBOX_Fisico[i]:='menu_screenratios=1';
           {4:3}
           3: Arquivo_DOSBOX_Fisico[i]:='menu_screenratios=0';
           else
           Arquivo_DOSBOX_Fisico[i]:='menu_screenratios=-1';
         end;
       end;
       if Pos('show_obituaries=true',Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='show_obituaries=false';
       if Pos('am_showmaplabel=',Arquivo_DOSBOX_Fisico[i]) = 1 then
       begin
         {HEXEN - WOLFENSTEIN 3D - SPEAR OF DESTINY}
         case id of
           7,12,13: Arquivo_DOSBOX_Fisico[i]:='am_showmaplabel=0';
           else
           Arquivo_DOSBOX_Fisico[i]:='am_showmaplabel=1';
         end;
       end;
       if Pos('cl_maxdecals='   ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='cl_maxdecals=0';
       if Pos('cl_rockettrails=',Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='cl_rockettrails=0';
       if Pos('language='       ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='language=enu';
       if Pos('wipetype='       ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='wipetype=0';
       if Pos('msgmidcolor='    ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='msgmidcolor=11';
       if Pos('msg4color='      ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='msg4color=11';
       if Pos('msg3color='      ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='msg3color=11';
       if Pos('msg2color='      ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='msg2color=11';
       if Pos('msg1color='      ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='msg1color=11';
       if Pos('msg0color='      ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='msg0color=11';
       if Pos('con_scaletext='  ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='con_scaletext=1';
       if Pos('am_drawmapback=' ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       begin
         {HERETIC - HEXEN}
         case id of
           6,7: Arquivo_DOSBOX_Fisico[i]:='am_drawmapback=1';
           else
           Arquivo_DOSBOX_Fisico[i]:='am_drawmapback=0';
         end;
       end;
       if Pos('am_colorset=',Arquivo_DOSBOX_Fisico[i]) = 1 then
       begin
         {HERETIC - HEXEN}
         case id of
           6,7: Arquivo_DOSBOX_Fisico[i]:='am_colorset=3';
           else
           Arquivo_DOSBOX_Fisico[i]:='am_colorset=1';
         end;
       end;
       if Pos('am_showtime=',Arquivo_DOSBOX_Fisico[i]) = 1 then
       begin
         {HEXEN}
         case id of
           7: Arquivo_DOSBOX_Fisico[i]:='am_showtime=true';
           else
           Arquivo_DOSBOX_Fisico[i]:='am_showtime=false';
         end;
       end;
       if Pos('am_showmonsters=true',Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='am_showmonsters=false';
       if Pos('am_showsecrets=true' ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='am_showsecrets=false';
       if Pos('am_rotate='          ,Arquivo_DOSBOX_Fisico[i]) = 1 then
       Arquivo_DOSBOX_Fisico[i]:='am_rotate=0';
       //-----------------------------------------------------------------------
       if Pos('['+Var_Bindings+'.Bindings]',Arquivo_DOSBOX_Fisico[i]) = 1 then
       begin
         //-----------------------------------------------------------------------------
         {APAGA TUDO DESDE [Doom.Bindings] ATÉ [Doom.DoubleBindings]}
         //-----------------------------------------------------------------------------
         for j:=i+1 to Arquivo_DOSBOX_Fisico.Count-1 do
         begin
           if Pos('['+Var_Bindings+'.DoubleBindings]',Arquivo_DOSBOX_Fisico[j]) = 0 then
           Arquivo_DOSBOX_Fisico[j]:=''
           else
           Break;
         end;                        // tirar os DELET e substituir pra nao mudar o tamanho do arquivo
        // usar talvez os colchetes pra nao ter INSERT e mudar tamanho do arquivo.
         //-----------------------------------------------------------------------------
       Arquivo_DOSBOX_Fisico.Insert(i+1,'1=slot 1');
       Arquivo_DOSBOX_Fisico.Insert(i+2,'2=slot 2');
       Arquivo_DOSBOX_Fisico.Insert(i+3,'3=slot 3');
       Arquivo_DOSBOX_Fisico.Insert(i+4,'4=slot 4');
         //-------------------------------------------------------------
         {HEXEN}
         //-------------------------------------------------------------
         if (id = 7) then
         begin
         Arquivo_DOSBOX_Fisico.Insert(i+5,'5=use ArtiInvulnerability2');
         Arquivo_DOSBOX_Fisico.Insert(i+6,'6=use ArtiPork');
         Arquivo_DOSBOX_Fisico.Insert(i+7,'7=use ArtiTeleportOther');
         Arquivo_DOSBOX_Fisico.Insert(i+8,'8=use ArtiTeleport');
         Arquivo_DOSBOX_Fisico.Insert(i+9,'9=use ArtiBlastRadius');
         Arquivo_DOSBOX_Fisico.Insert(i+10,'0=useflechette');
         end
         else
         begin
         Arquivo_DOSBOX_Fisico.Insert(i+5,'5=slot 5');
         Arquivo_DOSBOX_Fisico.Insert(i+6,'6=slot 6');
         Arquivo_DOSBOX_Fisico.Insert(i+7,'7=slot 7');
         Arquivo_DOSBOX_Fisico.Insert(i+8,'8=slot 8');
         Arquivo_DOSBOX_Fisico.Insert(i+9,'9=slot 9');
         Arquivo_DOSBOX_Fisico.Insert(i+10,'0=slot 0');
         end;
         //-------------------------------------------------------------
         Arquivo_DOSBOX_Fisico.Insert(i+11,'-=sizedown');
         Arquivo_DOSBOX_Fisico.Insert(i+12,'Equals=sizeup');
         Arquivo_DOSBOX_Fisico.Insert(i+13,'tab=togglemap');
         Arquivo_DOSBOX_Fisico.Insert(i+14,'t=messagemode');
         Arquivo_DOSBOX_Fisico.Insert(i+15,'LeftBracket=invprev');
         Arquivo_DOSBOX_Fisico.Insert(i+16,'RightBracket=invnext');
         Arquivo_DOSBOX_Fisico.Insert(i+17,'enter=invuse');
         //----------------------------------------------------------
         {TECLADO}
         //----------------------------------------------------------
         if RxControle.StateOn = False then
         begin
         Arquivo_DOSBOX_Fisico.Insert(i+18,'ctrl=+attack');
         Arquivo_DOSBOX_Fisico.Insert(i+19,'shift=+speed');
         Arquivo_DOSBOX_Fisico.Insert(i+20,'alt=+strafe');
         Arquivo_DOSBOX_Fisico.Insert(i+21,'space=+use');
         Arquivo_DOSBOX_Fisico.Insert(i+22,'capslock=toggle cl_run');
         Arquivo_DOSBOX_Fisico.Insert(i+23,'pause=pause');
         Arquivo_DOSBOX_Fisico.Insert(i+24,'uparrow=+forward');
         Arquivo_DOSBOX_Fisico.Insert(i+25,'leftarrow=+left');
         Arquivo_DOSBOX_Fisico.Insert(i+26,'rightarrow=+right');
         Arquivo_DOSBOX_Fisico.Insert(i+27,'downarrow=+back');
         Arquivo_DOSBOX_Fisico.Insert(i+28,'');
         end
         //----------------------------------------------------------
         {MOUSE}
         //----------------------------------------------------------
         else
         begin
         Arquivo_DOSBOX_Fisico.Insert(i+18,'shift=+speed');
         Arquivo_DOSBOX_Fisico.Insert(i+19,'capslock=toggle cl_run');
         Arquivo_DOSBOX_Fisico.Insert(i+20,'pause=pause');
         Arquivo_DOSBOX_Fisico.Insert(i+21,'w=+forward');
         Arquivo_DOSBOX_Fisico.Insert(i+22,'e=+use');
         Arquivo_DOSBOX_Fisico.Insert(i+23,'a=+moveleft');
         Arquivo_DOSBOX_Fisico.Insert(i+24,'s=+back');
         Arquivo_DOSBOX_Fisico.Insert(i+25,'d=+moveright');
         {WOLFENSTEIN 3D + SPEAR OF DESTINY - NÃO TEM "ABAIXAR"}
         Arquivo_DOSBOX_Fisico.Insert(i+26,'c=+crouch');
         Arquivo_DOSBOX_Fisico.Insert(i+27,'mouse1=+attack');
         {WOLFENSTEIN 3D + SPEAR OF DESTINY - NÃO TEM "PULAR"}
         Arquivo_DOSBOX_Fisico.Insert(i+28,'mouse2=+jump');
         Arquivo_DOSBOX_Fisico.Insert(i+29,'mwheelup=weapprev');
         Arquivo_DOSBOX_Fisico.Insert(i+30,'mwheeldown=weapnext');
         Arquivo_DOSBOX_Fisico.Insert(i+31,'');
         end;
         //----------------------------------------------------------
       end;
       //------------------------------------------------------------------------------
       {HEXEN}
       if (id = 7) then
       begin
         if Pos('playerclass=',Arquivo_DOSBOX_Fisico[i]) = 1 then
         begin
         Application.CreateForm(TForm2_DLC, Form2_DLC);
         Form2_DLC.ShowModal;
         Form2_DLC.Free;

           //----------------------
           if Fecha_ESC = True then
           Exit;
           //----------------------

           case EPI_Global_DLC of
           1: Arquivo_DOSBOX_Fisico[i]:='playerclass=Fighter';
           2: Arquivo_DOSBOX_Fisico[i]:='playerclass=Cleric';
           3: Arquivo_DOSBOX_Fisico[i]:='playerclass=Mage';
           end;

         end;
       end;
       if (check_single.Checked = False) then
       begin
         {SKIN - DOOM e DOOM II}
         case combo_doom.ItemIndex of
         0: begin
              if Pos('skin=',Arquivo_DOSBOX_Fisico[i]) = 1 then
              Arquivo_DOSBOX_Fisico[i]:='skin=base';
              if Pos('colorset=',Arquivo_DOSBOX_Fisico[i]) = 1 then
              Arquivo_DOSBOX_Fisico[i]:='colorset='+IntToStr(combo_color.ItemIndex);
            end;
         1: begin
              if Pos('skin=',Arquivo_DOSBOX_Fisico[i]) = 1 then
              Arquivo_DOSBOX_Fisico[i]:='skin=Phobos';
              if Pos('colorset=',Arquivo_DOSBOX_Fisico[i]) = 1 then
              Arquivo_DOSBOX_Fisico[i]:='colorset=-1';
              if Pos('color=',Arquivo_DOSBOX_Fisico[i]) = 1 then
              Arquivo_DOSBOX_Fisico[i]:='color=ff 50 00';
            end;
         end;
         if Pos('name=',Arquivo_DOSBOX_Fisico[i]) = 1 then
         Arquivo_DOSBOX_Fisico[i]:='name='+Trim(player_name.Text);
       end;
       if Pos('autoaim=',Arquivo_DOSBOX_Fisico[i]) = 1 then
       begin
         if RxControle.StateOn = True then
         Arquivo_DOSBOX_Fisico[i]:='autoaim=0'
         else
         Arquivo_DOSBOX_Fisico[i]:='autoaim=35';
       end;
       //------------------------------------------------------------------------------
     end; {END - FOR}
    Arquivo_DOSBOX_Fisico.SaveToFile(Config_Game_Global);
    Arquivo_DOSBOX_Fisico.Free;
    //------------------------------------------------------------------------------
    end;
end;
          
{DOSBOX}
if (Array_Games[id][7] = 'DOSBOX') then
begin
Arq_DosBox:=ExtractFilePath(Application.ExeName)
           +Array_Games[id][3]
           +LowerCase(ExtractName(Game_EXE_Global))
           +'_dosbox.conf';

CopyFile(pchar(ExtractFilePath(DosBox_EXE_Global)+'dosbox-0.74.conf'),pchar(Arq_DosBox),False);

{ARQUIVO DE CONFIGURAÇÃO}
//------------------------------------------------------------------------------
Arquivo_DOSBOX_Fisico:=TStringList.Create;
Arquivo_DOSBOX_Fisico.LoadFromFile(Arq_DosBox);
//------------------------------------------------------------------------------

 for i:=0 to Arquivo_DOSBOX_Fisico.Count-1 do
 begin

    if Pos('fullscreen=',Arquivo_DOSBOX_Fisico[i]) = 1 then
    begin
      //----------------------------------------------------------------
      {RISE OF THE TRIAD + WARCRAFT II}
      //----------------------------------------------------------------
      //PARA ACESSAR O COMANDO DE TECLAS QUE NÃO FUNCIONA SE ESTIVER FULLSCREEN
      if (check_single.Checked = False) and ((id = 9) or (id = 11)) then
      Arquivo_DOSBOX_Fisico[i]:='fullscreen=false'
      else
      Arquivo_DOSBOX_Fisico[i]:='fullscreen='+BoolToStr(not menu_debug.Checked);
    end;

    if Pos('fullresolution=',Arquivo_DOSBOX_Fisico[i]) = 1 then
    begin
      //--------------------------------------------------
      {BLOOD + DUKE NUKEM 3D + SHADOW WARRIOR}
      //--------------------------------------------------
      if (id = 1) or (id = 5) or (id = 10) then
      Arquivo_DOSBOX_Fisico[i]:='fullresolution=0x0';
    end;

    if Pos('output=',Arquivo_DOSBOX_Fisico[i]) = 1 then
    begin
      {NÃO TEM PLACA DE VÍDEO - INTEL}
      if ProcessExists('igfxTray.exe') = True then
      Arquivo_DOSBOX_Fisico[i]:='output=opengl'
      else
      Arquivo_DOSBOX_Fisico[i]:='output=overlay';
    end;

    if Pos('machine=',Arquivo_DOSBOX_Fisico[i]) = 1 then
    begin
     //-------------------------------------------------------------
     {BLOOD + DUKE NUKEM 3D + SHADOW WARRIOR}
     //-------------------------------------------------------------
     if (id = 1) or (id = 5) or (id = 10) then
     Arquivo_DOSBOX_Fisico[i]:='machine=vesa_nolfb';
     //-------------------------------------------------------------
    end;

    if Pos('memsize=',Arquivo_DOSBOX_Fisico[i]) = 1 then
    begin
     //-------------------------------------
     {CONSTRUCTOR}
     //-------------------------------------
     if (id = 2) then
     Arquivo_DOSBOX_Fisico[i]:='memsize=32'
     else
     Arquivo_DOSBOX_Fisico[i]:='memsize=64';
     //-------------------------------------
    end;

    if Pos('aspect=',Arquivo_DOSBOX_Fisico[i]) = 1 then
    Arquivo_DOSBOX_Fisico[i]:='aspect=true';
    if Pos('scaler=',Arquivo_DOSBOX_Fisico[i]) = 1 then
    Arquivo_DOSBOX_Fisico[i]:='scaler=normal2x';

    if Pos('core=',Arquivo_DOSBOX_Fisico[i]) = 1 then
    begin
      {QUAKE}
      if (id = 8) then
      Arquivo_DOSBOX_Fisico[i]:='core=auto'
      else
      Arquivo_DOSBOX_Fisico[i]:='core=dynamic';
    end;
    if Pos('cycles=',Arquivo_DOSBOX_Fisico[i]) = 1 then
    begin
      {QUAKE}
      if (id = 8) then
      Arquivo_DOSBOX_Fisico[i]:='cycles=fixed 120000'
      else
      Arquivo_DOSBOX_Fisico[i]:='cycles=max 105%';
    end;
    if Pos('ipx=',Arquivo_DOSBOX_Fisico[i]) = 1 then
    begin
      if check_single.Checked = True then
      Arquivo_DOSBOX_Fisico[i]:='ipx=false'
      else
      Arquivo_DOSBOX_Fisico[i]:='Enable=1'    +#13#10+
                                'Connection=1'+#13#10+
                                'ipx=true';
    end;
    if Pos('prebuffer=',Arquivo_DOSBOX_Fisico[i]) = 1 then
    begin
      {QUAKE}
      if (id = 8) then
      Arquivo_DOSBOX_Fisico[i]:='prebuffer=80'
      else
      Arquivo_DOSBOX_Fisico[i]:='prebuffer=20';
    end;

    if Pos('[autoexec]',Arquivo_DOSBOX_Fisico[i]) = 1 then
    begin
     //-------------------------------------
     {DEBUG MODE}
     //-------------------------------------
     if menu_debug.Checked = False then
     Arquivo_DOSBOX_Fisico.Add('@ECHO OFF');
     //-------------------------------------

     if DirectoryExists(ExtractFilePath(Arq_DosBox)) then
     Arquivo_DOSBOX_Fisico.Add('mount c "'+ExtractFilePath(Arq_DosBox)+'"')
     else
     begin
     MessageBox(Application.Handle,pchar(Lang_DGL(8)+':'+#13#13+ExtractFilePath(Arq_DosBox)),pchar(Application.Title),MB_ICONERROR+MB_OK);
      //--------------------------------
      {DEBUG MODE}
      //--------------------------------
      if menu_debug.Checked = False then
      Exit;
      //--------------------------------
     end;

     {WARCRAFT II}
     if (id = 11) then
     Arquivo_DOSBOX_Fisico.Add('mount d "'+ExtractFilePath(Application.ExeName)+Array_Games[id][3]+'" -t cdrom');
     Arquivo_DOSBOX_Fisico.Add('c:');

      //--------------------------------
      {DEBUG MODE}
      //--------------------------------
      if menu_debug.Checked = False then
      Arquivo_DOSBOX_Fisico.Add('cls');
      //--------------------------------

      {CONEXÃO IPXNET}
      //----------------------------------------------------------------------------------------------
      if check_servidor.Checked = True then
      Arquivo_DOSBOX_Fisico.Add('ipxnet startserver'+' '+Trim(ip_porta.Text));
      if check_cliente.Checked = True then
      Arquivo_DOSBOX_Fisico.Add('ipxnet connect'    +' '+Trim(ip_local.Text)+' '+Trim(ip_porta.Text));
      //----------------------------------------------------------------------------------------------

      case id of
        1: begin
             if FileExists(Caminho_Global+'game.ins') then
             Arquivo_DOSBOX_Fisico.Add('imgmount D game.ins -t iso');
           end;
        2: begin
             if FileExists(Caminho_Global+'const.gog') then
             Arquivo_DOSBOX_Fisico.Add('imgmount d "const.gog" -t iso -fs iso');
           end;
        8: begin
             if FileExists(Caminho_Global+'game.cue')  and (EPI_Global_DLC = 1) then
             Arquivo_DOSBOX_Fisico.Add('imgmount d "..\game.cue" -t iso');
             if FileExists(Caminho_Global+'gamea.cue') and (EPI_Global_DLC = 2) then
             Arquivo_DOSBOX_Fisico.Add('imgmount d "..\gamea.cue" -t iso');
             if FileExists(Caminho_Global+'gamed.cue') and (EPI_Global_DLC = 3) then
             Arquivo_DOSBOX_Fisico.Add('imgmount d "..\gamed.cue" -t iso');
           end;
       10: begin
             if FileExists(Caminho_Global+'GAME.DAT') then
             Arquivo_DOSBOX_Fisico.Add('imgmount d "..\GAME.DAT" -t iso');
           end;
      end;

      {MÉTODO DA STEAM}
      //--------------------------------------------------------------------
      if (id = 1) or (id = 5) or (id = 10) then
      begin

        {SINGLE PLAYER}
        if (check_single.Checked = True) then
        begin
        Seleciona_Fases;

          //----------------------
          if Fecha_ESC = True then
          Exit;
          //----------------------

          {DUKE NUKEM 3D - SHADOW WARRIOR}
          if (id = 5) or (id = 10) then
          VarParametro_Global:=' '+Map_Global;

          {SHADOW WARRIOR}
          if (id = 10) then
          begin
            //INÍCIO - CASE
            case EPI_Global_DLC of
            0,1: Arquivo_DOSBOX_Fisico.Add('@COPY sw.dat sw.exe');
              2: Arquivo_DOSBOX_Fisico.Add('@COPY '+SW_DLC_Archive(1)+' sw.exe');
              3: begin
                 Game_EXE_Global:=SW_DLC_Archive(2);
                   if (SW_DLC_Archive(2) = 'sw.exe') then
                   Arquivo_DOSBOX_Fisico.Add('cd dragon');
                 end;
                 //------------------------------------------------------------------------
                 {DEBUG MODE - DEATHMATCH SINGLE PLAYER}
                 //------------------------------------------------------------------------
              4: begin
                   case CAP_Global_DLC of
                     0..5: Arquivo_DOSBOX_Fisico.Add('@COPY sw.dat sw.exe');
                     6..9: Arquivo_DOSBOX_Fisico.Add('@COPY '+SW_DLC_Archive(1)+' sw.exe');
                   10..12: begin
                           Game_EXE_Global:=SW_DLC_Archive(2);
                             if (SW_DLC_Archive(2) = 'sw.exe') then
                             Arquivo_DOSBOX_Fisico.Add('cd dragon');
                           end;
                   end;
                 end;
                 //------------------------------------------------------------------------
            end;
            //FIM - CASE
          end;

        end
        {MULTIPLAYER}
        else
        begin

          {SHADOW WARRIOR - DLC´s}
          if (id = 10) then
          begin
          Application.CreateForm(TForm2_DLC, Form2_DLC);
          Form2_DLC.ShowModal;
          Form2_DLC.Free;

            //----------------------
            if Fecha_ESC = True then
            Exit;
            //----------------------

            case EPI_Global_DLC of
              1: Arquivo_DOSBOX_Fisico.Add('@COPY sw.dat sw.exe');
              2: Arquivo_DOSBOX_Fisico.Add('@COPY '+SW_DLC_Archive(1)+' sw.exe');
            end;

          end;

        //------------------------------------------------------------
        {ARQUIVO COMMIT.DAT}
        //------------------------------------------------------------
        Arquivo_COMMIT:=TStringList.Create;
        Arquivo_COMMIT.LoadFromFile(Caminho_Global+'commit.dat');

          {BLOOD - SE FOR O ARQUIVO ORIGINAL}
          if Arquivo_COMMIT[24] = '; - GAMECONNECTION - 4' then
          Arquivo_COMMIT.Delete(24);

        Arquivo_COMMIT[26]:='NUMPLAYERS = '+cont_player.Text;

          {SHADOW WARRIOR - TWIN DRAGON}
          if (id = 10) and (EPI_Global_DLC = 3) then
          Arquivo_COMMIT[33]:='LAUNCHNAME = "'+SW_DLC_Archive(2)+'"'
          else
          Arquivo_COMMIT[33]:='LAUNCHNAME = "'+Array_Games[id][5]+'"';

        Arquivo_COMMIT.SaveToFile(Caminho_Global+'commit.dat');
        Arquivo_COMMIT.Free;
        //------------------------------------------------------------
                     
        end;

        //-----------------------------------------------------------------------------------------------------
        {DEBUG MODE - "VarParametros_Global"}
        //-----------------------------------------------------------------------------------------------------
        if (menu_debug.Checked = True) and (check_single.Checked = True) then
        MessageBox(Application.Handle,pchar(VarParametro_Global),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);
        //-----------------------------------------------------------------------------------------------------

        //------------------------------------------------------------------------------------------------------
        {DEBUG MODE - MULTIPLAYER}
        //------------------------------------------------------------------------------------------------------
        if (check_single.Checked = False) and (menu_debug.Checked = True) then
        begin
          {SHADOW WARRIOR - TWIN DRAGON}
          if (id = 10) and (EPI_Global_DLC = 3) then
          begin
            if (SW_DLC_Archive(2) = 'sw.exe') then
            begin
            Arquivo_DOSBOX_Fisico.Add('cd dragon');
            Game_EXE_Global:='setup.exe';
            end
            else
            begin
            MessageBox(Application.Handle,pchar(VarParametro_Global),pchar(Lang_DGL(6)),MB_ICONINFORMATION+MB_OK);
            Game_EXE_Global:='commit.exe';
            end;
          end
          else
          begin
            {BLOOD - CRYPTIC PASSAGE - SETUP}
            if FileExists(Caminho_Global+'cryptic.exe') then
            Game_EXE_Global:='cpmulti.exe'
            else
            Game_EXE_Global:='setup.exe';
          end;
        end;
        //------------------------------------------------------------------------------------------------------
        Arquivo_DOSBOX_Fisico.Add('nolfblim.com');
                                    
        if (RxControle.StateOn = True) then
        Arquivo_DOSBOX_Fisico.Add('BMOUSE.EXE LAUNCH '+Game_EXE_Global+VarParametro_Global)
        else
        Arquivo_DOSBOX_Fisico.Add(Game_EXE_Global+VarParametro_Global);

      end
      else
      {EXECUTÁVEL DO JOGO + PARAMETROS}
      //--------------------------------------------------------------------
      Arquivo_DOSBOX_Fisico.Add(Game_EXE_Global+VarParametro_Global);
      //--------------------------------------------------------------------

      {DEBUG MODE}
      //---------------------------------
      if menu_debug.Checked = False then
      Arquivo_DOSBOX_Fisico.Add('Exit.');
      //---------------------------------

    end; //FIM - IF POS

 end; //FIM - FOR

//------------------------------------------------------------------------------
Arquivo_DOSBOX_Fisico.SaveToFile(Arq_DosBox);
Arquivo_DOSBOX_Fisico.Free;
//------------------------------------------------------------------------------
end;

{CLIENTE - CONTAGEM PRA INICIAR}
//---------------------------------------------------------------------
if (check_cliente.Checked = True) and (menu_debug.Checked = False) then
Contagem_Iniciar;
//---------------------------------------------------------------------

 {ZDOOM}
 if (Array_Games[id][7] = 'ZDOOM') then
 begin

   //---------------------------------
   {SINGLE PLAYER}
   //---------------------------------
   if check_single.Checked = True then
   begin
   Seleciona_Fases;

     //----------------------
     if Fecha_ESC = True then
     Exit;
     //----------------------

   VarParametro_Global:=' +map '+Map_Global;
   end;
   //---------------------------------

   //----------------------------------------------------------------------------------------------------------
   {SERVIDOR - INICIO}
   //----------------------------------------------------------------------------------------------------------
   if check_servidor.Checked = True then
   begin
   //-----------------------------------------------------------------------------
   Arquivo_INI.WriteString('DOS','PORT_SERVER_'+Array_Games[id][7],ip_porta.Text);
   //-----------------------------------------------------------------------------
   Seleciona_Fases;

     //----------------------
     if Fecha_ESC = True then
     Exit;
     //----------------------

     //--------------------------------------------------------------------------
     {DEBUG MODE - SIMULAR MULTIPLAYER}
     //--------------------------------------------------------------------------
     if menu_debug.Checked = True then
     begin
     Modo_Game:=0;
       case PT_MessageDlg(Lang_DGL(23),Lang_DGL(22),mtCustom,[mbYes,mbNo],0) of
       6: Modo_Game:=1;
       7: Modo_Game:=StrToInt(Form1_DGL.cont_player.Text);
       end;
     end
     else
     begin
     Modo_Game:=StrToInt(Form1_DGL.cont_player.Text);

     IMG_STATUS.Picture:=Nil;
     Lista_Imagens.GetBitmap(2,IMG_STATUS.Picture.Bitmap);
     StatusBar1.Panels[1].Text:=Lang_DGL(9);
     end;
     //--------------------------------------------------------------------------

   VarParametro_Global:=' -host '+IntToStr(Modo_Game)+DoomDM_Global+' -port '+Trim(ip_porta.Text)+' +map '+Map_Global;
   end; //FIM - SERVIDOR
   //----------------------------------------------------------------------------------------------------------

   //--------------------------------------------------------------------------
   {CLIENTE}
   //--------------------------------------------------------------------------
   if check_cliente.Checked = True then
   VarParametro_Global:=' -join '+Trim(ip_local.Text)+' + -port '+Trim(ip_porta.Text);
   //--------------------------------------------------------------------------

   //----------------------------------------------------------------------------------------------
   {DEBUG MODE}
   //----------------------------------------------------------------------------------------------
   if (menu_debug.Checked = True) then
   MessageBox(Application.Handle,pchar(VarParametro_Global),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);
   //----------------------------------------------------------------------------------------------

 //-------------------------------------------------------------------------------------------------------
 ShellExecute(Handle,'open',pchar(ZDoom_EXE_Global)
                           ,pchar(Game_EXE_Global+' '+DoomSkin_Global+' '+DoomMod_Global+' -config '+Array_Games[id][6]+VarParametro_Global)
                           ,pchar(ExtractFilePath(Config_Game_Global)),SW_NORMAL);
 //-------------------------------------------------------------------------------------------------------
 end;

{FICA AQUI POR CAUSA DO ZDOOM}
//-----------------------------
Config_Tela(False);
btn_start.Caption:=Lang_DGL(5);
//-----------------------------

 {DOSBOX}
 if (Array_Games[id][7] = 'DOSBOX') then
 begin
   //--------------------------------------------------------------------------------------------
   {DEBUG MODE}
   //--------------------------------------------------------------------------------------------
   if menu_debug.Checked = False then
   begin

     if (id = 8) then
     begin
     
       {NÃO TEM PLACA DE VÍDEO - INTEL}
       if ProcessExists('igfxTray.exe') = True then
       begin
       Quake_EXE:='Glquake.exe';
       VarParametro_Global:=VarParametro_Global+' -width 640 -height 480 -bpp 32';
       end
       else
       Quake_EXE:='Winquake.exe';

     ShellExecute(Handle,'open',pchar(Caminho_Global+'\'+Quake_EXE)
                               ,pchar(VarParametro_Global)
                               ,pchar(Caminho_Global),SW_HIDE);
     end;

     //----------------------------------------------------------------
     if (check_single.Checked = False) and ((id = 9) or (id = 11)) then
     begin
     Sleep(1000);
     Centraliza_Janela('SDL_app');

       if (id = 11) then
       begin
       Sleep(4000);
       keybd_event(VK_RETURN,0,0,0);
       keybd_event(VK_RETURN,0,KEYEVENTF_KEYUP,0);
       Sleep(1000);
       keybd_event(VK_RETURN,0,0,0);
       keybd_event(VK_RETURN,0,KEYEVENTF_KEYUP,0);
       end;

     Sleep(500);
     Setup_Teclas(id);
     Sleep(500);
     Tela_Cheia;
     end;
     //----------------------------------------------------------------

   end
   else
   ShellExecute(Handle,'open',pchar(DosBox_EXE_Global)
                             ,pchar('-conf '+ExtractFileName(Arq_DosBox))
                             ,pchar(ExtractFilePath(Arq_DosBox)),SW_NORMAL);
   //--------------------------------------------------------------------------------------------
 end;

img_game.Visible:=False;
gif_dos.Visible:=True;

Timer_MonitoraAPP.Enabled:=True;
end;

procedure TForm1_DGL.Refresh_LanClick(Sender: TObject);
begin
 //------------------------------------------
 {CASO ESTEJA SELECIONADO O CAMPO "SERVIDOR"}
 //------------------------------------------
 if check_servidor.Checked then
 ip_local.Text:=GetInternalIP;
 //------------------------------------------
 {CASO ESTEJA SELECIONADO O CAMPO "CLIENTE"}
 //------------------------------------------
 if check_cliente.Checked then
 begin

   if pingIp(Trim(ip_local.Text)) then
   begin
   MessageBox(Application.Handle,pchar(Lang_DGL(11)+' '+ip_local.Text+' ONLINE!'),pchar(Application.Title),MB_ICONINFORMATION+MB_OK);

   //-----------------------------------------------------------------------------
   Arquivo_INI.WriteString('DOS',  'IP_CLIENT',Trim(ip_local.Text));
   Arquivo_INI.WriteString('DOS','PORT_CLIENT_'+Array_Games[id][7],ip_porta.Text);
   //-----------------------------------------------------------------------------

     //--------------------------------
     {DEBUG MODE}
     //--------------------------------
     if menu_debug.Checked = False then
     begin
     StatusBar1.Panels[1].Text:='Online - '+Lang_DGL(12)+' '+ip_porta.Text;
     Form1_DGL.IMG_STATUS.Picture:=Nil;
     Lista_Imagens.GetBitmap(1,IMG_STATUS.Picture.Bitmap);
     end;
     //--------------------------------
   btn_start.Enabled:=True;
   end
   else
   begin
   MessageBox(Application.Handle,pchar(Lang_DGL(11)+' '+ip_local.Text+' OFFLINE!'),pchar(Application.Title),MB_ICONERROR+MB_OK);
     //--------------------------------
     {DEBUG MODE}
     //--------------------------------
     if menu_debug.Checked = False then
     begin
     StatusBar1.Panels[1].Text:='Offline - '+Lang_DGL(12)+' '+ip_porta.Text;
     Form1_DGL.IMG_STATUS.Picture:=Nil;
     Lista_Imagens.GetBitmap(0,IMG_STATUS.Picture.Bitmap);
     end;
     //--------------------------------
   btn_start.Enabled:=False;
   end;

end;
//------------------------------------------
end;

procedure TForm1_DGL.Refresh_InternetClick(Sender: TObject);
begin
//-----------------------------------
ip_internet.Text:=GetExternalIP;
//-----------------------------------
end;

procedure TForm1_DGL.cont_playerEnter(Sender: TObject);
begin
ActiveControl:=Nil;
end;

procedure TForm1_DGL.RxControleEnter(Sender: TObject);
begin
ActiveControl:=Nil;
end;

procedure TForm1_DGL.RxSenseEnter(Sender: TObject);
begin
ActiveControl:=Nil;
end;

procedure TForm1_DGL.RxBrutalEnter(Sender: TObject);
begin
ActiveControl:=Nil;
end;

procedure TForm1_DGL.RxDMEnter(Sender: TObject);
begin
ActiveControl:=Nil;
end;

procedure TForm1_DGL.RxQuakeServerEnter(Sender: TObject);
begin
ActiveControl:=Nil;
end;
 
procedure TForm1_DGL.RxDMOff(Sender: TObject);
begin
 if (Array_Games[id][7] = 'ZDOOM') then
 DoomDM_Global:='';

 if (id = 8) then
 begin
 Form1_DGL.RxQuakeServer.StateOn    :=False;
 Form1_DGL.RxQuakeServer.Visible    :=False;
 Form1_DGL.Label_QuakeServer.Visible:=False;
 end;

end;

procedure TForm1_DGL.RxDMOn(Sender: TObject);
begin
 if (Array_Games[id][7] = 'ZDOOM') then
 DoomDM_Global:=' -deathmatch -nomonsters ';

 if (id = 8) and (check_cliente.Checked = False) then
 begin
 Form1_DGL.RxQuakeServer.Visible    :=True;
 Form1_DGL.Label_QuakeServer.Visible:=True;
 end;

end;

procedure TForm1_DGL.FormCreate(Sender: TObject);
begin
Lang_DGL(0);
end;

procedure TForm1_DGL.RxOpcoesOff(Sender: TObject);
begin
Form1_DGL.label_name.Enabled:=True;
Form1_DGL.player_name.Enabled:=True;
CoolStuff_Global:='+name '+Trim(Form1_DGL.player_name.Text);
end;

procedure TForm1_DGL.RxCheckListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
i:Integer;
p:TPoint;
begin

 if (Button = mbRight) then
 begin
 p:=Point(X,Y); //PEGA A POSIÇÃO ATUAL DO CURSOR NO LISTBOX
 i:=RxCheckListBox1.ItemAtPos(p,True); //VERIFICA QUAL ITEM ESTÁ NESTA POSIÇÃO
   //-----------------------------------------------------
   if i > -1 then //SE EXISTE ITEM NA POSIÇÃO
   begin
   RxCheckListBox1.ItemIndex:=i; //SETA O ITEM SELECIONADO
   RxCheckListBox1.CheckedIndex:=i;
   p:=RxCheckListBox1.ClientToScreen(p);

     {QUAKE}
     case id of
     1,5,10: begin
             menu_linha.Visible:=True;
             popup_commit.Visible:=True;
             popup_qw.Visible:=False;
             popup_sa.Visible:=False;
             popup_de.Visible:=False;
             end;
     8: begin
        menu_linha.Visible:=True;
        popup_qw.Visible:=DirectoryExists(Caminho_Global+'qw\');
        popup_sa.Visible:=DirectoryExists(Caminho_Global+'hipnotic\');
        popup_de.Visible:=DirectoryExists(Caminho_Global+'rogue\');
        popup_commit.Visible:=False;
        end;
     else
     begin
     menu_linha.Visible:=False;
     popup_qw.Visible:=False;
     popup_sa.Visible:=False;
     popup_de.Visible:=False;
     popup_commit.Visible:=False;
     end;
     end;

     if RxCheckListBox1.EnabledItem[i] = True then
     PopupMenu1.Popup(p.X,p.Y); //MOSTRA O POPUP

   end;
   //-----------------------------------------------------
 end;

end;

procedure TForm1_DGL.popup_qwClick(Sender: TObject);
var
Caminho_Conf:String;
begin
Caminho_Conf:=ExtractFilePath(Application.ExeName)+Array_Games[id][3]+'qw\config.cfg';
WinExec(PChar('Notepad.exe '+Caminho_Conf),sw_shownormal);
end;

procedure TForm1_DGL.popup_saClick(Sender: TObject);
var
Caminho_Conf:String;
begin
Caminho_Conf:=ExtractFilePath(Application.ExeName)+Array_Games[id][3]+'hipnotic\config.cfg';
WinExec(PChar('Notepad.exe '+Caminho_Conf),sw_shownormal);
end;

procedure TForm1_DGL.popup_deClick(Sender: TObject);
var
Caminho_Conf:String;
begin
Caminho_Conf:=ExtractFilePath(Application.ExeName)+Array_Games[id][3]+'rogue\config.cfg';
WinExec(PChar('Notepad.exe '+Caminho_Conf),sw_shownormal);
end;

procedure TForm1_DGL.popup_commitClick(Sender: TObject);
var
Caminho_Conf:String;
begin
Caminho_Conf:=ExtractFilePath(Application.ExeName)+Array_Games[id][3]+'COMMIT.dat';
WinExec(PChar('Notepad.exe '+Caminho_Conf),sw_shownormal);
end;

procedure TForm1_DGL.player_nameChange(Sender: TObject);
begin

 if Length(player_name.Text) = 0 then
 begin
 player_name.Text:=UsuarioLogado;
 player_name.SelectAll;
 end;

end;

procedure TForm1_DGL.RxQuakeServerOn(Sender: TObject);
begin
img_game.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'CONFIG\png\08S.png');
RxOpcoes.Enabled:=Not(RxQuakeServer.StateOn);
Label_Opcoes.Enabled:=Not(RxQuakeServer.StateOn);
end;

procedure TForm1_DGL.RxQuakeServerOff(Sender: TObject);
begin
img_game.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'CONFIG\png\08.png');
RxOpcoes.Enabled:=Not(RxQuakeServer.StateOn);
Label_Opcoes.Enabled:=Not(RxQuakeServer.StateOn);
end;

procedure TForm1_DGL.combo_doomChange(Sender: TObject);
begin
  {SKIN - DOOM e DOOM II}
  case combo_doom.ItemIndex of
  0: begin
     combo_color.Enabled:=True;
     combo_color.ItemIndex:=0;
     combo_color.Items.Delete(8);
     end;
  1: begin
     combo_color.Enabled:=False;
     combo_color.Items.Add(IntToStr($000167E5));
     combo_color.ItemIndex:=8;
     end;
  end;
end;



end.


