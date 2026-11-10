object Form2_DLC: TForm2_DLC
  Left = 767
  Top = 347
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 105
  ClientWidth = 265
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  PrintScale = poNone
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  TextHeight = 13
  object PACK01: TSpeedButton
    Left = 32
    Top = 40
    Width = 201
    Height = 25
    Caption = 'DLC 1'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Calibri'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = PACK01Click
  end
  object PACK02: TSpeedButton
    Left = 32
    Top = 72
    Width = 201
    Height = 25
    Caption = 'DLC 2'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Calibri'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = PACK02Click
  end
  object PACK00: TSpeedButton
    Left = 32
    Top = 8
    Width = 201
    Height = 25
    Caption = 'ORIGINAL'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Calibri'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = PACK00Click
  end
end
