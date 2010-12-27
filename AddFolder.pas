unit AddFolder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellCtrls, StdCtrls;

type
  TAddFolderForm = class(TForm)
    ShellTreeView1: TShellTreeView;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddFolderForm: TAddFolderForm;
implementation

uses main;

{$R *.dfm}

procedure TAddFolderForm.Button1Click(Sender: TObject);
begin
  if ShellTreeView1.Selected.Text <> '' then begin
    MainForm.Cale:=ShellTreeView1.SelectedFolder.PathName;
    AddFolderForm.close;
  end;
end;

procedure TAddFolderForm.Button2Click(Sender: TObject);
begin
  MainForm.Cale:='';
  AddFolderForm.close;
end;

procedure TAddFolderForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:=false;
end;

end.
