program GrammarEdit;

{%ToDo 'GrammarEdit.todo'}

uses
  Forms,
  FormMain in 'FormMain.pas' {fmMain},
  GrammarParser in 'GrammarParser.pas',
  Variables in 'GOLDParser\Variables.pas',
  GOLDParser in 'GOLDParser\GOLDParser.pas',
  GrammarReader in 'GOLDParser\GrammarReader.pas',
  LRAction in 'GOLDParser\LRAction.pas',
  MemLeakFinder in 'GOLDParser\MemLeakFinder.pas',
  Rule in 'GOLDParser\Rule.pas',
  SourceFeeder in 'GOLDParser\SourceFeeder.pas',
  Symbol in 'GOLDParser\Symbol.pas',
  Token in 'GOLDParser\Token.pas',
  FAState in 'GOLDParser\fasTATE.pas',
  GrammarSyn in 'GrammarSyn.pas',
  UnitUtils in 'UnitUtils.pas',
  FormSettings in 'FormSettings.pas' {fmOptions},
  FormAbout in 'FormAbout.pas' {fmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
