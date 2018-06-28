unit FormSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, UnitUtils, SynUnicode, SynEdit,
  SynEditHighlighter;

type
  TfmOptions = class(TForm)
    Panel1: TPanel;
    bbOk: TBitBtn;
    bbCancel: TBitBtn;
    Panel2: TPanel;
    pcOptions: TPageControl;
    tsCommon: TTabSheet;
    Panel3: TPanel;
    cbAutoSave: TCheckBox;
    leAutoSaveInterval: TLabeledEdit;
    tsColor: TTabSheet;
    Panel4: TPanel;
    Label1: TLabel;
    lbElement: TListBox;
    cbForeground: TColorBox;
    cbBackground: TColorBox;
    Label2: TLabel;
    Label3: TLabel;
    gbFontStyle: TGroupBox;
    cbBold: TCheckBox;
    cbItalic: TCheckBox;
    cbUnderline: TCheckBox;
    sePreview: TSynEdit;
    Label4: TLabel;
    cbMakeBackup: TCheckBox;
    tsDisplay: TTabSheet;
    Panel5: TPanel;
    gbGutter: TGroupBox;
    cbGutterVisible: TCheckBox;
    cbGutterColor: TColorBox;
    Label5: TLabel;
    leGutterWidth: TLabeledEdit;
    cbGutterLineNumers: TCheckBox;
    cbGutterLeadingZeros: TCheckBox;
    leGutterDigitCount: TLabeledEdit;
    gmMagrin: TGroupBox;
    cbMagrinVisible: TCheckBox;
    cbMagrinColor: TColorBox;
    Label6: TLabel;
    leMarginWidth: TLabeledEdit;
    gbFont: TGroupBox;
    cbFontName: TComboBox;
    Label7: TLabel;
    cbFontSize: TComboBox;
    Label8: TLabel;
    gbEditor: TGroupBox;
    cbInsertMode: TCheckBox;
    cbAutoIndent: TCheckBox;
    cbGroupUndo: TCheckBox;
    cbHalfPageScroll: TCheckBox;
    cbSmartTabs: TCheckBox;
    cbTabIndent: TCheckBox;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure lbElementClick(Sender: TObject);
    procedure cbForegroundChange(Sender: TObject);
    procedure cbBackgroundChange(Sender: TObject);
    procedure cbBoldClick(Sender: TObject);
    procedure cbItalicClick(Sender: TObject);
    procedure cbUnderlineClick(Sender: TObject);
    procedure sePreviewClick(Sender: TObject);
    procedure sePreviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
  public
    Attri: TTextAttriArray;
  end;

type
  TOptionsDialogPage = (odpCommon, odpColor, odpDisplay);

function RunOptionsDialog(const APage: TOptionsDialogPage): boolean;

implementation

uses GrammarSyn;

{$R *.dfm}

function RunOptionsDialog(const APage: TOptionsDialogPage): boolean;
var
  SL: TStringList;
begin
  Result := false;
  with TfmOptions.Create(Application) do
  try
    case APage of
      odpCommon: pcOptions.ActivePage := tsCommon;
      odpColor: pcOptions.ActivePage := tsColor;
      odpDisplay: pcOptions.ActivePage := tsDisplay;
    end;
    cbAutoSave.Checked := Options.AutoSave;
    leAutoSaveInterval.Text := IntToStr(Options.AutoSaveInterval);
    cbMakeBackup.Checked := Options.MakeBackup;
    cbGutterVisible.Checked := Options.GutterVisible;
    cbGutterLineNumers.Checked := Options.GutterLineNumbers;
    cbGutterLeadingZeros.Checked := Options.GutterLeadingZeros;
    cbGutterColor.Selected := Options.GutterColor;
    leGutterWidth.Text := IntToStr(Options.GutterWidth);
    leGutterDigitCount.Text := IntToStr(Options.GutterDigitCount);
    leMarginWidth.Text := IntToStr(Options.RightMargin);

    SL := TStringList.Create;
    try
      GetFontNames(SL);
      SL.Sorted := true;
      cbFontName.Items.Assign(SL);
    finally
      SL.Free;
    end;
    cbFontName.ItemIndex := cbFontName.Items.IndexOf(Options.FontName);
    cbFontSize.ItemIndex := cbFontSize.Items.IndexOf(IntToStr(Options.FontSize));

    cbInsertMode.Checked := Options.EditorInsertMode;
    cbAutoIndent.Checked := Options.EditorInsertMode;
    cbGroupUndo.Checked := Options.EditorGroupUndo;
    cbHalfPageScroll.Checked := Options.EditorHalfPageScroll;
    cbSmartTabs.Checked := Options.EditorSmartTabs;
    cbTabIndent.Checked := Options.EditorTabIndent;

    if ShowModal=mrOk then
    begin
      Result := true;
      Options.AutoSaveInterval := StrToIntDef(leAutoSaveInterval.Text, Options.AutoSaveInterval);
      Options.AutoSave := cbAutoSave.Checked;
      Options.TextAttri  := Attri;
      Options.MakeBackup := cbMakeBackup.Checked;
      Options.MakeBackup := cbMakeBackup.Checked;
      Options.GutterVisible := cbGutterVisible.Checked;
      Options.GutterLineNumbers := cbGutterLineNumers.Checked;
      Options.GutterLeadingZeros := cbGutterLeadingZeros.Checked;
      Options.GutterColor := cbGutterColor.Selected;
      Options.GutterWidth := StrToInt(leGutterWidth.Text);
      Options.GutterDigitCount := StrToInt(leGutterDigitCount.Text);
      Options.FontName := cbFontName.Text;
      Options.FontSize := StrToIntDef(cbFontSize.Text, Options.FontSize);
      Options.EditorInsertMode := cbInsertMode.Checked;
      Options.EditorAutoIndent := cbAutoIndent.Checked;
      Options.EditorGroupUndo := cbGroupUndo.Checked;
      Options.EditorHalfPageScroll := cbHalfPageScroll.Checked;
      Options.EditorSmartTabs := cbSmartTabs.Checked;
      Options.EditorTabIndent := cbTabIndent.Checked;
    end;
  finally
    Free;
  end;
end;

procedure TfmOptions.FormCreate(Sender: TObject);
var
  i: TTextAttriItem;
  n: integer;
begin
  Attri := Options.TextAttri;
  sePreview.Highlighter := TGrammarSyn.Create(Self);
  for i:=Low(TTextAttriItem) to High(TTextAttriItem) do
    UpdateTextAttri(sePreview, Attri[i]);
  for i:=Low(Attri) to High(Attri) do
  begin
    n := lbElement.Items.Add(Attri[i].ItemName);
    lbElement.Items.Objects[n] := pointer(i);
  end;
  lbElement.ItemIndex := 0;
  lbElementClick(nil);
end;

procedure TfmOptions.lbElementClick(Sender: TObject);
var
  i: TTextAttriItem;
begin
  i := TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex]);
  cbForeground.Selected := Attri[i].Foreground;
  cbBackground.Selected := Attri[i].Background;
  cbBold.Checked := fsBold in Attri[i].Style;
  cbItalic.Checked := fsItalic in Attri[i].Style;
  cbUnderline.Checked := fsUnderline in Attri[i].Style;
end;

procedure TfmOptions.cbForegroundChange(Sender: TObject);
begin
  if lbElement.ItemIndex>=0 then
  begin
    Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Foreground :=
      cbForeground.Selected;
    UpdateTextAttri(sePreview,
      Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])]);
    sePreview.Invalidate;
  end;
end;

procedure TfmOptions.cbBackgroundChange(Sender: TObject);
begin
  if lbElement.ItemIndex>=0 then
  begin
    Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Background :=
      cbBackground.Selected;
    UpdateTextAttri(sePreview,
      Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])]);
    sePreview.Invalidate;
  end;
end;

procedure TfmOptions.cbBoldClick(Sender: TObject);
begin
  if lbElement.ItemIndex>=0 then
  begin
    if cbBold.Checked then
      Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style :=
        Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style+[fsBold]
    else
      Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style :=
        Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style-[fsBold];
    UpdateTextAttri(sePreview,
      Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])]);
    sePreview.Invalidate;
  end;
end;

procedure TfmOptions.cbItalicClick(Sender: TObject);
begin
  if lbElement.ItemIndex>=0 then
  begin
    if cbItalic.Checked then
      Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style :=
        Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style+[fsItalic]
    else
      Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style :=
        Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style-[fsItalic];
    UpdateTextAttri(sePreview,
      Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])]);
    sePreview.Invalidate;
  end;
end;

procedure TfmOptions.cbUnderlineClick(Sender: TObject);
begin
  if lbElement.ItemIndex>=0 then
  begin
    if cbUnderline.Checked then
      Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style :=
        Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style+[fsUnderline]
    else
      Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style :=
        Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])].Style-[fsUnderline];
    UpdateTextAttri(sePreview,
      Attri[TTextAttriItem(lbElement.Items.Objects[lbElement.ItemIndex])]);
    sePreview.Invalidate;
  end;
end;

procedure TfmOptions.sePreviewClick(Sender: TObject);
var
  P: TPoint;
  DC: TDisplayCoord;
  A: TSynHighlighterAttributes;
  i: integer;
  TA: TTextAttriItem;
  s: UnicodeString;
begin
  Exit;
  GetCursorPos(P);
  P := sePreview.ScreenToClient(P);
  DC := sePreview.PixelsToRowColumn(P.X, P.Y);
  if sePreview.GetHighlighterAttriAtRowCol(TBufferCoord(DC), s, A) then
  begin
    i := 0;
    repeat
      TA := TTextAttriItem(lbElement.Items.Objects[i]);
    until (i=lbElement.Items.Count) or (HighlighterAttri(sePreview.Highlighter, Attri[TA].HighlighterAttriName)<>A);
    if i<lbElement.Items.Count then
    begin
      lbElement.ItemIndex := i;
      lbElementClick(nil);
    end;
  end;
end;

procedure TfmOptions.sePreviewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  DC: TDisplayCoord;
  A: TSynHighlighterAttributes;
  i: integer;
  TA: TTextAttriItem;
  s: UnicodeString;
begin
  DC := sePreview.PixelsToRowColumn(X, Y);
  if sePreview.GetHighlighterAttriAtRowCol(TBufferCoord(DC), s, A) then
  begin
    i := -1;
    repeat
      Inc(i);
      TA := TTextAttriItem(lbElement.Items.Objects[i]);
    until (i=lbElement.Items.Count) or (HighlighterAttri(sePreview.Highlighter, Attri[TA].HighlighterAttriName)=A);
    if i<lbElement.Items.Count then
    begin
      lbElement.ItemIndex := i;
      lbElementClick(nil);
    end;
  end;
end;

procedure TfmOptions.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Err: string;
begin
  if ModalResult<>mrOk then Exit;

  Err := '';

  if StrToIntDef(leAutoSaveInterval.Text, -1)=-1 then
  begin
    Err := 'Illegal value for autosave interval';
    pcOptions.ActivePage := tsCommon;
    leAutoSaveInterval.SetFocus;
  end
  else
  if StrToIntDef(leGutterWidth.Text, -1)=-1 then
  begin
    Err := 'Illegal value for gutter width';
    pcOptions.ActivePage := tsDisplay;
    leGutterWidth.SetFocus;
  end
  else
  if StrToIntDef(leGutterDigitCount.Text, -1)=-1 then
  begin
    Err := 'Illegal value for gutter digit count';
    pcOptions.ActivePage := tsDisplay;
    leGutterDigitCount.SetFocus;
  end
  else
  if StrToIntDef(leMarginWidth.Text, -1)=-1 then
  begin
    Err := 'Illegal value for right margin width';
    pcOptions.ActivePage := tsDisplay;
    leMarginWidth.SetFocus;
  end;

  if Err<>'' then
  begin
    MessageDlg(Err, mtError, [mbOk], 0);
    CanClose := false;
  end;
end;

procedure TfmOptions.SpeedButton1Click(Sender: TObject);
var
  i: TTextAttriItem;
begin
  for i:=Low(TTextAttriItem) to High(TTextAttriItem) do
  begin
    Attri[i].Foreground := Attri[i].DefaultForeground;
    Attri[i].Background := Attri[i].DefaultBackground;
    Attri[i].Style := Attri[i].DefaultStyle;
    UpdateTextAttri(sePreview, Attri[i]);
    lbElementClick(nil);
    sePreview.Invalidate;
  end;
end;

end.
