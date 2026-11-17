object Form4_Select: TForm4_Select
  Left = 592
  Top = 270
  Margins.Left = 9
  Margins.Top = 9
  Margins.Right = 9
  Margins.Bottom = 9
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 885
  ClientWidth = 747
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -33
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 288
  TextHeight = 37
  object label_capitulo: TLabel
    Left = 24
    Top = 360
    Width = 157
    Height = 45
    Margins.Left = 9
    Margins.Top = 9
    Margins.Right = 9
    Margins.Bottom = 9
    Caption = 'CAP'#205'TULO:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object label_episodio: TLabel
    Left = 24
    Top = 24
    Width = 150
    Height = 45
    Margins.Left = 9
    Margins.Top = 9
    Margins.Right = 9
    Margins.Bottom = 9
    Caption = 'EPIS'#211'DIO:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btn_aplicar: TSpeedButton
    Left = 24
    Top = 792
    Width = 699
    Height = 75
    Margins.Left = 9
    Margins.Top = 9
    Margins.Right = 9
    Margins.Bottom = 9
    Caption = 'OK'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = btn_aplicarClick
  end
  object ListBox_Capitulo: TListBox
    Left = 24
    Top = 408
    Width = 699
    Height = 363
    Margins.Left = 9
    Margins.Top = 9
    Margins.Right = 9
    Margins.Bottom = 9
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = []
    ItemHeight = 45
    ParentFont = False
    TabOrder = 1
    OnClick = ListBox_CapituloClick
  end
  object ListBox_Episodio: TListBox
    Left = 24
    Top = 72
    Width = 699
    Height = 267
    Margins.Left = 9
    Margins.Top = 9
    Margins.Right = 9
    Margins.Bottom = 9
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = []
    ItemHeight = 45
    ParentFont = False
    TabOrder = 0
    OnClick = ListBox_EpisodioClick
  end
end
