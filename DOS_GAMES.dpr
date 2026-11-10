program dos_games;

uses
  Forms,
  Windows,
  SysUtils,
  Unit1 in 'Unit1.pas' {Form1_DGL},
  DLC in 'DLC.pas' {Form2_DLC},
  QUAKE_NameFun in 'QUAKE_NameFun.pas' {Form3_NameFun},
  MAP_Select in 'MAP_Select.pas' {Form4_Select},
  Splash in 'Splash.pas' {Form5_Splash},
  Mouse_Sense in 'Mouse_Sense.pas' {Form6_Mouse},
  About in 'About.pas' {Form7_About},
  HEXEN_Class in 'HEXEN_Class.pas' {Form8_HexenClass},
  Language in 'Language.pas',
  Funcoes in 'Funcoes.pas',
  NO_DOSBOX_Bind in 'NO_DOSBOX_Bind.pas',
  ZDOOM_Bind in 'ZDOOM_Bind.pas',
  DOSBOX_Bind_FPS in 'DOSBOX_Bind_FPS.pas',
  QUAKE_Bind in 'QUAKE_Bind.pas',
  UIUtils in 'UIUtils.pas',
  PastaMonitor in 'PastaMonitor.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

const
//----------------------------------------------------------
DGL_VERSAO_Global = '3.0';
DGL_VERSAO        = DGL_VERSAO_Global;
DGL_BLOG          = 'http://phobosfreeware.blogspot.com.br';
//----------------------------------------------------------
var
//------------------------------------------------------
DGL_EXE,
DGL_RAIZ:String;
T: UInt64;
//------------------------------------------------------

begin
  Application.Initialize;
  Application.Title := 'DOS GAME LAUNCHER 3.0';
  DGL_EXE  := Copy(ExtractFileName(Application.ExeName), 1,
                   Length(ExtractFileName(Application.ExeName)) - 4);
  DGL_RAIZ := ExtractFilePath(Application.ExeName);

  VarGlobais(DGL_EXE, DGL_RAIZ, DGL_VERSAO, DGL_BLOG);

  Lang_Load;

  Form5_Splash := TForm5_Splash.Create(nil);
  try
    Form5_Splash.Show;
    Form5_Splash.Update;
    T := GetTickCount64;

      while GetTickCount64 - T < 3000 do
      begin
      Application.ProcessMessages;
      Sleep(10);
      end;

  finally
    Form5_Splash.Free;
  end;

   if ParamStr(1) <> 'phobos' then
   Halt;

 Application.CreateForm(TForm1_DGL, Form1_DGL);
  Application.Run;

end.
