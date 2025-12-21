unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, WinSkinData;

type
  TForm2_DLC = class(TForm)
    PACK01: TSpeedButton;
    PACK02: TSpeedButton;
    SkinData_Buttons: TSkinData;
    PACK00: TSpeedButton;
    procedure PACK01Click(Sender: TObject);
    procedure PACK02Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PACK00Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2_DLC: TForm2_DLC;

implementation

uses Unit1,Language,Funcoes;

{$R *.dfm}

procedure TForm2_DLC.FormActivate(Sender: TObject);
begin

  case id of
   3: begin
      Form2_DLC.Caption:=Array_Games[id][2];
      PACK00.Caption:='THE ULTIMATE DOOM';
      PACK01.Caption:='SIGIL';
      PACK02.Caption:='SIGIL II';
      PACK01.Enabled:=SIGIL_DLC_Exists(1);
      PACK02.Enabled:=SIGIL_DLC_Exists(2);
      end;
   7: begin
      Form2_DLC.Caption:=Lang_DGL(7);
      PACK00.Caption:=UpperCase(Lang_DGL(2));
      PACK01.Caption:=UpperCase(Lang_DGL(3));
      PACK02.Caption:=UpperCase(Lang_DGL(4));
      end;
   8: begin
      Form2_DLC.Caption:=Array_Games[id][2];
      PACK00.Caption:=UpperCase(Form2_DLC.Caption);
      PACK01.Caption:='SCOURGE OF ARMAGON';
      PACK02.Caption:='DISSOLUTION OF ETERNITY';
      PACK01.Enabled:=DirectoryExists(Caminho_Global+'hipnotic\');
      PACK02.Enabled:=DirectoryExists(Caminho_Global+'rogue\');
      end;
  10: begin
      Form2_DLC.Caption:=Array_Games[id][2];
      PACK00.Caption:=UpperCase(Form2_DLC.Caption);
      PACK01.Caption:='WANTON DESTRUCTION';
      PACK02.Caption:='TWIN DRAGON';
      PACK01.Enabled:=SW_DLC_Exists(1);
      PACK02.Enabled:=SW_DLC_Exists(2);
      end;
  end;

end;

procedure TForm2_DLC.PACK00Click(Sender: TObject);
begin

  case id of
     3: Game_EXE_Global:=Array_Games[id][5];
     8: EPI_Global_DLC:=1;
  7,10: EPI_Global_DLC:=1;
  end;

Close;
end;

procedure TForm2_DLC.PACK01Click(Sender: TObject);
begin

  case id of
   3: Game_EXE_Global:=Array_SIGIL_DLC_Name[0]+Array_SIGIL_DLC_Name[1];
   8: begin
      EPI_Global_DLC:=2;
      Nome_DLC_Global:='Scourge of Armagon';
      Config_Game_Global:=Caminho_Global+'hipnotic\config.cfg';
      VarParametro_Global:=VarParametro_Global+' -game hipnotic -hipnotic';
      Form1_DGL.img_game.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'CONFIG\png\08A.png');
      end;
7,10: EPI_Global_DLC:=2; {WANTON DESTRUCTION}
  end;

Close;
end;

procedure TForm2_DLC.PACK02Click(Sender: TObject);
begin

  case id of
   3: Game_EXE_Global:=Array_SIGIL_DLC_Name[2]+Array_SIGIL_DLC_Name[3];
   8: begin
      EPI_Global_DLC:=3;
      Nome_DLC_Global:='Dissolution of Eternity';
      Config_Game_Global:=Caminho_Global+'rogue\config.cfg';
      VarParametro_Global:=VarParametro_Global+' -rogue';
      Form1_DGL.img_game.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'CONFIG\png\08B.png');
      end;
7,10: EPI_Global_DLC:=3; {TWIN DRAGON}
  end;

Close;
end;

procedure TForm2_DLC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form2_DLC.Release;
Form2_DLC:=Nil;
end;

procedure TForm2_DLC.FormKeyPress(Sender: TObject; var Key: Char);
begin

  if (key = #27) then
  begin
  Close;
  Fecha_ESC:=True;
  end;
  
end;

end.

