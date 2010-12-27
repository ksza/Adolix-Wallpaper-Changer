unit URMC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ShellCtrls, menus;

type
  TRMCForm = class(TForm)
    ShellTreeView1: TShellTreeView;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RMCForm: TRMCForm;

implementation

uses main, shellapi;

{$R *.dfm}

procedure TRMCForm.Button2Click(Sender: TObject);
begin
     RmcForm.Close;
end;

procedure TRMCForm.Button1Click(Sender: TObject);
var
   oldfilepath,newfilepath:string; overwrite:boolean;
begin
     if ShellTreeView1.Path<>'' then
     begin
          oldfilepath:=MainForm.PlayList.Strings[MainForm.MainListBox.itemindex*2];
          newfilepath:=ShellTreeview1.Path+ExtractFilename(oldfilepath);

          if RmcForm.Caption='Copy Files' then
          begin
               overwrite:=false; if fileexists(newfilepath) then overwrite:=true;
               copyfile(pchar(oldfilepath),pchar(newfilepath), overwrite);
          end;

          if RmcForm.Caption='Move Files' then
          begin
               movefile(pchar(oldfilepath),pchar(newfilepath));
               MainForm.PlayList.Strings[MainForm.MainListBox.itemindex*2]:=newfilepath;
          end;
     end;
     RMCform.Close;
end;

end.
