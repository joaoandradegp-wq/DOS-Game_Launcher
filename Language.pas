unit Language;

interface

uses SysUtils;

function Lang_DGL(id:Integer):String;

implementation

uses Funcoes, Unit1, Unit4, Unit3, About;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
function Lang_DGL(id:Integer):String;
begin

if (GetLanguageWin = 'por') and (Language_Global = 0) then
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
     //-----------------------------------------------------
     Form1_DGL.Label_Name.Caption:='NOME:';
     Form1_DGL.img_por.Visible:=True;
     //-----------------------------------------------------
     Form1_DGL.GroupIP.Caption:='Rede Local';
     Form1_DGL.Label3.Caption:='PORTA:';
     //-----------------------------------------------------
     Form1_DGL.Label_Sense.Caption:='SENSIBILIDADE';
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
  2: Result:='Guerreiro';
  3: Result:='Clérigo';
  4: Result:='Mago';
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
 //13: Result:='Uma nova atualização está disponível!'+#13#13+'Atualizar agora?';
 14: Result:='INICIAR';
 15: Result:='SERVIDOR';
 16: Result:='Execute como Administrador para incluir as plataformas DosBox e ZDoom no Firewall do Windows.';
 17: Result:='Os serviços DGL foram incluídos no Firewall do Windows!';
 18: Result:='TECLADO';
 19: begin
     Form3_QuakeWorld.Caption:='Opções';
     Form3_QuakeWorld.Mensagem_SemNome.Caption:=' Nomes Personalizados';
     Form3_QuakeWorld.Mensagem_SemSkin.Caption:=' Disponível apenas em Deathmatch';
     Form3_QuakeWorld.Label1.Caption:='PRÉ-VISUALIZAÇÃO:';
     Form3_QuakeWorld.btn_aplicar.Caption:='APLICAR';
     end;
 20: Result:='Sobre o';
 //21: Result:='O DOS GAME LAUNCHER já está em execução!';
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
     Form1_DGL.Menu_Site.Caption:='Oficial Site';
     Form1_DGL.Menu_Sobre.Caption:='About...';
     Form1_DGL.popup_pasta.Caption:='&Folder';
     Form1_DGL.config_menu.Caption:='&Configuration File';
     //-----------------------------------------------------
     Form1_DGL.Label_Name.Caption:='NAME:';
     Form1_DGL.img_ing.Visible:=True;
     //-----------------------------------------------------
     Form1_DGL.GroupIP.Caption:='Local Network';
     Form1_DGL.Label3.Caption:='PORT:';
     //-----------------------------------------------------
     Form1_DGL.Label_Sense.Caption:='MOUSE SENSITIVITY';
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
  2: Result:='Fighter';
  3: Result:='Cleric';
  4: Result:='Mage';
  5: Result:='STARTING...';
  6: Result:='This Expansion has no SETUP.EXE file.';
  7: Result:='Choose your Class';
  8: Result:='Error to find directory in';
  9: Result:='Waiting for players...';
 10: begin
     Form4_Select.label_episodio.Caption:='EPISODE:';
     Form4_Select.label_capitulo.Caption:='LEVEL:';
     end;
 11: Result:='Server';
 12: Result:='Port';
 //13: Result:='A new update is now available!'+#13#13+'Update now?';
 14: Result:='START';
 15: Result:='SERVER ADDRESS';
 16: Result:='Execute as Administrador to include DGL Services at Windows Firewall.';
 17: Result:='The DGL Services was included at Windows Firewall!';
 18: Result:='KEYBOARD';
 19: begin
     Form3_QuakeWorld.Caption:='Options';
     Form3_QuakeWorld.Mensagem_SemNome.Caption:=' NameFun List';
     Form3_QuakeWorld.Mensagem_SemSkin.Caption:=' Available only in DeathMatch';
     Form3_QuakeWorld.Label1.Caption:='PREVIEW:';
     Form3_QuakeWorld.btn_aplicar.Caption:='APPLY';
     end;
 20: Result:='About';
 //21: Result:='DOS GAME LAUNCHER is already running!';
 22: Result:='Would you like to simulate a Multiplayer session?';
 23: Result:='DEBUG MODE';
 24: Result:='DOS Game Launcher is a personal project i´ve maded to play with some friends like in the 90´s.'+#13+#10+#13+#10+
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
 end;

end;

end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
end.
