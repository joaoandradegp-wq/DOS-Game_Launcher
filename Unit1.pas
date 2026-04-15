unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, RXCtrls, StdCtrls, ToolEdit, ComCtrls, RXSwitch,
  pngextra, ExtCtrls, abfControls, ImgList, pngimage, ShellAPI, RxGIF,
  abfAppProps, Animate, GIFCtrl, Buttons, abfComponents, RxCombos,
  RXSlider, WinSkinData, rxAnimate, rxGIFCtrl, StrUtils, abfEdits,
  GraphicEx;

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
    MainMenu1: TMainMenu;
    Menu_Arquivo: TMenuItem;
    Menu_Sair: TMenuItem;
    RxCheckListBox1: TRxCheckListBox;
    StatusBar1: TStatusBar;
    Lista_Imagens: TImageList;
    Panel_Status: TPanel;
    IMG_STATUS: TImage;
    Panel_Icones: TPanel;
    img_game: TabfImage;
    Menu_Debug: TMenuItem;
    linha02: TBevel;
    linha01: TBevel;
    abfImage1: TabfImage;
    gif_dos: TRxGIFAnimator;
    Menu_Sobre: TMenuItem;
    Timer_MonitoraAPP: TTimer;
    loading_panel: TPanel;
    img_ing: TImage;
    Wav: TabfWav;
    Menu_Firewall: TMenuItem;
    Menu_Site: TMenuItem;
    Menu_Opcoes: TMenuItem;
    Menu_Ajuda: TMenuItem;
    N1: TMenuItem;
    Label_Controle: TLabel;
    Label_Sense: TLabel;
    PopupMenu1: TPopupMenu;
    popup_pasta: TMenuItem;
    config_menu: TMenuItem;
    Label_Brutal: TLabel;
    LoadingMod: TOpenDialog;
    Label_Opcoes: TLabel;
    Label_DM: TLabel;
    img_por: TImage;
    popup_qw: TMenuItem;
    popup_sa: TMenuItem;
    popup_de: TMenuItem;
    menu_linha: TMenuItem;
    popup_commit: TMenuItem;
    Label_QuakeServer: TLabel;
    logo_doom: TImage;
    logo_quake: TImage;
    logo_blood: TImage;
    logo_duke3d: TImage;
    logo_rott: TImage;
    logo_heretic: TImage;
    logo_warcraft: TImage;
    logo_wolf3d: TImage;
    logo_constructor: TImage;
    logo_shadow: TImage;
    combo_doom: TabfComboBox;
    GroupIP: TGroupBox;
    ip_local: TabfEdit;
    ip_internet: TabfEdit;
    Label1: TLabel;
    Label2: TLabel;
    ip_porta: TabfIntegerEdit;
    Label3: TLabel;
    combo_color: TabfComboBox;
    check_single: TRadioButton;
    check_servidor: TRadioButton;
    check_cliente: TRadioButton;
    SkinData1: TSkinData;
    Panel1: TPanel;
    player_name: TEdit;
    cont_player: TabfIntegerEdit;
    cont_seta: TUpDown;
    Label_Name: TLabel;
    btn_start: TButton;
    logo_hexen: TabfImage;
    Refresh_Internet: TBitBtn;
    Refresh_Lan: TBitBtn;
    RxControle: TSpeedButton;
    RxSense: TSpeedButton;
    RxBrutal: TSpeedButton;
    RxOpcoes: TSpeedButton;
    RxDM: TSpeedButton;
    RxQuakeServer: TSpeedButton;
    procedure Menu_SairClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RxCheckListBox1StateChange(Sender: TObject; Index: Integer);
    procedure Menu_DebugClick(Sender: TObject);
    procedure Menu_SobreClick(Sender: TObject);
    procedure RxCheckListBox1Click(Sender: TObject);
    procedure RxCheckListBox1DblClick(Sender: TObject);
    procedure Timer_MonitoraAPPTimer(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure Menu_FirewallClick(Sender: TObject);
    procedure Menu_SiteClick(Sender: TObject);
    procedure PNGButton1Click(Sender: TObject);
    procedure popup_pastaClick(Sender: TObject);
    procedure config_menuClick(Sender: TObject);
    procedure RxCheckListBox1Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RxCheckListBox1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure popup_qwClick(Sender: TObject);
    procedure popup_saClick(Sender: TObject);
    procedure popup_deClick(Sender: TObject);
    procedure popup_commitClick(Sender: TObject);
    procedure abfIntegerEdit1Enter(Sender: TObject);
    procedure combo_colorDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure combo_colorChange(Sender: TObject);
    procedure combo_doomChange(Sender: TObject);
    procedure ip_localKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ip_localKeyPress(Sender: TObject; var Key: Char);
    procedure ip_localKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure abfIntegerEdit1Change(Sender: TObject);
    procedure abfIntegerEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure abfIntegerEdit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure check_singleClick(Sender: TObject);
    procedure check_servidorClick(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure player_nameChange(Sender: TObject);
    procedure btn_startClick(Sender: TObject);
    procedure Refresh_LanClick(Sender: TObject);
    procedure Refresh_InternetClick(Sender: TObject);
    procedure RxControleClick(Sender: TObject);
    procedure RxSenseClick(Sender: TObject);
    procedure RxBrutalClick(Sender: TObject);
    procedure RxOpcoesClick(Sender: TObject);
    procedure RxDMClick(Sender: TObject);
    procedure RxQuakeServerClick(Sender: TObject);
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

Array_Games: Array[1..12] of Campos =
(  {1}  {2}                                      {3}                {4}              {5}              {6}                   {7}      {8}
  ('01','Blood - One Unit Whole Blood'          ,'DOS\BLOOD\'      ,'commit.exe'    ,'cryptic.exe'   ,'BLOOD.cfg'          ,'DOSBOX','213' ),
  ('02','Constructor'                           ,'DOS\CONSTRUCTOR\','game.exe'      ,'game.exe'      ,'SETTINGS\SYSTEM.ini','DOSBOX','213' ),
  ('03','DooM - The Ultimate DooM'              ,'DOS\DOOM\'       ,'doom.wad'      ,'doom.wad'      ,'doom.ini'           ,'ZDOOM' ,'5029'),
  ('04','DooM II - Hell on Earth'               ,'DOS\DOOM2\'      ,'doom2.wad'     ,'doom2.wad'     ,'doom2.ini'          ,'ZDOOM' ,'5029'),
  ('05','Duke Nukem 3D - Atomic Edition'        ,'DOS\DUKE3D\'     ,'commit.exe'    ,'duke3d.exe'    ,'duke3d.cfg'         ,'DOSBOX','213' ),
  ('06','Heretic - Shadow of the Serpent Riders','DOS\HERETIC\'    ,'heretic.wad'   ,'heretic.wad'   ,'Heretic.ini'        ,'ZDOOM' ,'5029'),
  ('07','HeXen - Beyond Heretic'                ,'DOS\HEXEN\'      ,'hexen.wad'     ,'hexen.wad'     ,'hexen.ini'          ,'ZDOOM' ,'5029'),
  ('08','Quake'                                 ,'DOS\QUAKE\'      ,'quakespasm.exe','quakespasm.exe','config.cfg'         ,'SPASM' ,'666' ),
  ('09','Rise of the Triad - Dark War'          ,'DOS\ROTT\'       ,'setup.exe'     ,'rott.exe'      ,'setup.rot'          ,'DOSBOX','213' ),
  ('10','Shadow Warrior'                        ,'DOS\SW\'         ,'commit.exe'    ,'sw.exe'        ,'SW.cfg'             ,'DOSBOX','213' ),
  ('11','Warcraft II - Beyond the Dark Portal'  ,'DOS\WAR2\'       ,'war2.exe'      ,'war2.exe'      ,'war2.ini'           ,'DOSBOX','213' ),
  ('12','Wolfenstein 3D'                        ,'DOS\WOLF3D\'     ,'Wolf3D.pk7'    ,'Wolf3D.pk7'    ,'Wolf3D.ini'         ,'ZDOOM' ,'5029')
);

{PADRÃO MOUSE - BLOOD E DUKE NUKEM}
ID_MouseAnalogX = 8112;
ID_MouseAnalogY = 20312;

{PADRÃO MOUSE - SHADOW WARRIOR}
SW_MouseAnalogX = 26112;
SW_MouseAnalogY = 52312;

implementation

uses IniFiles, Funcoes, About, QUAKE_NameFun, MAP_Select, Mouse_Sense, Language,
DLC, Splash, NO_DOSBOX_Bind, ZDOOM_Bind, DOSBOX_Bind_FPS, QUAKE_Bind;

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
function ResolveDebugPlayersUI(DefaultPlayers: Integer): Integer;
begin
Result := DefaultPlayers;

  case PT_MessageDlg(Lang_DGL(23), Lang_DGL(22), mtCustom, [mbYes, mbNo], 0) of
    6: Result := 1;
    7: Result := StrToIntDef(Form1_DGL.cont_player.Text, 2);
  end;
  
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function SelectMapUI: string;
begin
Seleciona_Fases;

  if Fecha_ESC then
  Result := ''
  else
  Result := Map_Global;
  
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
  RxCheckListBox1.Items.Add(UpperCase(Array_Games[i][2]));

    if not FileExists(ExtractFilePath(Application.ExeName)+Array_Games[i][3]+Array_Games[i][5]) then
    RxCheckListBox1.EnabledItem[i-1]:=False;

  end;

 //---------------------------------------------------------------------------
 {CARREGA DO ARQUIVO .INI O NOME DO JOGADOR SALVO ANTERIORMENTE}
 //---------------------------------------------------------------------------
 Arquivo_INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'dos.ini');

 if not FileExists(ExtractFilePath(Application.ExeName)+'dos.ini') then
 begin
 player_name.Text:=UsuarioLogado;
 FirewallBatch;
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
abfImage1.Visible:=False;
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

procedure TForm1_DGL.Menu_SobreClick(Sender: TObject);
begin
Application.CreateForm(TForm7_About, Form7_About);
Form7_About.ShowModal;
Form7_About.Free;
end;

procedure TForm1_DGL.RxCheckListBox1Click(Sender: TObject);
begin
RxCheckListBox1.Checked[RxCheckListBox1.ItemIndex]:=True;
end;

procedure TForm1_DGL.RxCheckListBox1DblClick(Sender: TObject);
begin

  if (check_single.Checked = True) and (btn_start.Enabled = True) and (Menu_Debug.Checked = False) then
  btn_startClick(Sender);

end;

procedure TForm1_DGL.Timer_MonitoraAPPTimer(Sender: TObject);
begin
Timer_MonitoraAPP.Interval:=1000;

if (id = 8) then
begin
  if AppAberto('qwsv.exe') and (not AppAberto('qwcl.exe')) and (not RxQuakeServer.Down) then
  Fecha_EXE(Caminho_Global + 'qwsv.exe');
end;

  if not (AppAberto(Array_Games[id][7]+'.exe') or
          AppAberto('qwcl.exe') or
          AppAberto('qwsv.exe') or
          AppAberto(Array_Games[id][4])) then
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

  try
  {
  Firewall('CONFIG\bin\','DOSBox.exe');
  Firewall('CONFIG\bin\zdoom\','zdoom.exe');
  Firewall('DOS\QUAKE\','qwcl.exe');
  Firewall('DOS\QUAKE\','qwsv.exe');
  Firewall('DOS\QUAKE\','quakespasm.exe');
  }
  FirewallBatch;
  finally
  MessageBox(Application.Handle,pchar(Language.Lang_DGL(17)),pchar(Application.Title),MB_ICONINFORMATION+MB_OK);
  end;

end;

procedure TForm1_DGL.Menu_SiteClick(Sender: TObject);
begin
ShellExecute(Handle,'open','http://phobosfreeware.blogspot.com','','',1);
end;

procedure TForm1_DGL.PNGButton1Click(Sender: TObject);
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

procedure TForm1_DGL.FormCreate(Sender: TObject);
begin
Lang_DGL(0);
Form1_DGL.DoubleBuffered := True;
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

procedure TForm1_DGL.abfIntegerEdit1Enter(Sender: TObject);
begin
ActiveControl:=Nil;
end;

procedure TForm1_DGL.combo_colorDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  //----------------------------------
  {ZDOOM - CORES DO COMBOBOX}
  //----------------------------------
  with Control as TabfComboBox, Canvas do
  begin
    if (Index >= 0) and (Index < Items.Count) then
    begin
      try
      Brush.Color := StrToInt(Items[Index]);
      except
      Brush.Color := clBlack;
      end;
    end
  else
  Brush.Color := clBlack;
  FillRect(Rect);
  InflateRect(Rect, -2, -2);
  FillRect(Rect);
  end;
  //----------------------------------
end;

procedure TForm1_DGL.combo_colorChange(Sender: TObject);
begin
RxCheckListBox1.SetFocus;
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
RxCheckListBox1.SetFocus;  
end;

procedure TForm1_DGL.ip_localKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (check_cliente.Checked = True) then
  begin
    if Key = VK_RETURN then
    Refresh_Lan.OnClick(Sender);
  end;
end;

procedure TForm1_DGL.ip_localKeyPress(Sender: TObject; var Key: Char);
begin
 //----------------------------------
 if (key in [#32]) then
 key:=#0;
 //----------------------------------
end;

procedure TForm1_DGL.ip_localKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

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

    if (Length(Trim(ip_local.Text)) = 0) or (Copy(ip_local.Text,1,1) = '0') then
    Refresh_Lan.Enabled:=False
    else
    Refresh_Lan.Enabled:=True;
  end;

end;

procedure TForm1_DGL.abfIntegerEdit1Change(Sender: TObject);
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

procedure TForm1_DGL.abfIntegerEdit1KeyPress(Sender: TObject;
  var Key: Char);
begin
  //--------------------------------
  if not (key in ['0'..'9',#8]) then
  key:=#0;
  //--------------------------------
end;

procedure TForm1_DGL.abfIntegerEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

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

    if (Length(Trim(ip_local.Text)) = 0) or (Copy(ip_porta.Text,1,1) = '0') then
    Refresh_Lan.Enabled:=False
    else
    Refresh_Lan.Enabled:=True;
  end;

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

procedure TForm1_DGL.RadioButton3Click(Sender: TObject);
begin
//------------------------------------------------------
Funcao_Config_Opcoes;
//------------------------------------------------------
end;

procedure TForm1_DGL.player_nameChange(Sender: TObject);
begin

 if Length(player_name.Text) = 0 then
 begin
 player_name.Text:=UsuarioLogado;
 player_name.SelectAll;
 end;

end;

procedure TForm1_DGL.btn_startClick(Sender: TObject);
begin
Config_Game_Global:=Caminho_Global+Array_Games[id][6];
VarParametro_Global:='';
Fecha_ESC:=False;

  if (player_name.Enabled = True) and (Length(Trim(player_name.Text)) = 0) then
  begin
  MessageBox(Application.Handle,pchar(Lang_DGL(1)),pchar(Application.Title),MB_ICONWARNING+MB_OK);
  player_name.SetFocus;
  Exit;
  end;

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

   {BLOOD - DUKE NUKEM - SHADOW WARRIOR} 
   1,5,10:
   DOSBOX_Bind_FPS_Games(Handle,DosBox_EXE_Global,Caminho_Global,Game_EXE_Global,menu_debug.Checked,RxControle.Down,check_single.Checked,check_servidor.Checked,check_cliente.Checked,ip_porta.Text,ip_local.Text,cont_player.Text,player_name.Text,Mouse_Global);

   {QUAKE}
   8:
   QUAKE_Bind_Spasm(id,RxDM.Down,RxQuakeServer.Down);

   {CONSTRUCTOR - RISE OF THE TRIAD - WARCRAFT II}
   2,9,11:
   DOSBOX_Bind_NEWS(Handle,DosBox_EXE_Global,Caminho_Global,Game_EXE_Global,menu_debug.Checked,check_single.Checked,check_servidor.Checked,check_cliente.Checked,ip_porta.Text,ip_local.Text,cont_player.Text,player_name.Text);

   {DOOM - DOOM II - HERETIC - HEXEN - WOLFENSTEIN 3D}
   3,4,6,7,12:
   begin
   Map_Global:='';
   ConfigureZDoom(
     id,
     RxControle.Down,
     menu_debug.Checked,
     player_name.Text,
     Config_Game_Global,
     Array_Games[id][4],

     GetZDoomMode(check_single.Checked,check_servidor.Checked),
     Map_Global,
     StrToIntDef(cont_player.Text,2),
     ip_porta.Text,
     ip_local.Text,

     combo_doom.ItemIndex,
     combo_color.ItemIndex,
     Screen.Width,
     Screen.Height,

     ResolveDebugPlayersUI,
     SelectMapUI);
   end;

end;

  //--------------------------------------------------------
  // CLIENTE - CONTAGEM PRA INICIAR
  //--------------------------------------------------------
  if check_cliente.Checked and (not menu_debug.Checked) then
  Contagem_Iniciar;
  //--------------------------------------------------------

  //---------------
  if Fecha_ESC then
  Exit;
  //---------------

//-------------------------------
// FINALIZAÇÃO DO START
//-------------------------------
Config_Tela(False);
//-------------------------------
btn_start.Caption := Lang_DGL(5);
img_game.Visible:=False;
gif_dos.Visible:=True;
Timer_MonitoraAPP.Enabled:=True;
//-------------------------------
end;

procedure TForm1_DGL.Refresh_LanClick(Sender: TObject);
begin
//-----------------------------------------------------------------------------

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

   if VerificaTCP_UDP(Trim(ip_local.Text),StrToInt(ip_porta.Text),300) then
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
//-----------------------------------------------------------------------------

end;

procedure TForm1_DGL.Refresh_InternetClick(Sender: TObject);
begin
//-----------------------------------
ip_internet.Text:=GetExternalIP;
//-----------------------------------
end;

procedure TForm1_DGL.RxControleClick(Sender: TObject);
begin
  if RxControle.Down then
  begin
    {BLOOD + DUKE NUKEM 3D + SHADOW WARRIOR}
    if (id = 1) or (id = 5) or (id = 10) then
    begin
    RxSense.Visible:=True;
    Label_Sense.Visible:=True;
    end;
  Label_Controle.Caption:='MOUSE';
  end
  else
  begin
  RxSense.Visible:=False;
  Label_Sense.Visible:=False;
  Label_Controle.Caption:=Lang_DGL(18);
  end;
ActiveControl:=Nil;
end;

procedure TForm1_DGL.RxSenseClick(Sender: TObject);
begin
  if RxSense.Down then
  begin
  Application.CreateForm(TForm6_Mouse, Form6_Mouse);
  Form6_Mouse.ShowModal;
  Form6_Mouse.Free;
  end;
ActiveControl:=Nil;
end;

procedure TForm1_DGL.RxBrutalClick(Sender: TObject);
var
Nome:String;
begin
  if RxBrutal.Down then
  begin
  Nome:=LowerCase(ExtractFileName(LoadingMod.FileName));
  LoadingMod.FileName:='';
  LoadingMod.InitialDir:=Caminho_Global;

    if LoadingMod.Execute then
    DoomMod_Global:=LoadingMod.FileName;

    if BlockIWAD(LoadingMod.FileName,True) or BlockIWAD(LoadingMod.FileName,False) then
    begin
    LoadingMod.FileName:='';
    RxBrutal.Down:=False;
    MessageBox(Application.Handle,PChar(Lang_DGL(32)),PChar(Application.Title),MB_ICONERROR+MB_OK);
    end
    else
    Lista_Imagens.GetBitmap(5,RxBrutal.Glyph.Create);

    if Length(DoomMod_Global) = 0 then
    RxBrutal.Down:=False;
    
  end
  else
  begin
  DoomMod_Global:='';
  RxBrutal.Glyph:=Nil;
  end;

ActiveControl:=Nil;
end;

procedure TForm1_DGL.RxOpcoesClick(Sender: TObject);
begin
  if RxOpcoes.Down then
  begin
  Application.CreateForm(TForm3_NameFun, Form3_NameFun);
  Form3_NameFun.ShowModal;
  Form3_NameFun.Free;
  end
  else
  begin
  Form1_DGL.label_name.Enabled:=True;
  Form1_DGL.player_name.Enabled:=True;
  CoolStuff_Global:='+name '+Trim(Form1_DGL.player_name.Text);
  end;

ActiveControl:=Nil;
end;

procedure TForm1_DGL.RxDMClick(Sender: TObject);
begin
  if RxDM.Down then
  begin
  Label_DM.Caption:='DEATHMATCH';

    if (Array_Games[id][7] = 'ZDOOM') then
    DoomDM_Global:=' -deathmatch -nomonsters ';

    if (id = 8) and (check_cliente.Checked = False) then
    begin
    Form1_DGL.RxQuakeServer.Visible    :=True;
    Form1_DGL.Label_QuakeServer.Visible:=True;
    end;

  end
  else
  begin
  Label_DM.Caption:=Lang_DGL(21);

    if (Array_Games[id][7] = 'ZDOOM') then
    DoomDM_Global:='';

    if (id = 8) then
    begin
    Form1_DGL.RxQuakeServer.Down:=False;
    //--------------------------------------------
    img_game.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'CONFIG\png\08.png');
    RxOpcoes.Enabled    :=True;
    Label_Opcoes.Enabled:=True;
    combo_color.Visible :=True;
    //--------------------------------------------
    Form1_DGL.RxQuakeServer.Visible    :=False;
    Form1_DGL.Label_QuakeServer.Visible:=False;
    end;

  end;

ActiveControl:=Nil;
end;

procedure TForm1_DGL.RxQuakeServerClick(Sender: TObject);
begin
  if RxQuakeServer.Down then
  begin
  EPI_Global_DLC:=1; 
  img_game.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'CONFIG\png\08S.png');
  RxOpcoes.Enabled    :=Not(RxQuakeServer.Down);
  Label_Opcoes.Enabled:=Not(RxQuakeServer.Down);
  combo_color.Visible :=Not(RxQuakeServer.Down);
  end
  else
  begin
  img_game.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'CONFIG\png\08.png');
  RxOpcoes.Enabled    :=Not(RxQuakeServer.Down);
  Label_Opcoes.Enabled:=Not(RxQuakeServer.Down);
  combo_color.Visible :=Not(RxQuakeServer.Down);
  end;
  
ActiveControl:=Nil;
end;

end.


