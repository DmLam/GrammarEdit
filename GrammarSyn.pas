unit GrammarSyn;

{$I SynEdit.inc}

interface

uses
  SysUtils,
  Classes,
{$IFDEF SYN_CLX}
  QControls,
  QGraphics,
{$ELSE}
  Windows,
  Controls,
  Graphics,
{$ENDIF}
  SynUnicode,
  SynEditTypes,
  SynEditHighlighter;

type
  TtkTokenKind = (
    tkChar,
    tkCharSet,
    tkCharSetName,
    tkComment,
    tkIdentifier,
    tkKey,
    tkNull,
    tkRuleName,
    tkString,
    tkUnknown);

  TRangeState = (rsUnKnown, rsMultiComment, rsComment, rsString, rsRuleName, rsCharSetName, rsCharSet, rsChar);

  TProcTableProc = procedure of object;

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = function: TtkTokenKind of object;

const
  MaxKey = 161;

type
  TGrammarSyn = class(TSynCustomHighlighter)
  private
    fAnsiLine: AnsiString;
    fLine: PChar;
    fLineNumber: Integer;
    fProcTable: array[#0..#255] of TProcTableProc;
    fRange: TRangeState;
    fStringLen: Integer;
    fToIdent: PChar;
    fTokenPos: Integer;
    fTokenID: TtkTokenKind;
    fIdentFuncTable: array[0 .. MaxKey] of TIdentFuncTableFunc;
    fWhitespaceAttri: TSynHighlighterAttributes;
    fCharAttri: TSynHighlighterAttributes;
    fCharSetAttri: TSynHighlighterAttributes;
    fCharSetNameAttri: TSynHighlighterAttributes;
    fCommentAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fRuleNameAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    function KeyHash(ToHash: PChar): Integer;
    function KeyComp(const aKey: string): Boolean;
    function Func123: TtkTokenKind;
    function Func161: TtkTokenKind;
    function Func106: TtkTokenKind;
    procedure IdentProc;
    procedure UnknownProc;
    function AltFunc: TtkTokenKind;
    procedure InitIdent;
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
    procedure NullProc;
    procedure CRProc;
    procedure LFProc;
    procedure MultiCommentProc;
    procedure CommentOpenProc;
    procedure CommentProc;
    procedure StringOpenProc;
    procedure StringProc;
    procedure RuleNameOpenProc;
    procedure RuleNameProc;
    procedure CharSetNameOpenProc;
    procedure CharSetNameProc;
    procedure CharSetOpenProc;
    procedure CharSetProc;
    procedure CharOpenProc;
    procedure CharProc;
  protected
    function GetSampleSource: UnicodeString; override;
    function IsFilterStored: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    {$IFNDEF SYN_CPPB_1} class {$ENDIF}
    function GetLanguageName: string; override;
    function GetRange: Pointer; override;
    procedure ResetRange; override;
    procedure SetRange(Value: Pointer); override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes; override;
    function GetEol: Boolean; override;
//    function GetKeyWords(TokenKind: Integer): UnicodeString; override;
    function GetTokenID: TtkTokenKind;
    procedure DoSetLine(const Value: UnicodeString; LineNumber:Integer); override;
    function GetToken: UnicodeString; override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: integer; override;
    function GetTokenPos: Integer; override;
    procedure Next; override;
  published
    property WhitespaceAttri: TSynHighlighterAttributes read fWhitespaceAttri write fWhitespaceAttri;
    property CharAttri: TSynHighlighterAttributes read fCharAttri write fCharAttri;
    property CharSetAttri: TSynHighlighterAttributes read fCharSetAttri write fCharSetAttri;
    property CharSetNameAttri: TSynHighlighterAttributes read fCharSetNameAttri write fCharSetNameAttri;
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri write fCommentAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property RuleNameAttri: TSynHighlighterAttributes read fRuleNameAttri write fRuleNameAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri write fStringAttri;
  end;

implementation

uses
  SynEditStrConst;

{$IFDEF SYN_COMPILER_3_UP}
resourcestring
{$ELSE}
const
{$ENDIF}
  SYNS_FilterGrammar = 'All files (*.*)|*.*';
  SYNS_LangGrammar = 'Grammar';
  SYNS_AttrChar = 'Char';
  SYNS_AttrCharSet = 'CharSet';
  SYNS_AttrCharSetName = 'CharSetName';
  SYNS_AttrRuleName = 'RuleName';

var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable : array[#0..#255] of Integer;

procedure MakeIdentTable;
var
  I, J: Char;
begin
  for I := #0 to #255 do
  begin
    case I of
      '_', ' ', '0'..'9', 'a'..'z', 'A'..'Z': Identifiers[I] := True;
    else
      Identifiers[I] := False;
    end;
    J := UpCase(I);
    case I in ['_', 'A'..'Z', 'a'..'z'] of
      True: mHashTable[I] := Ord(J) - 64
    else
      mHashTable[I] := 0;
    end;
  end;
end;

procedure TGrammarSyn.InitIdent;
var
  I: Integer;
  pF: PIdentFuncTableFunc;
begin
  pF := PIdentFuncTableFunc(@fIdentFuncTable);
  for I := Low(fIdentFuncTable) to High(fIdentFuncTable) do
  begin
    pF^ := AltFunc;
    Inc(pF);
  end;
  fIdentFuncTable[123] := Func123;
  fIdentFuncTable[161] := Func161;
  fIdentFuncTable[106] := Func106;
end;

function TGrammarSyn.KeyHash(ToHash: PChar): Integer;
begin
  Result := 0;
  while ToHash^ in [ '_', ' ', '0'..'9', 'a'..'z', 'A'..'Z'] do
  begin
    inc(Result, mHashTable[ToHash^]);
    inc(ToHash);
  end;
  while (ToHash-1)^ = ' ' do
  begin
    Dec(Result, mHashTable[(ToHash-1)^]);
    Dec(ToHash);
  end;
  fStringLen := ToHash - fToIdent;
end;

function TGrammarSyn.KeyComp(const aKey: String): Boolean;
var
  I: Integer;
  Temp: PChar;
begin
  Temp := fToIdent;
  if Length(aKey) = fStringLen then
  begin
    Result := True;
    for i := 1 to fStringLen do
    begin
      if mHashTable[Temp^] <> mHashTable[aKey[i]] then
      begin
        Result := False;
        break;
      end;
      inc(Temp);
    end;
  end
  else
    Result := False;
end;

function TGrammarSyn.AltFunc: TtkTokenKind;
begin
  Result := tkIdentifier;
end;

function TGrammarSyn.IdentKind(MayBe: PChar): TtkTokenKind;
var
  HashKey: Integer;
begin
  fToIdent := MayBe;
  HashKey := KeyHash(MayBe);
  if HashKey <= MaxKey then
    Result := fIdentFuncTable[HashKey]
  else
    Result := tkIdentifier;
end;

procedure TGrammarSyn.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #0: fProcTable[I] := NullProc;
      #10: fProcTable[I] := LFProc;
      #13: fProcTable[I] := CRProc;
      '!': fProcTable[I] := CommentOpenProc;
      '"': fProcTable[I] := StringOpenProc;
      '<': fProcTable[I] := RuleNameOpenProc;
      '{': fProcTable[I] := CharSetNameOpenProc;
      '[': fProcTable[I] := CharSetOpenProc;
      '''': fProcTable[I] := CharOpenProc;
      'A'..'Z', 'a'..'z', '_': fProcTable[I] := IdentProc;
    else
      fProcTable[I] := UnknownProc;
    end;
end;

procedure TGrammarSyn.NullProc;
begin
  fTokenID := tkNull;
end;

procedure TGrammarSyn.CRProc;
begin
  fTokenID := tkUnknown;
  inc(Run);
  if fLine[Run] = #10 then
    inc(Run);
end;

procedure TGrammarSyn.LFProc;
begin
  fTokenID := tkUnknown;
  inc(Run);
end;

procedure TGrammarSyn.MultiCommentProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      fTokenID := tkComment;
      repeat
        if (fLine[Run] = '*') and
           (fLine[Run + 1] = '!') then
        begin
          Inc(Run, 2);
          fRange := rsUnKnown;
          Break;
        end;
        if not (fLine[Run] in [#0, #10, #13]) then
          Inc(Run);
      until fLine[Run] in [#0, #10, #13];
    end;
  end;
end;

procedure TGrammarSyn.CommentOpenProc;
begin
  Inc(Run);
  if (fLine[Run] = '*') then
  begin
    fRange := rsMultiComment;
    MultiCommentProc;
    fTokenID := tkComment;
  end
  else
  begin
    fRange := rsComment;
    CommentProc;
    fTokenID := tkComment;
  end;  
end;

procedure TGrammarSyn.CommentProc;
begin
  fTokenID := tkComment;
  repeat
    if (fLine[Run] = '#') and
       (fLine[Run + 1] = '0') then
    begin
      Inc(Run, 2);
      fRange := rsUnKnown;
      Break;
    end;
    if not (fLine[Run] in [#0, #10, #13]) then
      Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

procedure TGrammarSyn.StringOpenProc;
begin
  Inc(Run);
  fRange := rsString;
  StringProc;
end;

procedure TGrammarSyn.StringProc;
begin
  fTokenID := tkString;
  repeat
    if (fLine[Run] = '"') then
    begin
      Inc(Run, 1);
      fRange := rsUnKnown;
      Break;
    end;
    if not (fLine[Run] in [#0, #10, #13]) then
      Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

procedure TGrammarSyn.RuleNameOpenProc;
begin
  Inc(Run);
  fRange := rsRuleName;
  RuleNameProc;
  fTokenID := tkRuleName;
end;

procedure TGrammarSyn.RuleNameProc;
begin
  fTokenID := tkRuleName;
  repeat
    if (fLine[Run] = '>') then
    begin
      Inc(Run, 1);
      fRange := rsUnKnown;
      Break;
    end;
    if not (fLine[Run] in [#0, #10, #13]) then
      Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

procedure TGrammarSyn.CharSetNameOpenProc;
begin
  Inc(Run);
  fRange := rsCharSetName;
  CharSetNameProc;
  fTokenID := tkCharSetName;
end;

procedure TGrammarSyn.CharSetNameProc;
begin
  fTokenID := tkCharSetName;
  repeat
    if (fLine[Run] = '}') then
    begin
      Inc(Run, 1);
      fRange := rsUnKnown;
      Break;
    end;
    if not (fLine[Run] in [#0, #10, #13]) then
      Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

procedure TGrammarSyn.CharSetOpenProc;
begin
  Inc(Run);
  fRange := rsCharSet;
  CharSetProc;
  fTokenID := tkCharSet;
end;

procedure TGrammarSyn.CharSetProc;
begin
  fTokenID := tkCharSet;
  repeat
    if fLine[Run]='''' then
    begin
      Inc(Run);
      while not (fLine[Run] in [#0, #10, #13, '''']) do
        Inc(Run);
    end
    else
    if (fLine[Run] = ']') then
    begin
      Inc(Run, 1);
      fRange := rsUnKnown;
      Break;
    end;
    if not (fLine[Run] in [#0, #10, #13]) then
      Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

procedure TGrammarSyn.CharOpenProc;
begin
  Inc(Run);
  fRange := rsChar;
  CharProc;
  fTokenID := tkChar;
end;

procedure TGrammarSyn.CharProc;
begin
  fTokenID := tkChar;
  repeat
    if fLine[Run] = '''' then
    begin
      if fLine[Run+1] = '''' then
        Inc(Run)
      else
      begin
        Inc(Run, 1);
        fRange := rsUnKnown;
        Break;
      end;  
    end;
    if not (fLine[Run] in [#0, #10, #13]) then
      Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

constructor TGrammarSyn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fWhitespaceAttri := TSynHighLighterAttributes.Create('Whitespace');
  AddAttribute(fWhitespaceAttri);

  fCharAttri := TSynHighLighterAttributes.Create(SYNS_AttrChar);
  fCharAttri.Foreground := clBlue;
  AddAttribute(fCharAttri);

  fCharSetAttri := TSynHighLighterAttributes.Create(SYNS_AttrCharSet);
  AddAttribute(fCharSetAttri);

  fCharSetNameAttri := TSynHighLighterAttributes.Create(SYNS_AttrCharSetName);
  fCharSetNameAttri.Foreground := clBlue;
  AddAttribute(fCharSetNameAttri);

  fCommentAttri := TSynHighLighterAttributes.Create(SYNS_AttrComment);
  fCommentAttri.Style := [fsItalic];
  fCommentAttri.Foreground := clNavy;
  AddAttribute(fCommentAttri);

  fIdentifierAttri := TSynHighLighterAttributes.Create(SYNS_AttrIdentifier);
  AddAttribute(fIdentifierAttri);

  fKeyAttri := TSynHighLighterAttributes.Create(SYNS_AttrReservedWord);
  fKeyAttri.Style := [fsBold];
  AddAttribute(fKeyAttri);

  fRuleNameAttri := TSynHighLighterAttributes.Create(SYNS_AttrRuleName);
  fRuleNameAttri.Foreground := clGreen;
  AddAttribute(fRuleNameAttri);

  fStringAttri := TSynHighLighterAttributes.Create(SYNS_AttrString);
  fStringAttri.Foreground := clBlue;
  AddAttribute(fStringAttri);

  SetAttributesOnChange(DefHighlightChange);
  InitIdent;
  MakeMethodTables;
  fDefaultFilter := SYNS_FilterGrammar;
  fRange := rsUnknown;
end;

procedure TGrammarSyn.DoSetLine(const Value: UnicodeString; LineNumber:Integer); 
begin
  fAnsiLine := string(Value);
  fLine := PChar(fAnsiLine);
  Run := 0;
  fLineNumber := LineNumber;
  
  inherited;
end;

procedure TGrammarSyn.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  if Identifiers[fLine[Run]] then
  begin
    while Identifiers[fLine[Run]] do
      Inc(Run);
    while fLine[Run-1]=' ' do
      Dec(Run);
  end;
end;

procedure TGrammarSyn.UnknownProc;
begin
{$IFDEF SYN_MBCSSUPPORT}
  if FLine[Run] in LeadBytes then
    Inc(Run,2)
  else
{$ENDIF}
  inc(Run);
  fTokenID := tkUnknown;
end;

procedure TGrammarSyn.Next;
begin
  fTokenPos := Run;
  case fRange of
    rsMultiComment: MultiCommentProc;
  else
    fProcTable[fLine[Run]];
  end;

  inherited;
end;

function TGrammarSyn.GetDefaultAttribute(Index: integer): TSynHighLighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT    : Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER : Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD    : Result := fKeyAttri;
    SYN_ATTR_STRING     : Result := fStringAttri;
    SYN_ATTR_WHITESPACE : Result := fWhitespaceAttri;
  else
    Result := nil;
  end;
end;

function TGrammarSyn.GetEol: Boolean;
begin
  Result := fTokenID = tkNull;
end;

//function TGrammarSyn.GetKeyWords(TokenKind: Integer): UnicodeString;
//begin
//  Result := 'Comment Line,Comment Start,Comment End';
//end;

function TGrammarSyn.GetToken: UnicodeString;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

function TGrammarSyn.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TGrammarSyn.GetTokenAttribute: TSynHighLighterAttributes;
begin
  case GetTokenID of
    tkChar: Result := fCharAttri; 
    tkCharSet: Result := fCharSetAttri;
    tkCharSetName: Result := fCharSetNameAttri;
    tkComment: Result := fCommentAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkRuleName: Result := fRuleNameAttri;
    tkString: Result := fStringAttri;
    tkUnknown: Result := fWhitespaceAttri;
  else
    Result := nil;
  end;
end;

function TGrammarSyn.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TGrammarSyn.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

function TGrammarSyn.GetSampleSource: UnicodeString;
begin
  Result := 'Sample source for: '#13#10 +
            'Syntax Parser/Highlighter';
end;

function TGrammarSyn.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterGrammar;
end;

class function TGrammarSyn.GetLanguageName: string;
begin
  Result := SYNS_LangGrammar;
end;

procedure TGrammarSyn.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TGrammarSyn.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

function TGrammarSyn.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

function TGrammarSyn.Func106: TtkTokenKind;
begin
  if KeyComp('Comment End') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TGrammarSyn.Func123: TtkTokenKind;
begin
  if KeyComp('Comment Line') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

function TGrammarSyn.Func161: TtkTokenKind;
begin
  if KeyComp('Comment Start') then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

initialization
  MakeIdentTable;
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TGrammarSyn);
{$ENDIF}
end.
