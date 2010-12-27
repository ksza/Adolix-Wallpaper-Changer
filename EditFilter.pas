unit EditFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TEditFilterForm = class(TForm)
    FilterListBox: TListBox;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Apply: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure ApplyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditFilterForm: TEditFilterForm;

implementation

uses Filter;

{$R *.dfm}

procedure TEditFilterForm.Button2Click(Sender: TObject);
begin
  with FilterListBox do
    Items.Delete(ItemIndex);
end;

procedure TEditFilterForm.Button1Click(Sender: TObject);
var i: 1..4;
    b: boolean;
begin
  b:=true;
  for i:=1 to length(edit1.Text) do
    if not (UpCase(edit1.text[i]) in ['A'..'Z']) then begin
      b:=false;
      break;
    end;
  if (b = true)and(Length(edit1.Text) > 0) then
    FilterListBox.Items.Add('*' + '.' + edit1.Text)
end;

procedure TEditFilterForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:=false;
end;

procedure TEditFilterForm.ApplyClick(Sender: TObject);
var i: word;
begin
  FilterForm.FilterEdit.Text:='';
  for i:=0 to (FilterListBox.Items.Count - 1) do
    with FilterForm do
        FilterEdit.Text:=FilterEdit.Text + FilterListBox.Items[i] + ';';
  close;
end;

end.
