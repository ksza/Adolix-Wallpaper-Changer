unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Bevel1: TBevel;
    Label2: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses EnterKeyUnit;

{$R *.dfm}

procedure TForm2.Button2Click(Sender: TObject);
begin
  EnterKeyForm.ShowModal;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  close;
end;

procedure TForm2.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:=false;
end;

end.
