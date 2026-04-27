[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{411D497D-D3E4-425E-BF92-38F938E951F0}
AppName=DOS Game Launcher
AppVersion=2.0
AppPublisher=JMBA Softwares   
DefaultDirName={autopf}\DOS Game Launcher
DefaultGroupName=DOS Game Launcher 
DisableDirPage=yes
DisableProgramGroupPage=yes 
OutputDir=Output
OutputBaseFilename=DGL_Setup_2.0  
SetupIconFile=bin\launcher_icon.ico
Compression=lzma2
SolidCompression=yes       
WizardStyle=modern

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; Flags: unchecked

[Files]
Source: "*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Excludes: "dos.ini,*.lnk,*.iss,*.bat,DOS\CONSTRUCTOR\SAVEGAME\*,*.zds,*.scr"
Excludes: "DOS\BLOOD\,DOS\CONSTRUCTOR\,DOS\DOOM\,DOS\DOOM2\,DOS\DUKE3D\,DOS\HERETIC\,DOS\HEXEN\,DOS\QUAKE\,DOS\ROTT\,DOS\SW\,DOS\WAR2\,DOS\WOLF3D\"

[Icons]
Name: "{group}\DOS Game Launcher"; Filename: "{app}\launcher.exe"; IconFilename: "{app}\bin\launcher_icon.ico"
Name: "{commondesktop}\DOS Game Launcher"; Filename: "{app}\launcher.exe"; Tasks: desktopicon; IconFilename: "{app}\bin\launcher_icon.ico"
Name: "{group}\Desinstalar"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\launcher.exe"; Description: "{cm:LaunchProgram,DOS Game Launcher}"; Flags: nowait postinstall skipifsilent