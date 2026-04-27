object Form6_Mouse: TForm6_Mouse
  Left = 627
  Top = 530
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 53
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object MouseSensitivity: TTrackBar
    Left = 30
    Top = 7
    Width = 275
    Height = 41
    Align = alCustom
    LineSize = 1000
    Max = 30000
    Min = -30000
    TabOrder = 0
    TabStop = False
    TickMarks = tmBoth
    OnChange = MouseSensitivityChange
  end
  object panel_negativo: TPanel
    Left = 0
    Top = 0
    Width = 30
    Height = 53
    Align = alLeft
    Alignment = taRightJustify
    BevelOuter = bvNone
    Caption = '0  '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Calibri'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object panel_positivo: TPanel
    Left = 305
    Top = 0
    Width = 30
    Height = 53
    Align = alRight
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '  0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Calibri'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
end
