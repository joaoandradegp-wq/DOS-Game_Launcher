unit Splash;

interface

uses
  Winapi.Windows, System.SysUtils, System.Math, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.WinXCtrls, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage,
  Winapi.ShellAPI;

type
  TForm5_Splash = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FIndicator: TActivityIndicator;
  public
    procedure AjustarTamanho;
  end;

var
  Form5_Splash: TForm5_Splash;

implementation

uses Unit1, Language;

{$R *.dfm}

procedure TForm5_Splash.AjustarTamanho;
const
PERC_MAX = 0.38;
var
PicW, PicH, MaxW, MaxH, NewW, NewH: Integer;
Esc: Double;
Src, Dst: TBitmap;
begin
PicW := Image1.Picture.Width;
PicH := Image1.Picture.Height;

  if (PicW <= 0) or (PicH <= 0) then
  Exit;

MaxW := Round((Monitor.WorkareaRect.Right - Monitor.WorkareaRect.Left) * PERC_MAX);
MaxH := Round((Monitor.WorkareaRect.Bottom - Monitor.WorkareaRect.Top) * PERC_MAX);

Esc := Min(MaxW / PicW, MaxH / PicH);

  if Esc > 1 then
  Esc := 1;

NewW := Round(PicW * Esc);
NewH := Round(PicH * Esc);

  if Esc < 1 then
  begin
    Src := TBitmap.Create;
    Dst := TBitmap.Create;
    try
      Src.Assign(Image1.Picture.Graphic);
      Src.PixelFormat := pf24bit;
      Dst.PixelFormat := pf24bit;
      Dst.SetSize(NewW, NewH);
      SetStretchBltMode(Dst.Canvas.Handle, HALFTONE);
      SetBrushOrgEx(Dst.Canvas.Handle, 0, 0, nil);
      StretchBlt(Dst.Canvas.Handle, 0, 0, NewW, NewH,
        Src.Canvas.Handle, 0, 0, PicW, PicH, SRCCOPY);
      Image1.Picture.Assign(Dst);
    finally
      Src.Free;
      Dst.Free;
    end;
  end;

Image1.Align := alNone;
Image1.Stretch := False;
Image1.AutoSize := False;
Image1.SetBounds(0, 0, NewW, NewH);

ClientWidth := NewW;
ClientHeight := NewH;
Position := poScreenCenter;
end;

procedure TForm5_Splash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
Form5_Splash := nil;
end;

procedure TForm5_Splash.FormCreate(Sender: TObject);
var
Exe: string;
begin
AjustarTamanho;

Label1.Caption := Lang_DGL(37);
Label1.Left := (ClientWidth - Label1.Width) div 2;
Label1.Top := ClientHeight - Label1.Height - MulDiv(6, CurrentPPI, 96);

FIndicator := TActivityIndicator.Create(Self);
FIndicator.Parent := Self;
FIndicator.IndicatorSize := aisMedium;
FIndicator.Left := (ClientWidth - FIndicator.Width) div 2;
FIndicator.Top := ClientHeight - FIndicator.Height - MulDiv(50, CurrentPPI, 96);
FIndicator.Animate := True;

Exe := ExtractFilePath(ParamStr(0)) + 'check_update.exe';

  if FileExists(Exe) then
  ShellExecute(0, 'open', PChar(Exe), PChar(DGL_VERSAO_Global), nil, SW_HIDE);

end;

end.
