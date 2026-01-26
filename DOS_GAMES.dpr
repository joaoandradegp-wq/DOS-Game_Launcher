program DOS_GAMES;

uses
  Forms,
  Wininet,
  Unit1 in 'Unit1.pas' {Form1_DGL},
  Funcoes in 'Funcoes.pas',
  About in 'About.pas' {Form5_About},
  Unit3 in 'Unit3.pas' {Form3_QuakeWorld},
  Unit4 in 'Unit4.pas' {Form4_Select},
  Unit5 in 'Unit5.pas' {Form5_Splash};
  Unit6 in 'Unit6.pas' {Form6_Mouse},
  Language in 'Language.pas',
  Unit2 in 'Unit2.pas' {Form2_DLC};

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

  DGL_EXE  := Copy(ExtractFileName(Application.ExeName), 1,
                   Length(ExtractFileName(Application.ExeName)) - 4);
  DGL_RAIZ := ExtractFilePath(Application.ExeName);

  VarGlobais(DGL_EXE, DGL_RAIZ, DGL_VERSAO, DGL_BLOG);

  Splash_Screen := TSplash_Screen.Create(nil);
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
 Language_Global:=1
 else
 Language_Global:=0;

  Application.CreateForm(TForm1_DGL, Form1_DGL);

  if InternetCheckConnection('http://www.google.com/',1,0) then
  begin
  //----------------------------------------------
  IP_Interno_Global:=Form1_DGL.IdIPWatch1.LocalIP;
  IP_Externo_Global:=IP_NET;
  //----------------------------------------------
  end
  else
  begin
  //----------------------------------------------
  IP_Interno_Global:=Form1_DGL.IdIPWatch1.LocalIP;
  IP_Externo_Global:='0.0.0.0';
  //----------------------------------------------
  end;
 Application.Run;

end.
