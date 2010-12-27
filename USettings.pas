unit USettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, {}INIfiles{}, {}Registry{}, {}ShlObj,
  Buttons, ExtDlgs{}, {}MMSystem{}, {}Menus{}, {}axCtrls{}, {}ShellAPI{},
  {}Commctrl{};

type
  TSettings = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    TabSheet5: TTabSheet;
    Bevel1: TBevel;
    PlaySoundCheckBox: TCheckBox;
    OpenDialog2: TOpenDialog;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    SoundListBox: TListBox;
    NamePanel: TPanel;
    ShuffleCheckBox: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox17: TCheckBox;
    HotKey17: THotKey;
    HotKey11: THotKey;
    HotKey10: THotKey;
    HotKey9: THotKey;
    HotKey8: THotKey;
    Bevel3: TBevel;
    Bevel4: TBevel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox6: TCheckBox;
    ComboBox2: TComboBox;
    Label5: TLabel;
    CheckBox12: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    DefPozComboBox: TComboBox;
    Bevel2: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    ColorBox3: TColorBox;
    CheckBox16: TCheckBox;
    CheckBox15: TCheckBox;
    Bevel5: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    MainBitBtn1: TSpeedButton;
    MainBitBtn2: TSpeedButton;
    MainBitBtn3: TSpeedButton;
    BitBtn1: TSpeedButton;
    BitBtn2: TSpeedButton;
    MainNew: TSpeedButton;
    MainAppend: TSpeedButton;
    MainLoad: TSpeedButton;
    MainSave: TSpeedButton;
    ColorBox2: TColorBox;
    DefColorBox: TPanel;
    ColorDialog1: TColorDialog;
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure MainNewClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure MainBitBtn3Click(Sender: TObject);
    procedure MainBitBtn2Click(Sender: TObject);
    procedure MainBitBtn1Click(Sender: TObject);
    procedure MainAppendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MainLoadClick(Sender: TObject);
    procedure MainSaveClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure SoundListBoxDblClick(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure CheckBox11Click(Sender: TObject);
    procedure CheckBox17Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DefColorBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DefColorBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DefColorBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    imageresampling:boolean;
    {Sound}
    PlayList: TStringList;
    {-------------------------------}
    {HotKeys}
    id1, id2, id3, id4, id5: Integer;
    HK1, HK2, HK3, HK4, HK5: boolean;
    {-------------------------------}

    {Desktop Icons}
    hLV: THandle;
    {-------------------------------}

    {Sound}
    procedure AddItemsToPlayList(Tomb: TStrings);
    procedure AddItemsFromFile(fis: string);
    {-------------------------------------------}

    {HotKey}
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure RegisterAll;
    procedure UnRegOneHK(var HK: boolean; var id: integer);
    procedure UnRegHK;
    {--------------------------------------------------------}

    {Desktop Icons}
    procedure GetDesktopListViewHandle;
    {--------------------------------------------------------}
  end;

var
  Settings: TSettings;
  IniSettings:TINIFile;
implementation

uses main, ScreenUnit;

{$R *.dfm}

procedure TSettings.Button2Click(Sender: TObject);
begin
  Button4.Click;
  Settings.Close;
end;

procedure RegisterExtensions;
const
  cMyExt = '.awc';
  cMyFileType = 'Wallpaper XE PlayList';
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try

    Reg.RootKey := HKEY_CLASSES_ROOT;

    Reg.OpenKey(cMyExt, True);

    Reg.WriteString('', cMyFileType);
    Reg.CloseKey;

    Reg.OpenKey(cMyFileType, True);

    Reg.WriteString('', 'Project1 File');
    Reg.CloseKey;

    Reg.OpenKey(cMyFileType + '\DefaultIcon', True);
    Reg.WriteString('', Application.ExeName + ',0');
    Reg.CloseKey;

    Reg.OpenKey(cMyFileType + '\Shell\Open', True);
    Reg.WriteString('', '&Open');
    Reg.CloseKey;

    Reg.OpenKey(cMyFileType + '\Shell\Open\Command', True);
    Reg.WriteString('', '"' + Application.ExeName + '" "%1"');
    Reg.CloseKey;

    SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
  finally
    Reg.Free;
  end;
end;

{Randomise Wallpaper List} procedure RandomiseWallpaperList;
    var
       i,j,k:integer;
       tomb:string;
    begin
       if MainForm.PlayList.Count>0 then
       begin
         randomize;
         for k:=1 to 10 do
         begin
              i:=Random( MainForm.PlayList.Count div 2 ); j:=Random( MainForm.PlayList.Count div 2 );

              tomb:=MainForm.PlayList.Strings[2*i];
              MainForm.PlayList.Strings[2*i]:=MainForm.PlayList.Strings[2*j];
              MainForm.PlayList.Strings[2*j]:=tomb;

              tomb:=MainForm.PlayList.Strings[2*i+1];
              MainForm.PlayList.Strings[2*i+1]:=MainForm.PlayList.Strings[2*j+1];
              MainForm.PlayList.Strings[2*j+1]:=tomb;
         end;

         MainForm.MainListBox.Clear; MainForm.LoadItemsToMainListBox(MainForm.ShowFullpath1.Checked);
       end;
end;

procedure TSettings.Button4Click(Sender: TObject);
var xColor: TColor;
begin
{INI Settings}
     IniSettings:=TiniFile.Create(MainForm.RootDir+IniName);
     IniSettings.WriteBool('Show help tips','Checked',Checkbox1.Checked);
     IniSettings.WriteBool('Run at startup','Checked',Checkbox2.Checked); MainForm.ChangeWallpaperAtStartup(checkbox2.Checked);
     IniSettings.WriteBool('Always minimize','Checked',Checkbox3.Checked);
     IniSettings.WriteBool('Animate Wallpaper','Checked',Checkbox4.Checked);
     IniSettings.WriteBool('Enable Drag and Drop','Checked',Checkbox5.Checked);
     IniSettings.WriteBool('Ask Confirmations','Checked',Checkbox6.Checked);
     IniSettings.WriteBool('High Quality Image Resampling','Checked',CheckBox7.Checked);

     IniSettings.WriteBool('Register Extensions','Checked',Checkbox12.Checked); RegisterExtensions;
     IniSettings.WriteBool('Shuffle Wallpapers','Checked',Checkbox13.Checked); RandomiseWallpaperList;

     Inisettings.WriteString('language','value',combobox2.Text);

{Hotkeys}
     IniSettings.WriteBool('Checkbox8','Checked',CheckBox8.Checked);
     IniSettings.WriteBool('Checkbox9','Checked',CheckBox9.Checked);
     IniSettings.WriteBool('Checkbox10','Checked',CheckBox10.Checked);
     IniSettings.WriteBool('Checkbox11','Checked',CheckBox11.Checked);
     IniSettings.WriteBool('Checkbox12','Checked',CheckBox12.Checked);

     IniSettings.WriteInteger('Hotkey8','value',Hotkey8.HotKey);
     IniSettings.WriteInteger('Hotkey9','value',Hotkey9.HotKey);
     IniSettings.WriteInteger('Hotkey10','value',Hotkey10.HotKey);
     IniSettings.WriteInteger('Hotkey11','value',Hotkey11.HotKey);
     IniSettings.WriteInteger('Hotkey17','value',Hotkey17.HotKey);

{Desktop Icons}
     IniSettings.WriteBool('Checkbox15','Checked',CheckBox15.Checked);
     IniSettings.WriteBool('Checkbox16','Checked',CheckBox16.Checked);
     IniSettings.WriteInteger('ColorBox2','Color',ColorBox2.Color);
     IniSettings.WriteInteger('ColorBox3','Color',ColorBox3.Color);
     IniSettings.WriteInteger('DefPozComboBox','value',DefPozComboBox.ItemIndex);
     IniSettings.WriteInteger('DefColorBox','Color',DefColorBox.Color);

{Sound}
     IniSettings.WriteBool('PlaySoundCheckBox','Checked',PlaySoundCheckBox.Checked);
     IniSettings.WriteBool('ShuffleCheckBox','Checked',ShuffleCheckBox.Checked);

{Hotkeys}

     IniSettings.Free;
{INI Settings}

  RegisterAll; // HotKeys

  MainForm.EnableHints(CheckBox1.Checked);

  MainForm.CoolTrayIcon1.CycleIcons:=CheckBox4.Checked;
  MainForm.CoolTrayIcon1.IconIndex:=0;

  if CheckBox15.Checked then begin
    GetDesktopListViewHandle;
    xColor := ListView_GetTextColor(hLV);
    ListView_SetTextColor(hLV, xColor);
    xColor := ListView_GetTextBkColor(hLV);
    ListView_SetTextBkColor(hLV, xColor);
    ListView_SetTextBkColor(hLV, $FFFFFFFF);
  end;
end;

procedure TSettings.Button3Click(Sender: TObject);
begin
  Settings.Close;
end;

{-------------------------------Sound------------------------------------------}
procedure TSettings.AddItemsToPlayList(Tomb: TStrings);
var i:integer;
    name, ext:string;
begin
  for i:=0 to Tomb.Count-1 do
    if FileExists(tomb.Strings[i]) then begin
      name:=ExtractFileName(Tomb.Strings[i]);
      ext:=ExtractFileExt(name);
      delete(name, pos(ext,name), length(ext) );
      SoundListBox.Items.Add(name);
      PlayList.Add(tomb.Strings[i])
    end;
end;

procedure TSettings.AddItemsFromFile(fis: string);
var f: TextFile;
    s, name, ext: string;
begin
  try
    AssignFile(f, fis);
    try
      try
        Reset(f);
        while (not eof(f)) do begin
          ReadLn(f, s);
          name:=ExtractFileName(s);
          ext:=ExtractFileExt(name);
          delete(name, pos(ext,name), length(ext) );
          SoundListBox.Items.Add(name);
          PlayList.Add(s);
        end;
      except
        on EReadError do
          raise EReadError.Create('Read Error');
      end;
    finally
      CloseFile(f);
    end;
  except
    on EAccessViolation do
      raise EAccessViolation.Create('Cannot assign file');
  end;
end;


procedure TSettings.MainNewClick(Sender: TObject);
begin
  SoundListBox.Clear;
  if Assigned(PlayList) then
    PlayList.Clear;
  NamePanel.Caption:='Default';
end;

procedure TSettings.BitBtn1Click(Sender: TObject);
begin
  with OpenDialog2 do
    if Execute then begin
      AddItemsToPlayList(Files);
    end;
end;

procedure TSettings.MainBitBtn3Click(Sender: TObject);
begin
  SoundListBox.DeleteSelected;
end;

procedure TSettings.MainBitBtn2Click(Sender: TObject);
begin
  if SoundListBox.ItemIndex < 0 then begin
    SoundListBox.ItemIndex:=0;
  end
  else
    if SoundListBox.ItemIndex < (SoundListBox.Items.Count - 1) then begin
    SoundListBox.ItemIndex:=SoundListBox.ItemIndex + 1;
    end;
end;

procedure TSettings.MainBitBtn1Click(Sender: TObject);
begin
  if SoundListBox.ItemIndex < 0 then SoundListBox.ItemIndex:=0
  else
    if SoundListBox.ItemIndex > 0 then begin
    SoundListBox.ItemIndex:=SoundListBox.ItemIndex - 1;
  end;
end;

procedure TSettings.MainAppendClick(Sender: TObject);
begin
 if OpenDialog1.Execute then
   if FileExists(OpenDialog1.FileName) then
     AddItemsFromFile(OpenDialog1.FileName);
end;

procedure TSettings.FormCreate(Sender: TObject);
var xColor: TColor;
begin
  Randomize;

  DefColorBox.ParentBackground:=false;
  DefColorBox.ParentColor:=false;

  PlayList:=TStringList.Create;

  HK1:=false; HK2:=false; HK3:=false; HK4:=false; HK5:=false; //HotKeys

     IniSettings:=TIniFile.Create(MainForm.RootDir+INIname);
{General}
     CheckBox1.Checked:=IniSettings.ReadBool('Show help tips','Checked',false);
     CheckBox2.Checked:=IniSettings.ReadBool('Run at startup','Checked',true);
     CheckBox3.Checked:=IniSettings.ReadBool('Always minimize','Checked',true);
     CheckBox4.Checked:=IniSettings.ReadBool('Animate Wallpaper','Checked',false);
     CheckBox5.Checked:=IniSettings.ReadBool('Enable Drag and Drop','Checked',false);
     CheckBox6.Checked:=IniSettings.ReadBool('Ask Confirmations','Checked',false);
     CheckBox7.Checked:=IniSettings.ReadBool('High Quality Image Resampling','Checked',false);

     combobox2.Text:=inisettings.ReadString('language','value','English');
    with MainForm do begin
     if Language1.LanguageFile <> RootDir + Settings.ComboBox2.Text + '.lng' then
     begin
       Language1.LanguageFile:=RootDir + Settings.ComboBox2.Text + '.lng';
       Language1.Translate;
     end;
     CoolTrayIcon1.CycleIcons:=CheckBox4.Checked;
     CoolTrayIcon1.IconIndex:=0;     
   end;

{Hotkeys}
     CheckBox8.Checked:=IniSettings.ReadBool('Checkbox8','Checked',false);
     CheckBox9.Checked:=IniSettings.ReadBool('Checkbox9','Checked',false);
     CheckBox10.Checked:=IniSettings.ReadBool('Checkbox10','Checked',false);
     CheckBox11.Checked:=IniSettings.ReadBool('Checkbox11','Checked',false);
     CheckBox12.Checked:=IniSettings.ReadBool('Checkbox12','Checked',false);

     Hotkey8.HotKey:=IniSettings.ReadInteger('Hotkey8','value',0);
     Hotkey9.HotKey:=IniSettings.ReadInteger('Hotkey9','value',0);
     Hotkey10.HotKey:=IniSettings.ReadInteger('Hotkey10','value',0);
     Hotkey11.HotKey:=IniSettings.ReadInteger('Hotkey11','value',0);
     Hotkey17.HotKey:=IniSettings.ReadInteger('Hotkey17','value',0);
{Hotkeys}

{Wallpaper List}
     CheckBox12.Checked:=IniSettings.ReadBool('Register Extensions','Checked',false);
     CheckBox13.Checked:=IniSettings.ReadBool('Shuffle Wallpapers','Checked',false);

{Desktop Icons}
     CheckBox15.Checked:=IniSettings.ReadBool('Checkbox15','Checked',false);
     CheckBox16.Checked:=IniSettings.ReadBool('Checkbox16','Checked',false);
     ColorBox2.Color:=IniSettings.ReadInteger('ColorBox2','Color',clBlack);
     ColorBox3.Color:=IniSettings.ReadInteger('ColorBox3','Color',clBlack);
     DefPozComboBox.ItemIndex:=IniSettings.ReadInteger('DefPozComboBox','value',0);
     DefColorBox.Color:=IniSettings.ReadInteger('DefColorBox','Color',clBlack);

{Sound}
     PlaySoundCheckBox.Checked:=IniSettings.ReadBool('PlaySoundCheckBox','Checked',false);
     ShuffleCheckBox.Checked:=IniSettings.ReadBool('ShuffleCheckBox','Checked',false);

     IniSettings.Free;

     RegisterAll;

     MainForm.EnableHints(CheckBox1.Checked);

     if CheckBox15.Checked then begin
       GetDesktopListViewHandle;
       xColor := ListView_GetTextColor(hLV);
       ListView_SetTextColor(hLV, xColor);
       xColor := ListView_GetTextBkColor(hLV);
       ListView_SetTextBkColor(hLV, xColor);
       ListView_SetTextBkColor(hLV, $FFFFFFFF);
     end;
end;

procedure TSettings.FormDestroy(Sender: TObject);
begin
  if Assigned(PlayList) then PlayList.Free;

  UnRegHK; //HotKeys
end;

procedure TSettings.MainLoadClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    if FileExists(OpenDialog1.FileName) then begin
      SoundListBox.Clear;
      PlayList.Clear;
      NamePanel.Caption:=ExtractFileName(OpenDialog1.FileName);

      AddItemsFromFile(OpenDialog1.FileName);
    end;
end;

procedure TSettings.MainSaveClick(Sender: TObject);
var nume, ext: string;
begin
  with SaveDialog1 do
    if Execute then begin
      nume:=ExtractFileName(SaveDialog1.FileName);
      ext:=ExtractFileExt(SaveDialog1.FileName);
      if ext = '' then begin
        NamePanel.Caption:=nume + '.wxs';
        PlayList.SaveToFile(SaveDialog1.FileName + '.wxs');
      end
      else begin
        NamePanel.Caption:=nume;
        PlayList.SaveToFile(SaveDialog1.FileName);
      end;
    end;
end;

procedure TSettings.BitBtn2Click(Sender: TObject);
var Music: array[0..1000]of char;
    s: string;
    nr: LongInt;
begin
  // procedura PlaySound o gasesti in unit-ul MMSystem !!!!!
  if SoundListBox.Items.Count <> 0 then begin
    if SoundListBox.ItemIndex < 0 then SoundListBox.ItemIndex:=0;
    if PlaySoundCheckBox.Checked then begin
      if ShuffleCheckBox.Checked then begin
        nr:=Random(SoundListBox.Items.Count);
        SoundListBox.ItemIndex:=nr;
      end;
      s:=PlayList.Strings[SoundListBox.ItemIndex];
      StrPCopy(Music, s);
      PlaySound(Music, 0, SND_FILENAME + SND_ASYNC);
    end;
  end;  
end;

procedure TSettings.SoundListBoxDblClick(Sender: TObject);
begin
  BitBtn2Click(Self);
end;
{------------------------------------------------------------------------------}

{--------------------------------HotKey----------------------------------------}
// WM_HOTKEY Hotkey Handler
procedure TSettings.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey = id1 then
    MainForm.WallpaperXEControlPanel1Click(Self); // Show WallpaperXE Control Panel
  if Msg.HotKey = id2 then
  begin
       with Mainform do
       begin
            NextWallpape1Click(self);
       end;
  end;
  if Msg.HotKey = id3 then
  begin
       with Mainform do
       begin
            PreviousWallpaper1Click(self);
       end;
  end;
  if Msg.HotKey = id4 then
  begin
       with mainform do ClearWallpaper1Click(self);
    ShowMessage('Message4'); // Clear Wallpaper
  end;
  if Msg.HotKey = id5 then begin
    ScreenForm.Desktop1Click(Self); // Capture Screen
    ScreenForm.Show;
  end;
end;

procedure ShortCutToHotKey(HotKey: TShortCut; var Key : Word; var Modifiers: Uint);
var Shift: TShiftState;
begin
  ShortCutToKey(HotKey, Key, Shift);
  Modifiers := 0;
  if (ssShift in Shift) then
  Modifiers := Modifiers or MOD_SHIFT;
  if (ssAlt in Shift) then
  Modifiers := Modifiers or MOD_ALT;
  if (ssCtrl in Shift) then
  Modifiers := Modifiers or MOD_CONTROL;
end;

procedure TSettings.RegisterAll;
var Key : Word;
    Modifiers: UINT;
begin
  if CheckBox8.Checked then begin
    if HK1 = true then UnRegOneHK(HK1, id1);
    ShortCutToHotKey(HotKey8.HotKey, Key, Modifiers);
    id1:=GlobalAddAtom('MyHotKey_1');
    RegisterHotKey(Handle, id1, Modifiers, Key);
    HK1:=true;
  end;
  if CheckBox9.Checked then begin
    if HK2 = true then UnRegOneHK(HK2, id2);
    ShortCutToHotKey(HotKey9.HotKey, Key, Modifiers);
    id2:=GlobalAddAtom('MyHotKey_2');
    RegisterHotKey(Handle, id2, Modifiers, Key);
    HK2:=true;
  end;
  if CheckBox10.Checked then begin
    if HK3 = true then UnRegOneHK(HK3, id3);
    ShortCutToHotKey(HotKey10.HotKey, Key, Modifiers);
    id3:=GlobalAddAtom('MyHotKey_3');
    RegisterHotKey(Handle, id3, Modifiers, Key);
    HK3:=true;
  end;
  if CheckBox11.Checked then begin
    if HK4 = true then UnRegOneHK(HK4, id4);
    ShortCutToHotKey(HotKey11.HotKey, Key, Modifiers);
    id4:=GlobalAddAtom('MyHotKey_4');
    RegisterHotKey(Handle, id4, Modifiers, Key);
    HK4:=true;
  end;
  if CheckBox17.Checked then begin
    if HK5 = true then UnRegOneHK(HK5, id5);
    ShortCutToHotKey(HotKey17.HotKey, Key, Modifiers);
    id5:=GlobalAddAtom('MyHotKey_5');
    RegisterHotKey(Handle, id5, Modifiers, Key);
    HK5:=true;
  end;
end;

// Remove Hotkey
procedure TSettings.UnRegOneHK(var HK: boolean; var id: integer);
begin
  if HK then begin
    UnRegisterHotKey(Handle, id);
    GlobalDeleteAtom(id);
    HK:=false;
  end;
end;

procedure TSettings.UnRegHK;
begin
  UnRegOneHK(HK1, id1);
  UnRegOneHK(HK2, id2);
  UnRegOneHK(HK3, id3);
  UnRegOneHK(HK4, id4);
  UnRegOneHK(HK5, id5);
end;

procedure TSettings.CheckBox8Click(Sender: TObject);
begin
  HotKey8.Visible:=CheckBox8.Checked;
end;

procedure TSettings.CheckBox9Click(Sender: TObject);
begin
  HotKey9.Visible:=CheckBox9.Checked;
end;

procedure TSettings.CheckBox10Click(Sender: TObject);
begin
  HotKey10.Visible:=CheckBox10.Checked;
end;

procedure TSettings.CheckBox11Click(Sender: TObject);
begin
  HotKey11.Visible:=CheckBox11.Checked;
end;

procedure TSettings.CheckBox17Click(Sender: TObject);
begin
  HotKey17.Visible:=CheckBox17.Checked;
end;

procedure TSettings.ComboBox2Change(Sender: TObject);
begin
  with MainForm do
    if Language1.LanguageFile <> RootDir + Settings.ComboBox2.Text + '.lng' then begin
      Language1.LanguageFile:=RootDir + Settings.ComboBox2.Text + '.lng';
      Language1.Translate;
    end;
end;

procedure TSettings.CheckBox5Click(Sender: TObject);
begin
     With Mainform do
     begin
         if CheckBox5.Checked then
         begin
            OldLBWindowProc := MainListBox.WindowProc; // store defualt WindowProc
            MainListBox.WindowProc := LBWindowProc; // replace default WindowProc
            DragAcceptFiles(MainListBox.Handle, True); // now ListBox1 accept dropped files
         end else
         begin
              MainListBox.WindowProc := OldLBWindowProc;
              DragAcceptFiles(MainListBox.Handle, False);
         end;
     end;
end;

{Desktop Icons}
procedure TSettings.GetDesktopListViewHandle;
var
  s1: String;
begin
  hLV := FindWindow('ProgMan', nil);
  hLV := GetWindow(hLV, GW_CHILD);
  hLV := GetWindow(hLV, GW_CHILD);
  SetLength(s1, 40);
  GetClassName(hLV, PChar(s1), 39);
  if PChar(s1) <> 'SysListView32' then
    ShowMessage('Failed');
end;
{------------------------------------------------------------------------------}

procedure TSettings.Button1Click(Sender: TObject);
begin
     IniSettings:=TIniFile.Create(MainForm.RootDir+INIname);
{General}
     CheckBox1.Checked:=IniSettings.ReadBool('Show help tips','Checked',false);
     CheckBox2.Checked:=IniSettings.ReadBool('Run at startup','Checked',true);
     CheckBox3.Checked:=IniSettings.ReadBool('Always minimize','Checked',true);
     CheckBox4.Checked:=IniSettings.ReadBool('Animate Wallpaper','Checked',false);
     CheckBox5.Checked:=IniSettings.ReadBool('Enable Drag and Drop','Checked',false);
     CheckBox6.Checked:=IniSettings.ReadBool('Ask Confirmations','Checked',false);
     CheckBox7.Checked:=IniSettings.ReadBool('High Quality Image Resampling','Checked',false);

     combobox2.Text:=inisettings.ReadString('language','value','English');
    with MainForm do
     if Language1.LanguageFile <> RootDir + Settings.ComboBox2.Text + '.lng' then
     begin
       Language1.LanguageFile:=RootDir + Settings.ComboBox2.Text + '.lng';
       Language1.Translate;
     end;

{Hotkeys}
     CheckBox8.Checked:=IniSettings.ReadBool('Checkbox8','Checked',false);
     CheckBox9.Checked:=IniSettings.ReadBool('Checkbox9','Checked',false);
     CheckBox10.Checked:=IniSettings.ReadBool('Checkbox10','Checked',false);
     CheckBox11.Checked:=IniSettings.ReadBool('Checkbox11','Checked',false);
     CheckBox12.Checked:=IniSettings.ReadBool('Checkbox12','Checked',false);

     Hotkey8.HotKey:=IniSettings.ReadInteger('Hotkey8','value',0);
     Hotkey9.HotKey:=IniSettings.ReadInteger('Hotkey9','value',0);
     Hotkey10.HotKey:=IniSettings.ReadInteger('Hotkey10','value',0);
     Hotkey11.HotKey:=IniSettings.ReadInteger('Hotkey11','value',0);
     Hotkey17.HotKey:=IniSettings.ReadInteger('Hotkey17','value',0);
{Hotkeys}

{Wallpaper List}
     CheckBox12.Checked:=IniSettings.ReadBool('Register Extensions','Checked',false);
     CheckBox13.Checked:=IniSettings.ReadBool('Shuffle Wallpapers','Checked',false);

{Desktop Icons}
     CheckBox15.Checked:=IniSettings.ReadBool('Checkbox15','Checked',false);
     CheckBox16.Checked:=IniSettings.ReadBool('Checkbox16','Checked',false);
     ColorBox2.Color:=IniSettings.ReadInteger('ColorBox2','Color',clBlack);
     ColorBox3.Color:=IniSettings.ReadInteger('ColorBox3','Color',clBlack);
     DefPozComboBox.ItemIndex:=IniSettings.ReadInteger('DefPozComboBox','value',0);
     DefColorBox.Color:=IniSettings.ReadInteger('DefColorBox','Color',clBlack);

{Sound}
     PlaySoundCheckBox.Checked:=IniSettings.ReadBool('PlaySoundCheckBox','Checked',false);
     ShuffleCheckBox.Checked:=IniSettings.ReadBool('ShuffleCheckBox','Checked',false);

     IniSettings.Free;
end;

procedure TSettings.DefColorBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DefColorBox.BevelOuter:=bvLowered;
end;

procedure TSettings.DefColorBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DefColorBox.BevelOuter:=bvRaised;
end;

procedure TSettings.DefColorBoxClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
    DefColorBox.Color:=ColorDialog1.Color;
end;

end.
