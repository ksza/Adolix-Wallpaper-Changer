unit sendmail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMailForm = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MailForm: TMailForm;

implementation

uses main;

{$R *.dfm}

procedure TMailForm.Button1Click(Sender: TObject);
begin
     mainform.mailadress:=edit1.Text;
     mailform.Close;
end;

end.
