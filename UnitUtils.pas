unit UnitUtils;

interface
uses Windows, Classes, Graphics, SysUtils, SynEdit, SynEditHighlighter,
     TypInfo;

const
  APPLICATION_NAME = 'GrammarEdit';
  APPLICATION_VERSION = 'v. 1.1';

type
  TMRUAction = (maNone, maInsert, maReorder);
  TTextAttriItem = (taiWhitespace, taiComment, taiReservedWord, taiRuleName, taiSetName,
                    taiSymbol, taiString, taiParameter, taiCharSet);

  TTextAttri = record
    ItemName: string;
    HighlighterAttriName: string;
    Foreground: TColor;
    Background: TColor;
    Style: TFontStyles;
    DefaultForeground: TColor;
    DefaultBackground: TColor;
    DefaultStyle: TFontStyles;
  end;
  TTextAttriArray = array [Low(TTextAttriItem)..High(TTextAttriItem)] of TTextAttri;

  TOptions = record
    MRUFiles: array[1..10] of string;
    AutoSave: boolean;
    AutoSaveInterval: integer;
    TextAttri: TTextAttriArray;
    MakeBackup: boolean;
    GutterVisible: boolean;
    GutterColor: TColor;
    GutterLineNumbers: boolean;
    GutterLeadingZeros: boolean;
    GutterDigitCount: integer;
    GutterWidth: integer;
    RightMarginVisible: boolean;
    RightMargin: integer;
    RightMarginColor: TColor;
    FontName: string;
    FontSize: integer;
    EditorInsertMode: boolean;
    EditorAutoIndent: boolean;
    EditorGroupUndo: boolean;
    EditorHalfPageScroll: boolean;
    EditorSmartTabs: boolean;
    EditorTabIndent: boolean;
  end;

var
  Options: TOptions;

function AddMRUFile(const FileName: string): TMRUAction;
function HighlighterAttri(const H: TSynCustomHighlighter; AttriName: string): TSynHighlighterAttributes;
procedure UpdateTextAttri(const Syn: TCustomSynEdit; const I: TTextAttri);
procedure GetFontNames(const SL: TStrings);

implementation

function AddMRUFile(const FileName: string): TMRUAction;
var
  i, j: integer;
  s: string;
  f: boolean;
begin
  Result := maNone;
  f := true;
  i := Low(Options.MRUFiles);
  while f and (i<=High(Options.MRUFiles)) do
    if AnsiCompareText(Options.MRUFiles[i], FileName)=0 then
      f := false
    else
      Inc(i);
  if f then
  begin
    for i:=High(Options.MRUFiles) downto Low(Options.MRUFiles)+1 do
      Options.MRUFiles[i] := Options.MRUFiles[i-1];
    Options.MRUFiles[Low(Options.MRUFiles)] := FileName;
    Result := maInsert;
  end
  else
  if i<>Low(Options.MRUFiles) then
  begin
    s := Options.MRUFiles[i];
    for j:=i-1 downto Low(Options.MRUFiles) do
      Options.MRUFiles[j+1] := Options.MRUFiles[j];
    Options.MRUFiles[Low(Options.MRUFiles)] := s;
    Result := maReorder;
  end;
end;

function HighlighterAttri(const H: TSynCustomHighlighter; AttriName: string): TSynHighlighterAttributes;
var
  PI: PPropInfo;
begin
  Result := nil;
  PI := GetPropInfo(H, AttriName);
  if Assigned(PI) then
    Result := TSynHighlighterAttributes(GetOrdProp(H, PI));
end;

procedure UpdateTextAttri(const Syn: TCustomSynEdit; const I: TTextAttri);
var
  A: TSynHighlighterAttributes;
begin
  if Syn.Highlighter <> nil then
  begin
    A := HighlighterAttri(Syn.Highlighter, I.HighlighterAttriName);
    A.Foreground := I.Foreground;
    A.Background := I.Background;
    A.Style := I.Style;
  end;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
var
  S: TStrings;
  Temp: string;
begin
  Result := 0;
  if LogFont.lfPitchAndFamily and FIXED_PITCH<>0 then
  begin
    S := TStrings(Data);
    Temp := LogFont.lfFaceName;
    if (S.Count = 0) or (AnsiCompareText(S[S.Count-1], Temp) <> 0) then
      S.Add(Temp);
    Result := 1;
  end;
end;

procedure GetFontNames(const SL: TStrings);
var
  LogFont: TLogFont;
  DC: HDC;
begin
  SL.Clear;
  DC := GetDC(0);
  try
    FillChar(LogFont, sizeof(LogFont), 0);
    LogFont.lfCharSet := DEFAULT_CHARSET;
    LogFont.lfPitchAndFamily := FIXED_PITCH;
    EnumFontFamiliesEx(DC, LogFont, @EnumFontsProc, LongInt(SL), 0);
  finally
    ReleaseDC(0, DC);
  end;
end;

var
  ii: TTextAttriItem;

initialization
  Options.AutoSave := false;
  Options.AutoSaveInterval := 10;
  Options.MakeBackup := true;
  Options.GutterVisible := true;
  Options.GutterColor := clBtnFace;
  Options.GutterLineNumbers := false;
  Options.GutterDigitCount := 4;
  Options.GutterLeadingZeros := false;
  Options.GutterWidth := 40;
  Options.RightMarginVisible := true;
  Options.RightMargin := 80;
  Options.RightMarginColor := clSilver;
  Options.FontName := 'Courier New';
  Options.FontSize := 10;
  Options.EditorInsertMode := true;
  Options.EditorAutoIndent := true;
  Options.EditorGroupUndo := true;
  Options.EditorHalfPageScroll := false;
  Options.EditorSmartTabs := true;
  Options.EditorTabIndent := false;

  for ii := Low(TTextAttriItem) to High(TTextAttriItem) do
    with Options.TextAttri[ii] do
    begin
      ItemName := 'Undef';
      HighlighterAttriName := 'Unknown';
      DefaultForeground := clBlack;
      DefaultBackground := clWhite;
      DefaultStyle := [];
    end;

  with Options.TextAttri[taiWhiteSpace] do
  begin
    ItemName := 'WhiteSpace';
    HighlighterAttriName := 'WhitespaceAttri';
    DefaultForeground := clBlack;
    DefaultBackground := clWhite;
    DefaultStyle := [];
  end;
  with Options.TextAttri[taiComment] do
  begin
    ItemName := 'Comment';
    HighlighterAttriName := 'CommentAttri';
    DefaultForeground := clNavy;
    DefaultBackground := clWhite;
    DefaultStyle := [fsItalic];
  end;
  with Options.TextAttri[taiReservedWord] do
  begin
    ItemName := 'Reserved word';
    HighlighterAttriName := 'KeyAttri';
    DefaultForeground := clBlack;
    DefaultBackground := clWhite;
    DefaultStyle := [fsBold];
  end;
  with Options.TextAttri[taiRuleName] do
  begin
    ItemName := 'Rule name';
    HighlighterAttriName := 'RuleNameAttri';
    DefaultForeground := clNavy;
    DefaultBackground := clWhite;
    DefaultStyle := [];
  end;
  with Options.TextAttri[taiSetName] do
  begin
    ItemName := 'Set name';
    HighlighterAttriName := 'CharSetNameAttri';
    DefaultForeground := clBlue;
    DefaultBackground := clWhite;
    DefaultStyle := [];
  end;
  with Options.TextAttri[taiSymbol] do
  begin
    ItemName := 'Symbol';
    HighlighterAttriName := 'IdentifierAttri';
    DefaultForeground := clMaroon;
    DefaultBackground := clWhite;
    DefaultStyle := [];
  end;
  with Options.TextAttri[taiString] do
  begin
    ItemName := 'String';
    HighlighterAttriName := 'CharAttri';
    DefaultForeground := clBlue;
    DefaultBackground := clWhite;
    DefaultStyle := [];
  end;
  with Options.TextAttri[taiParameter] do
  begin
    ItemName := 'Parameter';
    HighlighterAttriName := 'StringAttri';
    DefaultForeground := clBlue;
    DefaultBackground := clWhite;
    DefaultStyle := [fsBold];
  end;
  with Options.TextAttri[taiCharSet] do
  begin
    ItemName := 'Char set';
    HighlighterAttriName := 'CharSetAttri';
    DefaultForeground := clTeal;
    DefaultBackground := clWhite;
    DefaultStyle := [];
  end;

  for ii := Low(TTextAttriItem) to High(TTextAttriItem) do
    with Options.TextAttri[ii] do
    begin
      Foreground := DefaultForeground;
      Background := DefaultBackground;
      Style := DefaultStyle;
    end;

end.
