object Form6_Mouse: TForm6_Mouse
  Left = 627
  Top = 530
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 47
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  TextHeight = 13
  object MouseSensitivity: TTrackBar
    AlignWithMargins = True
    Left = 37
    Top = 3
    Width = 280
    Height = 41
    Align = alClient
    LineSize = 1000
    Max = 30000
    Min = -30000
    TabOrder = 0
    TabStop = False
    TickMarks = tmBoth
    Touch.ParentTabletOptions = False
    Touch.TabletOptions = [toPressAndHold]
    StyleElements = [seClient]
    StyleName = 'Windows11 White Smoke'
    OnChange = MouseSensitivityChange
    ExplicitHeight = 142
  end
  object panel_negativo: TPanel
    Left = 0
    Top = 0
    Width = 34
    Height = 47
    Align = alLeft
    Alignment = taRightJustify
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = True
    BevelOuter = bvNone
    Caption = '0  '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    ExplicitLeft = -6
    ExplicitHeight = 53
  end
  object panel_positivo: TPanel
    Left = 320
    Top = 0
    Width = 34
    Height = 47
    Align = alRight
    Alignment = taLeftJustify
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = True
    BevelOuter = bvNone
    Caption = '  0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    ExplicitLeft = 314
    ExplicitHeight = 53
  end
end
