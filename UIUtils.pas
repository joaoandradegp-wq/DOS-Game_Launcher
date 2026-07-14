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

procedure PosicionarBotao(Botao: TSpeedButton; Texto: TLabel; NovoTop: Integer);
procedure SetGlyph(Button: TBitBtn; ImageList: TImageList; Index: Integer);


implementation

uses Unit1;

//==========================================
//LOCK / UNLOCK
//==========================================

procedure LockWindow(AControl: TWinControl);
begin

  if Assigned(AControl) and AControl.HandleAllocated then
  SendMessage(AControl.Handle, WM_SETREDRAW, 0, 0);

end;

procedure UnlockWindow(AControl: TWinControl);
begin
  if Assigned(AControl) and AControl.HandleAllocated then
  begin
    SendMessage(AControl.Handle, WM_SETREDRAW, 1, 0);
    RedrawWindow(AControl.Handle, nil, 0, RDW_INVALIDATE);
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

end.
