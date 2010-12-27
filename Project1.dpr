program Project1;

uses
  Forms,
  main in 'MAIN.PAS' {MainForm},
  AddFolder in 'AddFolder.pas' {AddFolderForm},
  Filter in 'Filter.pas' {FilterForm},
  EditFilter in 'EditFilter.pas' {EditFilterForm},
  ScanDisk in 'ScanDisk.pas' {ScanDiskForm},
  USettings in 'USettings.pas' {Settings},
  selection in 'selection.pas' {SelectionForm},
  ScreenUnit in 'ScreenUnit.pas' {ScreenForm},
  ASGCapture in 'ASGCapture.pas',
  DelayUnit in 'DelayUnit.pas' {DelayForm},
  sendmail in 'sendmail.pas' {MailForm},
  about in 'about.pas' {AboutForm},
  Urename in 'Urename.pas' {RenameForm},
  URMC in 'URMC.pas' {RMCForm},
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  EnterKeyUnit in 'EnterKeyUnit.pas' {EnterKeyForm};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm:=false;
  Application.Title := 'Adolix Wallpaper Changer';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAddFolderForm, AddFolderForm);
  Application.CreateForm(TFilterForm, FilterForm);
  Application.CreateForm(TEditFilterForm, EditFilterForm);
  Application.CreateForm(TScanDiskForm, ScanDiskForm);
  Application.CreateForm(TSelectionForm, SelectionForm);
  Application.CreateForm(TScreenForm, ScreenForm);
  Application.CreateForm(TDelayForm, DelayForm);
  Application.CreateForm(TSettings, Settings);
  Application.CreateForm(TMailForm, MailForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TRenameForm, RenameForm);
  Application.CreateForm(TRMCForm, RMCForm);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TEnterKeyForm, EnterKeyForm);
  Form1.ShowModal;
  if MainForm.isRegistered then begin
    MainForm.CoolTrayIcon1.Enabled:=MainForm.isRegistered;
    Application.Run;
  end;
end.
