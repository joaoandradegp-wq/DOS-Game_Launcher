unit BotaoSteam;

{ Botão verde estilo Steam (gradiente + ícone de play), extraído do ML Launcher.
  Sem dependências do resto do projeto. }

interface

uses
  System.SysUtils, System.Classes, System.Math,
  Winapi.Windows, Winapi.Messages,
  Vcl.Graphics, Vcl.Controls;

type
  {BOTÃO STEAM - 01/04}
  TBotaoSteam = class(TCustomControl)
  private
    FHover: Boolean;
    FDown: Boolean;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    property Caption;
    property OnClick;
  end;

implementation

{BOTÃO STEAM - 02/04}
constructor TBotaoSteam.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  DoubleBuffered := True;
  Cursor := crHandPoint;
  Width := 240;
  Height := 40;
  Font.Name := 'Segoe UI';
end;

procedure TBotaoSteam.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FHover := True;
  Invalidate;
end;

procedure TBotaoSteam.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FHover := False;
  FDown := False;
  Invalidate;
end;

procedure TBotaoSteam.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TBotaoSteam.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TBotaoSteam.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
  begin
    FDown := True;
    Invalidate;
  end;
end;

procedure TBotaoSteam.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  FDown := False;
  Invalidate;
end;

{BOTÃO STEAM - 03/04}
procedure TBotaoSteam.Paint;
var
  Esq, Dir, CorTexto: TColor;
  X, W, H, IconH, IconW, Gap, TextW, TextH, L, T: Integer;

  function Mistura(A, B: TColor; Pos, Total: Integer): TColor;
  begin
    Result := TColor(RGB(
      GetRValue(A) + (GetRValue(B) - GetRValue(A)) * Pos div Total,
      GetGValue(A) + (GetGValue(B) - GetGValue(A)) * Pos div Total,
      GetBValue(A) + (GetBValue(B) - GetBValue(A)) * Pos div Total));
  end;

begin
  W := Width;
  H := Height;

  // cores do gradiente (esquerda -> direita), como o botão JOGAR da Steam
  if not Enabled then
  begin
    Esq := TColor(RGB(82, 90, 100));
    Dir := TColor(RGB(66, 72, 80));
    CorTexto := TColor(RGB(150, 158, 168));
  end
  else
  begin
    CorTexto := clWhite;
    if FDown then
    begin
      Esq := TColor(RGB(52, 160, 38));
      Dir := TColor(RGB(16, 140, 70));
    end
    else if FHover then
    begin
      Esq := TColor(RGB(104, 224, 60));
      Dir := TColor(RGB(36, 200, 108));
    end
    else
    begin
      Esq := TColor(RGB(84, 204, 48));
      Dir := TColor(RGB(24, 178, 90));
    end;
  end;

  for X := 0 to W - 1 do
  begin
    Canvas.Brush.Color := Mistura(Esq, Dir, X, Max(W - 1, 1));
    Canvas.FillRect(Rect(X, 0, X + 1, H));
  end;

  IconH := Round(H * 0.34);
  IconW := Round(IconH * 0.9);
  Gap := Round(H * 0.3);

  // diminui a fonte até o ícone + texto caberem no botão
  // altura da fonte em pixels proporcional à altura do botão (que já vem escalada pelo DPI)
  Canvas.Font.Assign(Font);
  Canvas.Font.Color := CorTexto;
  Canvas.Font.Height := -Round(H * 0.38);
  while (Canvas.Font.Height < -9) and
        (IconW + Gap + Canvas.TextWidth(Caption) > W - 16) do
    Canvas.Font.Height := Canvas.Font.Height + 1;
  TextW := Canvas.TextWidth(Caption);
  TextH := Canvas.TextHeight(Caption);

  L := (W - (IconW + Gap + TextW)) div 2;
  T := (H - IconH) div 2;

  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := CorTexto;
  Canvas.Pen.Color := CorTexto;
  Canvas.Polygon([Point(L, T), Point(L, T + IconH), Point(L + IconW, T + IconH div 2)]);

  Canvas.Brush.Style := bsClear;
  Canvas.TextOut(L + IconW + Gap, (H - TextH) div 2, Caption);
end;

{BOTÃO STEAM - 04/04}
end.
