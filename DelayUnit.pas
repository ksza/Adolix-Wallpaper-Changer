unit DelayUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TDelayForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    SpinEdit1: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DelayForm: TDelayForm;

implementation

uses ScreenUnit;

{$R *.dfm}

procedure TDelayForm.Button1Click(Sender: TObject);
begin
  ScreenForm.ASGScreenCapture.Delay:=SpinEdit1.Value;
  close;
end;

procedure TDelayForm.Button2Click(Sender: TObject);
begin
  close;
end;

end.
