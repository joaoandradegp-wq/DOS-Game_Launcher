unit Language;

interface

uses SysUtils;

function  UsePortuguese:Boolean;
function  Lang_DGL(id:Integer):String;
procedure Lang_Load;
procedure Lang_Save;
procedure Lang_Apply(NewLang:Integer);

implementation

uses Funcoes, Unit1, MAP_Select, QUAKE_NameFun, About, IniFiles, Forms;

//------------------------------------------------------------------------------
// Language_Global (declarada no Unit1):
//   0 = Automatico (idioma do Windows) | 1 = Portugues | 2 = English
//------------------------------------------------------------------------------
function UsePortuguese:Boolean;
begin
  case Language_Global of
    1: Result:=True;
    2: Result:=False;
  else
    Result:=(GetLanguageWin = 'por');
  end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function Lang_DGL(id:Integer):String;
begin

if UsePortuguese then
begin

  case id of
  0: begin
     //-----------------------------------------------------
     Form1_DGL.Menu_Arquivo.Caption:='Arquivo';
     Form1_DGL.Menu_Sair.Caption:='Sair';
     Form1_DGL.Menu_Opcoes.Caption:='Configurações';
     Form1_DGL.Menu_Debug.Caption:='Modo de Depuração';
     Form1_DGL.Menu_Firewall.Caption:='Regras de Firewall';
     Form1_DGL.Menu_Ajuda.Caption:='Ajuda';
     Form1_DGL.Menu_Site.Caption:='Site Oficial';
     Form1_DGL.Menu_Sobre.Caption:='Sobre...';
     Form1_DGL.popup_pasta.Caption:='&Diretório';
     Form1_DGL.config_menu.Caption:='&Configuração';
     Form1_DGL.popup_qsp.Caption:='Site Oficial QuakeSp&asm';
     //-----------------------------------------------------
     Form1_DGL.Menu_Idioma.Caption:='Idioma';
     Form1_DGL.Idioma_Auto.Caption:='Automático';
     Form1_DGL.Idioma_Por.Caption:='Português';
     Form1_DGL.Idioma_Eng.Caption:='English';
     Form1_DGL.Idioma_Auto.Checked:=(Language_Global = 0);
     Form1_DGL.Idioma_Por.Checked :=(Language_Global = 1);
     Form1_DGL.Idioma_Eng.Checked :=(Language_Global = 2);
     //-----------------------------------------------------
     Form1_DGL.Label_Name.Caption:='NOME:';
     Form1_DGL.img_ing.Visible:=False;
     Form1_DGL.img_por.Visible:=True;
     //-----------------------------------------------------
     Form1_DGL.GroupIP.Caption:=' Rede Local ';
     Form1_DGL.Label3.Caption:='PORTA:';
     //-----------------------------------------------------
     Form1_DGL.Label_Sense.Caption:='SENSIBILIDADE';
     Form1_DGL.Label_DM.Caption:='COOPERATIVO';
     Form1_DGL.Label_Opcoes.Caption:='OPÇÕES';
     Form1_DGL.Label_QuakeServer.Caption:='SERVIDOR DEDICADO';
     Form1_DGL.check_single.Caption:='JOGAR';
     Form1_DGL.check_servidor.Caption:='CRIAR SERVIDOR';
     Form1_DGL.check_cliente.Caption:='CONECTAR EM UMA PARTIDA';
     //-----------------------------------------------------
     Form1_DGL.btn_start.Caption:='INICIAR';
     //-----------------------------------------------------
     end;
  1: Result:='Defina seu nome antes de iniciar!';
  2: Result:='GUERREIRO';
  3: Result:='CLÉRIGO';
  4: Result:='MAGO';
  5: Result:='INICIANDO...';
  6: Result:='Essa Expansão não possui o arquivo SETUP.EXE';
  7: Result:='Escolha sua Classe';
  8: Result:='Erro para encontrar o diretório em';
  9: Result:='Aguardando jogadores...';
 10: begin
     Form4_Select.label_episodio.Caption:='EPISÓDIO:';
     Form4_Select.label_capitulo.Caption:='CAPÍTULO:';
     end;
 11: Result:='Servidor';
 12: Result:='Porta';
 13: Result:='Depuração';
 14: Result:='INICIAR';
 15: Result:='SERVIDOR';
 16: Result:='Execute como Administrador para incluir as plataformas DosBox e ZDoom no Firewall do Windows.';
 17: Result:='Os serviços DGL foram incluídos no Firewall do Windows!';
 18: Result:='TECLADO';
 19: begin
     Form3_NameFun.Caption:='Opções';
     Form3_NameFun.Mensagem_SemNome.Caption:=' Nomes Personalizados';
     Form3_NameFun.Mensagem_SemSkin.Caption:=' Disponível apenas em Deathmatch';
     Form3_NameFun.Label1.Caption:='PRÉ-VISUALIZAÇÃO:';
     Form3_NameFun.btn_aplicar.Caption:='APLICAR';
     end;
 20: Result:='Sobre o';
 21: Result:='COOPERATIVO';
 22: Result:='Gostaria de simular uma sessão Multiplayer?';
 23: Result:='MODO DE DEPURAÇÃO';
 24: Result:='DOS Game Launcher é um projeto pessoal criado para jogar com alguns amigos, igual fazíamos na década de 90.'+#13+#10+#13+#10+
             'Espero que goste e se divirta!'+#13+#10+#13+#10+
             'Phobos.'+#13+#10+
             'JMBA Softwares, Brasil';
 25: Result:='Confirmação';
 26: Result:='Aviso';
 27: Result:='Erro';
 28: Result:='Informação';
 29: Result:='&Sim';
 30: Result:='&Não';
 31: Result:='&Cancelar';
 32: Result:='Esse é o arquivo do próprio jogo, selecione apenas MODS.';
 33: Result:='AGILIDADE';
 34: Result:='ARMADURA';
 35: Result:='MAGIA';
 36: Result:='FORÇA';
 37: Result:='© 2026 JMBA Softwares. Todos os direitos reservados.';
 end;

end
else
begin

  case id of
  0: begin
     //-----------------------------------------------------
     Form1_DGL.Menu_Arquivo.Caption:='File';
     Form1_DGL.Menu_Sair.Caption:='Exit';
     Form1_DGL.Menu_Opcoes.Caption:='Settings';
     Form1_DGL.Menu_Debug.Caption:='Debug Mode';
     Form1_DGL.Menu_Firewall.Caption:='Firewall Rules';
     Form1_DGL.Menu_Ajuda.Caption:='Help';
     Form1_DGL.Menu_Site.Caption:='Official Site';
     Form1_DGL.Menu_Sobre.Caption:='About...';
     Form1_DGL.popup_pasta.Caption:='&Folder';
     Form1_DGL.config_menu.Caption:='&Configuration File';
     Form1_DGL.popup_qsp.Caption:='QuakeSp&asm Official Site';
     //-----------------------------------------------------
     Form1_DGL.Menu_Idioma.Caption:='Language';
     Form1_DGL.Idioma_Auto.Caption:='Automatic';
     Form1_DGL.Idioma_Por.Caption:='Português';
     Form1_DGL.Idioma_Eng.Caption:='English';
     Form1_DGL.Idioma_Auto.Checked:=(Language_Global = 0);
     Form1_DGL.Idioma_Por.Checked :=(Language_Global = 1);
     Form1_DGL.Idioma_Eng.Checked :=(Language_Global = 2);
     //-----------------------------------------------------
     Form1_DGL.Label_Name.Caption:='NAME:';
     Form1_DGL.img_por.Visible:=False;
     Form1_DGL.img_ing.Visible:=True;
     //-----------------------------------------------------
     Form1_DGL.GroupIP.Caption:=' Local Network ';
     Form1_DGL.Label3.Caption:='PORT:';
     //-----------------------------------------------------
     Form1_DGL.Label_Sense.Caption:='MOUSE SENSITIVITY';
     Form1_DGL.Label_DM.Caption:='COOPERATIVE';
     Form1_DGL.Label_Opcoes.Caption:='OPTIONS';
     Form1_DGL.Label_QuakeServer.Caption:='DEDICATED SERVER';
     Form1_DGL.check_single.Caption:='SINGLE PLAYER';
     Form1_DGL.check_servidor.Caption:='CREATE A SERVER';
     Form1_DGL.check_cliente.Caption:='CONNECT TO A GAME SERVER';
     //-----------------------------------------------------
     Form1_DGL.btn_start.Caption:='START';
     //-----------------------------------------------------
     end;
  1: Result:='Define your player name before you start!';
  2: Result:='FIGHTER';
  3: Result:='CLERIC';
  4: Result:='MAGE';
  5: Result:='STARTING...';
  6: Result:='This Expansion has no SETUP.EXE file.';
  7: Result:='Choose your Class';
  8: Result:='Could not find the directory';
  9: Result:='Waiting for players...';
 10: begin
     Form4_Select.label_episodio.Caption:='EPISODE:';
     Form4_Select.label_capitulo.Caption:='LEVEL:';
     end;
 11: Result:='Server';
 12: Result:='Port';
 13: Result:='Debug';
 14: Result:='START';
 15: Result:='SERVER ADDRESS';
 16: Result:='Run as Administrator to include DGL Services in Windows Firewall.';
 17: Result:='The DGL Services was included at Windows Firewall!';
 18: Result:='KEYBOARD';
 19: begin
     Form3_NameFun.Caption:='Options';
     Form3_NameFun.Mensagem_SemNome.Caption:=' NameFun List';
     Form3_NameFun.Mensagem_SemSkin.Caption:=' Available only in DeathMatch';
     Form3_NameFun.Label1.Caption:='PREVIEW:';
     Form3_NameFun.btn_aplicar.Caption:='APPLY';
     end;
 20: Result:='About';
 21: Result:='COOPERATIVE';
 22: Result:='Would you like to simulate a Multiplayer session?';
 23: Result:='DEBUG MODE';
 24: Result:='DOS Game Launcher is a personal project I made to play with some friends like in the 90s.'+#13+#10+#13+#10+
             'I hope you enjoy it!'+#13+#10+#13+#10+
             'Phobos.'+#13+#10+
             'JMBA Softwares, Brazil.';
 25: Result:='Confirmation';
 26: Result:='Warning';
 27: Result:='Error';
 28: Result:='Information';
 29: Result:='&Yes';
 30: Result:='&No';
 31: Result:='&Cancel';
 32: Result:='This is a game file. Please select MOD files only.';
 33: Result:='SPEED';
 34: Result:='ARMOR';
 35: Result:='MAGIC';
 36: Result:='STRENGTH';
 37: Result:='© 2026 JMBA Softwares. All rights reserved.';
 end;

end;

end;
//------------------------------------------------------------------------------
// Persistencia da escolha do usuario (dos.ini, secao [DOS], chave LANGUAGE)
//------------------------------------------------------------------------------
procedure Lang_Load;
var
Arquivo_INI:TIniFile;
begin
Arquivo_INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'dos.ini');
  try
  Language_Global:=Arquivo_INI.ReadInteger('DOS','LANGUAGE',0);
  finally
  Arquivo_INI.Free;
  end;

  if (Language_Global < 0) or (Language_Global > 2) then
  Language_Global:=0;
end;
//------------------------------------------------------------------------------
procedure Lang_Save;
var
Arquivo_INI:TIniFile;
begin
Arquivo_INI:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'dos.ini');
  try
  Arquivo_INI.WriteInteger('DOS','LANGUAGE',Language_Global);
  finally
  Arquivo_INI.Free;
  end;
end;
//------------------------------------------------------------------------------
// Troca o idioma em tempo de execucao (menu Configuracoes > Idioma).
// Os captions que mudam durante o uso (botao INICIAR, TECLADO, COOPERATIVO,
// LAN/SERVIDOR e a barra de status) sao guardados antes e traduzidos depois,
// para nao voltarem ao estado inicial.
// Os outros forms sao abertos em modo modal e pegam o idioma ao abrir.
//------------------------------------------------------------------------------
procedure Lang_Apply(NewLang:Integer);
var
sStart,sDM,sCtl,sLan,sStatus:String;
oStart,oWait,oCtl,oLan,oPort:String;
begin

  if Form1_DGL = nil then
  begin
  Language_Global:=NewLang;
  Lang_Save;
  Exit;
  end;

//-----------------------------------------------------
{TEXTOS DO IDIOMA ANTERIOR}
oStart:=Lang_DGL(14);
oWait :=Lang_DGL(5);
oCtl  :=Lang_DGL(18);
oLan  :=Lang_DGL(15)+':';
oPort :=Lang_DGL(12);
//-----------------------------------------------------
{GUARDA OS CAPTIONS QUE MUDAM DURANTE O USO}
sStart :=Form1_DGL.btn_start.Caption;
sDM    :=Form1_DGL.Label_DM.Caption;
sCtl   :=Form1_DGL.Label_Controle.Caption;
sLan   :=Form1_DGL.Label2.Caption;
sStatus:=Form1_DGL.StatusBar1.Panels[1].Text;
//-----------------------------------------------------
{TROCA O IDIOMA, GRAVA A ESCOLHA E REAPLICA NO FORM PRINCIPAL}
Language_Global:=NewLang;
Lang_Save;
Lang_DGL(0);
//-----------------------------------------------------
{BOTAO INICIAR}
  if sStart = oWait then
  Form1_DGL.btn_start.Caption:=Lang_DGL(5)
  else
  if Pos(oStart,sStart) = 1 then
  Form1_DGL.btn_start.Caption:=Lang_DGL(14)+Copy(sStart,Length(oStart)+1,MaxInt)
  else
  Form1_DGL.btn_start.Caption:=sStart;
//-----------------------------------------------------
{DEATHMATCH - O Lang_DGL(0) VOLTA PARA "COOPERATIVO"}
  if sDM = 'DEATHMATCH' then
  Form1_DGL.Label_DM.Caption:=sDM;
//-----------------------------------------------------
{TECLADO / MOUSE}
  if (sCtl = oCtl) or (sCtl = 'TECLADO') then
  Form1_DGL.Label_Controle.Caption:=Lang_DGL(18);
//-----------------------------------------------------
{LAN / SERVIDOR}
  if sLan = oLan then
  Form1_DGL.Label2.Caption:=Lang_DGL(15)+':';
//-----------------------------------------------------
{BARRA DE STATUS: "Online - Porta 27500"}
  if (Pos(oPort,sStatus) > 0) then
  Form1_DGL.StatusBar1.Panels[1].Text:=StringReplace(sStatus,oPort,Lang_DGL(12),[]);
//-----------------------------------------------------

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.
