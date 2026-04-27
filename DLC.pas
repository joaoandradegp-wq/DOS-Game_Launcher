unit DLC;

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
  IMG_QUAKE_DLC1, IMG_QUAKE_DLC2, IMG_WOLF3D_DLC:String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2_DLC: TForm2_DLC;

implementation

uses Unit1, Language, Funcoes, ZDOOM_Bind, DOSBOX_Bind_FPS, HEXEN_Class;

{$R *.dfm}

procedure TForm2_DLC.FormActivate(Sender: TObject);
begin
IMG_QUAKE_DLC1 := ExtractFilePath(Application.ExeName)+'CONFIG\png\08A.png';
IMG_QUAKE_DLC2 := ExtractFilePath(Application.ExeName)+'CONFIG\png\08B.png';
IMG_WOLF3D_DLC := ExtractFilePath(Application.ExeName)+'CONFIG\png\12A.png';

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
      PACK00.Caption:=Lang_DGL(2);
      PACK01.Caption:=Lang_DGL(3);
      PACK02.Caption:=Lang_DGL(4);
      end;
   8: begin
      Form2_DLC.Caption:=Array_Games[id][2];
      PACK00.Caption:='QUAKE';
      PACK01.Caption:='SCOURGE OF ARMAGON';
      PACK02.Caption:='DISSOLUTION OF ETERNITY';
      PACK01.Enabled:=DirectoryExists(Caminho_Global+'hipnotic\');
      PACK02.Enabled:=DirectoryExists(Caminho_Global+'rogue\');
      end;
  10: begin
      Form2_DLC.Caption:=Array_Games[id][2];
      PACK00.Caption:='SHADOW WARRIOR';
      PACK01.Caption:='WANTON DESTRUCTION';
      PACK02.Caption:='TWIN DRAGON';
      PACK01.Enabled:=SW_DLC_Exists(1);
      PACK02.Enabled:=SW_DLC_Exists(2);
      end;
  12: begin
      Form2_DLC.Caption:=Array_Games[id][2];
      PACK00.Caption:='WOLFENSTEIN 3D';
      PACK01.Caption:='SPEAR OF DESTINY';
      PACK02.Caption:='';
      PACK01.Enabled:=FileExists(ExtractFilePath(Application.ExeName)+Array_Games[id][3]+'SoD.pk7');
      PACK02.Visible:=not PACK01.Enabled;
      Form2_DLC.Height:=105;
      end;
  end;

end;

procedure TForm2_DLC.PACK00Click(Sender: TObject);
begin

  case id of
      3: Game_EXE_Global:=Array_Games[id][5];
      8: begin
         EPI_Global_DLC:=1;
         Nome_DLC_Global:='Quake';
         end;
7,10,12: EPI_Global_DLC:=1;
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
           if FileExists (IMG_QUAKE_DLC1) then
           Form1_DGL.img_game.Picture.LoadFromFile(IMG_QUAKE_DLC1);
         end;
7,10,12: begin
         EPI_Global_DLC:=2; {HEXEN(CLASSE) + WANTON DESTRUCTION + SPEAR OF DESTINY}
           if id = 12 then
           begin
           Nome_DLC_Global:='Spear of Destiny';
             if FileExists(IMG_WOLF3D_DLC) then
             Form1_DGL.img_game.Picture.LoadFromFile(IMG_WOLF3D_DLC);
           end;
         end;
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
        if FileExists (IMG_QUAKE_DLC2) then
        Form1_DGL.img_game.Picture.LoadFromFile(IMG_QUAKE_DLC2);
      end;
7,10: EPI_Global_DLC:=3; {HEXEN(CLASSE) + TWIN DRAGON}
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

