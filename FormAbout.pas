unit FormAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TfmAbout = class(TForm)
    Panel1: TPanel;
    bbOk: TBitBtn;
    Panel2: TPanel;
    iIcon: TImage;
    lbAppName: TLabel;
    Label1: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAbout;

implementation

uses UnitUtils;

{$R *.dfm}

procedure ShowAbout;
begin
  with TfmAbout.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfmAbout.FormCreate(Sender: TObject);
begin
  Caption := Caption+APPLICATION_NAME;
  iIcon.Picture.Assign(Application.Icon);
  lbAppName.Caption := APPLICATION_NAME+' '+APPLICATION_VERSION;
end;

end.
