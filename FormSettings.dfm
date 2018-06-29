object fmOptions: TfmOptions
  Left = 262
  Top = 214
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 370
  ClientWidth = 476
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 330
    Width = 476
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 327
    ExplicitWidth = 475
    DesignSize = (
      476
      40)
    object bbOk: TBitBtn
      Left = 267
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akTop, akRight]
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
      ExplicitLeft = 266
    end
    object bbCancel: TBitBtn
      Left = 371
      Top = 5
      Width = 100
      Height = 30
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      Glyph.Data = {
        56010000424D5601000000000000560000002800000010000000100000000100
        08000000000000010000120B0000120B0000080000000800000000000000FFFF
        FF0095B1E4007F97C2005C6E8D00BED5FF00B9B9B9008D8D8D00060606060606
        0606060606060606060606060606000706060606000706060606060606000400
        0706060004000706060606060004030400070004030400070606060004050203
        0400040202030400060606060004050203040202020400060606060606000405
        0202020204000606060606060606000402020204000706060606060606000402
        0202020304000706060606060004020202040502030400070606060004050202
        0400040502030400070606060004050400060004050203040006060606000400
        0606060004050400060606060606000606060606000400060606060606060606
        0606060606000606060606060606060606060606060606060606}
      ExplicitLeft = 370
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 476
    Height = 330
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 474
    ExplicitHeight = 325
    object pcOptions: TPageControl
      Left = 0
      Top = 0
      Width = 476
      Height = 330
      ActivePage = tsCommon
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 474
      ExplicitHeight = 325
      object tsCommon: TTabSheet
        Caption = 'Common'
        ExplicitWidth = 466
        ExplicitHeight = 297
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 468
          Height = 302
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          ExplicitWidth = 466
          ExplicitHeight = 297
          object cbAutoSave: TCheckBox
            Left = 16
            Top = 140
            Width = 117
            Height = 17
            Caption = 'Auto save editor file'
            TabOrder = 0
          end
          object leAutoSaveInterval: TLabeledEdit
            Left = 332
            Top = 138
            Width = 121
            Height = 21
            EditLabel.Width = 127
            EditLabel.Height = 13
            EditLabel.Caption = 'Autosave interval (minutes)'
            LabelPosition = lpLeft
            LabelSpacing = 10
            TabOrder = 1
          end
          object cbMakeBackup: TCheckBox
            Left = 16
            Top = 172
            Width = 181
            Height = 17
            Caption = 'Make backup files before saving'
            TabOrder = 2
          end
          object gbEditor: TGroupBox
            Left = 16
            Top = 12
            Width = 437
            Height = 105
            Caption = 'Editor'
            TabOrder = 3
            object cbInsertMode: TCheckBox
              Left = 16
              Top = 20
              Width = 81
              Height = 17
              Caption = 'Insert mode'
              TabOrder = 0
            end
            object cbAutoIndent: TCheckBox
              Left = 16
              Top = 48
              Width = 81
              Height = 17
              Caption = 'Auto indent'
              TabOrder = 1
            end
            object cbGroupUndo: TCheckBox
              Left = 16
              Top = 76
              Width = 85
              Height = 17
              Caption = 'Group undo'
              TabOrder = 2
            end
            object cbHalfPageScroll: TCheckBox
              Left = 160
              Top = 20
              Width = 97
              Height = 17
              Caption = 'Half page scroll'
              TabOrder = 3
            end
            object cbSmartTabs: TCheckBox
              Left = 160
              Top = 48
              Width = 81
              Height = 17
              Caption = 'Smart tabs'
              TabOrder = 4
            end
            object cbTabIndent: TCheckBox
              Left = 160
              Top = 76
              Width = 81
              Height = 17
              Caption = 'Tab indent'
              TabOrder = 5
            end
          end
        end
      end
      object tsColor: TTabSheet
        Caption = 'Color'
        ImageIndex = 1
        ExplicitWidth = 466
        ExplicitHeight = 297
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 468
          Height = 302
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          ExplicitWidth = 466
          ExplicitHeight = 297
          object Label1: TLabel
            Left = 16
            Top = 8
            Width = 38
            Height = 13
            Caption = 'Element'
            FocusControl = lbElement
          end
          object Label2: TLabel
            Left = 16
            Top = 120
            Width = 80
            Height = 13
            Caption = 'Foreground color'
            FocusControl = cbForeground
          end
          object Label3: TLabel
            Left = 16
            Top = 164
            Width = 84
            Height = 13
            Caption = 'Background color'
            FocusControl = cbBackground
          end
          object Label4: TLabel
            Left = 148
            Top = 8
            Width = 167
            Height = 13
            Caption = 'Preview (click on element to select)'
          end
          object SpeedButton1: TSpeedButton
            Left = 148
            Top = 256
            Width = 305
            Height = 32
            Caption = 'Set to default'
            Flat = True
            Glyph.Data = {
              F6060000424DF606000000000000360000002800000018000000180000000100
              180000000000C0060000120B0000120B00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF05710A05710A05710A05710A0571
              0A05710AFF00FFFF00FF00009A00009A00009A00009A00009A00009A00009A00
              009A00009A00009A00009A00009A00009A00009A00009A00009A05710A45D16C
              3AC75B2FBE4B24B53A05710AFF00FFFF00FF00009A0335FB0738FB1140FB204C
              FB365DFC5073FC6F8CFD94A9FDBDCAFEECF0FFFDFEFFFDFEFFFDFEFFFDFEFF00
              009A05710A52DB7E47D26E3CC95E30BF4D05710AFF00FFFF00FF00009A0335FB
              0738FB1140FB204CFB365DFC5073FC6F8CFD94A9FDBDCAFEECF0FFFDFEFFFDFE
              FFFDFEFFFDFEFF00009A05710A58E08753DC8049D3703DCA6005710AFF00FFFF
              00FF00009A0335FB0738FB1140FB204CFB365DFC5073FC6F8CFD94A9FDBDCAFE
              ECF0FFFDFEFFFDFEFFFDFEFFFDFEFF00009A05710A58E08758E08755DD824AD5
              7305710AFF00FFFF00FF00009A0335FB0738FB1140FB204CFB365DFC5073FC6F
              8CFD94A9FDBDCAFEECF0FFFDFEFFFDFEFFFDFEFFFDFEFF00009A05710A05710A
              05710A05710A05710A05710AFF00FFFF00FF00009A00009A00009A00009A0000
              9A00009A00009A00009A00009A00009A00009A00009A00009A00009A00009A00
              009AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF05710A05710AFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF05710A52D8
              7E54D98105710A05710AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FF05710A59E4885AE38A59E08849CA6F05710A05710AFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF05710A05710AFF00FFFF
              00FFFF00FFFF00FF05710A32B54D49D5714CD67552DB7D58E2885DE78F05710A
              05710AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF05710A3BB7
              5C05710AFF00FFFF00FFFF00FFFF00FF05710A34C55238C6583DCA5F46D36D3C
              BE5D05710A05710AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              05710A4FCD7832884205710AFF00FFFF00FFFF00FF05710A13962124B73B29B9
              422FBE4C38C7582DB14705710AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FF05710A52D87E3FBE6105710AFF00FFFF00FFFF00FFFF00FF05710A
              05710A05710A05710A21B43726B73E30C34E23A63805710AFF00FFFF00FFFF00
              FFFF00FFFF00FF05710A05710A5BE48C4ED07605710AFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FF05710A05710A18AD2A1EB03228BC4120A735
              05710A05710A05710A05710A05710A47CC6D5EE99050D67C05710AFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF05710A05710A12
              A72016AA271DB23227BC4027B5402AB5443ACA5B41D16544D26942CB6705710A
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FF05710A05710A0DA11A11A71F14AA251BB02F22B63727BA402DBD4829
              AF4205710AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FF05710A05710A1F84280B96160E991A119D
              1F159C2405710A05710AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF05710A
              05710A05710A05710A05710AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
            OnClick = SpeedButton1Click
          end
          object lbElement: TListBox
            Left = 16
            Top = 24
            Width = 121
            Height = 93
            ItemHeight = 13
            TabOrder = 0
            OnClick = lbElementClick
          end
          object cbForeground: TColorBox
            Left = 16
            Top = 135
            Width = 121
            Height = 22
            ItemHeight = 16
            TabOrder = 1
            OnChange = cbForegroundChange
          end
          object cbBackground: TColorBox
            Left = 16
            Top = 179
            Width = 121
            Height = 22
            ItemHeight = 16
            TabOrder = 2
            OnChange = cbBackgroundChange
          end
          object gbFontStyle: TGroupBox
            Left = 15
            Top = 208
            Width = 121
            Height = 81
            Caption = 'Text attributes'
            TabOrder = 3
            object cbBold: TCheckBox
              Left = 12
              Top = 16
              Width = 97
              Height = 17
              Caption = 'Bold'
              TabOrder = 0
              OnClick = cbBoldClick
            end
            object cbItalic: TCheckBox
              Left = 12
              Top = 36
              Width = 97
              Height = 17
              Caption = 'Italic'
              TabOrder = 1
              OnClick = cbItalicClick
            end
            object cbUnderline: TCheckBox
              Left = 12
              Top = 56
              Width = 97
              Height = 17
              Caption = 'Underline'
              TabOrder = 2
              OnClick = cbUnderlineClick
            end
          end
          object sePreview: TSynEdit
            Left = 148
            Top = 24
            Width = 305
            Height = 229
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            TabOrder = 4
            OnClick = sePreviewClick
            OnMouseDown = sePreviewMouseDown
            Gutter.Font.Charset = DEFAULT_CHARSET
            Gutter.Font.Color = clWindowText
            Gutter.Font.Height = -11
            Gutter.Font.Name = 'Terminal'
            Gutter.Font.Style = []
            HideSelection = True
            Lines.UnicodeStrings = 
              '{Literal Ch}     = {Printable Full} - ['#39#39']'#13#10'{Rule Ch}        = {' +
              'Printable} - [<>] - ['#39#39']'#13#10#13#10'ParameterName  = '#39'"'#39' {Parameter Ch}+' +
              ' '#39'"'#39#13#10'Symbol         = ({Symbol Chars} | '#39#39' {Literal Ch}* '#39#39' )+'#13 +
              #10'SetLiteral     = '#39'['#39' ({Set Literal Ch} | '#39#39' {Literal Ch}* '#39#39' )+' +
              ' '#39']'#39#13#10'SetName        = '#39'{'#39' {Set Name Ch}+ '#39'}'#39#13#10'RuleName       = ' +
              #39'<'#39' {Rule Ch}+ '#39'>'#39#13#10#13#10'! This is a line based grammar'#13#10'{Whitespac' +
              'e Ch} = {Whitespace} - {CR} - {LF}'#13#10#13#10'Whitespace = {Whitespace C' +
              'h}+'#13#10'Newline    = {CR}{LF} | {CR} | {LF}'#13#10#13#10'Comment Line  = '#39'!'#39#13 +
              #10'Comment Start = '#39'!*'#39#13#10'Comment End   = '#39'*!'#39#13#10#13#10#13#10'"Start Symbol" ' +
              '= <Grammar>'#13#10#13#10'!------------------------------------------------' +
              '--- Basics'#13#10'<Grammar>  ::= <nl opt> <Content>     ! The <nl opt>' +
              ' here removes all newlines before the first definition'#13#10#13#10'<Conte' +
              'nt> ::= <Definition> <Content> '#13#10'            | <Definition>'#13#10#13#10'<' +
              'Definition> ::= <Parameter>'#13#10'               | <Set>'#13#10'           ' +
              '    | <Terminal>'#13#10'               | <Rule>'#13#10'                '#13#10#13#10'!' +
              ' Optional series of New Line - use below is restricted'#13#10'<nl opt>' +
              ' ::= NewLine <nl opt>'
            Options = [eoAutoIndent, eoDragDropEditing, eoGroupUndo, eoHideShowScrollbars, eoNoCaret, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces, eoTrimTrailingSpaces]
            ReadOnly = True
            FontSmoothing = fsmNone
            RemovedKeystrokes = <
              item
                Command = ecContextHelp
                ShortCut = 112
              end>
            AddedKeystrokes = <
              item
                Command = ecContextHelp
                ShortCut = 16496
              end>
          end
        end
      end
      object tsDisplay: TTabSheet
        Caption = 'Display'
        ImageIndex = 2
        ExplicitWidth = 466
        ExplicitHeight = 297
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 468
          Height = 302
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          ExplicitWidth = 466
          ExplicitHeight = 297
          object gbGutter: TGroupBox
            Left = 8
            Top = 8
            Width = 445
            Height = 117
            Caption = 'Gutter'
            TabOrder = 0
            object Label5: TLabel
              Left = 268
              Top = 20
              Width = 24
              Height = 13
              Caption = 'Color'
              FocusControl = cbGutterColor
            end
            object cbGutterVisible: TCheckBox
              Left = 12
              Top = 20
              Width = 97
              Height = 17
              Caption = 'Visible'
              TabOrder = 0
            end
            object cbGutterColor: TColorBox
              Left = 308
              Top = 16
              Width = 121
              Height = 22
              ItemHeight = 16
              TabOrder = 1
            end
            object leGutterWidth: TLabeledEdit
              Left = 308
              Top = 48
              Width = 119
              Height = 21
              EditLabel.Width = 28
              EditLabel.Height = 13
              EditLabel.Caption = 'Width'
              LabelPosition = lpLeft
              LabelSpacing = 10
              TabOrder = 2
            end
            object cbGutterLineNumers: TCheckBox
              Left = 76
              Top = 20
              Width = 113
              Height = 17
              Caption = 'Show line numbers'
              TabOrder = 3
            end
            object cbGutterLeadingZeros: TCheckBox
              Left = 76
              Top = 52
              Width = 161
              Height = 17
              Caption = 'Leading zeros in line number'
              TabOrder = 4
            end
            object leGutterDigitCount: TLabeledEdit
              Left = 308
              Top = 80
              Width = 119
              Height = 21
              EditLabel.Width = 51
              EditLabel.Height = 13
              EditLabel.Caption = 'Digit count'
              LabelPosition = lpLeft
              LabelSpacing = 10
              TabOrder = 5
            end
          end
          object gmMagrin: TGroupBox
            Left = 8
            Top = 136
            Width = 181
            Height = 149
            Caption = 'Right magrin'
            TabOrder = 1
            object Label6: TLabel
              Left = 18
              Top = 60
              Width = 24
              Height = 13
              Caption = 'Color'
              FocusControl = cbMagrinColor
            end
            object cbMagrinVisible: TCheckBox
              Left = 12
              Top = 24
              Width = 97
              Height = 17
              Caption = 'Visible'
              TabOrder = 0
            end
            object cbMagrinColor: TColorBox
              Left = 52
              Top = 56
              Width = 113
              Height = 22
              ItemHeight = 16
              TabOrder = 1
            end
            object leMarginWidth: TLabeledEdit
              Left = 52
              Top = 100
              Width = 113
              Height = 21
              EditLabel.Width = 28
              EditLabel.Height = 13
              EditLabel.Caption = 'Width'
              LabelPosition = lpLeft
              LabelSpacing = 10
              TabOrder = 2
            end
          end
          object gbFont: TGroupBox
            Left = 200
            Top = 136
            Width = 253
            Height = 149
            Caption = 'Font'
            TabOrder = 2
            object Label7: TLabel
              Left = 12
              Top = 32
              Width = 28
              Height = 13
              Caption = 'Name'
              FocusControl = cbFontName
            end
            object Label8: TLabel
              Left = 12
              Top = 72
              Width = 20
              Height = 13
              Caption = 'Size'
            end
            object cbFontName: TComboBox
              Left = 64
              Top = 28
              Width = 169
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
            end
            object cbFontSize: TComboBox
              Left = 64
              Top = 68
              Width = 89
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 1
              Items.Strings = (
                '6'
                '7'
                '8'
                '9'
                '10'
                '11'
                '12'
                '13'
                '14'
                '15'
                '16'
                '17'
                '18'
                '19'
                '20'
                '21'
                '22'
                '23'
                '24'
                '25'
                '26'
                '27'
                '28'
                '29'
                '30')
            end
          end
        end
      end
    end
  end
end
