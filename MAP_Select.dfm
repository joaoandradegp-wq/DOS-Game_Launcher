object Form4_Select: TForm4_Select
  Left = 592
  Top = 270
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 295
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  TextHeight = 13
  object label_capitulo: TLabel
    Left = 8
    Top = 121
    Width = 53
    Height = 13
    Caption = 'CAP'#205'TULO:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object label_episodio: TLabel
    Left = 8
    Top = 9
    Width = 53
    Height = 13
    Caption = 'EPIS'#211'DIO:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object btn_aplicar: TSpeedButton
    Left = 8
    Top = 264
    Width = 233
    Height = 25
    Caption = 'OK'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = btn_aplicarClick
  end
  object ListBox_Capitulo: TListBox
    Left = 8
    Top = 136
    Width = 233
    Height = 121
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Calibri'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
    OnClick = ListBox_CapituloClick
  end
  object ListBox_Episodio: TListBox
    Left = 8
    Top = 24
    Width = 233
    Height = 89
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Calibri'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    OnClick = ListBox_EpisodioClick
  end
  object SIGIL_Off: TListBox
    Left = 10
    Top = 78
    Width = 229
    Height = 35
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Calibri'
    Font.Style = []
    ItemHeight = 14
    Items.Strings = (
      'DLC')
    ParentFont = False
    TabOrder = 2
    Visible = False
  end
end
