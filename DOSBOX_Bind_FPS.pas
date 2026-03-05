unit DOSBOX_Bind_FPS;

interface

uses
  Windows, ShellAPI, SysUtils, Classes, Forms,
  Unit1, Funcoes, Language, DLC, MAP_Select;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function  SW_DLC_Archive(DLC:Integer):String;
function  SW_DLC_Exists(DLC:Integer):Boolean;
procedure Blood_Levels(num_episodio,num_capitulo,qtde_capitulos:Integer);
//------------------------------------------------------------------------------
procedure DOSBOX_Bind_FPS_Blood(
  HandleApp: HWND;
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer
);
//------------------------------------------------------------------------------
procedure DOSBOX_Bind_FPS_Duke(
  HandleApp: HWND;
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer
);
//------------------------------------------------------------------------------
procedure DOSBOX_Bind_FPS_Shadow(
  HandleApp: HWND;
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer
);
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

implementation

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
arq_saida.Add('Title   = '+Form4_Select.ListBox_Episodio.Items[Form4_Select.ListBox_Episodio.ItemIndex]);

  {LISTA OS CAPÍTULOS - RESUMO}
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

arq_saida.SaveToFile(ExtractFilePath(Application.ExeName)+Array_Games[id][3]+'phobos.ini');
FreeAndNil(arq_entrada);
FreeAndNil(arq_saida);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ReplaceLinePrefix(L: TStringList; const Prefix, NewValue: string);
var i: Integer;
begin
  for i := 0 to L.Count-1 do
    if Pos(Prefix, L[i]) = 1 then
    L[i] := NewValue;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureBloodCFG(
  CaminhoJogo: string;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer;
  var Parametros: string
);
var
CFG: TStringList;
Arq: string;
begin
Arq := CaminhoJogo + 'blood.cfg';
CFG := TStringList.Create;
CFG.LoadFromFile(Arq);

ReplaceLinePrefix(CFG,'ScreenMode =','ScreenMode = 1');
ReplaceLinePrefix(CFG,'ScreenWidth =','ScreenWidth = 640');
ReplaceLinePrefix(CFG,'ScreenHeight =','ScreenHeight = 480');

ReplaceLinePrefix(CFG,'Size =','Size = 1');
ReplaceLinePrefix(CFG,'Gamma =','Gamma = 0');
ReplaceLinePrefix(CFG,'Detail =','Detail = 4');
ReplaceLinePrefix(CFG,'AimReticle =','AimReticle = 1');

ReplaceLinePrefix(CFG,'FXDevice =','FXDevice = 0');
ReplaceLinePrefix(CFG,'MusicDevice =','MusicDevice = 7');
ReplaceLinePrefix(CFG,'FXVolume =','FXVolume = 220');
ReplaceLinePrefix(CFG,'MusicVolume =','MusicVolume = 200');
ReplaceLinePrefix(CFG,'NumVoices =','NumVoices = 32');
ReplaceLinePrefix(CFG,'MixRate =','MixRate = 44000');
ReplaceLinePrefix(CFG,'NumChannels =','NumChannels = 2');
ReplaceLinePrefix(CFG,'NumBits =','NumBits = 16');
ReplaceLinePrefix(CFG,'MidiPort =','MidiPort = 0x330');
ReplaceLinePrefix(CFG,'BlasterAddress =','BlasterAddress = 0x220');
ReplaceLinePrefix(CFG,'BlasterType =','BlasterType = 6');
ReplaceLinePrefix(CFG,'BlasterInterrupt =','BlasterInterrupt = 7');
ReplaceLinePrefix(CFG,'BlasterDma8 =','BlasterDma8 = 1');
ReplaceLinePrefix(CFG,'BlasterDma16 =','BlasterDma16 = 5');
ReplaceLinePrefix(CFG,'BlasterEmu =','BlasterEmu = 0x620');
ReplaceLinePrefix(CFG,'ReverseStereo =','ReverseStereo = 0');

  {MOUSE}
  if RxControle_Mouse then
  begin
  ReplaceLinePrefix(CFG,'ControllerType =','ControllerType = 3');
  ReplaceLinePrefix(CFG,'ExternalFilename =','ExternalFilename = "BMOUSE.EXE"');
  ReplaceLinePrefix(CFG,'MouseAiming =','MouseAiming = 0');
  ReplaceLinePrefix(CFG,'MouseAimingFlipped =','MouseAimingFlipped = 0');
  ReplaceLinePrefix(CFG,'MouseButton0 =','MouseButton0 = "Weapon_Fire"');
  ReplaceLinePrefix(CFG,'MouseButton1 =','MouseButton1 = "Jump"');
  ReplaceLinePrefix(CFG,'MouseButton2 =','MouseButton2 = "Weapon_Special_Fire"');

  ReplaceLinePrefix(CFG,'Move_Forward =','Move_Forward = "W" "N/A"');
  ReplaceLinePrefix(CFG,'Move_Backward =','Move_Backward = "S" "N/A"');
  ReplaceLinePrefix(CFG,'Turn_Left =','Turn_Left = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Turn_Right =','Turn_Right = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Turn_Around =','Turn_Around = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Strafe =','Strafe = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Strafe_Left =','Strafe_Left = "A" "N/A"');
  ReplaceLinePrefix(CFG,'Strafe_Right =','Strafe_Right = "D" "N/A"');

  ReplaceLinePrefix(CFG,'Jump =','Jump = "Space" "N/A"');
  ReplaceLinePrefix(CFG,'Crouch =','Crouch = "C" "N/A"');
  ReplaceLinePrefix(CFG,'Run =','Run = "LShift" "RShift"');
  ReplaceLinePrefix(CFG,'AutoRun =','AutoRun = "CapLck" "N/A"');
  ReplaceLinePrefix(CFG,'Open =','Open = "E" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_Fire =','Weapon_Fire = "LCtrl" "RCtrl"');
  ReplaceLinePrefix(CFG,'Weapon_Special_Fire =','Weapon_Special_Fire = "X" "N/A"');

  ReplaceLinePrefix(CFG,'Aim_Up =','Aim_Up = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Aim_Down =','Aim_Down = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Aim_Center =','Aim_Center = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Look_Up =','Look_Up = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Look_Down =','Look_Down = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Tilt_Left =','Tilt_Left = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Tilt_Right =','Tilt_Right = "N/A" "N/A"');

  ReplaceLinePrefix(CFG,'Weapon_1 =','Weapon_1 = "1" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_2 =','Weapon_2 = "2" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_3 =','Weapon_3 = "3" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_4 =','Weapon_4 = "4" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_5 =','Weapon_5 = "5" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_6 =','Weapon_6 = "6" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_7 =','Weapon_7 = "7" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_8 =','Weapon_8 = "8" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_9 =','Weapon_9 = "9" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_10 =','Weapon_10 = "0" "N/A"');

  ReplaceLinePrefix(CFG,'Inventory_Use =','Inventory_Use = "Enter" "N/A"');
  ReplaceLinePrefix(CFG,'Inventory_Left =','Inventory_Left = "[" "N/A"');
  ReplaceLinePrefix(CFG,'Inventory_Right =','Inventory_Right = "]" "N/A"');

  ReplaceLinePrefix(CFG,'Map_Toggle =','Map_Toggle = "M" "N/A"');
  ReplaceLinePrefix(CFG,'Map_Follow_Mode =','Map_Follow_Mode = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Shrink_Screen =','Shrink_Screen = "-" "N/A"');
  ReplaceLinePrefix(CFG,'Enlarge_Screen =','Enlarge_Screen = "=" "N/A"');
  ReplaceLinePrefix(CFG,'Send_Message =','Send_Message = "T" "N/A"');
  ReplaceLinePrefix(CFG,'See_Coop_View =','See_Coop_View = "K" "N/A"');
  ReplaceLinePrefix(CFG,'See_Chase_View =','See_Chase_View = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Mouse_Aiming =','Mouse_Aiming = "U" "N/A"');
  ReplaceLinePrefix(CFG,'Toggle_Crosshair =','Toggle_Crosshair = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Next_Weapon =','Next_Weapon = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Previous_Weapon =','Previous_Weapon = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Holster_Weapon =','Holster_Weapon = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Show_Opponents_Weapon =','Show_Opponents_Weapon = "N/A" "N/A"');

  ReplaceLinePrefix(CFG,'BeastVision =','BeastVision = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'CrystalBall =','CrystalBall = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'JumpBoots =','JumpBoots = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'MedKit =','MedKit = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'ProximityBombs =','ProximityBombs = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'RemoteBombs =','RemoteBombs = "N/A" "N/A"');

  ReplaceLinePrefix(CFG,'MouseAim =','MouseAim = 1');

    {SENSIBILIDADE}
    if (Mouse_Global > 0) then
    begin
    ReplaceLinePrefix(CFG,'MouseAnalogScale0 =','MouseAnalogScale0 = '+IntToStr(MouseAnalogX+Mouse_Global));
    ReplaceLinePrefix(CFG,'MouseAnalogScale1 =','MouseAnalogScale1 = -'+IntToStr(MouseAnalogY+Mouse_Global));
    end;

  end
  else
  begin
  ReplaceLinePrefix(CFG,'ControllerType =','ControllerType = 0');
  ReplaceLinePrefix(CFG,'ExternalFilename =','ExternalFilename = "EXTERNAL.EXE"');

  ReplaceLinePrefix(CFG,'Move_Forward =','Move_Forward = "Up" "N/A"');
  ReplaceLinePrefix(CFG,'Move_Backward =','Move_Backward = "Down" "N/A"');
  ReplaceLinePrefix(CFG,'Turn_Left =','Turn_Left = "Left" "N/A"');
  ReplaceLinePrefix(CFG,'Turn_Right =','Turn_Right = "Right" "N/A"');
  ReplaceLinePrefix(CFG,'Turn_Around =','Turn_Around = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Strafe =','Strafe = "LAlt" "RAlt"');
  ReplaceLinePrefix(CFG,'Strafe_Left =','Strafe_Left = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Strafe_Right =','Strafe_Right = "N/A" "N/A"');

  ReplaceLinePrefix(CFG,'Jump =','Jump = "A" "N/A"');
  ReplaceLinePrefix(CFG,'Crouch =','Crouch = "Z" "N/A"');
  ReplaceLinePrefix(CFG,'Run =','Run = "LShift" "RShift"');
  ReplaceLinePrefix(CFG,'AutoRun =','AutoRun = "CapLck" "N/A"');
  ReplaceLinePrefix(CFG,'Open =','Open = "Space" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_Fire =','Weapon_Fire = "LCtrl" "RCtrl"');
  ReplaceLinePrefix(CFG,'Weapon_Special_Fire =','Weapon_Special_Fire = "X" "N/A"');

  ReplaceLinePrefix(CFG,'Aim_Up =','Aim_Up = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Aim_Down =','Aim_Down = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Aim_Center =','Aim_Center = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Look_Up =','Look_Up = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Look_Down =','Look_Down = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Tilt_Left =','Tilt_Left = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Tilt_Right =','Tilt_Right = "N/A" "N/A"');

  ReplaceLinePrefix(CFG,'Weapon_1 =','Weapon_1 = "1" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_2 =','Weapon_2 = "2" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_3 =','Weapon_3 = "3" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_4 =','Weapon_4 = "4" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_5 =','Weapon_5 = "5" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_6 =','Weapon_6 = "6" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_7 =','Weapon_7 = "7" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_8 =','Weapon_8 = "8" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_9 =','Weapon_9 = "9" "N/A"');
  ReplaceLinePrefix(CFG,'Weapon_10 =','Weapon_10 = "0" "N/A"');

  ReplaceLinePrefix(CFG,'Inventory_Use =','Inventory_Use = "Enter" "N/A"');
  ReplaceLinePrefix(CFG,'Inventory_Left =','Inventory_Left = "[" "N/A"');
  ReplaceLinePrefix(CFG,'Inventory_Right =','Inventory_Right = "]" "N/A"');

  ReplaceLinePrefix(CFG,'Map_Toggle =','Map_Toggle = "Tab" "N/A"');
  ReplaceLinePrefix(CFG,'Map_Follow_Mode =','Map_Follow_Mode = "F" "N/A"');
  ReplaceLinePrefix(CFG,'Shrink_Screen =','Shrink_Screen = "-" "N/A"');
  ReplaceLinePrefix(CFG,'Enlarge_Screen =','Enlarge_Screen = "=" "N/A"');
  ReplaceLinePrefix(CFG,'Send_Message =','Send_Message = "T" "N/A"');
  ReplaceLinePrefix(CFG,'See_Coop_View =','See_Coop_View = "K" "N/A"');
  ReplaceLinePrefix(CFG,'See_Chase_View =','See_Chase_View = "F7" "N/A"');
  ReplaceLinePrefix(CFG,'Mouse_Aiming =','Mouse_Aiming = "U" "N/A"');
  ReplaceLinePrefix(CFG,'Toggle_Crosshair =','Toggle_Crosshair = "I" "N/A"');
  ReplaceLinePrefix(CFG,'Next_Weapon =','Next_Weapon = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Previous_Weapon =','Previous_Weapon = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Holster_Weapon =','Holster_Weapon = "N/A" "N/A"');
  ReplaceLinePrefix(CFG,'Show_Opponents_Weapon =','Show_Opponents_Weapon = "W" "N/A"');

  ReplaceLinePrefix(CFG,'BeastVision =','BeastVision = "B" "N/A"');
  ReplaceLinePrefix(CFG,'CrystalBall =','CrystalBall = "C" "N/A"');
  ReplaceLinePrefix(CFG,'JumpBoots =','JumpBoots = "J" "N/A"');
  ReplaceLinePrefix(CFG,'MedKit =','MedKit = "M" "N/A"');
  ReplaceLinePrefix(CFG,'ProximityBombs =','ProximityBombs = "P" "N/A"');
  ReplaceLinePrefix(CFG,'RemoteBombs =','RemoteBombs = "R" "N/A"');

  ReplaceLinePrefix(CFG,'MouseAim =','MouseAim = 0');
  end;
  ReplaceLinePrefix(CFG,'AimReticle =','AimReticle = 1');

  if not check_single then
  begin
  ReplaceLinePrefix(CFG,'NumberPlayers =','NumberPlayers = '+NumPlayers);
  ReplaceLinePrefix(CFG,'PlayerName =','PlayerName = "'+PlayerName+'"');
  end;

  if RxControle_Mouse and check_single then
  Parametros := ' -noaim -ini PHOBOS.ini'
  else if RxControle_Mouse then
  Parametros := ' -noaim'
  else if check_single then
  Parametros := ' -ini PHOBOS.ini'
  else
  Parametros := ' -ini BLOOD.ini -broadcast';

CFG.SaveToFile(Arq);
CFG.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureDukeCFG(
  CaminhoJogo: string;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer;
  var Parametros: string
);
var
CFG: TStringList;
Arq: string;
begin
Arq := CaminhoJogo + 'duke3d.cfg';
CFG := TStringList.Create;
CFG.LoadFromFile(Arq);

{VIDEO}
ReplaceLinePrefix(CFG,'ScreenMode =','ScreenMode = 1');
ReplaceLinePrefix(CFG,'ScreenWidth =','ScreenWidth = 640');
ReplaceLinePrefix(CFG,'ScreenHeight =','ScreenHeight = 480');

{SOUND}
ReplaceLinePrefix(CFG,'FXDevice =','FXDevice = 0');
ReplaceLinePrefix(CFG,'MusicDevice =','MusicDevice = 7');
ReplaceLinePrefix(CFG,'FXVolume =','FXVolume = 220');
ReplaceLinePrefix(CFG,'MusicVolume =','MusicVolume = 200');
ReplaceLinePrefix(CFG,'NumVoices =','NumVoices = 8');
ReplaceLinePrefix(CFG,'NumChannels =','NumChannels = 2');
ReplaceLinePrefix(CFG,'NumBits =','NumBits = 16');
ReplaceLinePrefix(CFG,'MixRate =','MixRate = 44000');
ReplaceLinePrefix(CFG,'MidiPort =','MidiPort = 0x330');
ReplaceLinePrefix(CFG,'BlasterAddress =','BlasterAddress = 0x220');
ReplaceLinePrefix(CFG,'BlasterType =','BlasterType = 6');
ReplaceLinePrefix(CFG,'BlasterInterrupt =','BlasterInterrupt = 7');
ReplaceLinePrefix(CFG,'BlasterDma8 =','BlasterDma8 = 1');
ReplaceLinePrefix(CFG,'BlasterDma16 =','BlasterDma16 = 5');
ReplaceLinePrefix(CFG,'BlasterEmu =','BlasterEmu = 0x620');
ReplaceLinePrefix(CFG,'ReverseStereo =','ReverseStereo = 0');

  {MOUSE}
  if RxControle_Mouse then
  begin
  ReplaceLinePrefix(CFG,'ControllerType =','ControllerType = 3');
  ReplaceLinePrefix(CFG,'ExternalFilename =','ExternalFilename = "BMOUSE.EXE"');
  ReplaceLinePrefix(CFG,'MouseAiming =','MouseAiming = 0');
  ReplaceLinePrefix(CFG,'MouseAimingFlipped =','MouseAimingFlipped = 0');
  ReplaceLinePrefix(CFG,'MouseButton0 =','MouseButton0 = "Fire"');
  ReplaceLinePrefix(CFG,'MouseButton1 =','MouseButton1 = "Jump"');
  ReplaceLinePrefix(CFG,'MouseButton2 =','MouseButton2 = ""');

  ReplaceLinePrefix(CFG,'Move_Forward =','Move_Forward = "W" ""');
  ReplaceLinePrefix(CFG,'Move_Backward =','Move_Backward = "S" ""');
  ReplaceLinePrefix(CFG,'Turn_Left =','Turn_Left = "" ""');
  ReplaceLinePrefix(CFG,'Turn_Right =','Turn_Right = "" ""');
  ReplaceLinePrefix(CFG,'Strafe =','Strafe = "" ""');
  ReplaceLinePrefix(CFG,'Strafe_Left =','Strafe_Left = "A" ""');
  ReplaceLinePrefix(CFG,'Strafe_Right =','Strafe_Right = "D" ""');

  ReplaceLinePrefix(CFG,'Fire =','Fire = "LCtrl" "RCtrl"');
  ReplaceLinePrefix(CFG,'Open =','Open = "E" ""');
  ReplaceLinePrefix(CFG,'Run =','Run = "LShift" "RShift"');
  ReplaceLinePrefix(CFG,'AutoRun =','AutoRun = "CapLck" ""');
  ReplaceLinePrefix(CFG,'Jump =','Jump = "Space" ""');
  ReplaceLinePrefix(CFG,'Crouch =','Crouch = "C" ""');

  ReplaceLinePrefix(CFG,'Look_Up =','Look_Up = "" ""');
  ReplaceLinePrefix(CFG,'Look_Down =','Look_Down = "" ""');
  ReplaceLinePrefix(CFG,'Look_Left =','Look_Left = "" ""');
  ReplaceLinePrefix(CFG,'Look_Right =','Look_Right = "" ""');
  ReplaceLinePrefix(CFG,'Aim_Up =','Aim_Up = "" ""');
  ReplaceLinePrefix(CFG,'Aim_Down =','Aim_Down = "" ""');

  ReplaceLinePrefix(CFG,'Weapon_1 =','Weapon_1 = "1" ""');
  ReplaceLinePrefix(CFG,'Weapon_2 =','Weapon_2 = "2" ""');
  ReplaceLinePrefix(CFG,'Weapon_3 =','Weapon_3 = "3" ""');
  ReplaceLinePrefix(CFG,'Weapon_4 =','Weapon_4 = "4" ""');
  ReplaceLinePrefix(CFG,'Weapon_5 =','Weapon_5 = "5" ""');
  ReplaceLinePrefix(CFG,'Weapon_6 =','Weapon_6 = "6" ""');
  ReplaceLinePrefix(CFG,'Weapon_7 =','Weapon_7 = "7" ""');
  ReplaceLinePrefix(CFG,'Weapon_8 =','Weapon_8 = "8" ""');
  ReplaceLinePrefix(CFG,'Weapon_9 =','Weapon_9 = "9" ""');
  ReplaceLinePrefix(CFG,'Weapon_10 =','Weapon_10 = "0" ""');

  ReplaceLinePrefix(CFG,'Inventory =','Inventory = "I" ""');
  ReplaceLinePrefix(CFG,'Inventory_Left =','Inventory_Left = "[" ""');
  ReplaceLinePrefix(CFG,'Inventory_Right =','Inventory_Right = "]" ""');

  ReplaceLinePrefix(CFG,'Holo_Duke =','Holo_Duke = "" ""');
  ReplaceLinePrefix(CFG,'Jetpack =','Jetpack = "" ""');
  ReplaceLinePrefix(CFG,'NightVision =','NightVision = "" ""');
  ReplaceLinePrefix(CFG,'MedKit =','MedKit = "" ""');
  ReplaceLinePrefix(CFG,'Steroids =','Steroids = "" ""');
  ReplaceLinePrefix(CFG,'Quick_Kick =','Quick_Kick = "`" ""');

  ReplaceLinePrefix(CFG,'TurnAround =','TurnAround = "" ""');
  ReplaceLinePrefix(CFG,'SendMessage =','SendMessage = "T" ""');
  ReplaceLinePrefix(CFG,'Map =','Map = "M" ""');
  ReplaceLinePrefix(CFG,'Map_Follow_Mode =','Map_Follow_Mode = "" ""');
  ReplaceLinePrefix(CFG,'Shrink_Screen =','Shrink_Screen = "-" ""');
  ReplaceLinePrefix(CFG,'Enlarge_Screen =','Enlarge_Screen = "=" ""');
  ReplaceLinePrefix(CFG,'Center_View =','Center_View = "" ""');
  ReplaceLinePrefix(CFG,'Holster_Weapon =','Holster_Weapon = "" ""');
  ReplaceLinePrefix(CFG,'Show_Opponents_Weapon =','Show_Opponents_Weapon = "" ""');
  ReplaceLinePrefix(CFG,'See_Coop_View =','See_Coop_View = "K" ""');
  ReplaceLinePrefix(CFG,'Mouse_Aiming =','Mouse_Aiming = "U" ""');
  ReplaceLinePrefix(CFG,'Toggle_Crosshair =','Toggle_Crosshair = "" ""');
  ReplaceLinePrefix(CFG,'Next_Weapon =','Next_Weapon = "" ""');
  ReplaceLinePrefix(CFG,'Previous_Weapon =','Previous_Weapon = "" ""');

  ReplaceLinePrefix(CFG,'GameMouseAiming =','GameMouseAiming = 1');
  ReplaceLinePrefix(CFG,'AimingFlag =','AimingFlag = 1');

    {SENSIBILIDADE}
    if (Mouse_Global > 0) then
    begin
    ReplaceLinePrefix(CFG,'MouseAnalogScale0 =','MouseAnalogScale0 = '+IntToStr(MouseAnalogX+Mouse_Global));
    ReplaceLinePrefix(CFG,'MouseAnalogScale1 =','MouseAnalogScale1 = -'+IntToStr(MouseAnalogY+Mouse_Global));
    end;

  end
  else
  begin
  ReplaceLinePrefix(CFG,'ControllerType =','ControllerType = 0');
  ReplaceLinePrefix(CFG,'ExternalFilename =','ExternalFilename = "EXTERNAL.EXE"');

  ReplaceLinePrefix(CFG,'Move_Forward =','Move_Forward = "Up" ""');
  ReplaceLinePrefix(CFG,'Move_Backward =','Move_Backward = "Down" ""');
  ReplaceLinePrefix(CFG,'Turn_Left =','Turn_Left = "Left" ""');
  ReplaceLinePrefix(CFG,'Turn_Right =','Turn_Right = "Right" ""');
  ReplaceLinePrefix(CFG,'Strafe =','Strafe = "LAlt" "RAlt"');
  ReplaceLinePrefix(CFG,'Strafe_Left =','Strafe_Left = "," ""');
  ReplaceLinePrefix(CFG,'Strafe_Right =','Strafe_Right = "." ""');

  ReplaceLinePrefix(CFG,'Fire =','Fire = "LCtrl" "RCtrl"');
  ReplaceLinePrefix(CFG,'Open =','Open = "Space" ""');
  ReplaceLinePrefix(CFG,'Run =','Run = "LShift" "RShift"');
  ReplaceLinePrefix(CFG,'AutoRun =','AutoRun = "CapLck" ""');
  ReplaceLinePrefix(CFG,'Jump =','Jump = "A" ""');
  ReplaceLinePrefix(CFG,'Crouch =','Crouch = "Z" ""');

  ReplaceLinePrefix(CFG,'Look_Up =','Look_Up = "" ""');
  ReplaceLinePrefix(CFG,'Look_Down =','Look_Down = "" ""');
  ReplaceLinePrefix(CFG,'Look_Left =','Look_Left = "" ""');
  ReplaceLinePrefix(CFG,'Look_Right =','Look_Right = "" ""');
  ReplaceLinePrefix(CFG,'Aim_Up =','Aim_Up = "" ""');
  ReplaceLinePrefix(CFG,'Aim_Down =','Aim_Down = "" ""');

  ReplaceLinePrefix(CFG,'Weapon_1 =','Weapon_1 = "1" ""');
  ReplaceLinePrefix(CFG,'Weapon_2 =','Weapon_2 = "2" ""');
  ReplaceLinePrefix(CFG,'Weapon_3 =','Weapon_3 = "3" ""');
  ReplaceLinePrefix(CFG,'Weapon_4 =','Weapon_4 = "4" ""');
  ReplaceLinePrefix(CFG,'Weapon_5 =','Weapon_5 = "5" ""');
  ReplaceLinePrefix(CFG,'Weapon_6 =','Weapon_6 = "6" ""');
  ReplaceLinePrefix(CFG,'Weapon_7 =','Weapon_7 = "7" ""');
  ReplaceLinePrefix(CFG,'Weapon_8 =','Weapon_8 = "8" ""');
  ReplaceLinePrefix(CFG,'Weapon_9 =','Weapon_9 = "9" ""');
  ReplaceLinePrefix(CFG,'Weapon_10 =','Weapon_10 = "0" ""');

  ReplaceLinePrefix(CFG,'Inventory =','Inventory = "Enter" ""');
  ReplaceLinePrefix(CFG,'Inventory_Left =','Inventory_Left = "[" ""');
  ReplaceLinePrefix(CFG,'Inventory_Right =','Inventory_Right = "]" ""');

  ReplaceLinePrefix(CFG,'Holo_Duke =','Holo_Duke = "H" ""');
  ReplaceLinePrefix(CFG,'Jetpack =','Jetpack = "J" ""');
  ReplaceLinePrefix(CFG,'NightVision =','NightVision = "N" ""');
  ReplaceLinePrefix(CFG,'MedKit =','MedKit = "M" ""');
  ReplaceLinePrefix(CFG,'Steroids =','Steroids = "R" ""');
  ReplaceLinePrefix(CFG,'Quick_Kick =','Quick_Kick = "`" ""');

  ReplaceLinePrefix(CFG,'TurnAround =','TurnAround = "" ""');
  ReplaceLinePrefix(CFG,'SendMessage =','SendMessage = "T" ""');
  ReplaceLinePrefix(CFG,'Map =','Map = "Tab" ""');
  ReplaceLinePrefix(CFG,'Map_Follow_Mode =','Map_Follow_Mode = "F" ""');
  ReplaceLinePrefix(CFG,'Shrink_Screen =','Shrink_Screen = "-" ""');
  ReplaceLinePrefix(CFG,'Enlarge_Screen =','Enlarge_Screen = "=" ""');
  ReplaceLinePrefix(CFG,'Center_View =','Center_View = "" ""');
  ReplaceLinePrefix(CFG,'Holster_Weapon =','Holster_Weapon = "" ""');
  ReplaceLinePrefix(CFG,'Show_Opponents_Weapon =','Show_Opponents_Weapon = "W" ""');
  ReplaceLinePrefix(CFG,'See_Coop_View =','See_Coop_View = "K" ""');
  ReplaceLinePrefix(CFG,'Mouse_Aiming =','Mouse_Aiming = "U" ""');
  ReplaceLinePrefix(CFG,'Toggle_Crosshair =','Toggle_Crosshair = "I" ""');
  ReplaceLinePrefix(CFG,'Next_Weapon =','Next_Weapon = "" ""');
  ReplaceLinePrefix(CFG,'Previous_Weapon =','Previous_Weapon = "" ""');

  ReplaceLinePrefix(CFG,'GameMouseAiming =','GameMouseAiming = 0');
  ReplaceLinePrefix(CFG,'AimingFlag =','AimingFlag = 0');
  end;
  ReplaceLinePrefix(CFG,'Crosshairs =','Crosshairs = 1');

  {MULTIPLAYER}
  if not check_single then
  begin
  ReplaceLinePrefix(CFG,'NumberPlayers =','NumberPlayers = '+NumPlayers);
  ReplaceLinePrefix(CFG,'PlayerName =','PlayerName = "'+PlayerName+'"');
  end;

{EXTRA}
ReplaceLinePrefix(CFG,'Shadows =','Shadows = 1');
ReplaceLinePrefix(CFG,'Password =','Password = ""');
ReplaceLinePrefix(CFG,'Detail =','Detail = 1');
ReplaceLinePrefix(CFG,'Tilt =','Tilt = 1');
ReplaceLinePrefix(CFG,'ScreenSize =','ScreenSize = 4');
ReplaceLinePrefix(CFG,'ScreenGamma =','ScreenGamma = 0');

CFG.SaveToFile(Arq);
CFG.Free;

  {PARAMETROS DE MAPA}
  if check_single then
  Parametros := ' '+Map_Global
  else
  Parametros := '';

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureSWCFG(
  CaminhoJogo: string;
  var Game_EXE_Global: string;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer;
  var Parametros: string
);
var
CFG: TStringList;
Arq: string;
begin

Arq := CaminhoJogo + 'sw.cfg';

CFG := TStringList.Create;
CFG.LoadFromFile(Arq);

{VIDEO}
ReplaceLinePrefix(CFG,'ScreenMode =','ScreenMode = 1');
ReplaceLinePrefix(CFG,'ScreenWidth =','ScreenWidth = 640');
ReplaceLinePrefix(CFG,'ScreenHeight =','ScreenHeight = 480');
ReplaceLinePrefix(CFG,'ScreenGamma =','ScreenGamma = 0');

{SOUND}
ReplaceLinePrefix(CFG,'FXDevice =','FXDevice = 0');
ReplaceLinePrefix(CFG,'MusicDevice =','MusicDevice = 7');
ReplaceLinePrefix(CFG,'FXVolume =','FXVolume = 160');
ReplaceLinePrefix(CFG,'MusicVolume =','MusicVolume = 200');
ReplaceLinePrefix(CFG,'NumVoices =','NumVoices = 32');
ReplaceLinePrefix(CFG,'NumChannels =','NumChannels = 2');
ReplaceLinePrefix(CFG,'NumBits =','NumBits = 16');
ReplaceLinePrefix(CFG,'MixRate =','MixRate = 22000');
ReplaceLinePrefix(CFG,'MidiPort =','MidiPort = 0x330');
ReplaceLinePrefix(CFG,'BlasterAddress =','BlasterAddress = 0x220');
ReplaceLinePrefix(CFG,'BlasterType =','BlasterType = 6');
ReplaceLinePrefix(CFG,'BlasterInterrupt =','BlasterInterrupt = 7');
ReplaceLinePrefix(CFG,'BlasterDma8 =','BlasterDma8 = 1');
ReplaceLinePrefix(CFG,'BlasterDma16 =','BlasterDma16 = 5');
ReplaceLinePrefix(CFG,'BlasterEmu =','BlasterEmu = 0x620');
ReplaceLinePrefix(CFG,'ReverseStereo =','ReverseStereo = 0');
ReplaceLinePrefix(CFG,'FxOn =','FxOn = 1');
ReplaceLinePrefix(CFG,'MusicOn =','MusicOn = 1');

  {MOUSE}
  if RxControle_Mouse then
  begin
  ReplaceLinePrefix(CFG,'ControllerType =','ControllerType = 3');
  ReplaceLinePrefix(CFG,'ExternalFilename =','ExternalFilename = "BMOUSE.EXE"');
  ReplaceLinePrefix(CFG,'MouseAiming =','MouseAiming = 0');
  ReplaceLinePrefix(CFG,'MouseAimingFlipped =','MouseAimingFlipped = 0');
  ReplaceLinePrefix(CFG,'MouseButton0 =','MouseButton0 = "Fire"');
  ReplaceLinePrefix(CFG,'MouseButton1 =','MouseButton1 = "Jump"');
  ReplaceLinePrefix(CFG,'MouseButton2 =','MouseButton2 = ""');

  ReplaceLinePrefix(CFG,'Move_Forward =','Move_Forward = "W" ""');
  ReplaceLinePrefix(CFG,'Move_Backward =','Move_Backward = "S" ""');
  ReplaceLinePrefix(CFG,'Turn_Left =','Turn_Left = "" ""');
  ReplaceLinePrefix(CFG,'Turn_Right =','Turn_Right = "" ""');
  ReplaceLinePrefix(CFG,'Strafe =','Strafe = "" ""');
  ReplaceLinePrefix(CFG,'Strafe_Left =','Strafe_Left = "A" ""');
  ReplaceLinePrefix(CFG,'Strafe_Right =','Strafe_Right = "D" ""');

  ReplaceLinePrefix(CFG,'Fire =','Fire = "LCtrl" "RCtrl"');
  ReplaceLinePrefix(CFG,'Open =','Open = "E" ""');
  ReplaceLinePrefix(CFG,'Run =','Run = "LShift" "RShift"');
  ReplaceLinePrefix(CFG,'AutoRun =','AutoRun = "CapLck" ""');
  ReplaceLinePrefix(CFG,'Jump =','Jump = "Space" ""');
  ReplaceLinePrefix(CFG,'Crouch =','Crouch = "C" ""');

  ReplaceLinePrefix(CFG,'Look_Up =','Look_Up = "" ""');
  ReplaceLinePrefix(CFG,'Look_Down =','Look_Down = "" ""');
  ReplaceLinePrefix(CFG,'Aim_Up =','Aim_Up = "" ""');
  ReplaceLinePrefix(CFG,'Aim_Down =','Aim_Down = "" ""');

  ReplaceLinePrefix(CFG,'Weapon_1 =','Weapon_1 = "1" ""');
  ReplaceLinePrefix(CFG,'Weapon_2 =','Weapon_2 = "2" ""');
  ReplaceLinePrefix(CFG,'Weapon_3 =','Weapon_3 = "3" ""');
  ReplaceLinePrefix(CFG,'Weapon_4 =','Weapon_4 = "4" ""');
  ReplaceLinePrefix(CFG,'Weapon_5 =','Weapon_5 = "5" ""');
  ReplaceLinePrefix(CFG,'Weapon_6 =','Weapon_6 = "6" ""');
  ReplaceLinePrefix(CFG,'Weapon_7 =','Weapon_7 = "7" ""');
  ReplaceLinePrefix(CFG,'Weapon_8 =','Weapon_8 = "8" ""');
  ReplaceLinePrefix(CFG,'Weapon_9 =','Weapon_9 = "9" ""');
  ReplaceLinePrefix(CFG,'Weapon_10 =','Weapon_10 = "0" ""');

  ReplaceLinePrefix(CFG,'Inventory =','Inventory = "I" ""');
  ReplaceLinePrefix(CFG,'Inventory_Left =','Inventory_Left = "[" ""');
  ReplaceLinePrefix(CFG,'Inventory_Right =','Inventory_Right = "]" ""');

  ReplaceLinePrefix(CFG,'Med_Kit =','Med_Kit = "" ""');
  ReplaceLinePrefix(CFG,'Smoke_Bomb =','Smoke_Bomb = "" ""');
  ReplaceLinePrefix(CFG,'Night_Vision =','Night_Vision = "" ""');
  ReplaceLinePrefix(CFG,'Gas_Bomb =','Gas_Bomb = "" ""');
  ReplaceLinePrefix(CFG,'Flash_Bomb =','Flash_Bomb = "" ""');
  ReplaceLinePrefix(CFG,'Caltrops =','Caltrops = "" ""');

  ReplaceLinePrefix(CFG,'TurnAround =','TurnAround = "" ""');
  ReplaceLinePrefix(CFG,'SendMessage =','SendMessage = "T" ""');
  ReplaceLinePrefix(CFG,'Map =','Map = "M" ""');
  ReplaceLinePrefix(CFG,'Map_Follow_Mode =','Map_Follow_Mode = "" ""');
  ReplaceLinePrefix(CFG,'Shrink_Screen =','Shrink_Screen = "-" ""');
  ReplaceLinePrefix(CFG,'Enlarge_Screen =','Enlarge_Screen = "=" ""');
  ReplaceLinePrefix(CFG,'Center_View =','Center_View = "" ""');
  ReplaceLinePrefix(CFG,'Holster_Weapon =','Holster_Weapon = "" ""');
  ReplaceLinePrefix(CFG,'See_Co_Op_View =','See_Co_Op_View = "K" ""');
  ReplaceLinePrefix(CFG,'Mouse_Aiming =','Mouse_Aiming = "U" ""');
  ReplaceLinePrefix(CFG,'Toggle_Crosshair =','Toggle_Crosshair = "" ""');
  ReplaceLinePrefix(CFG,'Next_Weapon =','Next_Weapon = "" ""');
  ReplaceLinePrefix(CFG,'Previous_Weapon =','Previous_Weapon = "" ""');

  ReplaceLinePrefix(CFG,'AutoAim =','AutoAim = 0');
  ReplaceLinePrefix(CFG,'MouseAimingOn =','MouseAimingOn = 1');

    if (Mouse_Global > 0) then
    begin
    ReplaceLinePrefix(CFG,'MouseAnalogScale0 =','MouseAnalogScale0 = '+IntToStr(SW_MouseAnalogX+Mouse_Global));
    ReplaceLinePrefix(CFG,'MouseAnalogScale1 =','MouseAnalogScale1 = -'+IntToStr(SW_MouseAnalogY+Mouse_Global));
    end;

  end
  else
  begin
  ReplaceLinePrefix(CFG,'ControllerType =','ControllerType = 0');
  ReplaceLinePrefix(CFG,'ExternalFilename =','ExternalFilename = "EXTERNAL.EXE"');

  ReplaceLinePrefix(CFG,'Move_Forward =','Move_Forward = "Up" ""');
  ReplaceLinePrefix(CFG,'Move_Backward =','Move_Backward = "Down" ""');
  ReplaceLinePrefix(CFG,'Turn_Left =','Turn_Left = "Left" ""');
  ReplaceLinePrefix(CFG,'Turn_Right =','Turn_Right = "Right" ""');
  ReplaceLinePrefix(CFG,'Strafe =','Strafe = "LAlt" "RAlt"');
  ReplaceLinePrefix(CFG,'Strafe_Left =','Strafe_Left = "," ""');
  ReplaceLinePrefix(CFG,'Strafe_Right =','Strafe_Right = "." ""');

  ReplaceLinePrefix(CFG,'Fire =','Fire = "LCtrl" "RCtrl"');
  ReplaceLinePrefix(CFG,'Open =','Open = "Space" ""');
  ReplaceLinePrefix(CFG,'Run =','Run = "LShift" "RShift"');
  ReplaceLinePrefix(CFG,'AutoRun =','AutoRun = "CapLck" ""');
  ReplaceLinePrefix(CFG,'Jump =','Jump = "A" ""');
  ReplaceLinePrefix(CFG,'Crouch =','Crouch = "Z" ""');

  ReplaceLinePrefix(CFG,'Look_Up =','Look_Up = "" ""');
  ReplaceLinePrefix(CFG,'Look_Down =','Look_Down = "" ""');
  ReplaceLinePrefix(CFG,'Aim_Up =','Aim_Up = "" ""');
  ReplaceLinePrefix(CFG,'Aim_Down =','Aim_Down = "" ""');

  ReplaceLinePrefix(CFG,'Weapon_1 =','Weapon_1 = "1" ""');
  ReplaceLinePrefix(CFG,'Weapon_2 =','Weapon_2 = "2" ""');
  ReplaceLinePrefix(CFG,'Weapon_3 =','Weapon_3 = "3" ""');
  ReplaceLinePrefix(CFG,'Weapon_4 =','Weapon_4 = "4" ""');
  ReplaceLinePrefix(CFG,'Weapon_5 =','Weapon_5 = "5" ""');
  ReplaceLinePrefix(CFG,'Weapon_6 =','Weapon_6 = "6" ""');
  ReplaceLinePrefix(CFG,'Weapon_7 =','Weapon_7 = "7" ""');
  ReplaceLinePrefix(CFG,'Weapon_8 =','Weapon_8 = "8" ""');
  ReplaceLinePrefix(CFG,'Weapon_9 =','Weapon_9 = "9" ""');
  ReplaceLinePrefix(CFG,'Weapon_10 =','Weapon_10 = "0" ""');

  ReplaceLinePrefix(CFG,'Inventory =','Inventory = "Enter" ""');
  ReplaceLinePrefix(CFG,'Inventory_Left =','Inventory_Left = "[" ""');
  ReplaceLinePrefix(CFG,'Inventory_Right =','Inventory_Right = "]" ""');

  ReplaceLinePrefix(CFG,'Med_Kit =','Med_Kit = "M" ""');
  ReplaceLinePrefix(CFG,'Smoke_Bomb =','Smoke_Bomb = "S" ""');
  ReplaceLinePrefix(CFG,'Night_Vision =','Night_Vision = "N" ""');
  ReplaceLinePrefix(CFG,'Gas_Bomb =','Gas_Bomb = "G" ""');
  ReplaceLinePrefix(CFG,'Flash_Bomb =','Flash_Bomb = "F" ""');
  ReplaceLinePrefix(CFG,'Caltrops =','Caltrops = "C" ""');

  ReplaceLinePrefix(CFG,'TurnAround =','TurnAround = "" ""');
  ReplaceLinePrefix(CFG,'SendMessage =','SendMessage = "T" ""');
  ReplaceLinePrefix(CFG,'Map =','Map = "Tab" ""');
  ReplaceLinePrefix(CFG,'Map_Follow_Mode =','Map_Follow_Mode = "F" ""');
  ReplaceLinePrefix(CFG,'Shrink_Screen =','Shrink_Screen = "-" ""');
  ReplaceLinePrefix(CFG,'Enlarge_Screen =','Enlarge_Screen = "=" ""');
  ReplaceLinePrefix(CFG,'Center_View =','Center_View = "" ""');
  ReplaceLinePrefix(CFG,'Holster_Weapon =','Holster_Weapon = "" ""');
  ReplaceLinePrefix(CFG,'See_Co_Op_View =','See_Co_Op_View = "K" ""');
  ReplaceLinePrefix(CFG,'Mouse_Aiming =','Mouse_Aiming = "U" ""');
  ReplaceLinePrefix(CFG,'Toggle_Crosshair =','Toggle_Crosshair = "I" ""');
  ReplaceLinePrefix(CFG,'Next_Weapon =','Next_Weapon = "" ""');
  ReplaceLinePrefix(CFG,'Previous_Weapon =','Previous_Weapon = "" ""');

  ReplaceLinePrefix(CFG,'AutoAim =','AutoAim = 1');
  ReplaceLinePrefix(CFG,'MouseAimingOn =','MouseAimingOn = 0');
  end;
   ReplaceLinePrefix(CFG,'MouseInvert = 0','MouseInvert = 1');

  {MULTIPLAYER}
  if not check_single then
  begin
  ReplaceLinePrefix(CFG,'NumberPlayers =','NumberPlayers = '+NumPlayers);
  ReplaceLinePrefix(CFG,'PlayerName','PlayerName = "'+PlayerName+'"');
  end;

CFG.SaveToFile(Arq);
CFG.Free;

  {PARAMETROS + DLC}
  Parametros := '';

  case EPI_Global_DLC of
    0,1: begin
         // jogo base
         end;
      2: begin
         //Wanton Destruction
         Parametros := '';
         end;
      3: begin
         //Twin Dragon
         Game_EXE_Global := SW_DLC_Archive(2);
         end;
  end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureCommitBlood(CaminhoJogo, NumPlayers, ExeNome: string);
var
L: TStringList;
begin
L := TStringList.Create;
L.LoadFromFile(CaminhoJogo+'commit.dat');

  if L[24] = '; - GAMECONNECTION - 4' then
  L.Delete(24);

L[26] := 'NUMPLAYERS = '+NumPlayers;
L[33] := 'LAUNCHNAME = "'+ExeNome+'"';

L.SaveToFile(CaminhoJogo+'commit.dat');
L.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureCommitDuke(CaminhoJogo, NumPlayers: string);
var
L: TStringList;
begin
L := TStringList.Create;
L.LoadFromFile(CaminhoJogo+'commit.dat');

  if L[24] = '; - GAMECONNECTION - 4' then
  L.Delete(24);

L[26] := 'NUMPLAYERS = '+NumPlayers;

L.SaveToFile(CaminhoJogo+'commit.dat');
L.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureCommitShadowWarrior(CaminhoJogo: string;NumPlayers: string;Game_EXE_Global: string);
var
L: TStringList;
begin
L := TStringList.Create;
L.LoadFromFile(CaminhoJogo+'commit.dat');

L[26] := 'NUMPLAYERS = '+NumPlayers;

  if EPI_Global_DLC = 3 then
  L[33] := 'LAUNCHNAME = "'+SW_DLC_Archive(2)+'"'
  else
  L[33] := 'LAUNCHNAME = "'+Game_EXE_Global+'"';

L.SaveToFile(CaminhoJogo+'commit.dat');
L.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure ConfigureDOSBoxCONF(
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  Parametros: string;
  var Arq_DosBox: string
);
var
L: TStringList;
i: Integer;
begin
Arq_DosBox := CaminhoJogo + LowerCase(ChangeFileExt(Game_EXE_Global,'')) + '_dosbox.conf';

CopyFile(PChar(ExtractFilePath(DosBox_EXE_Global)+'dosbox-0.74.conf'),PChar(Arq_DosBox),False);

L := TStringList.Create;
L.LoadFromFile(Arq_DosBox);

ReplaceLinePrefix(L,'fullscreen=','fullscreen='+BoolToStr(not menu_debug,True));
ReplaceLinePrefix(L,'fullresolution=','fullresolution=0x0');

  {NÃO TEM PLACA DE VÍDEO - INTEL}
  if ProcessExists('igfxTray.exe') = True then
  ReplaceLinePrefix(L,'output=','output=opengl')
  else
  ReplaceLinePrefix(L,'output=','output=overlay');

ReplaceLinePrefix(L,'machine=','machine=vesa_nolfb');
ReplaceLinePrefix(L,'memsize=','memsize=64');
ReplaceLinePrefix(L,'aspect=','aspect=true');
ReplaceLinePrefix(L,'scaler=','scaler=normal2x');
ReplaceLinePrefix(L,'core=','core=dynamic');
ReplaceLinePrefix(L,'cycles=','cycles=max 105%');
ReplaceLinePrefix(L,'prebuffer=','prebuffer=20');

  //--------------------------------
  {IPX}
  //--------------------------------
  for i := 0 to L.Count-1 do
  begin
    if Pos('ipx=', L[i]) = 1 then
    begin
      if check_single then
      L[i] := 'ipx=false'
      else
      L[i] := 'Enable=1'    +#13#10+
              'Connection=1'+#13#10+
              'ipx=true';
    end;
  end;
  //--------------------------------

  for i := 0 to L.Count-1 do
    if Pos('[autoexec]',L[i]) = 1 then
    begin
      if not menu_debug then
      L.Add('@ECHO OFF');

      if DirectoryExists(ExtractFilePath(CaminhoJogo)) then
      L.Add('mount c "'+IncludeTrailingPathDelimiter(CaminhoJogo)+'"')
      else
      MessageBox(Application.Handle,PChar(Lang_DGL(8)+':'+#13#13+ExtractFilePath(Arq_DosBox)),PChar(Application.Title),MB_ICONERROR+MB_OK);

    L.Add('c:');

      if not menu_debug then
      L.Add('cls');

      if check_servidor then
      L.Add('ipxnet startserver '+ip_porta);

      if check_cliente then
      L.Add('ipxnet connect '+ip_local+' '+ip_porta);

      {CD - BLOOD E SHADOW WARRIOR}
      case id of
         1: begin
              if FileExists(CaminhoJogo+'game.ins') then
              L.Add('imgmount D game.ins -t iso');
            end;
        10: begin
              if FileExists(CaminhoJogo+'GAME.DAT') then
              L.Add('imgmount d "..\GAME.DAT" -t iso');
           end;
      end;

      {SINGLE PLAYER + DEBUG}
      if check_single and menu_debug then
      MessageBox(Application.Handle,pchar(Parametros),pchar(Lang_DGL(23)),MB_ICONINFORMATION+MB_OK);

      {MULTIPLAYER + DEBUG}
      if (not check_single) and menu_debug then
      begin
        {BLOOD - CRYPTIC PASSAGE - SETUP}
        if FileExists(CaminhoJogo+'cryptic.exe') then
        Game_EXE_Global:='cpmulti.exe'
        else
        {DUKE NUKEM 3D - SHADOW WARRIOR}
        Game_EXE_Global:='setup.exe';
      end;

      {SHADOW WARRIOR - DLC}
      if id = 10 then
      begin
        case EPI_Global_DLC of
          0,1: L.Add('@COPY sw.dat sw.exe');
            2: L.Add('@COPY '+SW_DLC_Archive(1)+' sw.exe');
            3: begin
                 if SW_DLC_Archive(2) = 'sw.exe' then
                 L.Add('cd dragon');
               end;
        end;
      end;

    L.Add('nolfblim.com');

      if RxControle_Mouse then
      L.Add('BMOUSE.EXE LAUNCH '+Game_EXE_Global+Parametros)
      else
      L.Add(Game_EXE_Global+Parametros);

      if not menu_debug then
      L.Add('Exit.');

    Break;
    end;
L.SaveToFile(Arq_DosBox);
L.Free;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure RunDOSBox(HandleApp: HWND; DosBox_EXE_Global, Arq_DosBox: string);
begin
ShellExecute(HandleApp,'open',PChar(DosBox_EXE_Global),PChar('-conf '+ExtractFileName(Arq_DosBox)),PChar(ExtractFilePath(Arq_DosBox)),SW_NORMAL);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure DOSBOX_Bind_FPS_Blood(
  HandleApp: HWND;
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer
);
var
Parametros: string;
Arq_DosBox: string;
begin

  {SELECIONA MAPA}
  if check_single then
  begin
  Seleciona_Fases;

    if Fecha_ESC then
    Exit;
  end;

{CFG}
ConfigureBloodCFG(CaminhoJogo,RxControle_Mouse,check_single,NumPlayers,PlayerName,Mouse_Global,Parametros);

  {COMMIT}
  if not check_single then
  ConfigureCommitBlood(CaminhoJogo, NumPlayers, Game_EXE_Global);

{DOSBOX CONF}
ConfigureDOSBoxCONF(DosBox_EXE_Global,CaminhoJogo,Game_EXE_Global,menu_debug,RxControle_Mouse,check_single,check_servidor,check_cliente,ip_porta,ip_local,Parametros,Arq_DosBox);

{RUN}
RunDOSBox(HandleApp, DosBox_EXE_Global, Arq_DosBox);

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure DOSBOX_Bind_FPS_Duke(
  HandleApp: HWND;
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer
);
var
Parametros: string;
Arq_DosBox: string;
begin

  {SELECIONA MAPA}
  if check_single then
  begin
  Seleciona_Fases;

    if Fecha_ESC then
    Exit;
  end;

{CFG}
ConfigureDukeCFG(CaminhoJogo,RxControle_Mouse,check_single,NumPlayers,PlayerName,Mouse_Global,Parametros);

  {COMMIT}
  if not check_single then
  ConfigureCommitDuke(CaminhoJogo, NumPlayers);

{DOSBOX CONF}
ConfigureDOSBoxCONF(DosBox_EXE_Global,CaminhoJogo,Game_EXE_Global,menu_debug,RxControle_Mouse,check_single,check_servidor,check_cliente,ip_porta,ip_local,Parametros,Arq_DosBox);

{RUN}
RunDOSBox(HandleApp, DosBox_EXE_Global, Arq_DosBox);

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
procedure DOSBOX_Bind_FPS_Shadow(
  HandleApp: HWND;
  DosBox_EXE_Global: string;
  CaminhoJogo: string;
  Game_EXE_Global: string;
  menu_debug: Boolean;
  RxControle_Mouse: Boolean;
  check_single: Boolean;
  check_servidor: Boolean;
  check_cliente: Boolean;
  ip_porta: string;
  ip_local: string;
  NumPlayers: string;
  PlayerName: string;
  Mouse_Global: Integer
);
var
Parametros: string;
Arq_DosBox: string;
begin

  {SELEÇÃO DLC / FASE}
  if check_single then
  begin
    Application.CreateForm(TForm2_DLC, Form2_DLC);
    Form2_DLC.ShowModal;
    Form2_DLC.Free;

    if Fecha_ESC then
    Exit;
  end;

{CFG + DLC + PARAMETROS}
ConfigureSWCFG(CaminhoJogo,Game_EXE_Global,RxControle_Mouse,check_single,NumPlayers,PlayerName,Mouse_Global,Parametros);

  {COMMIT}
  if not check_single then
  ConfigureCommitShadowWarrior(CaminhoJogo, NumPlayers, Game_EXE_Global);

{DOSBOX CONF}
ConfigureDOSBoxCONF(DosBox_EXE_Global,CaminhoJogo,Game_EXE_Global,menu_debug,RxControle_Mouse,check_single,check_servidor,check_cliente,ip_porta,ip_local,Parametros,Arq_DosBox);

{RUN}
RunDOSBox(HandleApp, DosBox_EXE_Global, Arq_DosBox);

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.

