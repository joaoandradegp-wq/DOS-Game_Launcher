unit UIUtils;

interface

uses
Windows, Messages, Classes, Controls, Forms, Graphics, ExtCtrls, StdCtrls, SysUtils, Buttons;

//==========================================
//REDRAW
//==========================================
procedure LockWindow(AControl: TWinControl);
procedure UnlockWindow(AControl: TWinControl);
procedure BeginUIUpdate(AControl: TWinControl);
procedure EndUIUpdate(AControl: TWinControl);

//==========================================
//DOUBLE BUFFER
//==========================================
procedure SetDoubleBufferedRecursive(AControl: TWinControl);

//==========================================
//SAFE SETTERS
//==========================================
procedure SetControlVisible(AControl: TControl; AVisible: Boolean);
procedure SetControlEnabled(AControl: TControl; AEnabled: Boolean);
procedure SetLabelCaption(ALabel: TLabel; const ACaption: String);
procedure LoadPicture(AImage: TImage; const FileName: String);

//==========================================
//HELPERS
//==========================================
procedure SetVisible(AControl: TControl; Value: Boolean);
procedure SetEnabled(AControl: TControl; Value: Boolean);
procedure SetCaption(ALabel: TLabel; const Value: String);
procedure SetEditText(AEdit: TCustomEdit; const Value: String);

procedure MostrarControle(Visible: Boolean);
procedure MostrarSensibilidade(Visible: Boolean);
procedure MostrarBrutal(Visible: Boolean);
procedure MostrarDM(Visible: Boolean);
procedure MostrarOpcoes(Visible: Boolean);
procedure MostrarQuakeServer(Visible: Boolean);
procedure DesabilitaMarcaDagua(Visible: Boolean);

procedure HabilitaPlayer(Enabled: Boolean);
procedure HabilitaTipoGame(Enabled: Boolean);

procedure PosicionarBotao(Botao: TSpeedButton; Texto: TLabel; NovoTop: Integer);
procedure SetGlyph(Button: TBitBtn; ImageList: TImageList; Index: Integer);

procedure GaranteLinha(Lista: TStringList; const Linha: string);

implementation

uses Unit1;

const
//SE ALGO FICAR SEM REPINTAR NA TROCA DE JOGO, MUDE PARA False (TRAVA SO O FORM)
LOCK_CHILD_WINDOWS = True;

type
TControlHack = class(TControl); //ACESSO A Color/Font (PROTECTED)

var
RedrawLockCount: Integer      = 0;   //CONTADOR - PERMITE Lock/Unlock ANINHADOS SEM LIBERAR O REDESENHO CEDO
RedrawLocked   : TList        = nil; //FILHOS COM JANELA PROPRIA TRAVADOS (EDITS, GROUPBOX, ETC)
RedrawSnapCtrl : TList        = nil; //FOTO "ANTES": CONTROLES
RedrawSnapSig  : TStringList  = nil; //FOTO "ANTES": ASSINATURA DE CADA CONTROLE
SigSerial      : Integer      = 0;

//==========================================
//ASSINATURAS - DETECTAM O QUE MUDOU NA TROCA
//==========================================

//PROPRIEDADES VISUAIS COMUNS (VISIVEL, HABILITADO, POSICAO, CORES, TEXTO)
function SigBasic(C: TControl): String;
var
Buf: array[0..255] of Char;
Len: Integer;
S: String;
begin
  S := '';

  if (not (C is TWinControl)) or TWinControl(C).HandleAllocated then
  begin
    Len := C.GetTextBuf(PChar(@Buf[0]), SizeOf(Buf));
    if Len > 0 then
    S := StrPas(PChar(@Buf[0]));
  end;

  Result := IntToStr(Ord(C.Visible)) + IntToStr(Ord(C.Enabled)) + '|'
          + IntToStr(C.Left)  + ',' + IntToStr(C.Top) + ','
          + IntToStr(C.Width) + ',' + IntToStr(C.Height) + '|'
          + IntToStr(TControlHack(C).Color) + ',' + IntToStr(TControlHack(C).Font.Color) + '|'
          + S + '|';
end;

//CONTROLE SEM JANELA (LABEL, IMAGEM, SPEEDBUTTON)
function SigGraphic(C: TControl): String;
begin
  Result := SigBasic(C);

  if C is TSpeedButton then
  Result := Result + IntToStr(Ord(TSpeedButton(C).Down))
  else
  if not ((C is TCustomLabel) or (C is TBevel)) then
  begin
    //IMAGEM OU TIPO DESCONHECIDO: NAO DA PRA COMPARAR O CONTEUDO - CONSIDERA SEMPRE "MUDOU"
    Inc(SigSerial);
    Result := Result + '#' + IntToStr(SigSerial);
  end;
end;

//CONTROLE COM JANELA (EDIT, GROUPBOX, FORM...)
function SigWin(W: TWinControl): String;
var
i: Integer;
C: TControl;
begin
  Result := SigBasic(W);

  if W.HandleAllocated then
  Result := Result + IntToStr(GetWindowLong(W.Handle, GWL_STYLE) and (ES_READONLY or WS_DISABLED));

  //FOLHA QUE NAO E EDIT (BOTAO, RADIO, LISTA...): NAO DA PRA COMPARAR - SEMPRE REPINTA (SEM APAGAR O FUNDO)
  if (W.ControlCount = 0) and (not (W is TCustomEdit)) then
  begin
    Inc(SigSerial);
    Result := Result + '#' + IntToStr(SigSerial);
  end;

  for i := 0 to W.ControlCount - 1 do
  begin
    C := W.Controls[i];

    if C is TWinControl then
    //FILHO COM JANELA TEM ASSINATURA PROPRIA - AQUI SO VISIBILIDADE E POSICAO
    Result := Result + '/' + IntToStr(Ord(C.Visible)) + IntToStr(C.Left) + ',' + IntToStr(C.Top)
                     + ',' + IntToStr(C.Width) + ',' + IntToStr(C.Height)
    else
    Result := Result + '/' + SigGraphic(C);
  end;
end;

//TODOS OS TWinControl VISIVEIS ABAIXO DE AControl (RECURSIVO)
procedure CollectVisibleWinControls(AControl: TWinControl; AList: TList);
var
i: Integer;
begin
  for i := 0 to AControl.ControlCount - 1 do
    if (AControl.Controls[i] is TWinControl) and AControl.Controls[i].Visible then
    begin
      AList.Add(AControl.Controls[i]);
      CollectVisibleWinControls(TWinControl(AControl.Controls[i]), AList);
    end;
end;

//==========================================
//LOCK / UNLOCK
//==========================================

procedure LockWindow(AControl: TWinControl);
var
i: Integer;
begin

  if Assigned(AControl) and AControl.HandleAllocated then
  begin
    //SO TRAVA NA PRIMEIRA CHAMADA (NIVEL MAIS EXTERNO)
    if RedrawLockCount = 0 then
    begin
      if RedrawLocked = nil then
      begin
        RedrawLocked   := TList.Create;
        RedrawSnapCtrl := TList.Create;
        RedrawSnapSig  := TStringList.Create;
      end;

      RedrawLocked.Clear;
      RedrawSnapCtrl.Clear;
      RedrawSnapSig.Clear;

      //FOTO "ANTES" (SE FALHAR, FICA VAZIA E TUDO SERA REPINTADO NO FINAL)
      try
        CollectVisibleWinControls(AControl, RedrawLocked);

        RedrawSnapCtrl.Add(AControl);
        RedrawSnapSig.Add(SigWin(AControl));

        for i := 0 to RedrawLocked.Count - 1 do
        begin
          RedrawSnapCtrl.Add(RedrawLocked[i]);
          RedrawSnapSig.Add(SigWin(TWinControl(RedrawLocked[i])));
        end;
      except
        RedrawSnapCtrl.Clear;
        RedrawSnapSig.Clear;
      end;

      SendMessage(AControl.Handle, WM_SETREDRAW, 0, 0);

      //TRAVA TAMBEM OS FILHOS COM JANELA PROPRIA - ELES SE REPINTAM SOZINHOS
      if LOCK_CHILD_WINDOWS then
      begin
        for i := 0 to RedrawLocked.Count - 1 do
          if TWinControl(RedrawLocked[i]).HandleAllocated then
          SendMessage(TWinControl(RedrawLocked[i]).Handle, WM_SETREDRAW, 0, 0);
      end
      else
      RedrawLocked.Clear;
    end;

    Inc(RedrawLockCount);
  end;

end;

procedure UnlockWindow(AControl: TWinControl);
var
i, idx: Integer;
Ctrl: TWinControl;
FormDirty: Boolean;
begin

  if Assigned(AControl) and AControl.HandleAllocated and (RedrawLockCount > 0) then
  begin
    Dec(RedrawLockCount);

    //SO LIBERA E REDESENHA QUANDO SAIR DO NIVEL MAIS EXTERNO (UM UNICO REPAINT)
    if RedrawLockCount = 0 then
    begin

      //1) LIBERA O REDESENHO - O FORM SEMPRE E LIBERADO, MESMO SE ALGO FALHAR
      try
        if RedrawLocked <> nil then
        begin
          //SO OS FILHOS TRAVADOS QUE CONTINUAM VISIVEIS (WM_SETREDRAW TRUE EM JANELA ESCONDIDA A MOSTRA)
          for i := RedrawLocked.Count - 1 downto 0 do
          begin
            Ctrl := TWinControl(RedrawLocked[i]);
            if Ctrl.HandleAllocated and Ctrl.Visible then
            SendMessage(Ctrl.Handle, WM_SETREDRAW, 1, 0);
          end;
          RedrawLocked.Clear;
        end;
      finally
        SendMessage(AControl.Handle, WM_SETREDRAW, 1, 0);
      end;

      //2) REPINTA SO O QUE MUDOU (COMPARA COM A FOTO "ANTES")
      if RedrawLocked <> nil then
      begin
        FormDirty := True;

        try
          CollectVisibleWinControls(AControl, RedrawLocked);

          for i := 0 to RedrawLocked.Count - 1 do
          begin
            Ctrl := TWinControl(RedrawLocked[i]);

            if Ctrl.HandleAllocated then
            begin
              idx := RedrawSnapCtrl.IndexOf(Ctrl);

              //APARECEU DURANTE A TROCA: PINTA COMPLETO, COM OS FILHOS
              if idx < 0 then
              RedrawWindow(Ctrl.Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_ALLCHILDREN or RDW_FRAME)
              else
              if RedrawSnapSig[idx] <> SigWin(Ctrl) then
              begin
                //FOLHA (EDIT, BOTAO...): REPINTA SEM APAGAR O FUNDO = SEM PISCAR
                if Ctrl.ControlCount = 0 then
                RedrawWindow(Ctrl.Handle, nil, 0, RDW_INVALIDATE or RDW_FRAME)
                //CONTAINER (PANEL, GROUPBOX...): APAGA O FUNDO DELE (FILHOS COM JANELA FICAM DE FORA)
                else
                RedrawWindow(Ctrl.Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_FRAME);
              end;
            end;
          end;

          FormDirty := (RedrawSnapSig.Count = 0)
                    or (RedrawSnapCtrl[0] <> Pointer(AControl))
                    or (RedrawSnapSig[0] <> SigWin(AControl));
        finally
          RedrawLocked.Clear;

          //FORM: APAGA O FUNDO (GARANTE QUE img_game/LOGOS ESCONDIDOS SUMAM)
          if FormDirty then
          RedrawWindow(AControl.Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_FRAME);
        end;
      end;

    end;
  end;

end;

procedure BeginUIUpdate(AControl: TWinControl);
begin
LockWindow(AControl);
end;

procedure EndUIUpdate(AControl: TWinControl);
begin
UnlockWindow(AControl);
end;

//==========================================
//DOUBLE BUFFER
//==========================================

procedure SetDoubleBufferedRecursive(AControl: TWinControl);
var
i: Integer;
begin

  if not Assigned(AControl) then
  Exit;

AControl.DoubleBuffered := True;

  for i := 0 to AControl.ControlCount - 1 do
    if AControl.Controls[i] is TWinControl then
    SetDoubleBufferedRecursive(TWinControl(AControl.Controls[i]));

end;

//==========================================
//SAFE SETTERS
//==========================================

procedure SetControlVisible(AControl: TControl; AVisible: Boolean);
begin
  if Assigned(AControl) then
  begin
    if AControl.Visible <> AVisible then
    AControl.Visible := AVisible;
  end;
end;

procedure SetControlEnabled(AControl: TControl; AEnabled: Boolean);
begin
  if Assigned(AControl) then
  begin
    if AControl.Enabled <> AEnabled then
    AControl.Enabled := AEnabled;
  end;
end;

procedure SetLabelCaption(ALabel: TLabel; const ACaption: String);
begin
  if Assigned(ALabel) then
  begin
    if ALabel.Caption <> ACaption then
    ALabel.Caption := ACaption;
  end;
end;

procedure LoadPicture(AImage: TImage; const FileName: String);
begin

  if not Assigned(AImage) then
  Exit;

  if FileExists(FileName) then
  AImage.Picture.LoadFromFile(FileName);
  
end;

procedure SetVisible(AControl: TControl; Value: Boolean);
begin
  if Assigned(AControl) then
  begin
    if AControl.Visible <> Value then
    AControl.Visible := Value;
  end;
end;

procedure SetEnabled(AControl: TControl; Value: Boolean);
begin
  if Assigned(AControl) then
  begin
    if AControl.Enabled <> Value then
    AControl.Enabled := Value;
  end;
end;

procedure SetCaption(ALabel: TLabel; const Value: String);
begin
  if Assigned(ALabel) then
  begin
    if ALabel.Caption <> Value then
    ALabel.Caption := Value;
  end;
end;

procedure SetEditText(AEdit: TCustomEdit; const Value: String);
begin
  if Assigned(AEdit) then
  begin
    if AEdit.Text <> Value then
    AEdit.Text := Value;
  end;
end;

procedure MostrarControle(Visible: Boolean);
begin
SetVisible(Form1_DGL.RxControle, Visible);
SetVisible(Form1_DGL.Label_Controle, Visible);
end;

procedure MostrarSensibilidade(Visible: Boolean);
begin
SetVisible(Form1_DGL.RxSense, Visible);
SetVisible(Form1_DGL.Label_Sense, Visible);
end;

procedure MostrarBrutal(Visible: Boolean);
begin
SetVisible(Form1_DGL.RxBrutal, Visible);
SetVisible(Form1_DGL.Label_Brutal, Visible);
end;

procedure MostrarDM(Visible: Boolean);
begin
SetVisible(Form1_DGL.RxDM, Visible);
SetVisible(Form1_DGL.Label_DM, Visible);
end;

procedure MostrarOpcoes(Visible: Boolean);
begin
SetVisible(Form1_DGL.RxOpcoes, Visible);
SetVisible(Form1_DGL.Label_Opcoes, Visible);
end;

procedure MostrarQuakeServer(Visible: Boolean);
begin
SetVisible(Form1_DGL.RxQuakeServer, Visible);
SetVisible(Form1_DGL.Label_QuakeServer, Visible);
end;

procedure DesabilitaMarcaDagua(Visible: Boolean);
begin
SetVisible(Form1_DGL.logo_blood      , Visible);
SetVisible(Form1_DGL.logo_constructor, Visible);
SetVisible(Form1_DGL.logo_doom       , Visible);
SetVisible(Form1_DGL.logo_duke3d     , Visible);
SetVisible(Form1_DGL.logo_heretic    , Visible);
SetVisible(Form1_DGL.logo_hexen      , Visible);
SetVisible(Form1_DGL.logo_quake      , Visible);
SetVisible(Form1_DGL.logo_rott       , Visible);
SetVisible(Form1_DGL.logo_shadow     , Visible);
SetVisible(Form1_DGL.logo_warcraft   , Visible);
SetVisible(Form1_DGL.logo_wolf3d     , Visible);
end;

procedure HabilitaPlayer(Enabled: Boolean);
begin
SetEnabled(Form1_DGL.label_name, Enabled);
SetEnabled(Form1_DGL.player_name, Enabled);
SetEnabled(Form1_DGL.cont_player, Enabled);
SetEnabled(Form1_DGL.cont_seta, Enabled);
end;

procedure HabilitaTipoGame(Enabled: Boolean);
begin
SetEnabled(Form1_DGL.check_single, Enabled);
SetEnabled(Form1_DGL.check_servidor, Enabled);
SetEnabled(Form1_DGL.check_cliente, Enabled);
end;

procedure PosicionarBotao(Botao: TSpeedButton; Texto: TLabel; NovoTop: Integer);
begin
  if Botao.Top <> NovoTop then
  Botao.Top := NovoTop;

  if Texto.Top <> (NovoTop + 1) then
  Texto.Top := NovoTop + 1;
end;

procedure SetGlyph(Button: TBitBtn; ImageList: TImageList; Index: Integer);
begin
Button.Glyph.Assign(nil);
ImageList.GetBitmap(Index, Button.Glyph);
end;

procedure GaranteLinha(Lista: TStringList; const Linha: string);
var
  j: Integer;
  Achou: Boolean;
begin
  Achou := False;
  for j := 0 to Lista.Count - 1 do
    if Trim(LowerCase(Lista[j])) = LowerCase(Linha) then
    begin
      Achou := True;
      Break;
    end;
  if not Achou then
    Lista.Add(Linha);
end;

initialization

finalization
  FreeAndNil(RedrawLocked);
  FreeAndNil(RedrawSnapCtrl);
  FreeAndNil(RedrawSnapSig);

end.
