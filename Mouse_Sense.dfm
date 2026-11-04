object Form6_Mouse: TForm6_Mouse
  Left = 627
  Top = 530
  Margins.Left = 9
  Margins.Top = 9
  Margins.Right = 9
  Margins.Bottom = 9
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 159
  ClientWidth = 1005
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -33
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 288
  TextHeight = 37
  object MouseSensitivity: TTrackBar
    Left = 90
    Top = 21
    Width = 825
    Height = 123
    Margins.Left = 9
    Margins.Top = 9
    Margins.Right = 9
    Margins.Bottom = 9
    Align = alCustom
    LineSize = 1000
    Max = 30000
    Min = -30000
    TabOrder = 0
    TabStop = False
    ThumbLength = 60
    TickMarks = tmBoth
    OnChange = MouseSensitivityChange
  end
  object panel_negativo: TPanel
    Left = 0
    Top = 0
    Width = 90
    Height = 159
    Margins.Left = 9
    Margins.Top = 9
    Margins.Right = 9
    Margins.Bottom = 9
    Align = alLeft
    Alignment = taRightJustify
    BevelOuter = bvNone
    Caption = '0  '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object panel_positivo: TPanel
    Left = 915
    Top = 0
    Width = 90
    Height = 159
    Margins.Left = 9
    Margins.Top = 9
    Margins.Right = 9
    Margins.Bottom = 9
    Align = alRight
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '  0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
end
