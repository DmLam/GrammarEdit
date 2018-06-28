unit FormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StrUtils, SynUnicode, SynEdit, SynEditTypes, SynEditHighlighter,
  GrammarSyn, ExtCtrls, GrammarParser, StdCtrls, ComCtrls, TypInfo, ImgList, Menus,
  ActnList, Buttons, ToolWin, IniFiles, SynEditKeyCmds, CheckLst, Grids;

type
  TfmMain = class(TForm)
    Panel1: TPanel;
    pnlMain: TPanel;
    splMain: TSplitter;
    pnlEdit: TPanel;
    sbMain: TStatusBar;
    pnlToolBar: TPanel;
    ilTree: TImageList;
    mmMain: TMainMenu;
    alMain: TActionList;
    ilActions: TImageList;
    aNew: TAction;
    aOpen: TAction;
    aSave: TAction;
    aSaveAs: TAction;
    mFile: TMenuItem;
    miNew: TMenuItem;
    miOpen: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    odMain: TOpenDialog;
    sdMain: TSaveDialog;
    tbMain: TToolBar;
    tbNew: TToolButton;
    tbOpen: TToolButton;
    tbSave: TToolButton;
    tbSaveAs: TToolButton;
    ToolButton1: TToolButton;
    miRecentFiles: TMenuItem;
    aExit: TAction;
    N1: TMenuItem;
    miExit: TMenuItem;
    pmRecentFiles: TPopupMenu;
    aUndo: TAction;
    aRedo: TAction;
    mEdit: TMenuItem;
    miUndo: TMenuItem;
    miRedo: TMenuItem;
    tbUndo: TToolButton;
    tbRedo: TToolButton;
    aFind: TAction;
    aFindNext: TAction;
    aReplace: TAction;
    N2: TMenuItem;
    miFind: TMenuItem;
    miFindNext: TMenuItem;
    miReplace: TMenuItem;
    fdMain: TFindDialog;
    rdMain: TReplaceDialog;
    ToolButton2: TToolButton;
    tbFind: TToolButton;
    tbFindNext: TToolButton;
    tbReplace: TToolButton;
    aCut: TAction;
    aCopy: TAction;
    aPaste: TAction;
    aDelete: TAction;
    aSelectAll: TAction;
    N3: TMenuItem;
    miCut: TMenuItem;
    miCopy: TMenuItem;
    miPaste: TMenuItem;
    miDelete: TMenuItem;
    miSelectAll: TMenuItem;
    aCommonOptions: TAction;
    tAutoSave: TTimer;
    mOptions: TMenuItem;
    miCommonOptions: TMenuItem;
    aColorOptions: TAction;
    miColorOptions: TMenuItem;
    aDisplayOptions: TAction;
    miDisplayOptions: TMenuItem;
    aAbout: TAction;
    mHelp: TMenuItem;
    miAbout: TMenuItem;
    pmItems: TPopupMenu;
    aSelectItemRules: TAction;
    miItemsSelectItemRules: TMenuItem;
    aDeselectItemRules: TAction;
    miItemsDeselectItemRules: TMenuItem;
    pmEdit: TPopupMenu;
    miEditSelectItemRules: TMenuItem;
    miEditDeselectItemRules: TMenuItem;
    aFindItemDef: TAction;
    miFindItemDef: TMenuItem;
    pnlExplorer: TPanel;
    pnlItems: TPanel;
    tvItems: TTreeView;
    pnlSelectedItems: TPanel;
    splExplorer: TSplitter;
    lbSelectedItems: TListBox;
    pmSelectedItems: TPopupMenu;
    miListDeselectItemRules: TMenuItem;
    pnlEditor: TPanel;
    pnlErrors: TPanel;
    splErrors: TSplitter;
    pcEditors: TPageControl;
    tsEditor: TTabSheet;
    seMain: TSynEdit;
    lbErrors: TListBox;
    aCompile: TAction;
    tsRules: TTabSheet;
    pnRules: TPanel;
    hcRules: THeaderControl;
    sgRules: TStringGrid;
    procedure seMainStatusChange(Sender: TObject;
      Changes: TSynStatusChanges);
    procedure seMainChange(Sender: TObject);
    procedure seMainPaintTransient(Sender: TObject; Canvas: TCanvas;
      TransientType: TTransientType);
    procedure seMainKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure seMainKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure seMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure seMainClick(Sender: TObject);
    procedure tvItemsDblClick(Sender: TObject);
    procedure aOpenExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aNewExecute(Sender: TObject);
    procedure aSaveAsExecute(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
    procedure aUndoUpdate(Sender: TObject);
    procedure aRedoUpdate(Sender: TObject);
    procedure aUndoExecute(Sender: TObject);
    procedure aRedoExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure aFindExecute(Sender: TObject);
    procedure fdMainFind(Sender: TObject);
    procedure aReplaceExecute(Sender: TObject);
    procedure rdMainReplace(Sender: TObject);
    procedure rdMainFind(Sender: TObject);
    procedure aFindNextExecute(Sender: TObject);
    procedure aCutUpdate(Sender: TObject);
    procedure aCopyUpdate(Sender: TObject);
    procedure aPasteExecute(Sender: TObject);
    procedure aCutExecute(Sender: TObject);
    procedure aCopyExecute(Sender: TObject);
    procedure aPasteUpdate(Sender: TObject);
    procedure aDeleteUpdate(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure aSelectAllExecute(Sender: TObject);
    procedure tAutoSaveTimer(Sender: TObject);
    procedure aCommonOptionsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure aColorOptionsExecute(Sender: TObject);
    procedure aDisplayOptionsExecute(Sender: TObject);
    procedure aAboutExecute(Sender: TObject);
    procedure seMainSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure aSelectItemRulesExecute(Sender: TObject);
    procedure aDeselectItemRulesExecute(Sender: TObject);
    procedure seMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvItemsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure aFindItemDefUpdate(Sender: TObject);
    procedure aFindItemDefExecute(Sender: TObject);
    procedure aSelectItemRulesUpdate(Sender: TObject);
    procedure aDeselectItemRulesUpdate(Sender: TObject);
    procedure lbSelectedItemsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure aCompileUpdate(Sender: TObject);
    procedure aCompileExecute(Sender: TObject);
    procedure lbErrorsDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure hcRulesSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure FormResize(Sender: TObject);
  private
    function GetModified: boolean;
    procedure SetModified(const Value: boolean);
    function IniName: string;
    procedure UpdateOptions;
    procedure SaveOptions;
    procedure LoadOptions;
    procedure CheckFileModified;
    procedure OpenFile(const FileName: string);
    procedure SaveFile(const FileName: string);
    procedure NewFile;
    procedure AddMRUFile(const FileName: string; const MenuFirst: boolean);
    procedure OpenMRUFile(Sender: TObject);
    procedure UpdateCaption(FileName: string);
    procedure UpdateInsertStatus;

  private
    tnRules, tnSymbols, tnSets, tnUndefs: TTreeNode;
    FParser: TGrammarParser;
    FCtrlLine: integer;
    FCtrlOnToken: boolean;
    FSelectedItems: TStringList;

    procedure Parse;
    procedure OnParse(Sender: TObject);
    procedure DrawParseTree;

    procedure OnSelectedItemsChange(Sender: TObject);
    function GetCursorPosLine: TDisplayCoord;
    function TokenAtPos(const BC: TBufferCoord): string;
    function FindItemDef(const Name: string; const IncludeUndef: boolean=false): TGrammarItem;
    function TokenStart(const DC: TDisplayCoord; var Token: string): integer;

  protected
    procedure UpdateModifiedStatus;

    property Modified: boolean
      read GetModified write SetModified;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fmMain: TfmMain;

implementation

uses UnitUtils, FormSettings, FormAbout, Token, Symbol;

{$R *.dfm}

const
  MAINFORM_CAPTION = 'Grammar editor';

{ TfmMain }

constructor TfmMain.Create(AOwner: TComponent);
begin
  inherited;

  tnRules := tvItems.Items[0];
  tnSymbols := tvItems.Items[1];
  tnSets := tvItems.Items[2];
  tnUndefs := tvItems.Items[3];
  FParser := TGrammarParser.Create;
  FParser.OnParse := OnParse;
  FSelectedItems := TStringList.Create;
  FSelectedItems.Duplicates := dupIgnore;
  FSelectedItems.OnChange := OnSelectedItemsChange;

  LoadOptions;
  FCtrlLine := -1;
  FCtrlOnToken := false;
  seMain.Highlighter := TGrammarSyn.Create(Self);
  FParser.Parse(seMain.Text);
  UpdateCaption(sdMain.FileName);
  UpdateInsertStatus;
end;

destructor TfmMain.Destroy;
begin
  FSelectedItems.Free;
  FParser.OnParse := nil;
  FParser.Shutdown;
  SaveOptions;
  FParser.Free;

  inherited;
end;

procedure TfmMain.seMainStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  sbMain.Panels[0].Text := Format('%d:%d', [seMain.CaretY, seMain.CaretX]);
end;

procedure TfmMain.OnParse(Sender: TObject);
var
  i: integer;
  Node: TTreeNode;
  RulesExp, TermsExp, SetsExp, UndefsExp: boolean;
begin
  RulesExp := tnRules.Expanded;
  TermsExp := tnSymbols.Expanded;
  SetsExp := tnSets.Expanded;
  UndefsExp := tnUndefs.Expanded;
  tvItems.Items.BeginUpdate;
  try
    tnRules.DeleteChildren;
    tnSymbols.DeleteChildren;
    tnSets.DeleteChildren;
    tnUndefs.DeleteChildren;
    with FParser.Grammar, tvItems.Items do
    begin
      for i:=0 to RuleCount-1 do
      begin
        Node := AddChild(tnRules, Rules[i].Name);
        Node.ImageIndex := 3;
        Node.SelectedIndex := 4;
        Node.Data := Rules[i];
      end;
      tnRules.Expanded := RulesExp;
      for i:=0 to TerminalCount-1 do
      begin
        Node := AddChild(tnSymbols, Terminals[i].Name);
        Node.ImageIndex := 3;
        Node.SelectedIndex := 4;
        Node.Data := Terminals[i];
      end;
      tnSymbols.Expanded := TermsExp;
      for i:=0 to SetCount-1 do
      begin
        Node := AddChild(tnSets, Sets[i].Name);
        Node.ImageIndex := 3;
        Node.SelectedIndex := 4;
        Node.Data := Sets[i];
      end;
      tnSets.Expanded := SetsExp;
      for i:= 0 to ItemCount-1 do
        if (RuleByName(Items[i].Name)=nil) and
           (TerminalByName(Items[i].Name)=nil) and
           (SetByName(Items[i].Name)=nil) then
        begin
          Node := AddChild(tnUndefs, Items[i].Name);
          case Items[i].Kind of
            gikRuleName:
            begin
              Node.ImageIndex := 0;
              Node.SelectedIndex := 0;
            end;
            gikTerminalName:
            begin
              Node.ImageIndex := 1;
              Node.SelectedIndex := 1;
            end;
            gikSetName:
            begin
              Node.ImageIndex := 2;
              Node.SelectedIndex := 2;
            end;
            else
              begin
                Node.ImageIndex := 3;
                Node.SelectedIndex := 3;
              end;
          end;
          Node.Data := Items[i];
        end;
      tnUndefs.Expanded := UndefsExp;
    end;
    if FParser.ErrorCount>0 then
    begin
      pnlErrors.Visible := true;
      splErrors.Visible := true;
      lbErrors.Items.BeginUpdate;
      try
        lbErrors.Items.Clear;
        for i:=0 to FParser.ErrorCount-1 do
          lbErrors.Items.AddObject(FParser.Error[i], pointer(FParser.ErrorLine[i]));
      finally
        lbErrors.Items.EndUpdate;
      end;
    end
    else
    begin
      splErrors.Visible := false;
      pnlErrors.Visible := false;
    end;
  finally
    tvItems.Items.EndUpdate;
  end;
end;

procedure TfmMain.seMainChange(Sender: TObject);
begin
  Parse;
  UpdateModifiedStatus;
end;

procedure TfmMain.seMainPaintTransient(Sender: TObject; Canvas: TCanvas;
  TransientType: TTransientType);

  function CharToPixels(DC: TDisplayCoord): TDisplayCoord;
  var
    P: TPoint;
  begin
    Result := DC;
    P := seMain.RowColumnToPixels(Result);
    Result := DisplayCoord(P.X, P.Y);
  end;

var
  P: TPoint;
  DC: TDisplayCoord;
  Attri: TSynHighlighterAttributes;
  s: UnicodeString;
  Token: string;
begin
  if (FCtrlLine<>-1) and (TransientType = ttAfter) then
  begin
    GetCursorPos(P);
    P := seMain.ScreenToClient(P);

    DC := seMain.PixelsToRowColumn(P.X, P.Y);
    seMain.GetHighlighterAttriAtRowCol(TBufferCoord(DC), s, Attri);
    DC.Column := TokenStart(DC, Token);
    if (P.X>0) and (FindItemDef(Token)<>nil) then
    begin
      DC := CharToPixels(DC);
      seMain.Canvas.Brush.Style := bsClear;
      seMain.Canvas.Font.Assign(seMain.Font);
      seMain.Canvas.Font.Color := clRed;
      seMain.Canvas.Font.Style := Attri.Style+[fsUnderline];
      seMain.Canvas.TextOut(DC.Column, DC.Row, Token);
    end;
  end;
end;

procedure TfmMain.seMainKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  DC: TDisplayCoord;
  s: string;
begin
  if ssCtrl in Shift then
  begin
    DC := GetCursorPosLine;
    if (TokenStart(DC, s)<>0) and (FindItemDef(TokenAtPos(BufferCoord(DC.Column, DC.Row)))<>nil) then
    begin
      FCtrlOnToken := true;
      FCtrlLine := DC.Row;
      seMain.Cursor := crHandPoint;
      seMain.InvalidateLine(FCtrlLine);
    end;
  end;
end;

procedure TfmMain.seMainKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (FCtrlLine<>-1) and not(ssCtrl in Shift) then
  begin
    seMain.Cursor := crIBeam;
    FCtrlLine := -1;
    seMain.InvalidateLine(GetCursorPosLine.Row);
    FCtrlOnToken := false;
  end;
  if (Shift=[]) and (Key=VK_INSERT) then
    UpdateInsertStatus; 
end;

procedure TfmMain.seMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  DC: TDisplayCoord;
  n: integer;
  s: string;
  IsToken: boolean;
begin
  n := 0;
  if FCtrlLine<>-1 then
  begin
    DC := GetCursorPosLine;
    IsToken := TokenStart(DC, s)<>0;
    if (IsToken<>FCtrlOnToken) or (FCtrlLine<>DC.Row) then
    begin
      n := FCtrlLine;
      seMain.InvalidateLine(n);
      FCtrlOnToken := IsToken;
      FCtrlLine := DC.Row;
    end;
    if not IsToken then
      seMain.Cursor := crIBeam;
    if IsToken and (n<>FCtrlLine) and (FindItemDef(TokenAtPos(BufferCoord(DC.Column, DC.Row)))<>nil) then
    begin
      FCtrlLine := DC.Row;
      seMain.Cursor := crHandPoint;
      seMain.InvalidateLine(FCtrlLine);
    end;
  end;
end;

procedure TfmMain.seMainClick(Sender: TObject);
var
  DC: TDisplayCoord;
  I: TGrammarItem;
begin
  if FCtrlLine<>-1 then
  begin
    DC := GetCursorPosLine;
    I := FindItemDef(TokenAtPos(BufferCoord(DC.Column, DC.Row)));
    if Assigned(I) then
      seMain.CaretXY := BufferCoord(I.StartPos.X, I.StartPos.Y+1);
  end;
end;

function TfmMain.GetCursorPosLine: TDisplayCoord;
var
  P: TPoint;
begin
  GetCursorPos(P);
  P := seMain.ScreenToClient(P);
  Result := seMain.PixelsToRowColumn(P.X, P.Y);
end;

function TfmMain.TokenAtPos(const BC: TBufferCoord): string;
var
  Attri: TSynHighlighterAttributes;
  Token: UnicodeString;
begin
  seMain.GetHighlighterAttriAtRowCol(BC, Token, Attri);
  Result := Trim(Token);
end;

function TfmMain.FindItemDef(const Name: string; const IncludeUndef: boolean=false): TGrammarItem;
var
  i: integer;
begin
  Result := FParser.Grammar.RuleByName(Name);
  if not Assigned(Result) then
  begin
    Result := FParser.Grammar.TerminalByName(Name);
    if not Assigned(Result) then
      Result := FParser.Grammar.SetByName(Name);
      if not(Assigned(Result)) and IncludeUndef then
      begin
        i := FParser.Grammar.ItemByName(Name);
        if i>=0 then
          Result := FParser.Grammar.Items[i];
      end;
  end;
end;

function TfmMain.TokenStart(const DC: TDisplayCoord; var Token: string): integer;
var
  i, l: integer;
begin
  Token := TokenAtPos(BufferCoord(DC.Column, DC.Row));
  l := Length(Token);
  if l>0 then
  begin
    i := 0;
    repeat
      i := PosEx(Token, seMain.Lines[DC.Row-1], i+1);
    until i+l>=DC.Column;
    Result := i;
  end
  else
    Result := 0;
end;

procedure TfmMain.tvItemsDblClick(Sender: TObject);
begin
  if Assigned(tvItems.Selected.Data) then
  begin
    seMain.CaretX := TGrammarItem(tvItems.Selected.Data).StartPos.X+1;
    seMain.CaretY := TGrammarItem(tvItems.Selected.Data).StartPos.Y+1;
    seMain.SetFocus;
  end;
end;

procedure TfmMain.aOpenExecute(Sender: TObject);
begin
  CheckFileModified;
  with odMain do
    if odMain.Execute then
      OpenFile(odMain.FileName);
end;

procedure TfmMain.Parse;
begin
  FParser.Parse(seMain.Text);
end;

procedure TfmMain.aSaveExecute(Sender: TObject);
begin
  with sdMain do
  begin
    if FileName='' then
      if not Execute then
        Abort;
    if FileName<>'' then
      SaveFile(FileName);
  end;
end;

function TfmMain.GetModified: boolean;
begin
  Result := seMain.Modified;
end;

procedure TfmMain.hcRulesSectionResize(HeaderControl: THeaderControl;
  Section: THeaderSection);
//var
//  i, j, w, r: integer;
begin
{
  if Section=nil then
  begin
    for i := 0 to hcRules.Sections.Count - 1 do
    begin
      w := 0;
      for j := 0 to hcRules.Sections.Count-1 do
        if j<>i then
          Inc(w, hcRules.Sections[j].MinWidth+1);
      hcRules.Sections[i].MaxWidth := hcRules.Width-w;
    end;

    w := 0;
    for i := 0 to hcRules.Sections.Count - 2 do
      w := w+hcRules.Sections[i].Width+1;
    hcRules.Sections[hcRules.Sections.Count-1].Width := hcRules.Width-w;
  end
  else
  begin
    w := 0;
    for i := 0 to hcRules.Sections.Count - 1 do
      if hcRules.Sections[i]<>Section then
        w := w+hcRules.Sections[i].Width;
    r := w-(hcRules.Width-Section.Width);
    j := r div (hcRules.Sections.Count-1);
    w := 0;
    for i := 0 to hcRules.Sections.Count - 1 do
      if hcRules.Sections[i]<>Section then
      begin
        hcRules.Sections[i].Width := hcRules.Sections[i].Width-j;
        w := w+j;
      end;
    if w<>r then
    begin
      i := 0;
      while i<hcRules.Sections.Count do
      begin
        if (hcRules.Sections[i]<>Section) and (hcRules.Sections[i].Width-r+w>=hcRules.Sections[i].MinWidth) then
        begin
          hcRules.Sections[i].Width := hcRules.Sections[i].Width-r+w;
          i := hcRules.Sections.Count-1;
        end;
        Inc(i);
      end;
    end;
  end;

  w := 0;
  for i := 0 to hcRules.Sections.Count - 2 do
  begin
    sgRules.ColWidths[i] := hcRules.Sections[i].Width-2;
    w := w+hcRules.Sections[i].Width;
  end;
  sgRules.ColWidths[hcRules.Sections.Count-1] := hcRules.Width-w-2-GetSystemMetrics(SM_CXVSCROLL);
}  
end;

procedure TfmMain.SetModified(const Value: boolean);
begin
  seMain.Modified := Value;
  UpdateModifiedStatus;
end;

procedure TfmMain.UpdateModifiedStatus;
begin
  case Modified of
    true: sbMain.Panels[1].Text := 'Modified';
    false: sbMain.Panels[1].Text := '';
  end;
  aUndo.Update;
  aRedo.Update;
end;

procedure TfmMain.aNewExecute(Sender: TObject);
begin
  NewFile;
end;

procedure TfmMain.aSaveAsExecute(Sender: TObject);
begin
  with sdMain do
    if Execute then aSave.Execute; 
end;

procedure TfmMain.LoadOptions;
var
  SL: TStringList;
  i: integer;
  ii: TTextAttriItem;
  s: string;
begin
  with TIniFile.Create(IniName) do
  try
    SL := TStringList.Create;
    try
      ReadSectionValues('MRU', SL);
      while SL.Count>High(Options.MRUFiles) do
        SL.Delete(High(Options.MRUFiles));
      if SL.Count=0 then
        miRecentFiles.Enabled := false
      else
      for i:=0 to SL.Count-1 do
        AddMRUFile(SL.Values[SL.Names[i]], false);

      Left := ReadInteger('Window', 'Left', Left);
      Top := ReadInteger('Window', 'Top', Top);
      Width := ReadInteger('Window', 'Width', Width);
      Height := ReadInteger('Window', 'Height', Height);
      pnlExplorer.Width := ReadInteger('Window', 'EditSplit', pnlExplorer.Width);
      pnlSelectedItems.Height := ReadInteger('Window', 'ExplorerSplit', pnlSelectedItems.Height);
      pnlErrors.Height := ReadInteger('Window', 'ErrorsSplit', pnlErrors.Height);

      s := ReadString('Editor', 'FileName', '');
      if (s<>'') and FileExists(s) then
        OpenFile(s);
      seMain.CaretX := ReadInteger('Editor', 'CaretX', 1);
      seMain.CaretY := ReadInteger('Editor', 'CaretY', 1);
      seMain.TopLine := ReadInteger('Editor', 'TopLine', 1);

      Options.AutoSave := ReadBool('Options', 'AutoSave', Options.AutoSave);
      Options.AutoSaveInterval := ReadInteger('Options', 'AutoSaveInterval', Options.AutoSaveInterval);
      Options.MakeBackup := ReadBool('Options', 'MakeBackup', Options.MakeBackup);

      ReadBool('Options.Common', 'AutoSave', Options.AutoSave);
      ReadInteger('Options.Common', 'AutoSaveInterval', Options.AutoSaveInterval);
      ReadBool('Options.Common', 'MakeBackup', Options.MakeBackup);

      Options.GutterVisible := ReadBool('Options.Display', 'GutterVisible', Options.GutterVisible);
      Options.GutterColor := ReadInteger('Options.Display', 'GutterColor', Options.GutterColor);
      Options.GutterLineNumbers := ReadBool('Options.Display', 'GutterLineNumbers', Options.GutterLineNumbers);
      Options.GutterLeadingZeros := ReadBool('Options.Display', 'GutterLeadingZeros', Options.GutterLeadingZeros);
      Options.GutterDigitCount := ReadInteger('Options.Display', 'GutterDigitCount', Options.GutterDigitCount);
      Options.GutterWidth := ReadInteger('Options.Display', 'GutterWidth', Options.GutterWidth);
      Options.RightMarginVisible := ReadBool('Options.Display', 'RightMarginVisible', Options.RightMarginVisible);
      Options.RightMargin := ReadInteger('Options.Display', 'RightMargin', Options.RightMargin);
      Options.RightMarginColor := ReadInteger('Options.Display', 'RightMarginColor', Options.RightMarginColor);
      Options.FontName := ReadString('Options.Display', 'FontName', Options.FontName);
      Options.FontSize := ReadInteger('Options.Display', 'FontSize', Options.FontSize);

      Options.EditorAutoIndent := ReadBool('Options.Editor', 'AutoIndent', Options.EditorAutoIndent);
      Options.EditorGroupUndo := ReadBool('Options.Editor', 'GroupUndo', Options.EditorGroupUndo);
      Options.EditorHalfPageScroll := ReadBool('Options.Editor', 'HalfPageScroll', Options.EditorHalfPageScroll);
      Options.EditorInsertMode := ReadBool('Options.Editor', 'InsertMode', Options.EditorInsertMode);
      Options.EditorSmartTabs := ReadBool('Options.Editor', 'SmartTabs', Options.EditorSmartTabs);
      Options.EditorTabIndent := ReadBool('Options.Editor', 'TabIndent', Options.EditorTabIndent);

      for ii:=Low(TTextAttriItem) to High(TTextAttriItem) do
      begin
        Options.TextAttri[ii].Foreground := ReadInteger('Options.Color.'+Options.TextAttri[ii].ItemName, 'Foreground', Options.TextAttri[ii].DefaultForeground);
        Options.TextAttri[ii].Background := ReadInteger('Options.Color.'+Options.TextAttri[ii].ItemName, 'Background', Options.TextAttri[ii].DefaultBackground);
        if ReadBool('Options.Color.'+Options.TextAttri[ii].ItemName, 'Bold', fsBold in Options.TextAttri[ii].DefaultStyle) then
          Options.TextAttri[ii].Style := Options.TextAttri[ii].Style+[fsBold]
        else
          Options.TextAttri[ii].Style := Options.TextAttri[ii].Style-[fsBold];
        if ReadBool('Options.Color.'+Options.TextAttri[ii].ItemName, 'Italic', fsItalic in Options.TextAttri[ii].DefaultStyle) then
          Options.TextAttri[ii].Style := Options.TextAttri[ii].Style+[fsItalic]
        else
          Options.TextAttri[ii].Style := Options.TextAttri[ii].Style-[fsItalic];
        if ReadBool('Options.Color.'+Options.TextAttri[ii].ItemName, 'Underline', fsUnderline in Options.TextAttri[ii].DefaultStyle) then
          Options.TextAttri[ii].Style := Options.TextAttri[ii].Style+[fsUnderline]
        else
          Options.TextAttri[ii].Style := Options.TextAttri[ii].Style-[fsUnderline];
      end;
    finally
      SL.Free;
    end;
  finally
    Free;
  end;
end;

procedure TfmMain.SaveOptions;
var
  i: integer;
  ii: TTextAttriItem;
begin
  with TIniFile.Create(IniName) do
  try
    EraseSection('MRU');
    for i:=1 to High(Options.MRUFiles) do
      if Options.MRUFiles[i]<>'' then
        WriteString('MRU', IntToStr(i), Options.MRUFiles[i]);

    WriteInteger('Window', 'Left', Left);
    WriteInteger('Window', 'Top', Top);
    WriteInteger('Window', 'Width', Width);
    WriteInteger('Window', 'Height', Height);
    WriteInteger('Window', 'EditSplit', pnlExplorer.Width);
    WriteInteger('Window', 'ExplorerSplit', pnlSelectedItems.Height);
    WriteInteger('Window', 'ErrorsSplit', pnlErrors.Height);

    WriteString('Editor', 'FileName', sdMain.FileName);
    WriteInteger('Editor', 'CaretX', seMain.CaretX);
    WriteInteger('Editor', 'CaretY', seMain.CaretY);
    WriteInteger('Editor', 'TopLine', seMain.TopLine);

    WriteBool('Options', 'AutoSave', Options.AutoSave);
    WriteInteger('Options', 'AutoSaveInterval', Options.AutoSaveInterval);
    WriteBool('Options', 'MakeBackup', Options.MakeBackup);

    WriteBool('Options.Display', 'GutterVisible', Options.GutterVisible);
    WriteInteger('Options.Display', 'GutterColor', Options.GutterColor);
    WriteBool('Options.Display', 'GutterLineNumbers', Options.GutterLineNumbers);
    WriteBool('Options.Display', 'GutterLeadingZeros', Options.GutterLeadingZeros);
    WriteInteger('Options.Display', 'GutterDigitCount', Options.GutterDigitCount);
    WriteInteger('Options.Display', 'GutterWidth', Options.GutterWidth);
    WriteBool('Options.Display', 'RightMarginVisible', Options.RightMarginVisible);
    WriteInteger('Options.Display', 'RightMargin', Options.RightMargin);
    WriteInteger('Options.Display', 'RightMarginColor', Options.RightMarginColor);
    WriteString('Options.Display', 'FontName', Options.FontName);
    WriteInteger('Options.Display', 'FontSize', Options.FontSize);

    WriteBool('Options.Editor', 'AutoIndent', Options.EditorAutoIndent);
    WriteBool('Options.Editor', 'GroupUndo', Options.EditorGroupUndo);
    WriteBool('Options.Editor', 'HalfPageScroll', Options.EditorHalfPageScroll);
    WriteBool('Options.Editor', 'InsertMode', Options.EditorInsertMode);
    WriteBool('Options.Editor', 'SmartTabs', Options.EditorSmartTabs);
    WriteBool('Options.Editor', 'TabIndent', Options.EditorTabIndent);

    for ii:=Low(TTextAttriItem) to High(TTextAttriItem) do
    begin
      WriteInteger('Options.Color.'+Options.TextAttri[ii].ItemName, 'Foreground', Options.TextAttri[ii].Foreground);
      WriteInteger('Options.Color.'+Options.TextAttri[ii].ItemName, 'Background', Options.TextAttri[ii].Background);
      WriteBool('Options.Color.'+Options.TextAttri[ii].ItemName, 'Bold', fsBold in Options.TextAttri[ii].Style);
      WriteBool('Options.Color.'+Options.TextAttri[ii].ItemName, 'Italic', fsItalic in Options.TextAttri[ii].Style);
      WriteBool('Options.Color.'+Options.TextAttri[ii].ItemName, 'Underline', fsUnderline in Options.TextAttri[ii].Style);
    end;
    UpdateFile;
  finally
    Free;
  end;
end;

function TfmMain.IniName: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

procedure TfmMain.AddMRUFile(const FileName: string; const MenuFirst: boolean);
var
  Item: TMenuItem;
  i: integer;
begin
  case UnitUtils.AddMRUFile(FileName) of
    maInsert:
    begin
      while miRecentFiles.Count>High(Options.MRUFiles) do
        miRecentFiles.Delete(High(Options.MRUFiles));
      Item := TMenuItem.Create(Self);
      Item.AutoHotkeys :=  maManual;
      Item.Caption := FileName;
      Item.OnClick := OpenMRUFile;
      if MenuFirst then
        miRecentFiles.Insert(0, Item)
      else
        miRecentFiles.Add(Item);
      miRecentFiles.Enabled := true;
      Item := TMenuItem.Create(Self);
      Item.AutoHotkeys :=  maManual;
      Item.Caption := FileName;
      Item.OnClick := OpenMRUFile;
      if MenuFirst then
        pmRecentFiles.Items.Insert(0, Item)
      else
        pmRecentFiles.Items.Add(Item);
    end;
    maReorder:
    begin
      i := miRecentFiles.Count-1;
      while (i>=0) and (AnsiCompareText(miRecentFiles.Items[i].Caption, FileName)<>0) do
        Dec(i);
      if i>=0 then
        miRecentFiles.Items[i].MenuIndex := 0;

      i := pmRecentFiles.Items.Count-1;
      while (i>=0) and (AnsiCompareText(pmRecentFiles.Items[i].Caption, FileName)<>0) do
        Dec(i);
      if i>=0 then
        pmRecentFiles.Items[i].MenuIndex := 0;
    end;
  end;
end;

procedure TfmMain.OpenMRUFile(Sender: TObject);
begin
  if Sender is TMenuItem then
    with Sender as TMenuItem do
    begin
      odMain.FileName := Caption;
      OpenFile(odMain.FileName);
    end;
end;

procedure TfmMain.OpenFile(const FileName: string);
begin
  seMain.Lines.LoadFromFile(FileName);
  AddMRUFile(FileName, true);
  odMain.FileName := FileName;
  sdMain.FileName := FileName;
  UpdateCaption(FileName);
  Modified := false;
  tnRules.Expanded := false;
  tnSymbols.Expanded := false;
  tnSets.Expanded := false;
  tnUndefs.Expanded := false;
  Parse;
end;

procedure TfmMain.SaveFile(const FileName: string);
var
  Ext: string;
begin
  if Options.MakeBackup and FileExists(FileName) then
  begin
    Ext := ExtractFileExt(FileName);
    if (Ext<>'') and (Ext[1]='.') then
      Ext := Copy(Ext, 1, Length(Ext)-1);
    RenameFile(FileName, ChangeFileExt(FileName, '.~'+Ext));
  end;
  seMain.Lines.SaveToFile(FileName);
  UpdateCaption(FileName);
  AddMRUFile(FileName, true);
  Modified := false;
end;

procedure TfmMain.UpdateCaption(FileName: string);
begin
  if FileName='' then
    FileName := 'untitled';
  Caption := MAINFORM_CAPTION+' - ['+FileName+']';
end;

procedure TfmMain.NewFile;
begin
  CheckFileModified;
  seMain.Lines.Clear;
  UpdateCaption('');
  Modified := false;
end;

procedure TfmMain.aExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.aUndoUpdate(Sender: TObject);
begin
  aUndo.Enabled := seMain.CanUndo;
end;

procedure TfmMain.aRedoUpdate(Sender: TObject);
begin
  aRedo.Enabled := seMain.CanRedo;
end;

procedure TfmMain.aUndoExecute(Sender: TObject);
begin
  seMain.Undo;
end;

procedure TfmMain.aRedoExecute(Sender: TObject);
begin
  seMain.Redo;
end;

procedure TfmMain.CheckFileModified;
begin
  if Modified and
    (MessageDlg('File have been changed. Do you want to save it?', mtWarning, [mbYes, mbNo], 0)=mrYes) then
    aSave.Execute;
end;

procedure TfmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  r: TModalResult;
begin
  if Modified then
  begin
    r := MessageDlg('File have been changed. Do you want to save it?', mtWarning, [mbYes, mbNo, mbCancel], 0);
    case r of
      mrYes: aSave.Execute;
      mrCancel: CanClose := false;
    end;
  end;
end;

procedure TfmMain.UpdateInsertStatus;
var
  s: string;
begin
  if seMain.InsertMode then
    s := 'Insert'
  else
    s := 'Overwrite';

  sbMain.Panels[2].Text := s;
end;

procedure TfmMain.aFindExecute(Sender: TObject);
var
  s: string;
begin
  s := TokenAtPos(seMain.CaretXY);
  if s<>'' then
    fdMain.FindText := s;
  fdMain.Execute;
end;

procedure TfmMain.fdMainFind(Sender: TObject);
var
  SO: TSynSearchOptions;
begin
  with fdMain do
  begin
      SO := [];
    if not(frDown in Options) then
      SO := SO+[ssoBackwards];
    if frMatchCase in Options then
      SO := SO+[ssoMatchCase];
    if frWholeWord in Options then
      SO := SO+[ssoWholeWord];

    seMain.SearchReplace(fdMain.FindText, '', SO);
  end;
end;

procedure TfmMain.aReplaceExecute(Sender: TObject);
var
  s: string;
  DC: TDisplayCoord;
begin
  DC := GetCursorPosLine;
  s := TokenAtPos(BufferCoord(DC.Column, DC.Row));
  if s<>'' then
    rdMain.FindText := s;
  rdMain.Execute;
end;

procedure TfmMain.rdMainReplace(Sender: TObject);
var
  SO: TSynSearchOptions;
begin
  if seMain.SelStart<>seMain.SelEnd then
  begin
    SO := [ssoReplace, ssoSelectedOnly];
    if not(frDown in rdMain.Options) then
      SO := SO+[ssoBackwards];
    if frMatchCase in rdMain.Options then
      SO := SO+[ssoMatchCase];
    if frWholeWord in rdMain.Options then
      SO := SO+[ssoWholeWord];

    seMain.SearchReplace(rdMain.FindText, rdMain.ReplaceText, SO);
  end;
end;

procedure TfmMain.rdMainFind(Sender: TObject);
var
  SO: TSynSearchOptions;
begin
  with rdMain do
  begin
    SO := [];
    if not(frDown in Options) then
      SO := SO+[ssoBackwards];
    if frMatchCase in Options then
      SO := SO+[ssoMatchCase];
    if frWholeWord in Options then
      SO := SO+[ssoWholeWord];

    seMain.SearchReplace(rdMain.FindText, '', SO);
  end;
end;

procedure TfmMain.aFindNextExecute(Sender: TObject);
var
  SO: TSynSearchOptions;
begin
  if fdMain.FindText='' then
    aFind.Execute
  else
  begin
    with fdMain do
    begin
        SO := [];
      if not(frDown in Options) then
        SO := SO+[ssoBackwards];
      if frMatchCase in Options then
        SO := SO+[ssoMatchCase];
      if frWholeWord in Options then
        SO := SO+[ssoWholeWord];

      seMain.SearchReplace(fdMain.FindText, '', SO);
    end;
  end;
end;

procedure TfmMain.aCutUpdate(Sender: TObject);
begin
  aCut.Enabled := seMain.SelStart<>seMain.SelEnd;
end;

procedure TfmMain.aCopyUpdate(Sender: TObject);
begin
  aCopy.Enabled := seMain.SelStart<>seMain.SelEnd;      
end;

procedure TfmMain.aPasteExecute(Sender: TObject);
begin
  seMain.PasteFromClipboard;
end;

procedure TfmMain.aCutExecute(Sender: TObject);
begin
  seMain.CutToClipboard;
end;

procedure TfmMain.aCopyExecute(Sender: TObject);
begin
  seMain.CopyToClipboard;
end;

procedure TfmMain.aPasteUpdate(Sender: TObject);
begin
  aCut.Enabled := seMain.CanPaste;
end;

procedure TfmMain.aDeleteUpdate(Sender: TObject);
begin
  aDelete.Enabled := seMain.SelStart<>seMain.SelEnd;
end;

procedure TfmMain.aDeleteExecute(Sender: TObject);
begin
  seMain.CommandProcessor(ecDeleteChar, ' ', nil);
end;

procedure TfmMain.aSelectAllExecute(Sender: TObject);
begin
  seMain.SelectAll;
end;

procedure TfmMain.tAutoSaveTimer(Sender: TObject);
begin
  if Screen.ActiveForm=Self then
  begin
    tAutoSave.Enabled := false;
    aSave.Execute;
    tAutoSave.Enabled := true;
  end;  
end;

procedure TfmMain.aCommonOptionsExecute(Sender: TObject);
begin
  if RunOptionsDialog(odpCommon) then
  begin
    UpdateOptions;
    seMain.Invalidate;
  end;
end;

procedure TfmMain.UpdateOptions;
var
  i: TTextAttriItem;
begin
  tAutoSave.Interval := Options.AutoSaveInterval*60*1000;
  if Options.AutoSave then
    tAutoSave.Enabled := true;
  for i := Low(TTextAttriItem) to High(TTextAttriItem) do
    UpdateTextAttri(seMain, Options.TextAttri[i]);
  with Options, seMain do
  begin
    Gutter.Visible := GutterVisible;
    GutterColor := GutterColor;
    Gutter.ShowLineNumbers :=  GutterLineNumbers;
    Gutter.LeadingZeros := GutterLeadingZeros;
    Gutter.DigitCount := GutterDigitCount;
    Gutter.Width := GutterWidth;
    if RightMarginVisible then
      RightEdge := RightMargin
    else
      RightEdge := 0;
    RightEdgeColor := RightMarginColor;
    Font.Name := FontName;
    Font.Size := FontSize;
    InsertMode := EditorInsertMode;
    if EditorAutoIndent then
      seMain.Options := seMain.Options+[eoAutoIndent]
    else
      seMain.Options := seMain.Options-[eoAutoIndent];
    if EditorGroupUndo then
      seMain.Options := seMain.Options+[eoGroupUndo]
    else
      seMain.Options := seMain.Options-[eoGroupUndo];
    if EditorHalfPageScroll then
      seMain.Options := seMain.Options+[eoHalfPageScroll]
    else
      seMain.Options := seMain.Options-[eoHalfPageScroll];
    if EditorSmartTabs then
      seMain.Options := seMain.Options+[eoSmartTabs]
    else
      seMain.Options := seMain.Options-[eoSmartTabs];
    if EditorTabIndent then
      seMain.Options := seMain.Options+[eoTabIndent]
    else
      seMain.Options := seMain.Options-[eoTabIndent];
  end;
  UpdateInsertStatus;
  seMain.Invalidate;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  UpdateOptions;
end;

procedure TfmMain.FormResize(Sender: TObject);
begin
  hcRulesSectionResize(nil, nil);
end;

procedure TfmMain.aColorOptionsExecute(Sender: TObject);
begin
  if RunOptionsDialog(odpColor) then
  begin
    UpdateOptions;
  end;
end;

procedure TfmMain.aDisplayOptionsExecute(Sender: TObject);
begin
  if RunOptionsDialog(odpDisplay) then
  begin
    UpdateOptions;
  end
end;

procedure TfmMain.aAboutExecute(Sender: TObject);
begin
  ShowAbout;
end;

procedure TfmMain.seMainSpecialLineColors(Sender: TObject; Line: Integer;
  var Special: Boolean; var FG, BG: TColor);
var
  R: TGrammarRule;
  i, y1, y2: integer;
begin
  R := FParser.Grammar.RuleAt(Point(0, Line-1));
  if Assigned(R) then
  begin
    y1 := R.StartPos.Y;
    y2 := R.EndPos.Y;
    i := 0;
    while not(Special) and (i<FParser.Grammar.ItemCount) do
    begin
      if (FParser.Grammar.Items[i].StartPos.Y>=y1) and
         (FParser.Grammar.Items[i].StartPos.Y<=y2) and
         (FSelectedItems.IndexOf(FParser.Grammar.Items[i].Name)>=0) then
      begin
        Special := true;
        BG := clSilver;
      end;
      Inc(i);
    end;
  end;
end;

procedure TfmMain.aSelectItemRulesExecute(Sender: TObject);
var
  s: string;
begin
  if tvItems.Focused then
  begin
    if Assigned(tvItems.Selected) and (tvItems.Selected.Level>0) then
      FSelectedItems.Add(tvItems.Selected.Text);
    seMain.Invalidate;
  end
  else
  if seMain.Focused then
  begin
    s := TokenAtPos(seMain.CaretXY);
    if (s<>'') and (FindItemDef(s, true)<>nil) then
    begin
      FSelectedItems.Add(s);
      seMain.Invalidate;
    end;
  end;
end;

procedure TfmMain.aDeselectItemRulesExecute(Sender: TObject);
var
  i: integer;
  s: string;
begin
  if tvItems.Focused and Assigned(tvItems.Selected) then
  begin
    i := FSelectedItems.IndexOf(tvItems.Selected.Text);
    if i>=0 then
    begin
      FSelectedItems.Delete(i);
      seMain.Invalidate;
    end;
  end
  else
  if seMain.Focused then
  begin
    s := TokenAtPos(seMain.CaretXY);
    if s<>'' then
    begin
      i := FSelectedItems.IndexOf(s);
      if i>=0 then
      begin
        FSelectedItems.Delete(i);
        seMain.Invalidate;
      end;
    end;
  end
  else
  if lbSelectedItems.Focused and (lbSelectedItems.ItemIndex>=0) then
  begin
    FSelectedItems.Delete(lbSelectedItems.ItemIndex);
    seMain.Invalidate;
  end;
end;

procedure TfmMain.seMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then
  begin
    aSelectItemRules.Update;
    aDeselectItemRules.Update;
  end;
end;

procedure TfmMain.tvItemsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then
  begin
    aSelectItemRules.Update;
    aDeselectItemRules.Update;
  end;
end;

procedure TfmMain.aFindItemDefUpdate(Sender: TObject);
begin
  aFindItemDef.Enabled :=
    (seMain.Focused and (FindItemDef(TokenAtPos(seMain.CaretXY))<>nil));
end;

procedure TfmMain.aFindItemDefExecute(Sender: TObject);
var
  s: string;
  I: TGrammarItem;
begin
  if seMain.Focused then
  begin
    s := TokenAtPos(seMain.CaretXY);
    if s<>'' then
    begin
      I := FindItemDef(s);
      if Assigned(I) then
      begin
        seMain.CaretX := I.StartPos.X+1;
        seMain.CaretY := I.StartPos.Y+1;
      end;
    end;
  end;
end;

procedure TfmMain.aSelectItemRulesUpdate(Sender: TObject);
begin
  aSelectItemRules.Enabled :=
    (tvItems.Focused and Assigned(tvItems.Selected) and (tvItems.Selected.Level>0)) or
    (seMain.Focused and (FindItemDef(TokenAtPos(seMain.CaretXY), true)<>nil));
end;

procedure TfmMain.aDeselectItemRulesUpdate(Sender: TObject);
begin
  aDeselectItemRules.Enabled :=
    (tvItems.Focused and Assigned(tvItems.Selected) and (tvItems.Selected.Level>0) and (FSelectedItems.IndexOf(tvItems.Selected.Text)>=0)) or
    (seMain.Focused and (FindItemDef(TokenAtPos(seMain.CaretXY), true)<>nil)) or
    (lbSelectedItems.Focused and (lbSelectedItems.ItemIndex>=0));
end;

procedure TfmMain.OnSelectedItemsChange(Sender: TObject);
begin
  lbSelectedItems.Items.Assign(FSelectedItems);
  if FSelectedItems.Count>0 then
  begin
    pnlSelectedItems.Visible := true;
    splExplorer.Visible := true;
  end
  else
  begin
    splExplorer.Visible := false;
    pnlSelectedItems.Visible := false;
  end;
end;

procedure TfmMain.lbSelectedItemsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then
    aDeselectItemRules.Update;
end;

procedure TfmMain.aCompileUpdate(Sender: TObject);
begin
  aCompile.Enabled := FParser.Parsed and FParser.ParsedOk;
end;

procedure TfmMain.DrawParseTree;

  procedure DrawReductionBranch(const Reduction: TReduction);


    procedure AddRule(R: TReduction; RuleName: string);

      procedure RuleItems(RI: TReduction; Level: integer);

        procedure CheckCol(ColNum: integer);
        begin
          if sgRules.ColCount<ColNum+1 then
            sgRules.ColCount := ColNum+1;
        end;

      var
        n: integer;
        s: string;
        R: TReduction;
      begin
        if RI<>nil then
        begin
          R := RI;
          if RI.Tokens[0].Reduction<>nil then
          begin
            CheckCol(Level+2);
            s := '';
            while (R<>nil) and (R.TokenCount>0) do
            begin
              if R.TokenCount=1 then
                s := R.Tokens[0].Reduction.Tokens[0].DataVar+' '+s
              else
                s := R.Tokens[1].Reduction.Tokens[0].DataVar+' '+s;
              R := R.Tokens[0].Reduction;
            end;
            sgRules.Cells[Level+2, sgRules.RowCount-1] := s; // RI.Tokens[0].Reduction.Tokens[0].DataVar;
            n := sgRules.Canvas.TextWidth(s)+10;  // RI.Tokens[0].Reduction.Tokens[0].DataVar
            if sgRules.ColWidths[Level+2]<n then
              sgRules.ColWidths[Level+2] := n;
          end;
          if RI.TokenCount=4 then
            AddRule(RI.Tokens[0].Reduction, RuleName); 
//            RuleItems(RI.Tokens[0].Reduction, Level+1);
        end;
      end;

    var
      n: integer;
    begin
      sgRules.Cells[0, sgRules.RowCount-1] := RuleName;
      sgRules.Cells[1, sgRules.RowCount-1] := '::=';
      n := sgRules.Canvas.TextWidth(RuleName)+10;
      if n>sgRules.ColWidths[0] then
        sgRules.ColWidths[0] := n;
      RuleItems(R.Tokens[3].Reduction.Tokens[0].Reduction, 0);
      sgRules.RowCount := sgRules.RowCount+1;
    end;

  var
    i: integer;
  begin
    for i:=0 to Reduction.TokenCount-1 do
      case Reduction.Tokens[i].Kind of
        SymbolTypeNonterminal:
          begin
            if Reduction.Tokens[i].Reduction.ParentRule.Name='<Rule Decl>' then
              AddRule(Reduction.Tokens[i].Reduction, Reduction.Tokens[i].Reduction.Tokens[0].DataVar);
            DrawReductionBranch(Reduction.Tokens[i].Reduction);
          end;
        SymbolTypeTerminal: ;
      end;
  end;

var
  R: TReduction;
begin
  sgRules.RowCount := 1;
  sgRules.Cells[0, 0] := '';
  sgRules.Cells[1, 0] := '';
  if FParser.Parsed and FParser.ParsedOk then
  begin
    R := FParser.LastReduction;
    if Assigned(R) then
    begin
      sgRules.ColWidths[1] := sgRules.Canvas.TextWidth('::=')+5;
      DrawReductionBranch(R);
      sgRules.RowCount := sgRules.RowCount-1;
    end;
  end;
end;

procedure TfmMain.aCompileExecute(Sender: TObject);
begin
  sgRules.Font.Assign(seMain.Font);
  sgRules.DefaultRowHeight := sgRules.Canvas.TextHeight('|')+4;
  DrawParseTree;
  tsRules.TabVisible := true;
end;

procedure TfmMain.lbErrorsDblClick(Sender: TObject);
var
  n: integer;
begin
  n := lbErrors.ItemIndex;
  if n<>-1 then
  begin
    n := integer(lbErrors.Items.Objects[n]);
    if n>=0 then
    begin
      seMain.CaretXY := BufferCoord(0, n);
      seMain.SetFocus;
    end;
  end;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  pcEditors.ActivePage := tsEditor;
  tsRules.TabVisible := false;
  seMain.SetFocus;
end;

end.
