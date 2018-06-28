object fmAbout: TfmAbout
  Left = 461
  Top = 339
  Caption = 'About '
  ClientHeight = 288
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 251
    Width = 347
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      347
      37)
    object bbOk: TBitBtn
      Left = 246
      Top = 4
      Width = 100
      Height = 30
      Anchors = [akTop, akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      Glyph.Data = {
        56010000424D5601000000000000560000002800000010000000100000000100
        08000000000000010000120B0000120B0000080000000800000000000000FFFF
        FF008D6E2300E4B23900C3983100EFC86A00B9B9B90080808000060606060606
        0606060606060606060606060606060606060606060606060606060606060606
        0007060606060606060606060606060002000706060606060606060606060002
        0402000706060606060606060600020303040200070606060606060600020303
        0303040200070606060606000203030302050304020007060606000205030302
        0002050304020007060606000205020006000205030402000706060600020006
        0606000205030402000706060600060606060600020503040200060606060606
        0606060600020502000606060606060606060606060002000606060606060606
        0606060606060006060606060606060606060606060606060606}
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 347
    Height = 251
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object iIcon: TImage
      Left = 12
      Top = 12
      Width = 32
      Height = 32
    end
    object lbAppName: TLabel
      Left = 72
      Top = 12
      Width = 152
      Height = 19
      Caption = 'GrammarEdit v.1.2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 72
      Top = 40
      Width = 211
      Height = 16
      Caption = 'by Dmitry Lamdan (lamdan@mail.ru)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object StaticText1: TStaticText
      Left = 12
      Top = 72
      Width = 325
      Height = 61
      AutoSize = False
      Caption = 
        'This editor is intended to work with grammar definition files. I' +
        't highlights grammar syntax elements, parse file '#39'on the fly'#39' an' +
        'd shows defined grammar elements, providing easy navigation on t' +
        'hem.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object StaticText2: TStaticText
      Left = 12
      Top = 136
      Width = 321
      Height = 101
      AutoSize = False
      Caption = 
        'Thanks to:'#13#10#13#10'Devin Cook for GOLD Parser'#13#10#13#10'Alexander Rai for tr' +
        'anslation to Delphi engine of GOLD Parser'#13#10#13#10'Borland Inc. for gr' +
        'eat development tool Delphi.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
end
