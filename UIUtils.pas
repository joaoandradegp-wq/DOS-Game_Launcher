unit UIUtils;

interface

uses
  Windows, Messages, Classes, Controls, Forms, Graphics, ExtCtrls, StdCtrls, SysUtils;

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

implementation

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

end.
