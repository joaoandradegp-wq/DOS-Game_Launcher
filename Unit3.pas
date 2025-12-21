unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, RxNotify, ShellAPI, ExtCtrls, pngextra,
  WinSkinData;

type
  TForm3_QuakeWorld = class(TForm)
    label_name: TLabel;
    ListBox_Nome: TListBox;
    label_skin: TLabel;
    ListBox_Skin: TListBox;
    btn_aplicar: TSpeedButton;
    btn_folder1: TSpeedButton;
    btn_folder2: TSpeedButton;
    btn_namefun: TSpeedButton;
    RxFolderMonitor1: TRxFolderMonitor;
    RxFolderMonitor2: TRxFolderMonitor;
    btn_skinbase: TSpeedButton;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Mensagem_SemNome: TPanel;
    SkinData_Buttons: TSkinData;
    Mensagem_SemSkin: TPanel;
    btn_skins: TSpeedButton;
    procedure btn_aplicarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_folder1Click(Sender: TObject);
    procedure btn_folder2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RxFolderMonitor1Change(Sender: TObject);
    procedure RxFolderMonitor2Change(Sender: TObject);
    procedure ListBox_SkinClick(Sender: TObject);
    procedure ListBox_NomeClick(Sender: TObject);
    procedure btn_namefunClick(Sender: TObject);
    procedure btn_skinbaseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure btn_skinsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3_QuakeWorld: TForm3_QuakeWorld;
  Caminho_Nome,Caminho_Skin,Arquivo_PCX:String;

implementation

uses Unit1, Funcoes, Language;

{$R *.dfm}

procedure TForm3_QuakeWorld.btn_aplicarClick(Sender: TObject);
var
Nome,Skin:String;
begin
 //---------------------------------------------------------------
 {NOME - NAMEFUN}
 //---------------------------------------------------------------
 if (ListBox_Nome.ItemIndex <> -1) then
 begin
 Nome:='+exec '+ListBox_Nome.Items[ListBox_Nome.ItemIndex]+'.scr';
 Form1_DGL.label_name.Enabled:=False;
 Form1_DGL.player_name.Enabled:=False;
 end
 else
 Nome:='+name '+Trim(Form1_DGL.player_name.Text);
 //---------------------------------------------------------------

 //---------------------------------------------------------------
 {SKIN}
 //---------------------------------------------------------------
 if (ListBox_Skin.ItemIndex <> -1) then
 begin
 Skin:='+skin '+ListBox_Skin.Items[ListBox_Skin.ItemIndex]+'.pcx';
   if (ListBox_Skin.Items[ListBox_Skin.ItemIndex] = 'base') then
   Skin:='+ skin ""';
 end
 else
 Skin:='+ skin ""';
 //---------------------------------------------------------------

CoolStuff_Global:=Nome+' '+Skin;

 //--------------------------------------------------------------------------------------------------
 {DEBUG MODE}
 //--------------------------------------------------------------------------------------------------
 if (Form1_DGL.menu_debug.Checked = True) then
 MessageBox(Application.Handle,pchar(CoolStuff_Global),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);
 //--------------------------------------------------------------------------------------------------

Close;
end;

procedure TForm3_QuakeWorld.btn_skinbaseClick(Sender: TObject);
begin
  if not FileExists(Caminho_Global+'id1\skins\base.pcx') then
  CopyFile(pchar(Pasta_INI_Global+'\quake\base.pcx'),pchar(Caminho_Global+'id1\skins\base.pcx'),False);

Carrega_PCX(Caminho_Skin+'base.pcx');
ListBox_Skin.ItemIndex:=ListBox_Skin.Items.IndexOf('base');

btn_aplicar.Enabled:=True
end;

procedure TForm3_QuakeWorld.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if CoolStuff_Global = '+name '+Trim(Form1_DGL.player_name.Text) then
Form1_DGL.RxOpcoes.StateOn:=False;

Form3_QuakeWorld.Release;
Form3_QuakeWorld:=Nil;
end;

procedure TForm3_QuakeWorld.btn_folder1Click(Sender: TObject);
begin
ShellExecute(Application.Handle,'open',pchar(Caminho_Nome),nil,nil,SW_SHOWNORMAL);
end;

procedure TForm3_QuakeWorld.btn_folder2Click(Sender: TObject);
begin
ShellExecute(Application.Handle,'open',pchar(Caminho_Skin),nil,nil,SW_SHOWNORMAL);
end;

procedure TForm3_QuakeWorld.FormActivate(Sender: TObject);
var
ArquivoQW:TStringList;
i:Integer;
CaminhoQW:String;
begin
CaminhoQW:=Caminho_Global+'qw\config.cfg';

//-------------------------------------------------
Caminho_Nome:=Caminho_Global+'ID1\';
RxFolderMonitor1.FolderName:=Caminho_Nome;
RxFolderMonitor1.Active:=True;
Listar_Arquivos(ListBox_Nome,Caminho_Nome,'scr');
Caminho_Skin:=Caminho_Nome+'skins\';

  if Form1_DGL.RxDM.StateOn = True then
  begin
  RxFolderMonitor2.FolderName:=Caminho_Skin;
  RxFolderMonitor2.Active:=True;
  Listar_Arquivos(ListBox_Skin,Caminho_Skin,'pcx');
  end;
//-------------------------------------------------

  //----------------------------------
  if ListBox_Nome.Items.Count = 0 then
  Mensagem_SemNome.Visible:=True
  else
  Mensagem_SemNome.Visible:=False;

  if (ListBox_Skin.Items.Count = 0) and (Form1_DGL.RxDM.StateOn = False) then
  Mensagem_SemSkin.Visible:=True
  else
  Mensagem_SemSkin.Visible:=False;
  //----------------------------------

  if (ListBox_Skin.Items.Count = 1) and (Form1_DGL.RxDM.StateOn = True) and (ListBox_Skin.Items[0] = 'base') then
  btn_skins.Enabled:=True;;

  //------------------------------------------------------------------------------------------------------------------------
  {DEBUG MODE}
  //------------------------------------------------------------------------------------------------------------------------
  if (Form1_DGL.menu_debug.Checked = True) then
  MessageBox(Application.Handle,pchar(CaminhoQW),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);
  //------------------------------------------------------------------------------------------------------------------------

  if Form1_DGL.RxDM.StateOn = True then
  begin
  ArquivoQW:=TStringList.Create;
  ArquivoQW.LoadFromFile(CaminhoQW);

   for i:=0 to ArquivoQW.Count-1 do
   begin

     if Pos('skin "',ArquivoQW[i]) = 1 then
     begin
       if Copy(ArquivoQW[i],7,Length(ArquivoQW[i])-11) = '' then
       ListBox_Skin.ItemIndex:=ListBox_Skin.Items.IndexOf('base')
       else
       ListBox_Skin.ItemIndex:=ListBox_Skin.Items.IndexOf(Copy(ArquivoQW[i],7,Length(ArquivoQW[i])-11));
     Break;
     end
     else
     begin
       if (i = ArquivoQW.Count-1) then
       ListBox_Skin.ItemIndex:=ListBox_Skin.Items.IndexOf('base');
     end;
   end;

  ArquivoQW.Free;
  Arquivo_PCX:=Form3_QuakeWorld.ListBox_Skin.Items[Form3_QuakeWorld.ListBox_Skin.ItemIndex]+'.pcx';
  Carrega_PCX(Caminho_Skin+Arquivo_PCX);
  end
  else
  begin
  Carrega_PCX(Caminho_Skin+'base.pcx');
  label_skin.Enabled  :=False;
  ListBox_Skin.Enabled:=False;
  btn_folder2.Enabled :=False;
  btn_skinbase.Enabled:=False;
  end;

end;

procedure TForm3_QuakeWorld.RxFolderMonitor1Change(Sender: TObject);
begin
Listar_Arquivos(ListBox_Nome,Caminho_Nome,'scr');

 if ListBox_Nome.Items.Count = 0 then
 Mensagem_SemNome.Visible:=True
 else
 Mensagem_SemNome.Visible:=False;

end;

procedure TForm3_QuakeWorld.RxFolderMonitor2Change(Sender: TObject);
begin
Listar_Arquivos(ListBox_Skin,Caminho_Skin,'pcx');
end;

procedure TForm3_QuakeWorld.ListBox_SkinClick(Sender: TObject);
begin
if (ListBox_Skin.ItemIndex <> -1) then
btn_aplicar.Enabled:=True;

Arquivo_PCX:=Form3_QuakeWorld.ListBox_Skin.Items[Form3_QuakeWorld.ListBox_Skin.ItemIndex]+'.pcx';
Carrega_PCX(Caminho_Skin+Arquivo_PCX);
end;

procedure TForm3_QuakeWorld.ListBox_NomeClick(Sender: TObject);
begin
if (ListBox_Nome.ItemIndex <> -1) then
btn_aplicar.Enabled:=True;
end;

procedure TForm3_QuakeWorld.btn_namefunClick(Sender: TObject);
begin
ShellExecute(Handle,'open',pchar(Caminho_Nome+'-[SwT]-NameFun.exe'),'',pchar(Caminho_Nome),SW_NORMAL);
end;

procedure TForm3_QuakeWorld.FormKeyPress(Sender: TObject; var Key: Char);
begin
//-----------------
if (key = #27) then
Close;
//-----------------
end;

procedure TForm3_QuakeWorld.FormCreate(Sender: TObject);
begin
Lang_DGL(19);
end;

procedure TForm3_QuakeWorld.btn_skinsClick(Sender: TObject);
begin
Copia_Pasta(Pasta_INI_Global+'\quake\skins\*.pcx',Caminho_Global+'id1\skins\');
btn_skins.Enabled:=False;
end;

end.
