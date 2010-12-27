unit Urename;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TRenameForm = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RenameForm: TRenameForm;

implementation

uses main;

{$R *.dfm}

procedure TRenameForm.FormShow(Sender: TObject);
begin
     With MainForm do
     begin
          Label1.Caption:=ExtractFilename(MainListBox.Items.Strings[MainListBox.itemindex]);
          Edit1.Text:=Label1.Caption; edit1.SelectAll;
     end;
end;

procedure TRenameForm.Button1Click(Sender: TObject);
var
   f:file;
   filepath,fileext,filedir:string;
begin
     with MainForm do
       if edit1.Text<>'' then
       begin
            filepath:=PlayList.Strings[MainListBox.itemindex*2];
            fileext:=ExtractFileExt(filepath);
            filedir:=ExtractFileDir(filepath);

            assignfile(f,filepath);
            rename(f,filedir+edit1.Text+fileext);

            PlayList.Strings[MainListBox.itemindex*2]:=filedir+edit1.Text+fileext;
            PlayList.Strings[MainListBox.itemindex*2+1]:=edit1.Text;

            MainListBox.Clear; LoadItemsToMainListBox(ShowFullPath1.Checked);

            RenameForm.Close;
       end;
end;

end.
