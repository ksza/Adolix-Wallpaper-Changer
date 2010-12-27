unit Filter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFilterForm = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    FilterEdit: TEdit;
    RecurseSubfoldersCheckBox: TCheckBox;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FilterForm: TFilterForm;

implementation

uses main, EditFilter;

{$R *.dfm}

procedure TFilterForm.Button2Click(Sender: TObject);
begin
  MainForm.SIZE:=0;
  close;
end;

procedure TFilterForm.Button1Click(Sender: TObject);
var i, j: integer;
    s: string;
begin
  for i:=0 to (EditFilterForm.FilterListBox.Items.Count - 1) do begin
    s:=EditFilterForm.FilterListBox.Items[i];
    delete(s, 1, 1);
    for j:=1 to length(s) do
      s[j]:=UpCase(s[j]);
    MainForm.ListOfExt[i + 1]:=s;
  end;
  MainForm.Size:=EditFilterForm.FilterListBox.Items.Count;
  MainForm.RecurseSubfolders:=RecurseSubfoldersCheckBox.Checked;
  
  close;
end;

procedure TFilterForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:=false;
end;

procedure TFilterForm.Button3Click(Sender: TObject);
begin
  EditFilterForm.ShowModal;
end;

end.
