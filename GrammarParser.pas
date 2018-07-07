unit GrammarParser;

interface

uses
  Windows, Types, Classes, Contnrs, GrammarReader, GOLDParser, Symbol, Token;

const
  RECOVER_ERROR_LEVEL = 10;

type
  TGrammarItemKind = (gikUnknown, gikRule, gikRuleName, gikTerminal, gikTerminalName,
                      gikSet, gikSetName);

  TGrammar = class;

  TOutputEvent = procedure (aMessage : String) of object;

  TGrammarParser = class(TThread)
  private
    FParsedOk: boolean;
    FErrors: TStringList;
    FSourceChanged: boolean;
    FParseEvent: THandle;
    FParseString: string;
    FParser: TGOLDParser;
    FGrammar: TGrammar;
    FOnParse: TNotifyEvent;
    FParsed: boolean;

    function LoadGrammarFromResource(aGoldParser : TGOLDParser) : Boolean;
    procedure ReplaceReduction (aParser : TGOLDParser);
    procedure DoOnParse;
    function GetErrorCount: integer;
    function GetError(Index: integer): string;
    function GetErrorLine(Index: integer): integer;
    function GetLastReduction: TReduction;

  protected
    procedure OnParseProc;
    procedure Execute; override;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Parse(s: string);
    procedure Shutdown;

    property Grammar: TGrammar
      read FGrammar;
    property Parsed: boolean
      read FParsed;
    property ParsedOk: boolean
      read FParsedOk;
    property ErrorCount: integer
      read GetErrorCount;
    property Error[Index: integer]: string
      read GetError;
    property ErrorLine[Index: integer]: integer
      read GetErrorLine;
    property LastReduction: TReduction
      read GetLastReduction;  
    property OnParse: TNotifyEvent
      read FOnParse write FOnParse;
  end;

  TGrammarItem = class
  private
    FKind: TGrammarItemKind;
    FStartPos, FEndPos: TPoint;
    FName: string;
  public
    constructor Create(const AKind: TGrammarItemKind; const AName: string; const AStartPos, AEndPos: TPoint);

    property Kind: TGrammarItemKind
      read FKind write FKind;
    property StartPos: TPoint
      read FStartPos;
    property EndPos: TPoint
      read FEndPos;
    property Name: string
      read FName write FName;
  end;

  TGrammarRule = class(TGrammarItem)
  public
    constructor Create(const AName: string; const AStartPos, AEndPos: TPoint);
  end;

  TGrammarTerminal = class(TGrammarItem)
  private
    FPredefined: boolean;
    FCharRange: boolean;
    FFirstChar, FLastChar: Integer;
  public
    constructor Create(const AName: string; const AStartPos, AEndPos: TPoint);
    constructor CreatePredefined(const AName: string);
    constructor CreateCharRange(const AName: string; const AFirstChar, ALastChar: integer);

    property Predefined: boolean
      read FPredefined;
    property CharRange: boolean
      read FCharRange;
    property FirstChar: integer
      read FFirstChar;
    property LastChar: integer
      read FLastChar;
  end;

  TGrammarSet = class(TGrammarItem)
  public
    constructor Create(const AName: string; const AStartPos, AEndPos: TPoint);
  end;

  TGrammar = class
  private
    FItems: TObjectList;
    FRules: TObjectList;
    FTerminals: TObjectList;
    FSets: TObjectList;
    function GetRule(Index: integer): TGrammarRule;
    function GetRuleCount: integer;
    function GetItem(Index: integer): TGrammarItem;
    function GetItemCount: integer;
    function GetTerminal(Index: integer): TGrammarTerminal;
    function GetTerminalCount: integer;
    function GetSet(Index: integer): TGrammarSet;
    function GetSetCount: integer;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Init;
    function AddItem(const Item: TGrammarItem): integer;
    procedure DeleteItem(const Index: integer);
    function ItemAt(const XY: TPoint): TGrammarItem;
    function ItemByName(const Name: string): integer;
    function AddRule(const Rule: TGrammarRule): integer;
    function RuleAt(const XY: TPoint): TGrammarRule;
    function RuleByName(const Name: string): TGrammarRule;
    function AddTerminal(Terminal: TGrammarTerminal): integer;
    function TerminalAt(const XY: TPoint): TGrammarTerminal;
    function TerminalByName(Name: string): TGrammarTerminal;
    function AddSet(const ASet: TGrammarSet): integer;
    function SetAt(const XY: TPoint): TGrammarSet;
    function SetByName(const Name: string): TGrammarSet;

    procedure Sort;
    function IsCharRange(Item: string; var First, Last: integer): boolean;

    property ItemCount: integer
      read GetItemCount;
    property Items[Index: integer]: TGrammarItem
      read GetItem;
    property RuleCount: integer
      read GetRuleCount;
    property Rules[Index: integer]: TGrammarRule
      read GetRule;
    property TerminalCount: integer
      read GetTerminalCount;
    property Terminals[Index: integer]: TGrammarTerminal
      read GetTerminal;
    property SetCount: integer
      read GetSetCount;
    property Sets[Index: integer]: TGrammarSet
      read GetSet;
  end;

implementation

{$R Grammar.res}

uses
  Forms,
  SysUtils;

// constant definitions - this is Delphi <= 5 compatible!
// Symbols

const
  Symbol_Eof            =  0; // (EOF)
  Symbol_Error          =  1; // (Error)
  Symbol_Whitespace     =  2; // (Whitespace)
  Symbol_Commentend     =  3; // (Comment End)
  Symbol_Commentline    =  4; // (Comment Line)
  Symbol_Commentstart   =  5; // (Comment Start)
  Symbol_Minus          =  6; // -
  Symbol_Lparan         =  7; // '('
  Symbol_Rparan         =  8; // ')'
  Symbol_Times          =  9; // '*'
  Symbol_Coloncoloneq   = 10; // '::='
  Symbol_Question       = 11; // '?'
  Symbol_Pipe           = 12; // '|'
  Symbol_Plus           = 13; // '+'
  Symbol_Eq             = 14; // '='
  Symbol_Newline        = 15; // Newline
  Symbol_Nonterminal    = 16; // Nonterminal
  Symbol_Parametername  = 17; // ParameterName
  Symbol_Setliteral     = 18; // SetLiteral
  Symbol_Setname        = 19; // SetName
  Symbol_Terminal       = 20; // Terminal
  Symbol_Content        = 21; // <Content>
  Symbol_Definition     = 22; // <Definition>
  Symbol_Grammar        = 23; // <Grammar>
  Symbol_Handle         = 24; // <Handle>
  Symbol_Handles        = 25; // <Handles>
  Symbol_Kleeneopt      = 26; // <Kleene Opt>
  Symbol_Nl             = 27; // <nl>
  Symbol_Nlopt          = 28; // <nl opt>
  Symbol_Parameter      = 29; // <Parameter>
  Symbol_Parameterbody  = 30; // <Parameter Body>
  Symbol_Parameteritem  = 31; // <Parameter Item>
  Symbol_Parameteritems = 32; // <Parameter Items>
  Symbol_Regexp         = 33; // <Reg Exp>
  Symbol_Regexp2        = 34; // <Reg Exp 2>
  Symbol_Regexpitem     = 35; // <Reg Exp Item>
  Symbol_Regexpseq      = 36; // <Reg Exp Seq>
  Symbol_Ruledecl       = 37; // <Rule Decl>
  Symbol_Setdecl        = 38; // <Set Decl>
  Symbol_Setexp         = 39; // <Set Exp>
  Symbol_Setitem        = 40; // <Set Item>
  Symbol_Symbol         = 41; // <Symbol>
  Symbol_Terminaldecl   = 42; // <Terminal Decl>
  Symbol_Terminalname   = 43; // <Terminal Name>

// Rules
const
  Rule_Grammar                           =  0; // <Grammar> ::= <nl opt> <Content>
  Rule_Content                           =  1; // <Content> ::= <Content> <Definition>
  Rule_Content2                          =  2; // <Content> ::= <Definition>
  Rule_Definition                        =  3; // <Definition> ::= <Parameter>
  Rule_Definition2                       =  4; // <Definition> ::= <Set Decl>
  Rule_Definition3                       =  5; // <Definition> ::= <Terminal Decl>
  Rule_Definition4                       =  6; // <Definition> ::= <Rule Decl>
  Rule_Nlopt_Newline                     =  7; // <nl opt> ::= Newline <nl opt>
  Rule_Nlopt                             =  8; // <nl opt> ::= 
  Rule_Nl_Newline                        =  9; // <nl> ::= Newline <nl>
  Rule_Nl_Newline2                       = 10; // <nl> ::= Newline
  Rule_Parameter_Parametername_Eq        = 11; // <Parameter> ::= ParameterName <nl opt> '=' <Parameter Body> <nl>
  Rule_Parameterbody_Pipe                = 12; // <Parameter Body> ::= <Parameter Body> <nl opt> '|' <Parameter Items>
  Rule_Parameterbody                     = 13; // <Parameter Body> ::= <Parameter Items>
  Rule_Parameteritems                    = 14; // <Parameter Items> ::= <Parameter Items> <Parameter Item>
  Rule_Parameteritems2                   = 15; // <Parameter Items> ::= <Parameter Item>
  Rule_Parameteritem_Parametername       = 16; // <Parameter Item> ::= ParameterName
  Rule_Parameteritem_Terminal            = 17; // <Parameter Item> ::= Terminal
  Rule_Parameteritem_Setliteral          = 18; // <Parameter Item> ::= SetLiteral
  Rule_Parameteritem_Setname             = 19; // <Parameter Item> ::= SetName
  Rule_Parameteritem_Nonterminal         = 20; // <Parameter Item> ::= Nonterminal
  Rule_Setdecl_Setname_Eq                = 21; // <Set Decl> ::= SetName <nl opt> '=' <Set Exp> <nl>
  Rule_Setexp_Plus                       = 22; // <Set Exp> ::= <Set Exp> <nl opt> '+' <Set Item>
  Rule_Setexp_Minus                      = 23; // <Set Exp> ::= <Set Exp> <nl opt> - <Set Item>
  Rule_Setexp                            = 24; // <Set Exp> ::= <Set Item>
  Rule_Setitem_Setliteral                = 25; // <Set Item> ::= SetLiteral
  Rule_Setitem_Setname                   = 26; // <Set Item> ::= SetName
  Rule_Terminaldecl_Eq                   = 27; // <Terminal Decl> ::= <Terminal Name> <nl opt> '=' <Reg Exp> <nl>
  Rule_Terminalname_Terminal             = 28; // <Terminal Name> ::= <Terminal Name> Terminal
  Rule_Terminalname_Terminal2            = 29; // <Terminal Name> ::= Terminal
  Rule_Regexp_Pipe                       = 30; // <Reg Exp> ::= <Reg Exp> <nl opt> '|' <Reg Exp Seq>
  Rule_Regexp                            = 31; // <Reg Exp> ::= <Reg Exp Seq>
  Rule_Regexpseq                         = 32; // <Reg Exp Seq> ::= <Reg Exp Seq> <Reg Exp Item>
  Rule_Regexpseq2                        = 33; // <Reg Exp Seq> ::= <Reg Exp Item>
  Rule_Regexpitem_Setliteral             = 34; // <Reg Exp Item> ::= SetLiteral <Kleene Opt>
  Rule_Regexpitem_Setname                = 35; // <Reg Exp Item> ::= SetName <Kleene Opt>
  Rule_Regexpitem_Terminal               = 36; // <Reg Exp Item> ::= Terminal <Kleene Opt>
  Rule_Regexpitem_Lparan_Rparan          = 37; // <Reg Exp Item> ::= '(' <Reg Exp 2> ')' <Kleene Opt>
  Rule_Regexp2_Pipe                      = 38; // <Reg Exp 2> ::= <Reg Exp 2> '|' <Reg Exp Seq>
  Rule_Regexp2                           = 39; // <Reg Exp 2> ::= <Reg Exp Seq>
  Rule_Kleeneopt_Plus                    = 40; // <Kleene Opt> ::= '+'
  Rule_Kleeneopt_Question                = 41; // <Kleene Opt> ::= '?'
  Rule_Kleeneopt_Times                   = 42; // <Kleene Opt> ::= '*'
  Rule_Kleeneopt                         = 43; // <Kleene Opt> ::=
  Rule_Ruledecl_Nonterminal_Coloncoloneq = 44; // <Rule Decl> ::= Nonterminal <nl opt> '::=' <Handles> <nl>
  Rule_Handles_Pipe                      = 45; // <Handles> ::= <Handles> <nl opt> '|' <Handle>
  Rule_Handles                           = 46; // <Handles> ::= <Handle>
  Rule_Handle                            = 47; // <Handle> ::= <Handle> <Symbol>
  Rule_Handle2                           = 48; // <Handle> ::=
  Rule_Symbol_Terminal                   = 49; // <Symbol> ::= Terminal
  Rule_Symbol_Nonterminal                = 50; // <Symbol> ::= Nonterminal

// pre-defined terminals
const
  PREDEFINED_TERMINALS: array [1..175] of string =
    ('HT', 'LF', 'VT', 'FF', 'CR', 'Space', 'NBSP', 'LS', 'PS',
     'Number', 'Digit', 'Letter', 'AlphaNumeric', 'Printable', 'Letter Extended', 'Printable Extended', 'Whitespace',
     'All Latin', 'All Letters', 'All Printable', 'All Space', 'All Newline', 'All Whitespace',
     //
     'Basic Latin', 'Latin-1 Supplement', 'Latin Extended-A', 'Latin Extended-B', 'IPA Extensions', 'Spacing Modifier Letters',
     'Combining Diacritical Marks', 'Greek and Coptic', 'Cyrillic', 'Cyrillic Supplement', 'Armenian', 'Hebrew', 'Arabic',
     'Syriac', 'Arabic Supplement', 'Thaana', 'NKo', 'Samaritan', 'Devanagari', 'Bengali', 'Gurmukhi', 'Gujarati', 'Oriya',
     'Tamil', 'Telugu', 'Kannada', 'Malayalam', 'Sinhala', 'Thai', 'Lao', 'Tibetan', 'Myanmar', 'Georgian', 'Hangul Jamo',
     'Ethiopic', 'Ethiopic Supplement', 'Cherokee', 'Unified Canadian Aboriginal Syllabics', 'Ogham', 'Runic', 'Tagalog',
     'Hanunoo', 'Buhid', 'Tagbanwa', 'Khmer', 'Mongolian', 'Unified Canadian Aboriginal Syllabics Extended', 'Limbu',
     'Tai Le', 'New Tai Lue', 'Khmer Symbols', 'Buginese', 'Tai Tham', 'Balinese', 'Sundanese', 'Lepcha', 'Ol Chiki',
     'Vedic Extensions', 'Phonetic Extensions', 'Phonetic Extensions Supplement', 'Combining Diacritical Marks Supplement',
     'Latin Extended Additional', 'Greek Extended', 'General Punctuation', 'Superscripts and Subscripts', 'Currency Symbols',
     'Combining Diacritical Marks for Symbols', 'Letterlike Symbols', 'Number Forms', 'Arrows', 'Mathematical Operators',
     'Miscellaneous Technical', 'Control Pictures', 'Optical Character Recognition', 'Enclosed Alphanumerics', 'Box Drawing',
     'Block Elements', 'Geometric Shapes', 'Miscellaneous Symbols', 'Dingbats', 'Miscellaneous Mathematical Symbols-A',
     'Supplemental Arrows-A', 'Braille Patterns', 'Supplemental Arrows-B', 'Miscellaneous Mathematical Symbols-B',
     'Supplemental Mathematical Operators', 'Miscellaneous Symbols and Arrows', 'Glagolitic', 'Latin Extended-C',
     'Coptic', 'Georgian Supplement', 'Tifinagh', 'Ethiopic Extended', 'Cyrillic Extended-A', 'Supplemental Punctuation',
     'CJK Radicals Supplement', 'Kangxi Radicals', 'Ideographic Description Characters', 'CJK Symbols and Punctuation',
     'Hiragana', 'Katakana', 'Bopomofo', 'Hangul Compatibility Jamo', 'Kanbun', 'Bopomofo Extended', 'CJK Strokes',
     'Katakana Phonetic Extensions', 'Enclosed CJK Letters and Months', 'CJK Compatibility', 'CJK Unified Ideographs Extension A',
     'Yijing Hexagram Symbols', 'CJK Unified Ideographs', 'Yi Syllables', 'Yi Radicals', 'Lisu', 'Vai', 'Cyrillic Extended-B',
     'Bamum', 'Modifier Tone Letters', 'Latin Extended-D', 'Syloti Nagri', 'Common Indic Number Forms', 'Phags-pa', 'Saurashtra',
     'Devanagari Extended', 'Kayah Li', 'Rejang', 'Hangul Jamo Extended-A', 'Javanese', 'Cham', 'Myanmar Extended-A',
     'Tai Viet', 'Meetei Mayek', 'Hangul Syllables', 'Hangul Jamo Extended-B', 'Private Use Area', 'CJK Compatibility Ideographs',
     'Alphabetic Presentation Forms', 'Arabic Presentation Forms-A', 'Variation Selectors', 'Vertical Forms', 'Combining Half Marks',
     'CJK Compatibility Forms', 'Small Form Variants', 'Arabic Presentation Forms-B', 'Halfwidth and Fullwidth Forms',
     //
     'All Valid', 'ANSI Mapped', 'ANSI Printable', 'Control Codes', 'Euro Sign', 'Formatting');

const
  COMMENT_LINE = 'Comment Line';
  COMMENT_START = 'Comment Start';
  COMMENT_END = 'Comment End';

function OffsetPoint(const P: TPoint; const X, Y: integer): TPoint;
begin
  Result.X := P.X+X;
  Result.Y := P.Y+Y;
end;

{ TGrammarParser }

constructor TGrammarParser.Create;
begin
  inherited Create(true);

  FParsed := false;
  FParsedOk := false;
  FErrors := TStringList.Create;
  FParseEvent := CreateEvent(nil, FALSE, FALSE, nil);
  if (FParseEvent=0) or (FParseEvent=INVALID_HANDLE_VALUE) then
    raise Exception.Create('Couldn''t create event object');
  FSourceChanged := false;
  FParseString := '';
  FreeOnTerminate := false;
  FParser := TGOLDParser.Create;
  FParser.TrimReductions := false;
  FGrammar := TGrammar.Create;
  if not LoadGrammarFromResource(FParser) then
    raise Exception.Create('Can''t load grammar');

  Resume;
end;

destructor TGrammarParser.Destroy;
begin
  if (FParseEvent<>0) and (FParseEvent<>INVALID_HANDLE_VALUE) then
    CloseHandle(FParseEvent);
  FGrammar.Free;
  FParser.Free;
  FErrors.Free;

  inherited;
end;

procedure TGrammarParser.DoOnParse;
begin
  if Assigned(FOnParse) then
    FOnParse(Self);
end;

procedure TGrammarParser.Execute;
var
   lResponse: Integer;
   lDone: boolean;
   zToken: integer;
   lError: string;
   RecoverError: integer;
   TokenName: string;
   CharRangeFirstChar, CharRangeLastChar: integer;
begin
  while not Terminated do
  begin
    WaitForSingleObject(FParseEvent, INFINITE);
    repeat
      if Terminated then
        Break;
        
      FSourceChanged := false;
      ResetEvent(FParseEvent);
      FParsed := false;
      FParsedOk := true;
      FGrammar.Clear;
      FGrammar.Init;
      FErrors.Clear;
      if Terminated then
        Break;
        
      FParser.OpenTextString(FParseString);
      if Terminated then
        Break;
        
      lDone := False;
      RecoverError := 0;
      while not (lDone or FSourceChanged or Terminated) do
      begin
        lResponse := FParser.Parse;
        case lResponse of
         gpMsgLexicalError:
          begin
            if FErrors.IndexOfObject(pointer(FParser.CurrentLineNumber))=-1 then
              FErrors.AddObject('Line ' + IntToStr(FParser.CurrentLineNumber)+
                                  ': Lexical Error: Cannot recognize token: '+
                                  FParser.CurrentToken.DataVar,
                                pointer(FParser.CurrentLineNumber));
            // try ro recover error
            if RecoverError<RECOVER_ERROR_LEVEL then
            begin
              if FParser.PopInputToken=nil then
                lDone := true
              else
                Inc(RecoverError);
            end
            else
              lDone := true;
            FParsedOk := false;
          end;
          gpMsgTokenRead:
          begin
            if FParser.CurrentToken.Kind=SymbolTypeTerminal then
            begin
              if FParser.CurrentToken.Name='SetName' then
              begin
                TokenName := FParser.CurrentToken.DataVar;
                FGrammar.AddItem(TGrammarItem.Create(
                  gikSetName,
                  TokenName,
                  FParser.CurrentToken.Position,
                  OffsetPoint(FParser.CurrentToken.Position, Length(FParser.CurrentToken.DataVar), 0)
                ));

                if Grammar.IsCharRange(TokenName, CharRangeFirstChar, CharRangeLastChar) then
                begin
                  if FGrammar.TerminalByName(TokenName) = nil then
                    FGrammar.AddTerminal(TGrammarTerminal.CreateCharRange(TokenName, CharRangeFirstChar, CharRangeLastChar));

                end;
              end
              else
              if FParser.CurrentToken.Name='<Rule Decl>' then
              begin
                FGrammar.AddItem(TGrammarItem.Create(
                  gikRuleName,
                  FParser.CurrentToken.DataVar,
                  FParser.CurrentToken.Position,
                  OffsetPoint(FParser.CurrentToken.Position, Length(FParser.CurrentToken.DataVar), 0)
                  ));
              end
              else
              if (FParser.CurrentToken.Name='<Terminal Decl>') and (FParser.CurrentToken.DataVar[1]<>'''') then
              begin
                FGrammar.AddItem(TGrammarItem.Create(
                  gikTerminalName,
                  FParser.CurrentToken.DataVar,
                  FParser.CurrentToken.Position,
                  OffsetPoint(FParser.CurrentToken.Position, Length(FParser.CurrentToken.DataVar), 0)
                ));
              end;
            end;
          end;
          gpMsgSyntaxError:
          begin
            if FErrors.IndexOfObject(pointer(FParser.CurrentLineNumber))=-1 then
            begin
              lError := '';
              for zToken := 0 to FParser.TokenTable.Count - 1 do
                lError := lError + ' ' + FParser.TokenTable[zToken].Name;
              FErrors.AddObject(Format('[%d, %d] : Syntax Error: Expecting the following tokens: %s', [FParser.CurrentLineNumber, FParser.CurrentLinePos,  Trim(lError)]),
                                pointer(FParser.CurrentLineNumber));
            end;

            if RecoverError < RECOVER_ERROR_LEVEL then
            begin
              if FParser.TokenTable.Count > 0 then
              begin
                FParser.PushInputToken(FParser.TokenTable[0]);
                Inc(RecoverError);
              end
              else
                lDone := true;
            end
            else
              lDone := true;
            FParsedOk := false;
          end;
          gpMsgReduction:
          begin
            ReplaceReduction(FParser);
          end;
          gpMsgAccept:
          begin
            lDone := True;
          end;
          gpMsgInternalError,
          gpMsgNotLoadedError:
          begin
            if FErrors.IndexOfObject(pointer(FParser.CurrentLineNumber))=-1 then
              FErrors.AddObject('Internal Parser error! Aborting!',
                                pointer(FParser.CurrentLineNumber));
            lDone := True;
            FParsedOk := false;
          end;
          gpMsgCommentError:
          begin
            if FErrors.IndexOfObject(pointer(FParser.CurrentLineNumber))=-1 then
              FErrors.AddObject('Line '+IntToStr(FParser.CurrentLineNumber)+
                                  ': Syntax Error: Unexpected end of file!',
                                pointer(FParser.CurrentLineNumber));
            lDone := True;
            FParsedOk := false;
          end;
        end;
      end;
    until (not FSourceChanged) or Terminated;

    if not Terminated and FSourceChanged then Continue;

    Grammar.Sort;

    if not Terminated and FSourceChanged then Continue;

    FParsed := true;
    if not Terminated and Assigned(FOnParse) then
      OnParseProc;
  end;
end; // TGrammarParser.Execute

function TGrammarParser.GetError(Index: integer): string;
begin
  Result := FErrors[Index];
end;

function TGrammarParser.GetErrorCount: integer;
begin
  Result := FErrors.Count;
end;

function TGrammarParser.GetErrorLine(Index: integer): integer;
begin
  Result := integer(FErrors.Objects[Index]);
end;

function TGrammarParser.GetLastReduction: TReduction;
begin
  Result := nil;
  if FParsedOk and (FParser.CurrentReduction<>nil) then
    Result := FParser.CurrentReduction;
end;

function TGrammarParser.LoadGrammarFromResource(aGoldParser: TGOLDParser) : Boolean;
var
  lMemStream : TMemoryStream;
  lResource : Pointer;
  lHandle   : Cardinal;
begin
  Result := TRUE;
  try
    lHandle := FindResource(0, 'GRAMMAR', RT_RCDATA);
    lResource := LockResource(LoadResource(0, lHandle));
    if lResource = nil then abort;
    lMemStream := TMemoryStream.Create;
    try
      lMemStream.WriteBuffer(lResource^, SizeofResource(0, lHandle));
      lMemStream.Position := 0;
      if not aGoldParser.LoadCompiledGrammar(lMemStream) then abort;
    finally
      lMemStream.Free;
    end; // try .. finally
  except
    Result := FALSE;
  end; // try .. except
end; // TGrammarParser.LoadGrammarFromResource

procedure TGrammarParser.OnParseProc;
begin
  Synchronize(DoOnParse);
end;

procedure TGrammarParser.Parse(s: string);
begin
  FParseString := s;
  FSourceChanged := true;
  if (FParseEvent<>0) and (FParseEvent<>INVALID_HANDLE_VALUE) then
    SetEvent(FParseEvent);
end;

procedure TGrammarParser.ReplaceReduction(aParser: TGOLDParser);

  function EndPos: TPoint;

    procedure CheckPosition(const Reduction: TReduction; var P: TPoint);
    var
      i: integer;
    begin
      for i:=0 to Reduction.TokenCount-1 do
      begin
        if Assigned(Reduction.Tokens[i].Reduction) then
          CheckPosition(Reduction.Tokens[i].Reduction, P)
        else
        if Reduction.Tokens[i].ParentSymbol.TableIndex<>Symbol_Newline then
        begin
          if Reduction.Tokens[i].Position.Y>P.Y then
          begin
            P.Y := Reduction.Tokens[i].Position.Y;
            P.X := Reduction.Tokens[i].Position.X+Length(Reduction.Tokens[i].DataVar);
          end
          else
          if (Reduction.Tokens[i].Position.Y=P.Y) and
             (Reduction.Tokens[i].Position.X+Length(Reduction.Tokens[i].DataVar)>P.X) then
            P.X := Reduction.Tokens[i].Position.X+Length(Reduction.Tokens[i].DataVar);
        end;
      end;
    end;

  begin
    Result := Point(0, 0);
    CheckPosition(FParser.CurrentReduction, Result);
  end;

  function TerminalName: string;
  var
    R: TReduction;
    i: integer;
  begin
    Result := '';

    R := FParser.CurrentReduction.Tokens[0].Reduction;
    if R.Tokens[0].Reduction=nil then
      Result := R.Tokens[0].DataVar
    else
    begin
      Result := Result+' '+R.Tokens[0].Reduction.Tokens[0].DataVar;
      for i := 1 to R.TokenCount-1 do
        Result := Result+' '+R.Tokens[i].DataVar;
    end;
  end;

begin
  case aParser.CurrentReduction.ParentRule.TableIndex of
    Rule_Setdecl_Setname_Eq:    // <Set Decl> ::= SetName <nl opt> '=' <Set Exp> <nl>
    begin
      FGrammar.AddSet(TGrammarSet.Create(
        FParser.CurrentReduction.Tokens[0].DataVar,
        FParser.CurrentReduction.Tokens[0].Position,
        EndPos));
    end;
    Rule_Terminaldecl_Eq:        // <Terminal Decl> ::= <Terminal Name> <nl opt> '=' <Reg Exp> <nl>
    begin
      FGrammar.AddTerminal(TGrammarTerminal.Create(
        TerminalName,
        FParser.CurrentReduction.Tokens[0].Reduction.Tokens[0].Position,
        EndPos));
    end;
    Rule_Ruledecl_Nonterminal_Coloncoloneq: // <Rule Decl> ::= Nonterminal <nl opt> '::=' <Handles> <nl>
    begin
      FGrammar.AddRule(TGrammarRule.Create(
        FParser.CurrentReduction.Tokens[0].DataVar,
        FParser.CurrentReduction.Tokens[0].Position,
        EndPos));
    end;
  end; // case aParser.CurrentReduction.ParentRule.TableIndex
end; // TGrammarParser.ReplaceReduction

{ TGrammarItemsList }

function TGrammar.AddItem(const Item: TGrammarItem): integer;
begin
  Result := 0;
  while (Result<FItems.Count) and (Items[Result].StartPos.Y<Item.StartPos.Y) do
    Inc(Result);
  if (Result<FItems.Count) and (Items[Result].StartPos.Y=Item.StartPos.Y) then
    while (Result<FItems.Count) and (Items[Result].StartPos.X<Item.StartPos.X) do
      Inc(Result);

  FItems.Insert(Result, Item);
end;

function TGrammar.AddRule(const Rule: TGrammarRule): integer;
begin
  Result := 0;
  while (Result<FRules.Count) and (Rules[Result].StartPos.Y<Rule.StartPos.Y) do
    Inc(Result);
  if (Result<FRules.Count) and (Rules[Result].StartPos.Y=Rule.StartPos.Y) then
    while (Result<FRules.Count) and (Rules[Result].StartPos.X<Rule.StartPos.X) do
      Inc(Result);

  FRules.Insert(Result, Rule);
end;

function TGrammar.AddSet(const ASet: TGrammarSet): integer;
begin
  Result := 0;
  while (Result<FSets.Count) and (Sets[Result].StartPos.Y<ASet.StartPos.Y) do
    Inc(Result);
  if (Result<FSets.Count) and (Sets[Result].StartPos.Y=ASet.StartPos.Y) then
    while (Result<FSets.Count) and (Sets[Result].StartPos.X<ASet.StartPos.X) do
      Inc(Result);

  FSets.Insert(Result, ASet);
end;

function TGrammar.AddTerminal(Terminal: TGrammarTerminal): integer;
begin
  Result := 0;
  while (Result<FTerminals.Count) and (Terminals[Result].StartPos.Y<Terminal.StartPos.Y) do
    Inc(Result);
  if (Result<FTerminals.Count) and (Terminals[Result].StartPos.Y=Terminal.StartPos.Y) then
    while (Result<FTerminals.Count) and (Terminals[Result].StartPos.X<Terminal.StartPos.X) do
      Inc(Result);

  FTerminals.Insert(Result, Terminal);
end;

procedure TGrammar.Clear;
begin
  FSets.Clear;
  FRules.Clear;
  FItems.Clear;
  FTerminals.Clear;
end;

constructor TGrammar.Create;
begin
  FTerminals := TObjectList.Create;
  FTerminals.OwnsObjects := true;
  FItems := TObjectList.Create;
  FItems.OwnsObjects := true;
  FRules := TObjectList.Create;
  FRules.OwnsObjects := true;
  FSets := TObjectList.Create;
  FSets.OwnsObjects := true;
end;

procedure TGrammar.DeleteItem(const Index: integer);
begin
  FItems.Delete(Index);
end;

destructor TGrammar.Destroy;
begin
  FSets.Free;
  FRules.Free;
  FItems.Free;
  FTerminals.Free;

  inherited;
end;

procedure TGrammarParser.Shutdown;
begin
  Terminate;
  if (FParseEvent<>0) and (FParseEvent<>INVALID_HANDLE_VALUE) then
    SetEvent(FParseEvent);
end;

function TGrammar.GetItem(Index: integer): TGrammarItem;
begin
  Result := FItems[Index] as TGrammarItem;
end;

function TGrammar.GetItemCount: integer;
begin
  Result := FItems.Count;
end;

function TGrammar.GetRule(Index: integer): TGrammarRule;
begin
  Result := FRules[Index] as TGrammarRule;
end;

function TGrammar.GetRuleCount: integer;
begin
  Result := FRules.Count;
end;

function TGrammar.GetSet(Index: integer): TGrammarSet;
begin
  Result := FSets[Index] as TGrammarSet;
end;

function TGrammar.GetSetCount: integer;
begin
  Result := FSets.Count;
end;

function TGrammar.GetTerminal(Index: integer): TGrammarTerminal;
begin
  Result := FTerminals[Index] as TGrammarTerminal;
end;

function TGrammar.GetTerminalCount: integer;
begin
  Result := FTerminals.Count
end;

procedure TGrammar.Init;
var
  i: integer;
begin
  // add predefined terminals
  for i := Low(PREDEFINED_TERMINALS) to High(PREDEFINED_TERMINALS) do
    AddTerminal(TGrammarTerminal.CreatePredefined('{' + PREDEFINED_TERMINALS[i] + '}'));
end;

function TGrammar.IsCharRange(Item: string; var First, Last: integer): boolean;

  function ExtractNumber(var Start: integer; const Finish: Integer): string;
  var
    Chars: set of Char;
    Hex: boolean;
  begin
    Result := '';

    Hex := false;
    if Item[Start] = '#' then
      Chars := ['0' .. '9']
    else
    if Item[Start] = '&' then
    begin
      Chars := ['0'..'9', 'A'..'F', 'a'..'f'];
      Hex := true;
    end
    else
      Exit;

    Inc(Start);
    while (Start <= Finish) and (Item[Start] in Chars) do
    begin
      Result := Result + Item[Start];
      Inc(Start);
    end;
    if Hex then
      Result := '$' + Result;
  end;

  procedure SkipSpace(var Start: Integer; const Finish: Integer);
  begin
    while (Start <= Finish) and (Item[Start] in [#9, ' ']) do
      Inc(Start)
  end;

var
  ItemLen, CurChar: integer;
  s: string;
begin
  Result := false;

  Item := Trim(Item);
  ItemLen := Length(Item);
  if (ItemLen = 0) or (Item[1] <> '{') or (Item[ItemLen] <> '}') then
    Exit;

  // delete '{' and '}' from the begin and the end
  Dec(ItemLen, 2);
  Delete(Item, 1, 1);
  SetLength(Item, ItemLen);

  CurChar := 1;
  s := ExtractNumber(CurChar, ItemLen);
  if s <> '' then
    First := StrToInt(s)
  else
    Exit;

  SkipSpace(CurChar, ItemLen);
  if CurChar > ItemLen then
  begin
    Last := First;
    Result := true;
    Exit;
  end;

  if (CurChar >= ItemLen) or (Item[CurChar] <> '.') or (Item[CurChar+1] <> '.') then
    Exit;
  Inc(CurChar, 2); // skip '..'  

  SkipSpace(CurChar, ItemLen);

  if CurChar >= ItemLen then
    Exit;

  s := ExtractNumber(CurChar, ItemLen);
  if s <> '' then
    Last := StrToInt(s)
  else
    Exit;

  SkipSpace(CurChar, ItemLen);

  if CurChar > ItemLen then
    Result := true;
end;

function TGrammar.ItemAt(const XY: TPoint): TGrammarItem;
var
  i: integer;
begin
  i := FRules.Count-1;
  Result := nil;
  while not Assigned(Result) and (i>=0) and
       ((Items[i].StartPos.Y>XY.Y) or (Items[i].EndPos.Y<XY.Y) or
        ((Items[i].StartPos.Y=XY.Y) and (Items[i].StartPos.X>XY.X)) or
        ((Items[i].EndPos.Y=XY.Y) and (Items[i].EndPos.X<XY.X)))
  do
    Dec(i);

  if i>=0 then
    Result := Items[i];
end;

function TGrammar.ItemByName(const Name: string): integer;
begin
  Result := FItems.Count-1;
  while (Result>=0) and (AnsiCompareText(Items[Result].Name, Name)<>0) do
    Dec(Result);
end;

function TGrammar.RuleAt(const XY: TPoint): TGrammarRule;
var
  i: integer;
begin
  i := FRules.Count-1;
  Result := nil;
  while not Assigned(Result) and (i>=0) and
       ((Rules[i].StartPos.Y>XY.Y) or (Rules[i].EndPos.Y<XY.Y) or
        ((Rules[i].StartPos.Y=XY.Y) and (Rules[i].StartPos.X>XY.X)) or
        ((Rules[i].EndPos.Y=XY.Y) and (Rules[i].EndPos.X<XY.X)))
  do
    Dec(i);

  if i>=0 then
    Result := Rules[i];
end;

function TGrammar.RuleByName(const Name: string): TGrammarRule;
var
  i: integer;
begin
  i := FRules.Count-1;
  while (i>=0) and (AnsiCompareText(Rules[i].Name, Name)<>0) do
    Dec(i);

  if i>=0 then
    Result := Rules[i]
  else
    Result := nil;
end;

function TGrammar.SetAt(const XY: TPoint): TGrammarSet;
var
  i: integer;
begin
  i := FSets.Count-1;
  Result := nil;
  while not Assigned(Result) and (i>=0) and
       ((Sets[i].StartPos.Y>XY.Y) or (Sets[i].EndPos.Y<XY.Y) or
        ((Sets[i].StartPos.Y=XY.Y) and (Sets[i].StartPos.X>XY.X)) or
        ((Sets[i].EndPos.Y=XY.Y) and (Sets[i].EndPos.X<XY.X)))
  do
    Dec(i);

  if i>=0 then
    Result := Sets[i];
end;

function TGrammar.SetByName(const Name: string): TGrammarSet;
var
  i: integer;
begin
  i := FSets.Count-1;
  while (i>=0) and (AnsiCompareText(Sets[i].Name, Name)<>0) do
    Dec(i);

  if i>=0 then
    Result := Sets[i]
  else
    Result := nil;
end;

function GrammarItemsCompare(Item1, Item2: pointer): integer;
begin
  Result := AnsiCompareText(TGrammarItem(Item1).Name, TGrammarItem(Item2).Name);
end;

procedure TGrammar.Sort;
var
  i: integer;
begin
  for i:=FItems.Count-2 downto 0 do
  begin
    if (Items[i].Name='Comment') and
      ((Items[i+1].Name='Start') or (Items[i+1].Name='End') or (Items[i+1].Name='Line')) then
    begin
      FItems.Delete(i+1);
      FItems.Delete(i);
    end;
  end;
  FRules.Sort(GrammarItemsCompare);
  FTerminals.Sort(GrammarItemsCompare);
  FSets.Sort(GrammarItemsCompare);
end;

function TGrammar.TerminalAt(const XY: TPoint): TGrammarTerminal;
var
  i: integer;
begin
  i := FTerminals.Count-1;
  Result := nil;
  while not Assigned(Result) and (i>=0) and
       ((Terminals[i].StartPos.Y>XY.Y) or (Terminals[i].EndPos.Y<XY.Y) or
        ((Terminals[i].StartPos.Y=XY.Y) and (Terminals[i].StartPos.X>XY.X)) or
        ((Terminals[i].EndPos.Y=XY.Y) and (Terminals[i].EndPos.X<XY.X)))
  do
    Dec(i);

  if i>=0 then
    Result := Terminals[i];
end;

function TGrammar.TerminalByName(Name: string): TGrammarTerminal;
var
  i, CharRangeFirst, CharRangeLast: integer;
begin
  Result := nil;
  
  repeat
    i := Pos('  ', Name);
    if i > 0 then
      Delete(Name, i, 1);
  until i = 0;
  i := FTerminals.Count-1;
  while (i >= 0) and not AnsiSameText(Terminals[i].Name, Name) do
    Dec(i);

  if i >= 0 then
    Result := Terminals[i]
  else
  begin
    if IsCharRange(Name, CharRangeFirst, CharRangeLast) then
    begin
      for i := 0 to FTerminals.Count - 1 do
        if Terminals[i].CharRange and (Terminals[i].FirstChar = CharRangeFirst) and (Terminals[i].LastChar = CharRangeLast) then
        begin
          Result := Terminals[i];
          Break;
        end;
    end;
  end;
end;

{ TGrammarSet }

constructor TGrammarSet.Create(const AName: string; const AStartPos, AEndPos: TPoint);
begin
  inherited Create(gikSet, AName, AStartPos, AEndPos);
end;

{ TGrammarItem }

constructor TGrammarItem.Create(const AKind: TGrammarItemKind;  const AName: string; const AStartPos, AEndPos: TPoint);
begin
  FKind := AKind;
  FName := AName;
  FStartPos := AStartPos;
  FEndPos := AEndPos;
end;

{ TGrammarTerminal }

constructor TGrammarTerminal.Create(const AName: string; const AStartPos, AEndPos: TPoint);
begin
  FPredefined := false;
  FCharRange := false;

  inherited Create(gikTerminal, AName, AStartPos, AEndPos);
end;

constructor TGrammarTerminal.CreateCharRange(const AName: string; const AFirstChar, ALastChar: integer);
begin
  Create(AName, Point(1, 1), Point(1, 1));

  FCharRange := true;
  FFirstChar := AFirstChar;
  FLastChar := ALastChar;
end;

constructor TGrammarTerminal.CreatePredefined(const AName: string);
begin
  Create(AName, Point(1, 1), Point(1, 1));

  FPredefined := true;
end;

{ TGrammarRule }

constructor TGrammarRule.Create(const AName: string; const AStartPos, AEndPos: TPoint);
begin
  inherited Create(gikRule, AName, AStartPos, AEndPos);
end;

end.
