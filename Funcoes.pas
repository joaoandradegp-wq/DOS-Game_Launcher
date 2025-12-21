unit Funcoes;

interface

uses
IdHTTP,GraphicEx,IdIcmpClient,SysUtils,Forms,Classes,Windows,PsAPI,ShellApi,Graphics,StdCtrls,Dialogs,WinSock,TlHelp32;

type
//--------------------------------------------------------------------------------------------
{VERIFICAR MEMÓRIA DO PC ACIMA DE 2GB - PARTE 01/03}
//--------------------------------------------------------------------------------------------
TWinVersion = (wvUnknown, wv95, wv98, wv98SE, wvNT, wvME, wv2000, wvXP, wvVista, wv2003, wv7);

 TMemoryStatusEx = record
 dwLength: DWORD;
 dwMemoryLoad: DWORD;
 ullTotalPhys: Int64;
 ullAvailPhys: Int64;
 ullTotalPageFile: Int64;
 ullAvailPageFile: Int64;
 ullTotalVirtual: Int64;
 ullAvailVirtual: Int64;
 ullAvailExtendedVirtual: Int64;
 end;
//--------------------------------------------------------------------------------------------

TStringArray = Array of String;

function  SIGIL_DLC_Exists(DLC:Integer):Boolean;
function  ProcessExists(exeFileName: String): Boolean;
function  Episodio_Numero(Episodio:String):Integer;
function  SW_DLC_Archive(DLC:Integer):String;
function  SW_DLC_Exists(DLC:Integer):Boolean;
procedure Copia_Pasta(Origem,Destino:String);
procedure Blood_Levels(num_episodio,num_capitulo,qtde_capitulos:Integer);
function  PC_Bom: Boolean;
//--------------------------------------------------
{VERIFICAR MEMÓRIA DO PC ACIMA DE 2GB - PARTE 02/03}
//--------------------------------------------------
function GetWinVersion:TWinVersion;
function GetGlobalMemoryRecord:TMemoryStatusEx;
function GetTotalRAM:Int64;
function FormatBytes(ABytes:Int64):Integer;
function MemoriaRAM:Integer;
//--------------------------------------------------
function  Windows64:Boolean;
function  UsuarioLogado:String;
function  AspectRatio(Largura,Altura:Integer):Integer;
function  GetLanguageWin:String;
procedure Tela_Cheia;
procedure Centraliza_Janela(Nome_WinSpy:PAnsiChar);
procedure Carrega_PCX(const FileName: String);
procedure Fecha_EXE(Executavel:String);
function  ZeroEsquerda(Numero:Integer):String;
procedure Seleciona_Fases;
function  Listar_Arquivos(Lista:TListBox;Caminho,Extensao:String):String;
procedure Contagem_Iniciar;
procedure Modo_Game(Tipo:Integer);
procedure Lista_Cores(Game:Integer);
function  Quake_Color(Cor:Integer):Integer;
function  SplitString(Expression:String; Delimiter:String):TStringArray;
procedure Deleta_Lixo(Pasta_Game,Single_EXE,Multi_EXE:String);
procedure Setup_Teclas(Game:Integer);
procedure Firewall(Pasta,Executavel:String);
function  Config_Tela(On_Off:Boolean):Boolean;
function  AppAberto(Nome:String):Boolean;
function  ExtractNamePath(path: String):String;
procedure Funcao_Config_Opcoes;
function  ExtractName(const Filename:String):String;
function  IP_NET:String;

implementation

uses IniFiles, Unit1, Unit4, Unit3, Unit6, Language;

var
Arquivo_INI:TIniFile;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function SIGIL_DLC_Exists(DLC:Integer):Boolean;
var
Var_Pesquisa:TSearchRec;
begin

 case DLC of
 1: begin
      if FindFirst(Caminho_Global+'SIGIL_v*.wad',faAnyFile,Var_Pesquisa) = 0 then
      begin
      Result:=True;
      Array_SIGIL_DLC_Name[0]:=Var_Pesquisa.Name;
        if FindFirst(Caminho_Global+'SIGIL_SHREDS.wad',faAnyFile,Var_Pesquisa) = 0 then
        Array_SIGIL_DLC_Name[1]:=' -file '+Var_Pesquisa.Name;
      end;
    end;
 2: begin
      if FindFirst(Caminho_Global+'SIGIL_II_V*.wad',faAnyFile,Var_Pesquisa) = 0 then
      begin
      Result:=True;
      Array_SIGIL_DLC_Name[2]:=Var_Pesquisa.Name;
        if FindFirst(Caminho_Global+'SIGIL_II_MP3_V*.WAD',faAnyFile,Var_Pesquisa) = 0 then
        Array_SIGIL_DLC_Name[3]:=' -file '+Var_Pesquisa.Name;
      end;
 end
 else
 Result:=False;
 end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function ProcessExists(exeFileName: String):Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function Episodio_Numero(Episodio:String):Integer;
var
i:Integer;
begin

   for i:=1 to Length(Array_Episodios) do
   begin
     if Array_Episodios[i][3] = Episodio then
     Result:=StrToInt(Array_Episodios[i][2]);
   end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function SW_DLC_Archive(DLC:Integer):String;
begin

  case DLC of
  1: begin
       {GOG}
       if FileExists(Caminho_Global+'Wanton.dat') then
       Result:='Wanton.dat';
       {ORIGINAL}
       if FileExists(Caminho_Global+'wt.dat') then
       Result:='wt.dat';
     end;
  2: begin
       {GOG}
       if FileExists(Caminho_Global+'\dragon\sw.exe') then
       Result:='sw.exe';
       {ORIGINAL}
       if FileExists(Caminho_Global+'sw_td.exe') then
       Result:='sw_td.exe';
     end;
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function SW_DLC_Exists(DLC:Integer):Boolean;
begin

  case DLC of
  1: begin
       {1.GOG - 2.ORIGINAL}
       if (FileExists(Caminho_Global+'Wanton.dat')) or (FileExists(Caminho_Global+'wt.dat')) then
       Result:=True
       else
       Result:=False;
     end;
  2: begin
       {1.GOG - 2.ORIGINAL}
       if (DirectoryExists(Caminho_Global+'dragon\')) or (FileExists(Caminho_Global+'sw_td.exe')) then
       Result:=True
       else
       Result:=False;
     end;
  end;
  
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Copia_Pasta(Origem,Destino:String);
var
dados:TSHFileOpStruct;
begin
FillChar(Dados,SizeOf(Dados), 0);
  with Dados do
  begin
  wFunc :=FO_COPY;
  pFrom :=PChar(Origem);
  pTo   :=PChar(Destino);
  fFlags:=FOF_ALLOWUNDO;
  end;
SHFileOperation(dados);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Blood_Levels(num_episodio,num_capitulo,qtde_capitulos:Integer);
var
arq_entrada,arq_saida: TStringList;
i,j,k,cont:Integer;
begin
cont:=0;
k:=0;
arq_entrada:=TStringList.Create;
arq_entrada.LoadFromFile(Caminho_Global+'blood.ini');

arq_saida:=TStringList.Create;
arq_saida.Add(arq_entrada.Strings[47]);
arq_saida.Add('');
arq_saida.Add('[Episode1]');
arq_saida.Add('Title   = '+Form4_Select.ListBox_Capitulo.Items[Form4_Select.ListBox_Capitulo.ItemIndex]);

  //----------------------------------------------------------------------------
  {LISTA OS CAPÍTULOS - RESUMO}
  //----------------------------------------------------------------------------
  for i:=num_capitulo to qtde_capitulos do
  begin
  Inc(cont);

    case num_episodio of
 1..4: begin {BLOOD - LEVEL 1 ATÉ 4}
         if i = 5 then
         begin
           case num_episodio of
           1,3: arq_saida.Add('Map'+IntToStr(cont)+'    = '+'E'+IntToStr(num_episodio)+'M8');
           2,4: arq_saida.Add('Map'+IntToStr(cont)+'    = '+'E'+IntToStr(num_episodio)+'M9');
           end;
         end
         else
         begin
            case i of
            6..9: arq_saida.Add('Map'+IntToStr(cont)+'    = '+'E'+IntToStr(num_episodio)+'M'+IntToStr(i-1));
            else
            arq_saida.Add('Map'+IntToStr(cont)+'    = '+'E'+IntToStr(num_episodio)+'M'+IntToStr(i));
            end;
         end;
       end;
    5: begin {CRYPTIC PASSAGE - LEVEL 5}
         if i = 7 then
         arq_saida.Add('Map'+IntToStr(cont)+'    = '+'cpsl')
         else
         begin
           case i of
           8..10: arq_saida.Add('Map'+IntToStr(cont)+'    = '+'cp0'+IntToStr(i-1));
           else
           arq_saida.Add('Map'+IntToStr(cont)+'    = '+'cp0'+IntToStr(i));
           end;
         end;
       end;
    6: begin {PLASMA PAK - EPISODE 6}
         if i = 7 then
         arq_saida.Add('Map'+IntToStr(cont)+'    = '+'E'+IntToStr(num_episodio)+'M9')
         else
         begin
           case i of
           8,9: arq_saida.Add('Map'+IntToStr(cont)+'    = '+'E'+IntToStr(num_episodio)+'M'+IntToStr(i-1));
           else
           arq_saida.Add('Map'+IntToStr(cont)+'    = '+'E'+IntToStr(num_episodio)+'M'+IntToStr(i));
           end;
         end;
       end;
    7: begin {BLOODBATH - EPISODE 7}
         case num_capitulo of
           1..8: arq_saida.Add('Map1    = '+'bb'   +IntToStr(num_capitulo));   //Blood
          9..11: arq_saida.Add('Map1    = '+'DM'   +IntToStr(num_capitulo-8)); //Plasma Pak
         12..15: arq_saida.Add('Map1    = '+'cpbb0'+IntToStr(num_capitulo-11));//Cryptic Passage
         end;
       Break;
       end;
    end;

  end;
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  {LISTA OS CAPÍTULOS - DETALHADO}
  //----------------------------------------------------------------------------
  for i:=160 to arq_entrada.Count-1 do
  begin
    {CRYPTIC BLOODBATH}
    if (num_episodio = 7) then
    begin
      case num_capitulo of
      12,13,14,15: begin
                     if Pos(';Episode 8',arq_entrada.Strings[i]) = 1 then
                     Break;
                   end;
      else
      begin
        if Pos(';Episode '+IntToStr(num_episodio),arq_entrada.Strings[i]) = 1 then
        Break;
      end;
      end;
    end
    else
    begin
      if Pos(';Episode '+IntToStr(num_episodio),arq_entrada.Strings[i]) = 1 then
      Break;
    end;
  end;
  //----------------------------------------------------------------------------

  arq_saida.Add('');
  arq_saida.Add(';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');

  //-----------------------------------------------------
  {LISTA ATÉ ENCONTRAR A PALAVRA ";EPISODE"}
  //-----------------------------------------------------
  for j:=i to arq_entrada.Count-1 do
  begin

    if (copy(arq_entrada.Strings[j],1,8)=';Episode') then
    Inc(k);

    if k = 2 then
    Break
    else
    arq_saida.Add(arq_entrada.Strings[j]);

  end;
  //-----------------------------------------------------

arq_saida.SaveToFile(ExtractFilePath(Application.ExeName)+Array_Games[id][3]+'phobos.ini');
FreeAndNil(arq_entrada);
FreeAndNil(arq_saida);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function PC_Bom: Boolean;
begin
  if (Windows64 = True) and (MemoriaRAM > 3) then
  Result:=True
  else
  Result:=False;
 // Result:=False;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
{VERIFICAR MEMÓRIA DO PC ACIMA DE 2GB - PARTE 03/03}
//------------------------------------------------------------------------------
function GetWinVersion:TWinVersion;
var
osVerInfo:TOSVersionInfo;
majorVersion,minorVersion:Integer;
begin
Result:=wvUnknown;
osVerInfo.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  if GetVersionEx(osVerInfo) then
  begin
  minorVersion:=osVerInfo.dwMinorVersion;
  majorVersion:=osVerInfo.dwMajorVersion;
    case osVerInfo.dwPlatformId of
      VER_PLATFORM_WIN32_NT:
      begin
        if majorVersion <= 4 then
        Result:=wvNT
        else if (majorVersion = 5) and (minorVersion = 0) then
        Result:=wv2000
        else if (majorVersion = 5) and (minorVersion = 1) then
        Result:=wvXP
        else if (majorVersion = 5) and (minorVersion = 2) then
        Result:=wv2003
        else if (majorVersion = 6) then
        Result:=wvVista
        else if (majorVersion = 7) then
        Result:=wv7;
      end;
      VER_PLATFORM_WIN32_WINDOWS:
      begin
        if (majorVersion = 4) and (minorVersion = 0) then
        Result:=wv95
        else if (majorVersion = 4) and (minorVersion = 10) then
        begin
          if osVerInfo.szCSDVersion[1] = 'A' then
          Result:=wv98SE
          else
          Result:=wv98;
        end
        else if (majorVersion = 4) and (minorVersion = 90) then
        Result:=wvME
        else
        Result:=wvUnknown;
      end;
    end;
  end;
end;

function GetGlobalMemoryRecord:TMemoryStatusEx;
type
TGlobalMemoryStatusEx = procedure(var lpBuffer:TMemoryStatusEx);stdcall;
var
ms:TMemoryStatus;
h:THandle;
gms:TGlobalMemoryStatusEx;
begin
Result.dwLength := SizeOf(Result);

  if GetWinVersion in [wvUnknown, wv95, wv98, wv98SE, wvNT, wvME] then
  begin
  ms.dwLength:=SizeOf(ms);
  GlobalMemoryStatus(ms);
  Result.dwMemoryLoad:=ms.dwMemoryLoad;
  Result.ullTotalPhys:=ms.dwTotalPhys;
  Result.ullAvailPhys:=ms.dwAvailPhys;
  Result.ullTotalPageFile:=ms.dwTotalPageFile;
  Result.ullAvailPageFile:=ms.dwAvailPageFile;
  Result.ullTotalVirtual:=ms.dwTotalVirtual;
  Result.ullAvailVirtual:=ms.dwAvailVirtual;
  end
  else
  begin
  h:=LoadLibrary(kernel32);
    try
      if h <> 0 then
      begin
      @gms:=GetProcAddress(h,'GlobalMemoryStatusEx');
        if @gms <> nil then
        gms(Result);
      end;
    finally
    FreeLibrary(h);
    end;
  end;

end;

function GetTotalRAM:Int64;
begin
Result:=GetGlobalMemoryRecord.ullTotalPhys;
end;

function FormatBytes(ABytes:Int64):Integer;
var
fr:Double;
begin
fr:=ABytes;

  while fr >= 1024 do
  fr:=fr/1024;

  if fr >= 1000 then
  fr:=fr/1024;

Result:=Round(fr);
end;

function MemoriaRAM:Integer;
begin
Result:=FormatBytes(GetTotalRAM);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function Windows64:Boolean;
type
TIsWow64Process = function(AHandle:THandle; var AIsWow64: BOOL): BOOL; stdcall;
var
vKernel32Handle:DWORD;
vIsWow64Process:TIsWow64Process;
vIsWow64:BOOL;
begin
Result:=False;
vKernel32Handle:=LoadLibrary('kernel32.dll');

if (vKernel32Handle = 0) then
Exit;

  try
  @vIsWow64Process := GetProcAddress(vKernel32Handle,'IsWow64Process');

    if not Assigned(vIsWow64Process) then
    Exit;

  vIsWow64 := False;

    if (vIsWow64Process(GetCurrentProcess,vIsWow64)) then
    Result := vIsWow64;

  finally
  FreeLibrary(vKernel32Handle);
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function UsuarioLogado:String;
var
i:DWord;
user:String;
begin
i:=255;
SetLength(user,i);
Windows.GetUserName(PChar(user),i);
user:=String(PChar(user));
Result:=user;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function AspectRatio(Largura,Altura:Integer):Integer;
var
aux:Double;
begin
aux:=Trunc((Largura/Altura)*100)/100;

 {4:3}
 if FloatToStr(aux) = '1,33' then
 Result:=3
 {16:9}
 else if FloatToStr(aux) = '1,77' then
 Result:=1
 {Autodetect}
 else
 Result:=0;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function GetLanguageWin:String;
var
ID:LangID;
Language: Array [0..100] of Char;
begin
ID:=GetSystemDefaultLangID;
VerLanguageName(ID,Language,100);
Result:=LowerCase(Copy(String(Language),0,3));
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Tela_Cheia;
begin
keybd_event(VK_MENU,  0,0,0);
keybd_event(VK_RETURN,0,0,0);
keybd_event(VK_RETURN,0,KEYEVENTF_KEYUP,0);
keybd_event(VK_MENU,  0,KEYEVENTF_KEYUP,0);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Centraliza_Janela(Nome_WinSpy:PAnsiChar);
var
DOSBox,CLauncher:TRect;
DOSBox_X,DOSBox_Y,CLauncher_X,CLauncher_Y,X,Y:Word;
begin
GetWindowRect(FindWindow(Nome_WinSpy,nil),DOSBox);
GetWindowRect(FindWindow(nil,pchar(Application.Title)),CLauncher);

//DOSBOX - Largura e Altura
DOSBox_X:=DOSBox.Right -DOSBox.Left;
DOSBox_Y:=DOSBox.Bottom-DOSBox.Top;

//DOS GAME LAUNCHER - Largura e Altura
CLauncher_X:=CLauncher.Right -CLauncher.Left;
CLauncher_Y:=CLauncher.Bottom-CLauncher.Top;

X:=CLauncher.Left+((CLauncher_X div 2)-(DOSBox_X div 2));
Y:=CLauncher.Top +((CLauncher_Y div 2)-(DOSBox_Y div 2));

MoveWindow(FindWindow(Nome_WinSpy,nil),X,Y,DOSBox.Right-DOSBox.Left,DOSBox.Bottom-DOSBox.Top,True);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Carrega_PCX(const FileName: String);
var
GraphicClass:TGraphicExGraphicClass;
Graphic:TGraphic;
begin
GraphicClass := FileFormatList.GraphicFromContent(FileName);

 if GraphicClass = nil then
 Form3_QuakeWorld.Image1.Picture.LoadFromFile(FileName)
 else
 begin
 Graphic:=GraphicClass.Create;
 Graphic.LoadFromFile(FileName);
 Form3_QuakeWorld.Image1.Picture.Graphic:=Graphic;
 end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Fecha_EXE(Executavel:String);
var
Janela:THandle;
begin
Janela:=FindWindow(nil,pchar(Executavel));
 if Janela > 0 then
 SendMessage(Janela,$0010,0,0);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function ZeroEsquerda(Numero:Integer):String;
begin

 case Numero of
 1,2,3,4,5,6,7,8,9: Result:='0'+IntToStr(Numero);
 else
 Result:=IntToStr(Numero);
 end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Seleciona_Fases;
begin
Application.CreateForm(TForm4_Select, Form4_Select);
Form4_Select.ShowModal;
Form4_Select.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function Listar_Arquivos(Lista:TListBox;Caminho,Extensao:String):String;
var
SR:TSearchRec;
i:Integer;
begin
Lista.Clear;

 i:=FindFirst(Caminho+'*.'+Extensao,faAnyFile,SR);
 while i = 0 do
 begin
 Lista.Items.Add(ExtractName(SR.Name));
 i:=FindNext(SR);
 end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Contagem_Iniciar;
var
contador:Integer;
begin
contador:=6;

Form1_DGL.btn_start.Enabled:=False;

 while contador > 1 do
 begin
 Dec(contador);
 Form1_DGL.btn_start.Caption:=Lang_DGL(14)+' ('+inttostr(contador)+')';
 Form1_DGL.btn_start.Refresh;
 Form1_DGL.Wav.Play;
 Sleep(1000);
 end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Modo_Game(Tipo:Integer);
var
Caminho_INI:String;
begin
//------------------------------------------------------------------------------
Caminho_INI:=ExtractFilePath(Application.ExeName)+'dos.ini';
Form1_DGL.Refresh_Lan.Glyph:=Nil;
//------------------------------------------------------------------------------
CoolStuff_Global:='';
//------------------------------------------------------------------------------

 case Tipo of
  {SINGLE PLAYER}
  0: begin
     Form1_DGL.Lista_Imagens.GetBitmap(4,Form1_DGL.Refresh_Lan.Glyph);
     //----------------------------------------
     Form1_DGL.label_name.Enabled      :=False;
     Form1_DGL.player_name.Enabled     :=False;
     Form1_DGL.cont_player.Enabled     :=False;
     Form1_DGL.cont_seta.Enabled       :=False;
     Form1_DGL.combo_color.Visible     :=False;
     Form1_DGL.combo_doom.Visible      :=False;
     //----------------------------------------
     Form1_DGL.Label2.Caption:='LAN:';
     Form1_DGL.ip_local.Text:='0.0.0.0';
     Form1_DGL.ip_local.Enabled:=False;
     Form1_DGL.ip_internet.Text:='0.0.0.0';
     Form1_DGL.ip_internet.Enabled:=False;
     Form1_DGL.ip_porta.Text:='0';
     Form1_DGL.ip_porta.Enabled:=False;
     //----------------------------------------
     Form1_DGL.Refresh_Lan.Enabled:=False;
     Form1_DGL.Refresh_Internet.Enabled:=False;
     //----------------------------------------
     Form1_DGL.Label1.Enabled:=False;
     Form1_DGL.Label2.Enabled:=False;
     Form1_DGL.Label3.Enabled:=False;
     //----------------------------------------
     Form1_DGL.btn_start.Enabled:=True;
     Form1_DGL.RxCheckListBox1.SetFocus;
     //----------------------------------------
     end;
  {SERVIDOR}
  1: begin
     Form1_DGL.player_name.Enabled:=True;
     Form1_DGL.Lista_Imagens.GetBitmap(4,Form1_DGL.Refresh_Lan.Glyph);
     //---------------------------------------------------------
       if (Form1_DGL.player_name.Enabled = True) then            {Verificar AQUI}
       Form1_DGL.player_name.SetFocus
       else
       Form1_DGL.RxCheckListBox1.SetFocus;
     //---------------------------------------------------------
     Form1_DGL.Label2.Caption     :='LAN:';
     Form1_DGL.ip_local.ReadOnly  :=True;
     Form1_DGL.ip_local.Text      :=IP_Interno_Global;
     Form1_DGL.ip_local.Enabled   :=True;
     Form1_DGL.ip_internet.Text   :=IP_Externo_Global;
     Form1_DGL.ip_internet.Enabled:=True;
     Form1_DGL.ip_porta.Enabled   :=True;
     Form1_DGL.ip_porta.Clear;
     //------------------------------------------------------------------------------------------
     Arquivo_INI:=TIniFile.Create(Caminho_INI);
     Form1_DGL.ip_porta.Text:=Arquivo_INI.ReadString('DOS','PORT_SERVER_'+Array_Games[id][7],'');
     Arquivo_INI.Free;
     //------------------------------------------------------------------------------------------
     if Length(Form1_DGL.ip_porta.Text) = 0 then
     Form1_DGL.ip_porta.Text:=Array_Games[id][8];
     //---------------------------------------------------------
     Form1_DGL.Refresh_Lan.Enabled:=True;
     Form1_DGL.Refresh_Internet.Enabled:=True;
     //---------------------------------------------------------
     Form1_DGL.Label1.Enabled:=True;
     Form1_DGL.Label2.Enabled:=True;
     Form1_DGL.Label3.Enabled:=True;
     //---------------------------------------------------------
     Form1_DGL.btn_start.Enabled:=True;
     //---------------------------------------------------------
     end;
  {CLIENTE}
  2: begin
     Form1_DGL.Lista_Imagens.GetBitmap(5,Form1_DGL.Refresh_Lan.Glyph);
     //-----------------------------------------------
     Form1_DGL.Label2.Caption     :=Lang_DGL(15)+':';
     Form1_DGL.ip_local.ReadOnly  :=False;
     Form1_DGL.ip_local.Enabled   :=True;
     Form1_DGL.ip_local.Clear;
     Form1_DGL.ip_internet.Enabled:=False;
     Form1_DGL.ip_porta.Enabled   :=True;
     Form1_DGL.ip_porta.Clear;
     //------------------------------------------------------------------------------------------
     Arquivo_INI:=TIniFile.Create(Caminho_INI);
     Form1_DGL.ip_local.Text:=Arquivo_INI.ReadString('DOS',  'IP_CLIENT','');
     Form1_DGL.ip_porta.Text:=Arquivo_INI.ReadString('DOS','PORT_CLIENT_'+Array_Games[id][7],'');
     Arquivo_INI.Free;
     //------------------------------------------------------------------------------------------
     if Length(Trim(Form1_DGL.ip_porta.Text)) = 0 then
     Form1_DGL.ip_porta.Text:=Array_Games[id][8];
     //-----------------------------------------------
     if Length(Form1_DGL.ip_local.Text) = 0 then
     Form1_DGL.Refresh_Lan.Enabled:=False
     else
     Form1_DGL.Refresh_Lan.Enabled:=True;
     //-----------------------------------------------
     Form1_DGL.Refresh_Internet.Enabled:=False;
     //-----------------------------------------------
     Form1_DGL.Label1.Enabled:=False;
     Form1_DGL.Label2.Enabled:=True;
     Form1_DGL.Label3.Enabled:=True;
     //-----------------------------------------------
     Form1_DGL.btn_start.Enabled:=False;
     //-----------------------------------------------
     Form1_DGL.ip_local.SetFocus;
     Form1_DGL.ip_local.SelectAll;
     //-----------------------------------------------
     end;
  end;

  case id of
     {DOOM + DOOM II}
     3,4: begin
          Form1_DGL.RxOpcoes.Visible     :=False;
          Form1_DGL.Label_Opcoes.Visible :=False;
          Form1_DGL.RxQuakeServer.Visible    :=False;
          Form1_DGL.Label_QuakeServer.Visible:=False;

            {SINGLE PLAYER E CLIENTE}
            if (Tipo = 0) or (Tipo = 2) then
            begin
            //----------------------------------------
            Form1_DGL.RxBrutal.Top    :=232;
            Form1_DGL.Label_Brutal.Top:=237;
            Form1_DGL.RxBrutal.StateOn:=False;
            //----------------------------------------
            Form1_DGL.RxBrutal.Visible        :=True;
            Form1_DGL.Label_Brutal.Visible    :=True;
            Form1_DGL.RxDM.Visible            :=False;
            Form1_DGL.Label_DM.Visible        :=False;
            //----------------------------------------
            end;
            {SERVIDOR}
            if (Tipo = 1) then
            begin
            //---------------------------------------
            Form1_DGL.RxBrutal.Top:=232;
            Form1_DGL.Label_Brutal.Top:=237;
            Form1_DGL.RxBrutal.StateOn:=False;
            Form1_DGL.RxDM.Top:=256;
            Form1_DGL.Label_DM.Top:=261;
            Form1_DGL.RxDM.StateOn:=False;
            //---------------------------------------
            Form1_DGL.RxBrutal.Visible        :=True;
            Form1_DGL.Label_Brutal.Visible    :=True;
            Form1_DGL.RxDM.Visible            :=True;
            Form1_DGL.Label_DM.Visible        :=True;
            //---------------------------------------
            end;
          end;
       {QUAKE}
       8: begin
          CoolStuff_Global:='+name '+Trim(Form1_DGL.player_name.Text);

          Form1_DGL.RxBrutal.Visible         :=False;
          Form1_DGL.Label_Brutal.Visible     :=False;

            {SERVIDOR E CLIENTE}
            if (Tipo = 1) or (Tipo = 2) then
            begin
            //-----------------------------------------
            Form1_DGL.RxOpcoes.StateOn:=False;
            Form1_DGL.RxOpcoes.Top:=208;
            Form1_DGL.Label_Opcoes.Top:=213;
            Form1_DGL.RxDM.StateOn:=False;
            Form1_DGL.RxDM.Top:=232;
            Form1_DGL.Label_DM.Top:=237;
            Form1_DGL.RxQuakeServer.StateOn:=False;
            Form1_DGL.RxQuakeServer.Top:=256;
            Form1_DGL.Label_QuakeServer.Top:=261;
            //-------------------------------------------
            Form1_DGL.RxOpcoes.Visible     :=True;
            Form1_DGL.Label_Opcoes.Visible :=True;
            Form1_DGL.RxDM.Visible         :=DirectoryExists(Caminho_Global+'qw\');
            Form1_DGL.Label_DM.Visible     :=DirectoryExists(Caminho_Global+'qw\');
              if (Tipo = 2) then
              begin
              Form1_DGL.RxQuakeServer.Visible    :=False;
              Form1_DGL.Label_QuakeServer.Visible:=False;
              end;
            //-------------------------------------------
            end
            {SINGLE PLAYER}
            else
            begin
            //-----------------------------------------
            Form1_DGL.RxOpcoes.Visible         :=False;
            Form1_DGL.Label_Opcoes.Visible     :=False;
            Form1_DGL.RxDM.Visible             :=False;
            Form1_DGL.Label_DM.Visible         :=False;
            Form1_DGL.RxQuakeServer.Visible    :=False;
            Form1_DGL.Label_QuakeServer.Visible:=False;
            Form1_DGL.RxQuakeServer.Visible    :=False;
            Form1_DGL.Label_QuakeServer.Visible:=False;
            //-----------------------------------------
            end;

          end;
   {HERETIC + HEXEN + WOLFENSTEIN 3D + SPEAR OF DESTINY}
   6,7,
   12,13: begin
          Form1_DGL.RxBrutal.Visible         :=False;
          Form1_DGL.Label_Brutal.Visible     :=False;
          Form1_DGL.RxOpcoes.Visible         :=False;
          Form1_DGL.Label_Opcoes.Visible     :=False;
          Form1_DGL.RxQuakeServer.Visible    :=False;
          Form1_DGL.Label_QuakeServer.Visible:=False;

            {SINGLE PLAYER - CLIENTE}
            if (Tipo = 0) or (Tipo = 2) then
            begin
            //----------------------------------------
            Form1_DGL.RxOpcoes.Visible    :=False;
            Form1_DGL.Label_Opcoes.Visible:=False;
            Form1_DGL.RxDM.Visible        :=False;
            Form1_DGL.Label_DM.Visible    :=False;
            //----------------------------------------
            end;
            {SERVIDOR}
            if (Tipo = 1) then
            begin
            //----------------------------------------
            Form1_DGL.RxDM.Top:=232;
            Form1_DGL.Label_DM.Top:=237;
            Form1_DGL.RxDM.StateOn:=False;
            //----------------------------------------
            Form1_DGL.RxDM.Visible            :=True;
            Form1_DGL.Label_DM.Visible        :=True;
            //----------------------------------------
            end;
          end;
     {BLOOD + CONSTRUCTOR + DUKE NUKEM 3D + RISE OF THE TRIAD + SHADOW WARRIOR + WARCRAFT II}
     else
     begin
     //-----------------------------------------
     Form1_DGL.RxBrutal.Visible         :=False;
     Form1_DGL.Label_Brutal.Visible     :=False;
     Form1_DGL.RxOpcoes.Visible         :=False;
     Form1_DGL.Label_Opcoes.Visible     :=False;
     Form1_DGL.RxDM.Visible             :=False;
     Form1_DGL.Label_DM.Visible         :=False;
     Form1_DGL.RxQuakeServer.Visible    :=False;
     Form1_DGL.Label_QuakeServer.Visible:=False;
     //-----------------------------------------
     end;

  end; {END - CASE id of}

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Lista_Cores(Game:Integer);
var
Config_Game,Nome_Game:String;
i:Integer;
Config_Fisico:TStringList;
begin

//------------------------------------------------------------------------------------------
if (Game = 8) then
Config_Game:=ExtractFilePath(Application.ExeName)+Array_Games[Game][3]+'id1\'+Array_Games[Game][6]
else
Config_Game:=ExtractFilePath(Application.ExeName)+Array_Games[Game][3]+Array_Games[Game][6];
Nome_Game:=UpperCase(ExtractName(Array_Games[id][5]));
//------------------------------------------------------------------------------------------

 if (Game = 3) or (Game = 4) then
 begin
 //--------------------------------------------------
 Form1_DGL.combo_color.Items.Clear;
 //--------------------------------------------------
 {DOOM - DOOM 2}
 //--------------------------------------------------
  with Form1_DGL.combo_color.Items do
  begin
  Add(IntToStr($008000));           //0 - Green
  Add(IntToStr($808080));           //1 - Gray
  Add(IntToStr(RGB(160, 82, 45)));  //2 - Brown
  Add(IntToStr(RGB(171,  8,  8)));  //3 - Red
  Add(IntToStr($D3D3D3));           //4 - Light Gray
  Add(IntToStr(RGB(245,222,179)));  //5 - Light Brown
  Add(IntToStr($0000FF));           //6 - Light Red
  Add(IntToStr($FF0000));           //7 - Light Blue
  end;
 //--------------------------------------------------
 end;

 if (Game = 6) then
 begin
 //--------------------------------------------------
 Form1_DGL.combo_color.Items.Clear;
 //--------------------------------------------------
 {HERETIC}
 //--------------------------------------------------
  with Form1_DGL.combo_color.Items do
  begin
  Add(IntToStr(RGB( 85,107, 47)));  //0 - Green
  Add(IntToStr(RGB(255,165,  0)));  //1 - Yellow
  Add(IntToStr(RGB(171,  8,  8)));  //2 - Red
  Add(IntToStr(RGB(  0,  0,179)));  //3 - Blue
  Add(IntToStr(RGB(160, 82, 45)));  //4 - Brown
  Add(IntToStr($D3D3D3));        ;  //5 - Light Gray
  Add(IntToStr(RGB(245,222,179)));  //6 - Light Brown
  Add(IntToStr($0000FF));           //7 - Light Red
  Add(IntToStr(RGB( 51, 51,255)));  //8 - Light Blue
  Add(IntToStr(RGB(205,133, 63)));  //9 - Beige
  end;
 //--------------------------------------------------
 end;

 if (Game = 7) then
 begin
 //-------------------------------------------------
 Form1_DGL.combo_color.Items.Clear;
 //-------------------------------------------------
 {HEXEN}
 //-------------------------------------------------
  with Form1_DGL.combo_color.Items do
  begin
  Add(IntToStr(RGB(  0,  0,179)));  //0 - Blue
  Add(IntToStr(RGB(171,  8,  8)));  //1 - Red
  Add(IntToStr(RGB(255,165,  0)));  //2 - Gold
  Add(IntToStr(RGB( 85,107, 47)));  //3 - Dull Green
  Add(IntToStr($008000));           //4 - Green
  Add(IntToStr($808080));           //5 - Gray
  Add(IntToStr(RGB(160, 82, 45)));  //6 - Brown
  Add(IntToStr($800080));           //7 - Purple
  end;
 //-------------------------------------------------
 end;

 if (Game = 8) then
 begin
 //---------------------------------------------------
 Form1_DGL.combo_color.Items.Clear;
 //---------------------------------------------------
 {QUAKE}
 //---------------------------------------------------
  with Form1_DGL.combo_color.Items do
  begin
  Add(IntToStr(RGB(255,255,255)));  //0  - White
  Add(IntToStr(RGB( 88, 61, 18)));  //1  - Brown
  Add(IntToStr(RGB(139,139,203)));  //2  - Light Blue
  Add(IntToStr(RGB(107,107, 11)));  //3  - Green
  Add(IntToStr(RGB(127,  0,  0)));  //4  - Red
  Add(IntToStr(RGB(132,110, 50)));  //5  - Orange
  Add(IntToStr(RGB(158, 72, 51)));  //6  - Gold
  Add(IntToStr(RGB(227,179,151)));  //7  - Peach
  Add(IntToStr(RGB(171,139,163)));  //8  - Purple
  Add(IntToStr(RGB(187,115,159)));  //9  - Magenta
  Add(IntToStr(RGB(219,195,187)));  //10 - Tan
  Add(IntToStr(RGB(111,131,123)));  //11 - Light Green
  Add(IntToStr(RGB(255,243, 27)));  //12 - Yellow
  Add(IntToStr(RGB(  0,  0,255)));  //13 - Blue
  end;
 //---------------------------------------------------
 Config_Fisico:=TStringList.Create;
 Config_Fisico.LoadFromFile(Config_Game);

   for i:=0 to Config_Fisico.Count-1 do
   begin
     if Pos('_cl_color "0"',Config_Fisico[i]) = 1 then
     begin
     Form1_DGL.combo_color.ItemIndex:=0;
     Break;
     end
     else
     begin
       if Pos('_cl_color ',Config_Fisico[i]) = 1 then
       begin
       Form1_DGL.combo_color.ItemIndex:=Quake_Color(StrToInt(Copy(SplitString(Config_Fisico[i],'"')[1],1,Pos('.',SplitString(Config_Fisico[i],'"')[1])-1)));
       Break;
       end;
     end;
   end;

 Config_Fisico.Free;
 //--------------------------------------------------
 end;

 if (Game = 12) or (Game = 13) then
 begin
 //--------------------------------------------
 Form1_DGL.combo_color.Items.Clear;
 //--------------------------------------------
 {WOLFENSTEIN 3D + SPEAR OF DESTINY}
 //--------------------------------------------
  with Form1_DGL.combo_color.Items do
  begin
  Add(IntToStr($008000));          //0 - Green
  Add(IntToStr($808080));          //1 - Gray
  Add(IntToStr(RGB(160, 82, 45))); //2 - Brown
  Add(IntToStr($0000FF));          //3 - Red
  Add(IntToStr($00FFFF));          //4 - Yellow
  Add(IntToStr($A0C8FF));          //5 - Tan
  Add(IntToStr($800080));          //6 - Purple
  Add(IntToStr($808000));          //7 - Teal
  end;
 //--------------------------------------------
 end;

 //------------------------------------------------------------------------------------------------
 {ZDOOM - PLAYER SETUP - CORES DO PLAYER}
 //------------------------------------------------------------------------------------------------
 if (Array_Games[Game][7] = 'ZDOOM') then
 begin
  //--------------------------------------------------------
  {DOOM 2 - WOLFENSTEIN 3D - USAM NOME DE "DOOM" NO ARQUIVO}
  //--------------------------------------------------------
  if (Game = 4) or (Game = 12) or (Game = 13) then
  Nome_Game:='Doom';
  //-----------------------------------------------------------------------------------------------

   //-----------------------------------------------------------------------------------------------------
   {DOOM - DOOM 2 - PEGA A COR DENTRO DO ARQUIVO .INI APENAS SE ESTIVER USANDO O DOOM GUY NO COMBO_DOOM}
   //-----------------------------------------------------------------------------------------------------
   {SKIN - DOOM}
   if Form1_DGL.combo_doom.ItemIndex = 0 then
   begin
   Arquivo_INI:=TIniFile.Create(Config_Game);
     if Arquivo_INI.ReadString(Nome_Game+'.Player','colorset','') <> '' then
     Form1_DGL.combo_color.ItemIndex:=StrToInt(Arquivo_INI.ReadString(Nome_Game+'.Player','colorset',''));
   Arquivo_INI.Free;
   end
   {SKIN - PHOBOS}
   else if Form1_DGL.combo_doom.ItemIndex = 1 then
   begin
   Form1_DGL.combo_color.Items.Add(IntToStr($000167E5));
   Form1_DGL.combo_color.ItemIndex:=8;
   end;
   //-----------------------------------------------------------------------------------------------------

 end;
 //------------------------------------------------------------------------------------------------

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
function SplitString(Expression:String; Delimiter:String):TStringArray;
var
Res:TStringArray;
ResCount:DWORD;
dLength:DWORD;
StartIndex:DWORD;
sTemp:String;
begin
dLength:=Length(Expression);
StartIndex:=1;
ResCount:=0;
  repeat
    sTemp:=Copy(Expression,StartIndex,Pos(Delimiter,Copy(Expression,StartIndex,Length(Expression)))-1);
    SetLength(Res,Length(Res)+1);
    SetLength(Res[ResCount],Length(sTemp));
    Res[ResCount]:=sTemp;
    StartIndex:=StartIndex+Length(sTemp)+Length(Delimiter);
    ResCount:=ResCount+1;
  until StartIndex > dLength;
  Result:=Res;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Deleta_Lixo(Pasta_Game,Single_EXE,Multi_EXE:String);
var
Pasta_App:String;
begin
Pasta_App:=ExtractFilePath(Application.ExeName)+Pasta_Game;

if FileExists(Pasta_App+'stderr.txt') then
DeleteFile(PAnsiChar(Pasta_App+'stderr.txt'));

if FileExists(Pasta_App+'stdout.txt') then
DeleteFile(PAnsiChar(Pasta_App+'stdout.txt'));

if FileExists(Pasta_App+ExtractName(Single_EXE)+'_dosbox.conf')then
DeleteFile(PAnsiChar(Pasta_App+ExtractName(Single_EXE)+'_dosbox.conf'));

if FileExists(Pasta_App+ExtractName(Multi_EXE)+'_dosbox.conf')then
DeleteFile(PAnsiChar(Pasta_App+ExtractName(Multi_EXE)+'_dosbox.conf'));

//----------------------------------------------
{BLOOD}
//----------------------------------------------
if (id = 1) then
begin
  if FileExists(Pasta_App+'phobos.ini') then
  DeleteFile(PAnsiChar(Pasta_App+'phobos.ini'));
end;
//----------------------------------------------

//----------------------------------------------
{QUAKE / QUAKEWORLD}
//----------------------------------------------
if (id = 8) then
begin
  if FileExists(Pasta_App+'id1\autoexec.cfg') then
  DeleteFile(PAnsiChar(Pasta_App+'id1\autoexec.cfg'));

  if FileExists(Pasta_App+'hipnotic\autoexec.cfg') then
  DeleteFile(PAnsiChar(Pasta_App+'hipnotic\autoexec.cfg'));

  if FileExists(Pasta_App+'rogue\autoexec.cfg') then
  DeleteFile(PAnsiChar(Pasta_App+'rogue\autoexec.cfg'));

  if FileExists(Pasta_App+'qw\autoexec.cfg') then
  DeleteFile(PAnsiChar(Pasta_App+'qw\autoexec.cfg'));
end;
//----------------------------------------------

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Setup_Teclas(Game:Integer);
begin
 //-------------------------------------------------------------
 //MODO MULTIPLAYER - SELEÇÃO AUTOMATICA DE SETUPS
 //-------------------------------------------------------------

 {RISE OF THE TRIAD}
 if (Game = 9) then
 begin
 keybd_event(VK_DOWN,0,0,0);
 keybd_event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
 Sleep(300);
 keybd_event(VK_RETURN,0,0,0);
 keybd_event(VK_RETURN,0,KEYEVENTF_KEYUP,0);
 Sleep(300);
   {SERVIDOR}
   if (Form1_DGL.check_servidor.Checked = True) then
   begin
   keybd_event(VK_DOWN,0,0,0);
   keybd_event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
   Sleep(300);
   keybd_event(VK_RETURN,0,0,0);
   keybd_event(VK_RETURN,0,KEYEVENTF_KEYUP,0);
   Sleep(300);
   keybd_event(VK_RETURN,0,0,0);
   keybd_event(VK_RETURN,0,KEYEVENTF_KEYUP,0);
   Sleep(300);
   keybd_event(VK_RETURN,0,0,0);
   keybd_event(VK_RETURN,0,KEYEVENTF_KEYUP,0);
   end;
   {CLIENTE}
   if (Form1_DGL.check_cliente.Checked = True) then
   begin
   keybd_event(VK_RETURN,0,0,0);
   keybd_event(VK_RETURN,0,KEYEVENTF_KEYUP,0);
   end;
 end;

 {WARCRAFT II}
 if (Game = 11) then
 begin
 Sleep(200);
 keybd_event(ORD('M'),0,0,0);
 keybd_event(ORD('M'),0,KEYEVENTF_KEYUP,0);
 Sleep(200);
 keybd_event(VK_RETURN,0,0,0);
 keybd_event(VK_RETURN,0,KEYEVENTF_KEYUP,0);
 Sleep(200);
 keybd_event(VK_DOWN,0,0,0);
 keybd_event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
 keybd_event(VK_DOWN,0,0,0);
 keybd_event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
 keybd_event(VK_RETURN,0,0,0);
 keybd_event(VK_RETURN,0,KEYEVENTF_KEYUP,0);
 Sleep(200);
   {SERVIDOR}
   if (Form1_DGL.check_servidor.Checked = True) then
   begin
   keybd_event(ORD('C'),0,0,0);
   keybd_event(ORD('C'),0,KEYEVENTF_KEYUP,0);
   end;
   {CLIENTE}
   if (Form1_DGL.check_cliente.Checked = True) then
   begin
   keybd_event(VK_DOWN,0,0,0);
   keybd_event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
   Sleep(200);
   keybd_event(VK_RETURN,0,0,0);
   keybd_event(VK_RETURN,0,KEYEVENTF_KEYUP,0);
   end;
 end;
 //-------------------------------------------------------------

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Firewall(Pasta,Executavel:String);
var
aux:Integer;
Mensagem:String;
begin
{O 'runas' FAZ COM QUE SEJA EXECUTADO EM MODO ADMIN}
aux:=ShellExecute(Application.Handle,'runas','netsh.exe',PChar('firewall add allowedprogram "'+ExtractFilePath(Application.ExeName)+Pasta+Executavel+'" '+ChangeFileExt(Executavel,EmptyStr)+' ENABLE'),nil,SW_HIDE);

 case aux of
   SE_ERR_ACCESSDENIED,ERROR_FILE_NOT_FOUND,SE_ERR_ASSOCINCOMPLETE:
   begin
   Mensagem:=Lang_DGL(16);
   MessageBox(Application.Handle,pchar(Mensagem),pchar(Application.Title),MB_ICONERROR+MB_OK);
   end;
 end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function Config_Tela(On_Off:Boolean):Boolean;
begin

 if On_Off = False then
 begin
 Form1_DGL.Enabled:=False;
 //---------------------------------------------------------
 Form1_DGL.loading_panel.Visible:=True;
 Form1_DGL.img_game.Visible     :=Not AppAberto('qwsv.exe');
 Form1_DGL.gif_dos.Visible      :=    AppAberto('qwsv.exe');
 Form1_DGL.btn_start.Enabled    :=False;
 //---------------------------------------------------------
 end
 else
 begin
 Form1_DGL.Enabled:=True;
 //-------------------------------------
 Form1_DGL.loading_panel.Visible:=False;

  // if (id = 8) then
  // Form1_DGL.img_game.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'CONFIG\png\08.png');

 Form1_DGL.img_game.Visible     :=True;
 Form1_DGL.gif_dos.Visible      :=False;
 Form1_DGL.btn_start.Enabled    :=True;
 //-------------------------------------
   if (Form1_DGL.check_servidor.Enabled = True) and (Array_Games[id][7] = 'ZDOOM') then
   begin
   Form1_DGL.StatusBar1.Panels[1].Text:='';
   Form1_DGL.IMG_STATUS.Picture:=Nil;
   end;
 //-------------------------------------
 end;

Result:=On_Off;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function AppAberto(Nome:String):Boolean;
var rId:array[0..999] of DWord; i,NumProc,NumMod:DWord;
    HProc,HMod:THandle; sNome:String;
    Tamanho, Count:Integer;
    sNomeTratado:String;
begin
  result:=False;
  SetLength(sNome, 256);
  EnumProcesses(@rId[0], 4000, NumProc);

  for i := 0 to NumProc div 4 do
  begin
    HProc := OpenProcess(Process_Query_Information or Process_VM_Read, FALSE, rId[i]);
    if HProc = 0 then
      Continue;
    EnumProcessModules(HProc, @HMod, 4, NumMod);
    GetModuleBaseName(HProc, HMod, @sNome[1], 256);
    sNomeTratado := trim(sNome);
    Tamanho:=Length(SnomeTratado);
     Count:=1;
     While Count <= Tamanho do
       begin
         if SnomeTratado[Count]= '' Then
           Break;
        count:=Count+1;
       end;
     sNomeTratado:=Copy(SnomeTratado,1,Count-1);
    if AnsiUpperCase(sNomeTratado)=AnsiUpperCase(Nome) Then
      Result:=True;
    CloseHandle(HProc);
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function ExtractNamePath(path: String):String;
var
pathAjustado:String;
begin
pathAjustado:=path;
 if FileExists(pathAjustado) then
 pathAjustado:=ExtractFileDir(pathAjustado);

Result:=ExtractFileName(ExcludeTrailingPathDelimiter(pathAjustado));
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure Funcao_Config_Opcoes;
var
Nome_Game,Caminho_Imagem,Config_Game:String;
Game_Existe:Boolean;
Arquivo_DOSBOX_Fisico:TStringList;
i:Integer;
Arquivo_Blood_Default,Arquivo_Blood_Atual: File of Byte;
Arquivo_Quake_Default,Arquivo_Quake_Atual: File of Byte;
begin
//-------------------------------------------------------------------------
Nome_Game:=UpperCase(ExtractName(Array_Games[id][5]));
//-------------------------------------------------------------------------
Caminho_Imagem:=ExtractFilePath(Application.ExeName)+'CONFIG\png\'
               +ExtractNamePath(Array_Games[id][1])+'.png';
//-------------------------------------------------------------------------
Game_Existe:=Form1_DGL.RxCheckListBox1.EnabledItem[id-1];
Form1_DGL.gif_dos.Visible:=False;
//-------------------------------------------------------------------------

 if FileExists(Caminho_Imagem) then
 Form1_DGL.img_game.Picture.LoadFromFile(Caminho_Imagem)
 else
 begin
 Form1_DGL.img_game.Picture:=Nil;
 Form1_DGL.gif_dos.Visible:=True;
 end;

//----------------------------------------------------------------

 if (Game_Existe = False) then
 begin
 //----------------------------------------
 Form1_DGL.label_name.Enabled :=False;
 Form1_DGL.player_name.Enabled:=False;
 Form1_DGL.cont_player.Enabled:=False;
 Form1_DGL.cont_seta.Enabled  :=False;
 Form1_DGL.combo_color.Visible:=False;
 Form1_DGL.combo_doom.Visible :=False;
 //----------------------------------------
 Form1_DGL.RxControle.Visible    :=False;
 Form1_DGL.Label_Controle.Visible:=False;
 Form1_DGL.RxSense.Visible       :=False;
 Form1_DGL.Label_Sense.Visible   :=False;
 //----------------------------------------
 Form1_DGL.RxBrutal.Visible    :=False;
 Form1_DGL.Label_Brutal.Visible:=False;
 Form1_DGL.RxOpcoes.Visible    :=False;
 Form1_DGL.Label_Opcoes.Visible:=False;
 Form1_DGL.RxDM.Visible        :=False;
 Form1_DGL.Label_DM.Visible    :=False;
 //----------------------------------------
 Form1_DGL.ip_local.Enabled   :=False;
 Form1_DGL.ip_internet.Enabled:=False;
 Form1_DGL.ip_porta.Enabled   :=False;
 //----------------------------------------
 Form1_DGL.Refresh_Lan.Enabled     :=False;
 Form1_DGL.Refresh_Internet.Enabled:=False;
 //----------------------------------------
 Form1_DGL.check_single.Enabled  :=False;
 Form1_DGL.check_servidor.Enabled:=False;
 Form1_DGL.check_cliente.Enabled :=False;
 //--------------------------------------
 Form1_DGL.Label1.Enabled:=False;
 Form1_DGL.Label2.Enabled:=False;
 Form1_DGL.Label3.Enabled:=False;
 //---------------------------------
 Form1_DGL.btn_start.Enabled:=False;
 //---------------------------------
 end
 else
 begin
 Form1_DGL.cont_player.Text:='2';

   //------------------------------------------
   {DEBUG MODE}
   //------------------------------------------
   if Form1_DGL.menu_debug.Checked = False then
   begin
   Form1_DGL.StatusBar1.Panels[1].Text:='';
   Form1_DGL.IMG_STATUS.Picture:=Nil;
   end;
   //------------------------------------------

 Form1_DGL.check_single.Enabled  :=True;
 Form1_DGL.check_servidor.Enabled:=True;
 Form1_DGL.check_cliente.Enabled :=True;

   //---------------------------------------------------
   {HABILITAR SELEÇÃO TECLADO OU MOUSE}
   //---------------------------------------------------
   case id of
   {BLOOD + DOOM + DOOM 2 + DUKE NUKEM 3D + HERETIC + HEXEN + SHADOW WARRIOR}
   {WOLFENSTEIN 3D + SPEAR OF DESTINY}
   1,3,4,5,6,7,10,
            12,13: begin
                   //-------------------------------------
                   {MOUSE - HABILITAR}
                   //-------------------------------------
                   Form1_DGL.RxControle.Visible    :=True;
                   Form1_DGL.Label_Controle.Visible:=True;
                   //-------------------------------------

                     //------------------------------------------------------------------------------------------------------------------
                     {DOOM + DOOM II + HERETIC + HEXEN + WOLFENSTEIN 3D + SPEAR OF DESTINY - COPIA O ARQUIVO .INI ORIGINAL}
                     //------------------------------------------------------------------------------------------------------------------
                     case id of
                     3,4,6,7,12,13:
                                   begin
                                     if not FileExists(Caminho_Global+Array_Games[id][6]) then
                                     CopyFile(pchar(Pasta_INI_Global+Array_Games[id][6]),pchar(Caminho_Global+Array_Games[id][6]),False);
                                   end;
                     end;
                     //------------------------------------------------------------------------------------------------------------------

                     //-------------------------------------
                     {DOOM + DOOM II - BRUTAL DOOM}
                     //-------------------------------------
                     if (id = 3) or (id = 4) then
                     begin
                     Form1_DGL.RxBrutal.Visible:=True;
                     Form1_DGL.Label_Brutal.Visible:=True;
                     end
                     else
                     begin
                     Form1_DGL.RxBrutal.Visible:=False;
                     Form1_DGL.Label_Brutal.Visible:=False;
                     end;
                     //-------------------------------------

                     //---------------------------------------------------------------------
                     {BLOOD + DUKE NUKEM 3D + SHADOW WARRIOR}
                     //---------------------------------------------------------------------
                     if (id = 1) or (id = 5) or (id = 10) then
                     begin
                     //------------------------
                     Mouse_Global:=0;
                     //------------------------

                       if not FileExists(Caminho_Global+'BMOUSE.EXE') then
                       CopyFile(pchar(Pasta_INI_Global+'data\BMOUSE.EXE'),pchar(Caminho_Global+'BMOUSE.EXE'),False);

                       if not FileExists(Caminho_Global+'nolfblim.com') then
                       CopyFile(pchar(Pasta_INI_Global+'data\nolfblim.com'),pchar(Caminho_Global+'nolfblim.com'),False);

                       {SHADOW WARRIOR - TWIN DRAGON - VERSÃO GOG}
                       if (id = 10) and (SW_DLC_Exists(2) = True) and (SW_DLC_Archive(2) = 'sw.exe') then
                       begin
                         if not FileExists(Caminho_Global+'dragon\BMOUSE.EXE') then
                         CopyFile(pchar(Pasta_INI_Global+'data\BMOUSE.EXE'),pchar(Caminho_Global+'dragon\BMOUSE.EXE'),False);

                         if not FileExists(Caminho_Global+'dragon\nolfblim.com') then
                         CopyFile(pchar(Pasta_INI_Global+'data\nolfblim.com'),pchar(Caminho_Global+'dragon\nolfblim.com'),False);
                       end;

                       //-------------------------------------------------------------------------------------------------------
                       {BLOOD - ARQUIVOS .INI}
                       //-------------------------------------------------------------------------------------------------------
                       if (id = 1) then
                       begin

                         if FileExists(Caminho_Global+'cryptic.exe') and (not FileExists(Caminho_Global+'CPMULTI.EXE')) then
                         CopyFile(pchar(Pasta_INI_Global+'data\CPMULTI.EXE'),pchar(Caminho_Global+'CPMULTI.EXE'),False);

                         if not FileExists(Caminho_Global+'blood.ini') then
                         begin

                           if FileExists(Caminho_Global+'cryptic.exe') then
                           CopyFile(pchar(Pasta_INI_Global+'cryptic.ini'),pchar(Caminho_Global+'blood.ini'),False)
                           else
                           CopyFile(pchar(Pasta_INI_Global+'blood.ini'  ),pchar(Caminho_Global+'blood.ini'),False);

                         end
                         else
                         begin

                           if FileExists(Caminho_Global+'cryptic.exe') then
                           begin
                           //---------------------------------------------------------------
                           AssignFile(Arquivo_Blood_Default,Pasta_INI_Global+'cryptic.ini'); //PASTA CONFIG
                           AssignFile(Arquivo_Blood_Atual  ,Caminho_Global  +'blood.ini'  ); //PASTA DO JOGO
                           Reset(Arquivo_Blood_Default);
                           Reset(Arquivo_Blood_Atual);
                           //---------------------------------------------------------------

                             if FileSize(Arquivo_Blood_Default) > FileSize(Arquivo_Blood_Atual) then
                             CopyFile(pchar(Pasta_INI_Global+'cryptic.ini'),pchar(Caminho_Global+'blood.ini'),False);

                           //-------------------------------
                           CloseFile(Arquivo_Blood_Default); //PASTA CONFIG
                           CloseFile(Arquivo_Blood_Atual);   //PASTA DO JOGO
                           //-------------------------------
                           end;

                         end;

                       end;
                       //-------------------------------------------------------------------------------------------------------

                       //-------------------------------------
                       {SENSIBILIDADE DO MOUSE - PADRÃO STEAM}
                       //-------------------------------------
                       {BLOOD + DUKE NUKEM 3D}
                       if (id = 1) or (id = 5) then
                       begin
                       MouseAnalogX:=ID_MouseAnalogX;
                       MouseAnalogY:=ID_MouseAnalogY;
                       end
                       {SHADOW WARRIOR}
                       else
                       begin
                       MouseAnalogX:=SW_MouseAnalogX;
                       MouseAnalogY:=SW_MouseAnalogY;
                       end;
                       //-------------------------------------

                     Form1_DGL.RxSense.Visible    :=Form1_DGL.RxControle.StateOn;
                     Form1_DGL.Label_Sense.Visible:=Form1_DGL.RxControle.StateOn;
                     end
                     else
                     begin
                     Form1_DGL.RxSense.Visible    :=False;
                     Form1_DGL.Label_Sense.Visible:=False;
                     end;
                     //---------------------------------------------------------------------

                   //---------------------------------------------
                   Config_Game:=Caminho_Global+Array_Games[id][6];
                   //---------------------------------------------

                   Arquivo_DOSBOX_Fisico:=TStringList.Create;
                   Arquivo_DOSBOX_Fisico.LoadFromFile(Config_Game);

                     for i:=0 to Arquivo_DOSBOX_Fisico.Count-1 do
                     begin
                       //---------------------------------------------------------------------
                       {BLOOD + DUKE NUKEM 3D + SHADOW WARRIOR}
                       //---------------------------------------------------------------------
                       if (id = 1) or (id = 5) or (id = 10) then
                       begin
                         //----------------------------------------------------------------------------
                         {PADRÃO DA SENSIBILIDADE DO MOUSE - 01/02}
                         //----------------------------------------------------------------------------
                         if Pos('MouseAnalogScale0 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                         begin
                           if (id = 10) then
                           Arquivo_DOSBOX_Fisico[i]:='MouseAnalogScale0 = '+IntToStr(SW_MouseAnalogX)
                           else
                           Arquivo_DOSBOX_Fisico[i]:='MouseAnalogScale0 = '+IntToStr(ID_MouseAnalogX);
                         end;

                         if Pos('MouseAnalogScale1 = ',Arquivo_DOSBOX_Fisico[i]) = 1 then
                         begin
                           if (id = 10) then
                           Arquivo_DOSBOX_Fisico[i]:='MouseAnalogScale1 = -'+IntToStr(SW_MouseAnalogY)
                           else
                           Arquivo_DOSBOX_Fisico[i]:='MouseAnalogScale1 = -'+IntToStr(ID_MouseAnalogY);
                         end;
                         //----------------------------------------------------------------------------

                         if Pos('ControllerType = 3',Arquivo_DOSBOX_Fisico[i]) = 1 then
                         begin
                         Form1_DGL.RxControle.StateOn:=True;
                         Form1_DGL.Label_Controle.Caption:='MOUSE';
                         Form1_DGL.RxSense.Visible:=True;
                         Form1_DGL.Label_Sense.Visible:=True;
                         Break;
                         end
                         else
                         begin
                         Form1_DGL.RxControle.StateOn:=False;
                         Form1_DGL.Label_Controle.Caption:=Lang_DGL(18);
                         Form1_DGL.RxSense.Visible:=False;
                         Form1_DGL.Label_Sense.Visible:=False;
                         end;

                       end
                       //-------------------------------------------------------------------
                       {DOOM + DOOM 2 + HERETIC + HEXEN + WOLFENSTEIN 3D + SPEAR OF DESTINY}
                       //-------------------------------------------------------------------
                       else
                       begin

                         if Pos('skin=base',Arquivo_DOSBOX_Fisico[i]) = 1 then
                         begin
                         Form1_DGL.combo_doom.ItemIndex:=0;
                         Form1_DGL.combo_color.Enabled:=True;
                         end;
                         
                         if Pos('skin=Phobos',Arquivo_DOSBOX_Fisico[i]) = 1 then
                         begin
                         Form1_DGL.combo_doom.ItemIndex:=1;
                         Form1_DGL.combo_color.Enabled:=False;
                         end;

                         //if Pos('am_colorset=0',Arquivo_DOSBOX_Fisico[i]) = 1 then
                         //Form1_DGL.combo_color.ItemIndex:=0;

                         if Pos('use_mouse=true',Arquivo_DOSBOX_Fisico[i]) = 1 then
                         begin
                         Form1_DGL.RxControle.StateOn:=True;
                         Form1_DGL.Label_Controle.Caption:='MOUSE';
                         Break;
                         end;
                         if Pos('use_mouse=false',Arquivo_DOSBOX_Fisico[i]) = 1 then
                         begin
                         Form1_DGL.RxControle.StateOn:=False;
                         Form1_DGL.Label_Controle.Caption:=Lang_DGL(18);
                         Break;
                         end;

                       end;
                       //--------------------------------------------------------------
                     end;

                     //---------------------------------------------------------------------------------
                     {PADRÃO DA SENSIBILIDADE DO MOUSE - 02/02}
                     //---------------------------------------------------------------------------------
                     if ((id = 1) or (id = 5) or (id = 10)) and (Form1_DGL.RxSense.Visible = False) then
                     Arquivo_DOSBOX_Fisico.SaveToFile(Config_Game);
                     //---------------------------------------------------------------------------------

                   Arquivo_DOSBOX_Fisico.Free;
                   end;
                   //--------------------------------------------------------------
   //----------------------------------------------------------------------------------------------------------------------
   {QUAKE}
   //----------------------------------------------------------------------------------------------------------------------
   8: begin
      Form1_DGL.RxControle.Visible    :=False;
      Form1_DGL.Label_Controle.Visible:=False;
      Form1_DGL.RxSense.Visible       :=False;
      Form1_DGL.Label_Sense.Visible   :=False;

        //----------------------------------------------------------------------------------------------------------------
        {ARQUIVOS DO GLQUAKE.EXE}
        //----------------------------------------------------------------------------------------------------------------
        if not FileExists(Caminho_Global+'Glquake.exe') then
        CopyFile(pchar(Pasta_INI_Global+'quake\Glquake.exe') ,pchar(Caminho_Global+'Glquake.exe') ,False);
        if not FileExists(Caminho_Global+'glide2x.dll') then
        CopyFile(pchar(Pasta_INI_Global+'quake\glide2x.dll') ,pchar(Caminho_Global+'glide2x.dll') ,False);
        if not FileExists(Caminho_Global+'opengl32.dll') then
        CopyFile(pchar(Pasta_INI_Global+'quake\opengl32.dll'),pchar(Caminho_Global+'opengl32.dll'),False);
        if not FileExists(Caminho_Global+'Winquake.exe') then
        CopyFile(pchar(Pasta_INI_Global+'quake\Winquake.exe'),pchar(Caminho_Global+'Winquake.exe'),False);
        //----------------------------------------------------------------------------------------------------------------

        if not FileExists(Caminho_Global+'id1\-[swt]-namefun.exe') then
        CopyFile(pchar(Pasta_INI_Global+'quake\-[swt]-namefun.exe'),pchar(Caminho_Global+'id1\-[swt]-namefun.exe'),False);

        if FileExists(Pasta_INI_Global+'quake\quake.exe') then
        begin
        //-------------------------------------------------------------------
        AssignFile(Arquivo_Quake_Default,Pasta_INI_Global+'quake\quake.exe'); //PASTA CONFIG
        AssignFile(Arquivo_Quake_Atual  ,Caminho_Global  +'quake.exe');       //PASTA DO JOGO
        Reset(Arquivo_Quake_Default);
        Reset(Arquivo_Quake_Atual);
        //-------------------------------------------------------------------

          if FileSize(Arquivo_Quake_Default) > FileSize(Arquivo_Quake_Atual) then
          CopyFile(pchar(Pasta_INI_Global+'quake\quake.exe'),pchar(Caminho_Global+'quake.exe'),False);

        //-------------------------------
        CloseFile(Arquivo_Quake_Default); //PASTA CONFIG
        CloseFile(Arquivo_Quake_Atual);   //PASTA DO JOGO
        //-------------------------------
        end;

        Try
          if not DirectoryExists(Caminho_Global+'id1\skins\') then
          CreateDir(Caminho_Global+'id1\skins\');
        Finally
          if not FileExists(Caminho_Global+'id1\skins\base.pcx') then
          CopyFile(pchar(Pasta_INI_Global+'\quake\base.pcx'),pchar(Caminho_Global+'id1\skins\base.pcx'),False);
        end;

      end;
   //----------------------------------------------------------------------------------------------------------------------
   else
   begin
   Form1_DGL.RxControle.Visible    :=False;
   Form1_DGL.Label_Controle.Visible:=False;
   Form1_DGL.RxSense.Visible       :=False;
   Form1_DGL.Label_Sense.Visible   :=False;
   end;
   end;
   //---------------------------------------------------

   //---------------------------------------------------
   {SERVIDOR E CLIENTE}
   //---------------------------------------------------
   if Form1_DGL.check_single.Checked = True then
   Modo_Game(0)
   else
   begin

     {SERVIDOR}
     if Form1_DGL.check_servidor.Checked = True then
     Modo_Game(1);
     {CLIENTE}
     if Form1_DGL.check_cliente.Checked  = True then
     Modo_Game(2);

     //---------------------------------------------------------
     {HABILITA O MODO DE SELEÇÃO DE CORES/SKIN DE PERSONAGEM}
     //---------------------------------------------------------
     case id of
     3,4,6,7, {DOOM - DOOM 2 - HERETIC - HEXEN}
     8,12,13: {QUAKE - WOLFENSTEIN 3D - SPEAR OF DESTINY}
     begin
     Form1_DGL.combo_color.Visible:=True;
     Lista_Cores(id);
     end;
     else
     Form1_DGL.combo_color.Visible:=False;
     Form1_DGL.RxOpcoes.Visible    :=False;
     Form1_DGL.Label_Opcoes.Visible:=False;
     Form1_DGL.RxDM.Visible        :=False;
     Form1_DGL.Label_DM.Visible    :=False;
     end;
     //---------------------------------------------------------
     {DOOM 2 - SKINS}
     if (id = 4) then
     Form1_DGL.combo_doom.Visible:=True
     else
     Form1_DGL.combo_doom.Visible:=False;
     //---------------------------------------------------------

     //---------------------------------------------------------
     {HABILITA A QUANTIDADE MÁXIMA DE JOGADORES SUPORTADO}
     //---------------------------------------------------------
     case id of
     1,5,9,10, {BLOOD - DUKE NUKEM 3D - RISE OF THE TRIAD - SHADOW WARRIOR}
     3,4,6,7,  {DOOM - DOOM 2 - HERETIC - HEXEN}
     12,13:    {WOLFENSTEIN 3D - SPEAR OF DESTINY}
     begin
     Form1_DGL.label_name.Enabled :=True;
     Form1_DGL.player_name.Enabled:=True;
     Form1_DGL.cont_player.Enabled:=True;
     Form1_DGL.cont_seta.Enabled  :=True;
       {MÁXIMO 11 JOGADORES - RISE OF THE TRIAD}
       if (id = 9) then
       Form1_DGL.cont_seta.Max:=11
       {MÁXIMO 8 JOGADORES}
       else
       Form1_DGL.cont_seta.Max:=8;
     end;

     2,8,11: {CONSTRUCTOR - QUAKE - WARCRAFT II}
     begin
     Form1_DGL.label_name.Enabled :=True;
     Form1_DGL.player_name.Enabled:=True;
       {MÁXIMO 4 JOGADORES - QUAKE}
       if (id = 8) and (Form1_DGL.check_servidor.Checked = True) then
       begin
       Form1_DGL.cont_seta.Max:=4;
       Form1_DGL.cont_player.Enabled:=True;
       Form1_DGL.cont_seta.Enabled  :=True;
       end
       else
       begin
       Form1_DGL.cont_player.Enabled:=False;
       Form1_DGL.cont_seta.Enabled  :=False;
       end;
     end;

     end; //END - CASE
   end; //END - SINGLE PLAYER
 end; //END - Game_Existe = False
//---------------------------------------------------
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function ExtractName(const Filename:String):String;
var
aExt:String;
aPos:Integer;
begin
aExt := ExtractFileExt(Filename);
Result := ExtractFileName(Filename);
if aExt <> '' then
   begin
   aPos := Pos(aExt,Result);
   if aPos > 0 then
      begin
      Delete(Result,aPos,Length(aExt));
      end;
   end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function IP_NET: String;
const
site = 'http://checkip.dyndns.org';
var
html:String;
posstart,posend:Integer;
begin
Result:='0.0.0.0';

 Try
  with TIdHTTP.Create(nil) do
   Try
   html:=Get(site);
   Finally
   Free;
  end;
 Except
 Result:='0.0.0.0';
 end;

 if Length(Trim(Result)) = 0 then
 Result:='0.0.0.0'
 else
 begin
 posstart:=Pos(':',html);
 posend:=Pos('</body>',html);
 Result:=Trim(Copy(html,posstart+1,posend-posstart-1));
 end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.






