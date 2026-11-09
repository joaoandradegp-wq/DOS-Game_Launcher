unit QUAKE_NameFun;

interface

uses
  Windows, SysUtils, Classes, Forms, Buttons, StdCtrls, ShellAPI, ExtCtrls,
  Vcl.ImageCollection, Vcl.VirtualImageList, PastaMonitor, System.ImageList,
  Vcl.ImgList, Vcl.BaseImageCollection, Vcl.Controls, Vcl.WinXCtrls;

type
  TForm3_NameFun = class(TForm)
    label_name: TLabel;
    ListBox_Nome: TListBox;
    label_skin: TLabel;
    ListBox_Skin: TListBox;
    btn_aplicar: TSpeedButton;
    btn_folder1: TSpeedButton;
    btn_folder2: TSpeedButton;
    btn_namefun: TSpeedButton;
    btn_skinbase: TSpeedButton;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Mensagem_SemNome: TPanel;
    Mensagem_SemSkin: TPanel;
    btn_skins: TSpeedButton;
    btn_SkinDownload: TSpeedButton;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
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
    procedure btn_SkinDownloadClick(Sender: TObject);
  private
    { Private declarations }
    Monitor1, Monitor2: TPastaMonitor;
  public
    { Public declarations }
  end;

var
  Form3_NameFun: TForm3_NameFun;
  Caminho_Nome,Caminho_Skin,Arquivo_PCX:String;

implementation

uses Unit1, Funcoes, Language;

{$R *.dfm}

procedure TForm3_NameFun.btn_aplicarClick(Sender: TObject);
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

procedure TForm3_NameFun.btn_skinbaseClick(Sender: TObject);
begin
  if not FileExists(Caminho_Global+'id1\skins\base.pcx') then
  CopyFile(pchar(Pasta_INI_Global+'\quake\base.pcx'),pchar(Caminho_Global+'id1\skins\base.pcx'),False);

Carrega_PCX(Caminho_Skin+'base.pcx');
ListBox_Skin.ItemIndex:=ListBox_Skin.Items.IndexOf('base');

btn_aplicar.Enabled:=True
end;

procedure TForm3_NameFun.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if CoolStuff_Global = '+name '+Trim(Form1_DGL.player_name.Text) then
Form1_DGL.RxOpcoes.State:=tssOff;

Monitor1.Free;
Monitor2.Free;

Form3_NameFun.Release;
Form3_NameFun:=Nil;
end;

procedure TForm3_NameFun.btn_folder1Click(Sender: TObject);
begin
ShellExecute(Application.Handle,'open',pchar(Caminho_Nome),nil,nil,SW_SHOWNORMAL);
end;

procedure TForm3_NameFun.btn_folder2Click(Sender: TObject);
begin
ShellExecute(Application.Handle,'open',pchar(Caminho_Skin),nil,nil,SW_SHOWNORMAL);
end;

procedure TForm3_NameFun.FormActivate(Sender: TObject);
var
ArquivoQW:TStringList;
i:Integer;
CaminhoQW:String;
begin
CaminhoQW:=Caminho_Global+'qw\config.cfg';

//-------------------------------------------------
Caminho_Nome:=Caminho_Global+'ID1\';
Monitor1.Pasta:=Caminho_Nome;
Monitor1.Ativo:=True;
Listar_Arquivos(ListBox_Nome,Caminho_Nome,'scr');
Caminho_Skin:=Caminho_Nome+'skins\';

  if Form1_DGL.RxDM.State = tssOn then
  begin
  Monitor2.Pasta:=Caminho_Skin;
  Monitor2.Ativo:=True;
  btn_SkinDownload.Enabled:=True;
  Listar_Arquivos(ListBox_Skin,Caminho_Skin,'pcx');
  end;
//-------------------------------------------------

  //----------------------------------
  if ListBox_Nome.Items.Count = 0 then
  Mensagem_SemNome.Visible:=True
  else
  Mensagem_SemNome.Visible:=False;

  if (ListBox_Skin.Items.Count = 0) and (Form1_DGL.RxDM.State = tssOff) then
  Mensagem_SemSkin.Visible:=True
  else
  Mensagem_SemSkin.Visible:=False;
  //----------------------------------

  if (ListBox_Skin.Items.Count = 1) and (Form1_DGL.RxDM.State = tssOn) and (ListBox_Skin.Items[0] = 'base') then
  btn_skins.Enabled:=True;;

  //------------------------------------------------------------------------------------------------------------------------
  {DEBUG MODE}
  //------------------------------------------------------------------------------------------------------------------------
  if (Form1_DGL.menu_debug.Checked = True) then
  MessageBox(Application.Handle,pchar(CaminhoQW),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);
  //------------------------------------------------------------------------------------------------------------------------

  if Form1_DGL.RxDM.State = tssOn then
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
  Arquivo_PCX:=Form3_NameFun.ListBox_Skin.Items[Form3_NameFun.ListBox_Skin.ItemIndex]+'.pcx';
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

procedure TForm3_NameFun.RxFolderMonitor1Change(Sender: TObject);
begin
Listar_Arquivos(ListBox_Nome,Caminho_Nome,'scr');

 if ListBox_Nome.Items.Count = 0 then
 Mensagem_SemNome.Visible:=True
 else
 Mensagem_SemNome.Visible:=False;

end;

procedure TForm3_NameFun.RxFolderMonitor2Change(Sender: TObject);
begin
Listar_Arquivos(ListBox_Skin,Caminho_Skin,'pcx');
end;

procedure TForm3_NameFun.ListBox_SkinClick(Sender: TObject);
begin
if (ListBox_Skin.ItemIndex <> -1) then
btn_aplicar.Enabled:=True;

Arquivo_PCX:=Form3_NameFun.ListBox_Skin.Items[Form3_NameFun.ListBox_Skin.ItemIndex]+'.pcx';
Carrega_PCX(Caminho_Skin+Arquivo_PCX);
end;

procedure TForm3_NameFun.ListBox_NomeClick(Sender: TObject);
begin
if (ListBox_Nome.ItemIndex <> -1) then
btn_aplicar.Enabled:=True;
end;

procedure TForm3_NameFun.btn_namefunClick(Sender: TObject);
begin
ShellExecute(Handle,'open',pchar(Caminho_Nome+'-[SwT]-NameFun.exe'),'',pchar(Caminho_Nome),SW_NORMAL);
end;

procedure TForm3_NameFun.FormKeyPress(Sender: TObject; var Key: Char);
begin
//-----------------
if (key = #27) then
Close;
//-----------------
end;

procedure TForm3_NameFun.FormCreate(Sender: TObject);
begin
Lang_DGL(19);
Monitor1:=TPastaMonitor.Create;
Monitor1.OnChange:=RxFolderMonitor1Change;
Monitor2:=TPastaMonitor.Create;
Monitor2.OnChange:=RxFolderMonitor2Change;
end;

procedure TForm3_NameFun.btn_skinsClick(Sender: TObject);
begin
Copia_Pasta(Pasta_INI_Global+'\quake\skins\*.pcx',Caminho_Global+'id1\skins\');
btn_skins.Enabled:=False;
end;
           
procedure TForm3_NameFun.btn_SkinDownloadClick(Sender: TObject);
var
Params, Destino: String;
begin
Destino := Caminho_Global + 'id1\skins\';
Params  := '"' + ExcludeTrailingPathDelimiter(Destino) + '" ' +
                 IntToStr(ActiveLang);   {SKIN DOWNLOAD IDIOMA}

ShellExecute(Handle, 'open',
               PChar(IncludeTrailingPathDelimiter(Caminho_Global) + 'qw_skins.exe'),
               PChar(Params),
               PChar(Caminho_Global),SW_SHOWNORMAL);

end;

end.


