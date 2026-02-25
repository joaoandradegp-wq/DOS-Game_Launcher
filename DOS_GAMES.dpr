program DOS_GAMES;

uses
  Forms,
  Wininet,
  SysUtils,
  Unit1 in 'Unit1.pas'            {Form1_DGL},
  DLC in 'DLC.pas'                {Form2_DLC},
  NameFun in 'NameFun.pas'        {Form3_NameFun},
  MAP_Select in 'MAP_Select.pas'  {Form4_Select},
  Splash in 'Splash.pas'          {Form5_Splash},
  Mouse_Sense in 'Mouse_Sense.pas'{Form6_Mouse},
  About in 'About.pas'            {Form7_About},

  Language in 'Language.pas',
  Funcoes in 'Funcoes.pas',

  NO_DOSBOX_Bind in 'NO_DOSBOX_Bind.pas',
  ZDOOM_Bind in 'ZDOOM_Bind.pas',
  DOSBOX_Bind_FPS in 'DOSBOX_Bind_FPS.pas';

{$R *.res}

const
//------------------------------------------------------
DGL_VERSAO     = '2.0';
DGL_BLOG       = 'http://phobosfreeware.blogspot.com.br';
//------------------------------------------------------
var
//------------------------------------------------------
DGL_EXE,
DGL_RAIZ:String;
//------------------------------------------------------

begin
  Application.Initialize;
  Application.Title := 'DOS GAME LAUNCHER 2.0';

  IP_Interno_Global := GetInternalIP;
  IP_Externo_Global := GetExternalIP;

  DGL_EXE  := Copy(ExtractFileName(Application.ExeName), 1,
                   Length(ExtractFileName(Application.ExeName)) - 4);
  DGL_RAIZ := ExtractFilePath(Application.ExeName);

  VarGlobais(DGL_EXE, DGL_RAIZ, DGL_VERSAO, DGL_BLOG);

  Form5_Splash := TForm5_Splash.Create(nil);
  try
    Form5_Splash.Show;
    Form5_Splash.Update;
    Sleep(3000);
  finally
    Form5_Splash.Free;
  end;

 //if ParamStr(1) <> 'phobos' then
 //Halt;

 if ParamStr(2) = 'usa' then
 Language_Global:=1  //INGLÊS
 else
 Language_Global:=0; //PT-BR

 Application.CreateForm(TForm1_DGL, Form1_DGL);
 Application.Run;

end.
