unit EnterKeyUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TEnterKeyForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    NameEdit: TEdit;
    Label3: TLabel;
    KeyEdit: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EnterKeyForm: TEnterKeyForm;

implementation

{$R *.dfm}

procedure TEnterKeyForm.Button3Click(Sender: TObject);
begin
  close;
end;

procedure TEnterKeyForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:=false;
end;

end.
