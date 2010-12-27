unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, StdCtrls, Buttons, Spin, {}jpeg{}, Menus,
  {}ShellAPI{}, AppEvnts, ExtDlgs, {}INIfiles{}, {}axCtrls{}, {}Registry{}, ShlObj, ComObj,
  Lang, {}Printers{}, {}ResampleUnit, TrayIcon, CoolTrayIcon, ImgList{};

const

     ct_time:array[0..3] of integer=(1,60,3600,86400);

     READ_ERROR='ERROR Reading from Disk';
     WRITE_ERROR='ERROR Writing to Disk';
     NOFILE_ERROR='File not Present';

     INIname='settings.ini';

     MAX_SIZE = 30;

     oldLocation='Location'; oldType='Type'; oldSize='Size'; oldProperties='Properties'; oldCreationDate='Creation Date';

type
  INDEX = 0..MAX_SIZE;
  VECTOR = array[INDEX]of string[10];

  TMyThread = class(TThread)
    protected
      procedure GetAllFiles(mask: ANSIstring);
      procedure Execute; override;
      procedure AddToList;
    public
      { Public declarations }
      StrConst: ANSIstring;
      function CheckExt(ext: string): boolean;
    end;

  TMainForm = class(TForm)
    MainImage: TImage;
    MainStatusBar: TStatusBar;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    MainListBox: TListBox;
    MainPreview: TImage;
    MainPrint: TBitBtn;
    Label1: TLabel;
    MainChPreview: TCheckBox;
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    MainComboBox: TComboBox;
    MainTime: TSpinEdit;
    MainLocationLabel: TLabel;
    MainTypeLabel: TLabel;
    MainSizeLabel: TLabel;
    MainPropertiesLabel: TLabel;
    MainCreationLavel: TLabel;
    MainWallpaperStyleLabel: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    PopupMenu1: TPopupMenu;
    WallpaperXEControlPanel1: TMenuItem;
    Settings1: TMenuItem;
    N1: TMenuItem;
    ScreenCapture1: TMenuItem;
    Desktop1: TMenuItem;
    SelectedArea1: TMenuItem;
    ActiveWindow1: TMenuItem;
    SelectedObject1: TMenuItem;
    N2: TMenuItem;
    PreviousWallpaper1: TMenuItem;
    NextWallpape1: TMenuItem;
    Reload1: TMenuItem;
    ClearWallpaper1: TMenuItem;
    ClearWallpaperPosition1: TMenuItem;
    Center1: TMenuItem;
    ile1: TMenuItem;
    FitToScreen1: TMenuItem;
    CustomPosition1: TMenuItem;
    AutoFit1: TMenuItem;
    N3: TMenuItem;
    ShowDisplayProperties1: TMenuItem;
    LaunchWindowsScreenSaver1: TMenuItem;
    HideDesktopIcons1: TMenuItem;
    LockDesktopItems1: TMenuItem;
    N4: TMenuItem;
    Help1: TMenuItem;
    AboutWallpaperXE1: TMenuItem;
    N5: TMenuItem;
    ExitWallpaperXE1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    Add1: TPopupMenu;
    Add2: TPopupMenu;
    Addwallpapers1: TMenuItem;
    Addfromfolder1: TMenuItem;
    AddHTMLandMovieWallpapers1: TMenuItem;
    ScanDiskforWallpapers1: TMenuItem;
    Download1: TMenuItem;
    SetasWallpaper1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    ShowFullPath1: TMenuItem;
    Bevel1: TBevel;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    N6: TMenuItem;
    AddFromFile1: TMenuItem;
    AddFromFolder2: TMenuItem;
    AddHTMLWallpaper1: TMenuItem;
    ScanDiskForWallpapers2: TMenuItem;
    Download2: TMenuItem;
    N7: TMenuItem;
    EmptyWallpaperList1: TMenuItem;
    SortWallpaperList1: TMenuItem;
    RandomiseWallpaperList1: TMenuItem;
    N8: TMenuItem;
    CopyFiles1: TMenuItem;
    MoveFiles1: TMenuItem;
    MoveFiles2: TMenuItem;
    RenameFiles1: TMenuItem;
    N9: TMenuItem;
    FindCurrentSelection1: TMenuItem;
    SellectAll1: TMenuItem;
    InvertSelection1: TMenuItem;
    N10: TMenuItem;
    RemoveBadGraphics1: TMenuItem;
    Language1: TLanguage;
    Panel1: TPanel;
    Timer1: TTimer;
    OpenDialog2: TOpenDialog;
    MovieDimensionLabel: TLabel;
    moviewidthlabel: TLabel;
    Movieheightlabel: TLabel;
    moviewidthspin: TSpinEdit;
    movieheightspin: TSpinEdit;
    lunglabel: TLabel;
    htmlpreviewbutton: TBitBtn;
    ColorDialog1: TColorDialog;
    locationval: TLabel;
    typeval: TLabel;
    sizeval: TLabel;
    propertiesval: TLabel;
    creationval: TLabel;
    ColorBox1: TPanel;
    MainBitBtn1: TSpeedButton;
    MainBitBtn2: TSpeedButton;
    MainBitBtn3: TSpeedButton;
    MainBitBtn4: TSpeedButton;
    MainBitBtn5: TSpeedButton;
    MainNew: TSpeedButton;
    MainAppend: TSpeedButton;
    MainLoad: TSpeedButton;
    MainSave: TSpeedButton;
    BitBtn1: TSpeedButton;
    BitBtn2: TSpeedButton;
    BitBtn3: TSpeedButton;
    BitBtn4: TSpeedButton;
    BitBtn5: TSpeedButton;
    BitBtn6: TSpeedButton;
    SpeedButton1: TSpeedButton;
    CoolTrayIcon1: TCoolTrayIcon;
    ImageList1: TImageList;
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure ExitWallpaperXE1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure WallpaperXEControlPanel1Click(Sender: TObject);
    procedure MainBitBtn4Click(Sender: TObject);
    procedure MainBitBtn5Click(Sender: TObject);
    procedure ShowFullPath1Click(Sender: TObject);
    procedure Addwallpapers1Click(Sender: TObject);
    procedure MainNewClick(Sender: TObject);
    procedure MainListBoxClick(Sender: TObject);
    procedure MainSaveClick(Sender: TObject);
    procedure MainLoadClick(Sender: TObject);
    procedure MainAppendClick(Sender: TObject);
    procedure MainBitBtn1Click(Sender: TObject);
    procedure MainBitBtn2Click(Sender: TObject);
    procedure MainBitBtn3Click(Sender: TObject);
    procedure MainChPreviewClick(Sender: TObject);
    procedure MainListBoxDblClick(Sender: TObject);
    procedure Addfromfolder1Click(Sender: TObject);
    procedure EmptyWallpaperList1Click(Sender: TObject);
    procedure SortWallpaperList1Click(Sender: TObject);
    procedure RandomiseWallpaperList1Click(Sender: TObject);
    procedure SellectAll1Click(Sender: TObject);
    procedure AddFromFile1Click(Sender: TObject);
    procedure SetasWallpaper1Click(Sender: TObject);
    procedure ScanDiskforWallpapers1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure Desktop1Click(Sender: TObject);
    procedure SelectedArea1Click(Sender: TObject);
    procedure ActiveWindow1Click(Sender: TObject);
    procedure SelectedObject1Click(Sender: TObject);
    procedure Language1AfterTranslation(Sender: TObject);
    procedure MainPrintClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure ClearWallpaper1Click(Sender: TObject);
    procedure NextWallpape1Click(Sender: TObject);
    procedure PreviousWallpaper1Click(Sender: TObject);
    procedure ShowDisplayProperties1Click(Sender: TObject);
    procedure HideDesktopIcons1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure AboutWallpaperXE1Click(Sender: TObject);
    procedure AddHTMLandMovieWallpapers1Click(Sender: TObject);
    procedure RenameFiles1Click(Sender: TObject);
    procedure CopyFiles1Click(Sender: TObject);
    procedure MoveFiles1Click(Sender: TObject);
    procedure MainTimeChange(Sender: TObject);
    procedure MainComboBoxChange(Sender: TObject);
    procedure Language1BeforeTranslation(Sender: TObject);
    procedure htmlpreviewbuttonClick(Sender: TObject);
    procedure ColorBox1Click(Sender: TObject);
    procedure ColorBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColorBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AddFromFolder2Click(Sender: TObject);
    procedure AddHTMLWallpaper1Click(Sender: TObject);
    procedure ScanDiskForWallpapers2Click(Sender: TObject);
    procedure FindCurrentSelection1Click(Sender: TObject);
    procedure RemoveBadGraphics1Click(Sender: TObject);
    procedure Reload1Click(Sender: TObject);
    procedure Center1Click(Sender: TObject);
    procedure ile1Click(Sender: TObject);
    procedure FitToScreen1Click(Sender: TObject);
    procedure CustomPosition1Click(Sender: TObject);
    procedure LaunchWindowsScreenSaver1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    ActivePlayList:string; // Calea la playlistul activ
    IniSettings:TIniFile; //fisierul INI ptr setarile initiale

  public
    { Public declarations }
    RootDir:string;

    EnableApplicationClose: boolean;

    LastIndex:integer; WallpaperPath:string;

    mailadress:string;
    ListOfExt: VECTOR; { vector cu extensiile }
    Size: INDEX; { dimensiunea actuala a vectorului }
    Cale: ANSIstring;
    RecurseSubfolders: boolean;
    FileList: TStrings;
    PlayList:TStrings; // Play list cu cale completa la fisiere
    index1, index2, index3: byte;
    isRegistered: boolean;

    {----------- Drag and drop -----------}
      OldLBWindowProc: TWndMethod;
      procedure WMDROPFILES(var Msg: TMessage);
      procedure LBWindowProc(var Message: TMessage);
      procedure AddFile(sFileName: string);
    {----------- Drag and drop -----------}

    {------------- PlayList -------------}
      procedure AddFolder;
      procedure AddItemsToPlayList(Tomb:TStrings);
      procedure LoadItemsToMainListBox(checked:boolean);
    {------------- PlayList ------------- END}

    {------------- Change Wallpaper at Startup -------------}
      procedure ChangeWallpaperAtStartup(Checked:boolean);
    {------------- Change Wallpaper at Startup ------------- END}

    {------------- Hints -------------}
      procedure EnableHints(SHint: boolean);
    {------------- Hints -------------}
   end;

var
  MainForm: TMainForm;

implementation

uses AddFolder, Filter, ScanDisk, USettings, ScreenUnit, sendmail, about,
  Urename, URMC;

{$R *.dfm}
{$R WinXP.res}

{--------------- upcase la extensie ca sa mearga la toate --------}

function extupcase(a:string):string;
var
  tomb:string; i:integer;
begin
  tomb:=a;
  if tomb<>'' then for i:=1 to length(tomb) do tomb[i]:=upcase(tomb[i]);
  extupcase:=tomb;
end;

function maketreipuncte(s:ansistring):string;
var
   i:integer; fname,tomb:string;
begin
     tomb:=s;
     if length(tomb)>50 then
     begin
         tomb:='';
         fname:='\'+ExtractFileName(s);
         for i:=1 to 45-length(fname) do
         begin
              tomb:=tomb+s[i];
         end;
         tomb:=tomb+'...'+fname;
     end;
     maketreipuncte:=tomb;
end;

{----------------------------------- TMyThread --------------------------------}

procedure TMyThread.GetAllFiles(mask: string);
var
  search: TSearchRec;
  directory: string;
begin
  directory := ExtractFilePath(mask);

  // find all files
  if FindFirst(mask, $23, search) = 0 then
  begin
    repeat
      // add the files to the listbox
      if CheckExt(ExtractFileExt(search.Name)) then begin
        StrConst:=directory + search.Name;
        Synchronize(AddToList);
      end;
    until FindNext(search) <> 0;
  end;

  // Subdirectories/ Unterverzeichnisse
  if MainForm.RecurseSubfolders = true then
    if FindFirst(directory + '*.*', faDirectory, search) = 0 then begin
      repeat
        if ((search.Attr and faDirectory) = faDirectory) and (search.Name[1] <> '.') then
          GetAllFiles(directory + search.Name + '\' + ExtractFileName(mask));
      until FindNext(search) <> 0;
      FindClose(search);
    end;
end;

procedure TMyThread.Execute;
begin
  GetAllFiles(MainForm.Cale + '\' + '*.*');
end;

procedure TMyThread.AddToList;
var name, extension: string;
begin
  name:=ExtractFileName(StrConst);
  extension:=ExtractFileExt(StrConst);
  delete(name, pos(extension, name), length(extension) );
  MainForm.PlayList.Add(StrConst);
  MainForm.PlayList.Add(name);
  with MainForm do
    if ShowFullpath1.Checked then
      MainListBox.Items.Add(PlayList.Strings[PlayList.Count - 2])
    else
      MainListBox.Items.Add(PlayList.Strings[PlayList.Count - 1]);
end;

function TMyThread.CheckExt(ext: string): boolean;
var i: 1..MAX_SIZE;
    j: integer;
    b: boolean;
begin
  for j:=1 to Length(ext) do
    ext[j]:=UpCase(ext[j]);

  b:=false;
  with MainForm do
    for i:=1 to SIZE do
      if ext = ListOfExt[i] then begin
        b:=true;
        break;
      end;

  CheckExt:=b;
end;

{------------------------------------------------------------------------------}
{----- drag and drop ------}
procedure TMainForm.LBWindowProc(var Message: TMessage);
begin
  if Message.Msg = WM_DROPFILES then
    WMDROPFILES(Message); // handle WM_DROPFILES message
  OldLBWindowProc(Message);
  // call default ListBox1 WindowProc method to handle all other messages
end;

procedure TMainForm.WMDROPFILES(var Msg: TMessage);
var
  pcFileName: PChar;
  i, iSize, iFileCount: integer;
  extension:string;
  tomb:TstringList; error:integer;
begin
  pcFileName := ''; // to avoid compiler warning message
  iFileCount := DragQueryFile(Msg.wParam, $FFFFFFFF, pcFileName, 255);
  for i := 0 to iFileCount - 1 do
  begin
    iSize := DragQueryFile(Msg.wParam, i, nil, 0) + 1;
    pcFileName := StrAlloc(iSize);
    DragQueryFile(Msg.wParam, i, pcFileName, iSize);
    extension:=extractfileext(pcFilename);
    if (FileExists(pcFileName)) and ( (extension='.bmp') or (extension='.jpg') or (extension='.jpeg')
      or (extension='.ico') or (extension='.avi') or (extension='.emf') or (extension='.wmf')
      or (extension='.mpg') or (extension='.mpeg') ) then AddFile(pcFileName); // method to add each file
    error:=0;
    if (FileExists(pcFileName)) and (extension='.awc') then
    begin
         tomb:=tstringlist.create;
          try
             Tomb.LoadFromFile(pcFileName);
          except
                MessageDlg(READ_ERROR,mtERROR,[mbok],0);
                error:=1;
          end;
          if error=0 then
          begin
               PlayList.AddStrings(tomb);
               MainListBox.Clear ;LoadItemsToMainListBox(showfullpath1.checked);
          end;
    end;

    StrDispose(pcFileName);
  end;
  DragFinish(Msg.wParam);
end;

procedure TMainForm.AddFile(sFileName: string);
var
   tomb:TStrings;
begin
     tomb:=TStringList.Create;
     tomb.Add(sFileName);
     AddItemsToPlayList(tomb);
     MainListBox.clear; LoadItemsToMainListBox(ShowFullpath1.Checked);
end;
{----- drag and drop ------}


procedure TMainForm.AddItemsToPlayList(Tomb:TStrings);
var
   i:integer;
   name,ext:string;
begin
     for i:=0 to Tomb.Count-1 do
     begin
          name:=ExtractFileName(Tomb.Strings[i]);
          ext:=ExtractFileExt(name);
          delete(name, pos(ext,name), length(ext) );
          PlayList.Add(Tomb.Strings[i]);
          PlayList.Add(name);
     end;
end;

procedure TMainForm.LoadItemsToMainListBox(checked:boolean);
var
   i:integer;
begin
     for i:=0 to (PlayList.Count div 2)-1 do
     begin
         if Checked
           then MainListBox.Items.Add(PlayList.Strings[i*2])
           else MainListBox.Items.Add(PlayList.Strings[i*2+1]);
     end;
     if (MainChPreview.Checked) and (MainListBox.Count>0) then MainChPreviewClick(MainListBox);
end;

procedure TMainForm.ChangeWallpaperAtStartup(Checked:boolean);
var
   Reg:TRegistry;
begin
     if checked then
     begin
          reg:=TRegistry.Create;
          reg.rootkey:=HKEY_CURRENT_USER;
          reg.openkey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',true);
          reg.writestring('Wallpaper Manager',Application.ExeName+' -startup');
          reg.free;
     end else
     begin
          reg:=TRegistry.Create;
          reg.rootkey:=HKEY_CURRENT_USER;
          reg.openkey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',true);
          reg.DeleteValue('Wallpaper Manager');
          reg.free;
     end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
   tomb:boolean;
begin
{INITIALIZARE}
  CoolTrayIcon1.Enabled:=isRegistered;

  EnableApplicationClose:=false;

  ColorBox1.ParentBackground:=false;
  ColorBox1.ParentColor:=false;
  SIZE:=0; isRegistered:=false;
{--------------------------------------------}
  RootDir:=ExtractFilePath(Application.ExeName);

  IniSettings:=TIniFile.Create(RootDir+INIname);

  ShowFullPath1.Checked:=IniSettings.ReadBool('Show Full Path','Checked',false); //Add2 - Showfullpath1
  MainChPreview.Checked:=IniSettings.ReadBool('Show Preview','Checked',true);
  CheckBox1.Checked:=IniSettings.ReadBool('Change at Startup','Checked',false);
  ColorBox1.Color:=IniSettings.ReadInteger('ColorBox1','Color',clBlack);
  {Settings}
     {General}
      tomb:=IniSettings.ReadBool('Always minimize','Checked',true); Application.ShowMainForm:=not tomb;
     {General}

  {Settings}
{--------------------------------------------}

  PlayList:=TStringList.Create;

  if (paramstr(1)<>'') and (paramstr(1)<>'-startup')
    then ActivePlaylist:=paramstr(1)
    else ActivePlayList:=RootDir+'DefPlayList.awc';

  if not fileexists(rootdir+'DefPlayList.awc') then
  begin
       try
          playlist.SaveToFile(rootdir+'DefPlayList.awc');
       except
       end;
  end;
  try
     PlayList.LoadFromFile(ActivePlayList);
  except
     MessageDlg(READ_ERROR,mtERROR,[mbok],0);
  end;

  MainListBox.Clear; LoadItemsToMainListBox(ShowFullpath1.Checked);
  LastIndex:=IniSettings.ReadInteger('Last Wallpaper Index','Value',0);

{----------ini settings}
  tomb:=IniSettings.ReadBool('Shuffle Wallpapers','Checked',false);
  if tomb then LastIndex:=random(MainListbox.Count); checkbox2.Checked:=tomb;

  MainComboBox.ItemIndex:=IniSettings.ReadInteger('Timer interval','value',0);
  checkbox3.checked:=IniSettings.readbool('Enable Timer','Checked',false);
  MainTime.Value:=IniSettings.ReadInteger('Interval Value','Value',0);
  timer1.Enabled:=checkbox3.Checked; if timer1.Enabled then timer1.Interval:=1000*MainTime.value*ct_time[MainComboBox.ItemIndex];

  moviewidthspin.Value:=IniSettings.ReadInteger('movie width','Value',800);
  movieheightspin.Value:=IniSettings.ReadInteger('movie height','Value',600);
{----------ini settings - end}

  if (paramstr(1)='-startup')and (CheckBox1.Checked) then
  begin
       if mainlistbox.Items.Count>0 then
       begin
            MainListBoxDblClick(MainListBox);
            Application.Terminate;
       end;
  end;

  {Drag and drop}
    tomb:=IniSettings.ReadBool('Enable Drag and Drop','Checked',true);
    if false then
    begin
        OldLBWindowProc := MainListBox.WindowProc; // store defualt WindowProc
        MainListBox.WindowProc := LBWindowProc; // replace default WindowProc
        DragAcceptFiles(MainListBox.Handle, True); // now ListBox1 accept dropped files
    end;
  {Drag and drop}


{INITIALIZARE - END}
IniSettings.Free;

if (MainListBox.Items.Count = 0) then
  Cale:=RootDir + 'Images'; Size:=1; ListOfExt[1]:='.JPG'; AddFolder;

if(CheckBox1.Checked) then
  MainListBoxDblClick(Self);  
end;

procedure TMainForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize := false;
end;

{--------- Minimize to Tray ---------}
    procedure HideMainForm;
    begin
         MainForm.Hide;
    end;

    procedure ShowMainForm;
    begin
         MainForm.Show;
         Application.Restore;
    end;

    procedure TMainForm.Button1Click(Sender: TObject);
    begin
         HideMainForm;
    end;

{-------- Minimize to Tray --------- - END}


{-------- Tray PopupMenu Items --------}
    procedure TMainForm.WallpaperXEControlPanel1Click(Sender: TObject);
    begin
         ShowMainForm;
    end;

    procedure TMainForm.ExitWallpaperXE1Click(Sender: TObject);
    begin
      EnableApplicationClose:=true;
      close;
    end;

    procedure TMainForm.PreviousWallpaper1Click(Sender: TObject);
    begin
         if Lastindex=0 then lastindex:=mainlistbox.Count-1 else lastindex:=lastindex-1;
         if checkbox2.Checked then LastIndex:=random(MainListbox.Count);
         MainListBoxDblClick(MainListBox);
    end;

    procedure TMainForm.NextWallpape1Click(Sender: TObject);
    begin
        if LastIndex=MainListBox.Count-1 then lastindex:=0 else lastindex:=lastindex+1;
        if checkbox2.Checked then LastIndex:=random(MainListbox.Count);
        MainListBoxDblClick(MainListBox);
    end;

    procedure TMainForm.ClearWallpaper1Click(Sender: TObject);
    const
      CLSID_ActiveDesktop: TGUID = '{75048700-EF1F-11D0-9888-006097DEACF9}';
    var
       hObj: IUnknown;
       ADesktop: IActiveDesktop;
       str: string;
       wstr: PWideChar;
    begin
         hObj     := CreateComObject(CLSID_ActiveDesktop);
         ADesktop := hObj as IActiveDesktop;
         wstr := AllocMem(MAX_PATH);
         try
            StringToWideChar('', wstr, MAX_PATH);
            ADesktop.SetWallpaper(wstr, 0);
            ADesktop.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE);
         finally
                FreeMem(wstr);
         end;
    end;

    procedure TMainForm.ShowDisplayProperties1Click(Sender: TObject);
    begin
         ShellExecute(handle,pchar('open'),pchar('rundll32.exe'),pchar('shell32.dll,Control_RunDLL desk.cpl'),nil,sw_show);
    end;

    procedure TMainForm.HideDesktopIcons1Click(Sender: TObject);
    begin
         if HideDeskTopIcons1.Checked then ShowWindow(FindWindow(nil, 'Program Manager'), SW_SHOW)
         else ShowWindow(FindWindow(nil, 'Program Manager'), SW_HIDE);
         HideDeskTopIcons1.Checked:=not HideDeskTopIcons1.Checked;
    end;

    procedure TMainForm.Reload1Click(Sender: TObject);
    begin
         MainListBoxDblClick(self);
    end;

    procedure TMainForm.Center1Click(Sender: TObject);
    begin
         Combobox1.ItemIndex:=1; MainListBoxDblClick(self);
    end;

    procedure TMainForm.ile1Click(Sender: TObject);
    begin
         Combobox1.ItemIndex:=0; MainListBoxDblClick(self);
    end;

    procedure TMainForm.FitToScreen1Click(Sender: TObject);
    begin
         Combobox1.ItemIndex:=2; MainListBoxDblClick(self);
    end;

    procedure TMainForm.CustomPosition1Click(Sender: TObject);
    begin
         Combobox1.ItemIndex:=3; MainListBoxDblClick(self);
    end;
    procedure TMainForm.LaunchWindowsScreenSaver1Click(Sender: TObject);
    begin
         SystemParametersInfo( SPI_SETSCREENSAVEACTIVE, 1, Nil, SPIF_UPDATEINIFILE);
    end;
{-------- Tray PopupMenu Items -------- - END}


{-------- Add1 Items --------}


    {+ Button Click} procedure TMainForm.MainBitBtn4Click(Sender: TObject);
    var
         mouse_cursor:TMouse;
    begin
         Add1.Popup(mouse_cursor.CursorPos.x,mouse_cursor.CursorPos.y);
    end;

    {Add wallpaper from file} procedure TMainForm.Addwallpapers1Click(Sender: TObject);
    begin
         if (OpenPictureDialog1.Execute) and (OpenPictureDialog1.Files.Count<>0) then
         begin
              AddItemsToPlayList(OpenPictureDialog1.Files);
              MainListBox.clear; LoadItemsToMainListBox(ShowFullPath1.Checked);
         end;
    end;

    procedure TMainForm.AddFolder;
    var MyThread: TMyThread;
    begin
         MyThread:=TMyThread.Create(True);
         MyThread.StrConst:='';
         MyThread.FreeOnTerminate:=True;
         MyThread.Resume;
    end;

    {Add wallpaper from folder} procedure TMainForm.Addfromfolder1Click(Sender: TObject);
//    var MyThread: TMyThread;
    begin
         AddFolderForm.ShowModal;

         if Cale <> '' then
           FilterForm.ShowModal;

         AddFolder;

//         FileList:=TStrings.Create;

{         MyThread:=TMyThread.Create(True);
         MyThread.StrConst:='';
         MyThread.FreeOnTerminate:=True;
         MyThread.Resume;}

//         AddItemsToPlayList(FileList);
//         LoadItemsToMainListBox(ShowFullpath1.Checked);
//         FileList.Free;
    end;
{-------- Add1 Items -------- - END}

{-------- Add2 Items --------}
    {-> Button} procedure TMainForm.MainBitBtn5Click(Sender: TObject);
    var
       mouse_cursor:TMouse;
    begin
         Add2.Popup(mouse_cursor.CursorPos.x,mouse_cursor.CursorPos.y);
    end;

    {Show Full Path} procedure TMainForm.ShowFullPath1Click(Sender: TObject);
    begin
         ShowFullPath1.Checked:=not ShowFullPath1.Checked;
        {write ini changes}
         IniSettings:=TiniFile.Create(Rootdir+IniName);
         IniSettings.WriteBool('Show Full Path','Checked',ShowFullPath1.Checked);
         IniSettings.Free;
        {write ini changes}
         MainListBox.Clear ;LoadItemsToMainListBox(ShowFullPath1.Checked);
    end;

    {Empty Wallpaper List} procedure TMainForm.EmptyWallpaperList1Click(Sender: TObject);
    begin
         MainListBox.Clear; PlayList.Clear;
         Mainpreview.Picture:=nil; Mainpreview.Refresh;
    end;

    {Sort Wallpaper List} procedure TMainForm.SortWallpaperList1Click(Sender: TObject);
    var
       i,j:integer;
       Min,tomb:string; Minpos:integer;
       found:boolean;
    begin
         for i:=0 to ((PlayList.Count-2) div 2) do
         begin
              j:=2*i; min:=Playlist.Strings[j]; minpos:=j; found:=false;
              repeat
                    if PlayList.Strings[j]<min then
                    begin
                         Minpos:=j;
                         Min:=PlayList.Strings[j];
                         found:=true;
                    end;
                    j:=j+2;
              until j>playlist.Count-2;
              if found then
              begin
                   tomb:=PlayList.Strings[2*i];
                   PlayList.Strings[2*i]:=PlayList.Strings[minpos];
                   PlayList.Strings[minpos]:=tomb;
                   
                   tomb:=PlayList.Strings[2*i+1];
                   PlayList.Strings[2*i+1]:=PlayList.Strings[minpos+1];
                   PlayList.Strings[minpos+1]:=tomb;

                   MainListBox.Clear; LoadItemsToMainListBox(ShowFullpath1.Checked);
              end;
         end;
    end;

    {Randomise Wallpaper List} procedure TMainForm.RandomiseWallpaperList1Click(Sender: TObject);
    var
       i,j,k:integer;
       tomb:string;
    begin
       if playlist.Count>0 then
       begin
         randomize;
         for k:=1 to 10 do
         begin
              i:=Random( PlayList.Count div 2 ); j:=Random( PlayList.Count div 2 );

              tomb:=PlayList.Strings[2*i];
              PlayList.Strings[2*i]:=PlayList.Strings[2*j];
              PlayList.Strings[2*j]:=tomb;

              tomb:=PlayList.Strings[2*i+1];
              PlayList.Strings[2*i+1]:=PlayList.Strings[2*j+1];
              PlayList.Strings[2*j+1]:=tomb;
         end;

         MainListBox.Clear; LoadItemsToMainListBox(ShowFullpath1.Checked);
       end;

    end;

    {Selectall} procedure TMainForm.SellectAll1Click(Sender: TObject);
    begin
         MainListBox.SelectAll;
    end;


    {Add file} procedure TMainForm.AddFromFile1Click(Sender: TObject);
    begin
         Addwallpapers1Click(Add2);
    end;

    {Rename}procedure TMainForm.RenameFiles1Click(Sender: TObject);
    begin
         RenameForm.showmodal;
    end;

    {Move Copy}procedure TMainForm.CopyFiles1Click(Sender: TObject);
     var
        tomb:string;
    begin
         tomb:=TMenuItem(sender).Caption; delete(tomb,1,1);
         RMCForm.Caption:=tomb;
         RMCForm.showmodal;
    end;

    procedure TMainForm.MoveFiles1Click(Sender: TObject);
    var
       f:file;
    begin
         if messagedlg('Delete File',mtInformation,[mbok,mbcancel],0)=mrok then
         begin
             deletefile(PlayList.Strings[mainlistbox.itemindex*2]);
             playlist.Delete(mainlistbox.ItemIndex*2);
             playlist.Delete(mainlistbox.ItemIndex*2);
             mainlistbox.Items.Delete(mainlistbox.ItemIndex);
             LastIndex:=LastIndex-1; if lastindex<0 then lastindex:=0;
         end;
    end;

    procedure TMainForm.FindCurrentSelection1Click(Sender: TObject);
    begin
         Mainlistbox.itemindex:=0;
    end;

    procedure TMainForm.RemoveBadGraphics1Click(Sender: TObject);
    var
       i,lastitem:integer; iext:string;

       OleGraphic: TOleGraphic;
       fs: TFileStream;

       tomb:boolean;

    begin
         lastitem:=mainlistbox.Items.Count-1; i:=0;

         repeat
               tomb:=false;
              if not FileExists(PlayList.Strings[i*2]) then
              begin
                   MainListbox.Items.Delete(i);
                   PlayList.Delete(i*2);
                   PlayList.Delete(i*2);
                   lastitem:=lastitem-1;
                   tomb:=true;
              end;

              iext:=ExtractFileExt(PlayList.Strings[i]);
              if ( (iext<>'.avi') and (iext<>'.mpeg') and (iext<>'.mpg') and (iext<>'.htm') and (iext<>'.html') )
              then
              begin
                   OleGraphic := TOleGraphic.Create;
                   try
                     fs         := TFileStream.Create(PlayList.Strings[i*2], fmOpenRead or fmSharedenyNone);
                     OleGraphic.LoadFromStream(fs);
                   except
                     MainListbox.Items.Delete(i);
                     PlayList.Delete(i*2);
                     PlayList.Delete(i*2);
                     lastitem:=lastitem-1;
                     tomb:=true;
                   end;
                  fs.Free;
                  OleGraphic.Free
              end;
              if not tomb then i:=i+1;

         until i>lastitem;
    end;
 {-------- Add2 Items -------- - END}

{-------- Change Wallpaper -------- - END}
procedure TMainForm.MainListBoxDblClick(Sender: TObject);
      const
        // WallPaperStyles
        WPS_Tile      = 0;
        WPS_Center    = 1;
        WPS_SizeToFit = 2;
        WPS_XY        = 3;

        CLSID_ActiveDesktop: TGUID = '{75048700-EF1F-11D0-9888-006097DEACF9}';
      var
         OleGraphic: TOleGraphic;
         fs: TFileStream;
         ext:string; fmovie:textfile;

         hObj: IUnknown;
         ADesktop: IActiveDesktop;
         str: string;
         wstr: PWideChar;
         tomb:tpicture;

      procedure SetWallpaperExt(sWallpaperBMPPath : string; nStyle, nX, nY : integer );
      var
        reg    : TRegIniFile;
        s1     : string;
        X, Y   : integer;
      begin
        //
        // change registry
        //
        // HKEY_CURRENT_USER\
        //   Control Panel\Desktop
        //     TileWallpaper (REG_SZ)
        //     Wallpaper (REG_SZ)
        //     WallpaperStyle (REG_SZ)
        //     WallpaperOriginX (REG_SZ)
        //     WallpaperOriginY (REG_SZ)
        //
        reg := TRegIniFile.Create('Control Panel\Desktop' );
        with reg do
        begin
          s1 := '0';
          X  := 0;
          Y  := 0;

          case nStyle of
            WPS_Tile  : s1 := '1';
            WPS_Center: nStyle := WPS_Tile;
            WPS_XY    :
            begin
              nStyle := WPS_Tile;
              X := nX;
              Y := nY;
            end;
          end;

          WriteString( '','Wallpaper', sWallpaperBMPPath );

          WriteString( '', 'TileWallpaper', s1 );

          WriteString( '', 'WallpaperStyle', IntToStr( nStyle ) );

          WriteString( '', 'WallpaperOriginX', IntToStr( X ) );

          WriteString( '', 'WallpaperOriginY', IntToStr( Y ) );
        end;
        reg.Free;

        //
        // let everyone know that we
        // changed a system parameter
        //
        SystemParametersInfo( SPI_SETDESKWALLPAPER, 0, Nil, SPIF_SENDWININICHANGE );
      end;
begin
 if mainlistbox.Items.Count>0 then
 begin
     if mainlistbox.SelCount<=0 then mainlistbox.Selected[Lastindex]:=true;

     tomb:=tpicture.Create;

     ext:=extupcase(ExtractFileExt(PlayList.Strings[MainListbox.ItemIndex*2]));
     if ( (ext<>'.AVI') and (ext<>'.MPEG') and (ext<>'.MPG') and (ext<>'.HTM') and (ext<>'.HTML') )
     then
     begin
          if FileExists(PlayList.Strings[MainListbox.ItemIndex*2]) then
          begin
            try
              OleGraphic := TOleGraphic.Create;
              fs         := TFileStream.Create(PlayList.Strings[MainListbox.ItemIndex*2], fmOpenRead or fmSharedenyNone);
              OleGraphic.LoadFromStream(fs);
              tomb.Assign(OleGraphic);
            finally
              fs.Free;
              OleGraphic.Free
            end;
          end else MessageDlg(NOFILE_ERROR,mtERROR,[mbOk],0);
     end;


     if Settings.CheckBox7.Checked then ResampleBitmap(tomb.Bitmap,tomb.width,tomb.height);

     tomb.Bitmap.SaveToFile(rootdir+'wallpaper.bmp');
     tomb.Free;

     if (ext='.AVI') or (ext='.MPG') or (ext='.MPEG') then
     begin
          assignfile(fmovie,rootdir+'movie.html');
          rewrite(fmovie);

          writeln(fmovie,'<html>');
          writeln(fmovie,'<head>');
          writeln(fmovie,'<title>',PlayList.Strings[MainListbox.ItemIndex*2],'</title>');
          writeln(fmovie,'</head>');
          writeln(fmovie,'<body leftMargin=0 topMargin=0>');
          writeln(fmovie,'<IMG DYNSRC="',PlayList.Strings[MainListbox.ItemIndex*2],'" WIDTH=',moviewidthspin.value,' HEIGHT=',movieheightspin.value,' LOOP=INFINITE ALIGN=center>');
          writeln(fmovie,'</body>');
          writeln(fmovie,'</html>');

          closefile(fmovie);
          SetWallpaperExt({rootdir+'wallpaper.bmp'}'movie.html',combobox1.ItemIndex,spinedit1.Value,spinedit2.Value);
     end
     else SetWallpaperExt({rootdir+'wallpaper.bmp'}PlayList.Strings[MainListbox.ItemIndex*2],combobox1.ItemIndex,spinedit1.Value,spinedit2.Value);

     hObj     := CreateComObject(CLSID_ActiveDesktop);
     ADesktop := hObj as IActiveDesktop;
     wstr := AllocMem(MAX_PATH);
     try
        if (ext='.AVI') or (ext='.MPG') or (ext='.MPEG') then StringToWideChar({'wallpaper.bmp'}rootdir+'movie.html', wstr, MAX_PATH)
        else StringToWideChar({'wallpaper.bmp'}PlayList.Strings[MainListbox.ItemIndex*2], wstr, MAX_PATH);
        
        ADesktop.SetWallpaper(wstr, 0);
        ADesktop.ApplyChanges(AD_APPLY_ALL or AD_APPLY_FORCE);
     finally
            FreeMem(wstr);
     end;
     Settings.BitBtn2Click(sender);
 end;
end;
{-------- Change Wallpaper -------- - END}

{-------- Playlist control buttons --------}
{New Playlist} procedure TMainForm.MainNewClick(Sender: TObject);
begin
     MainListBox.Clear;
     Playlist.Clear;
     mainpreview.Picture:=nil;
     mainpreview.Refresh;
end;

{Save Playlist} procedure TMainForm.MainSaveClick(Sender: TObject);
var
   savepath:string;
begin
     if Savedialog1.Execute then
     begin
          savepath:=savedialog1.FileName;
          if ExtractFileExt(savepath)='' then savepath:=savepath+'.awc';
          Playlist.SaveToFile(savepath);
     end;
end;

{Load Playlist} procedure TMainForm.MainLoadClick(Sender: TObject);
var
   error:byte;
begin
     if opendialog1.Execute then
     begin
          error:=0;
          if FileExists(opendialog1.FileName) then
          begin
               Playlist.Clear;
               try
                  Playlist.LoadFromFile(opendialog1.FileName);
               except
                  MessageDlg(READ_ERROR,mtERROR,[mbok],0);
                  error:=1;
               end;
               if error=0 then
                 MainListBox.Clear; LoadItemsToMainListBox(Showfullpath1.Checked);
          end;
     end;
end;

{Append Playlist} procedure TMainForm.MainAppendClick(Sender: TObject);
var
   Tomb:TStringlist;
   error:byte;
begin
     Tomb:=TStringlist.Create; error:=0;
     If opendialog1.Execute then
     begin
          try
             Tomb.LoadFromFile(opendialog1.FileName);
          except
                MessageDlg(READ_ERROR,mtERROR,[mbok],0);
                error:=1;
          end;
          if error=0 then
          begin
               PlayList.AddStrings(tomb);
               MainListBox.Clear ;LoadItemsToMainListBox(showfullpath1.checked);
          end;
     end;
end;

{Move up in PlayList} procedure TMainForm.MainBitBtn1Click(Sender: TObject);
var
   Tomb:string;
   i:integer;
begin
     if MainListBox.ItemIndex<0 then MainListBox.ItemIndex:=0;
     if MainListBox.ItemIndex>0 then
     begin
          i:=MainListBox.ItemIndex;
          tomb:=MainListBox.Items.Strings[i];
          MainListBox.Items.Strings[i]:=MainListBox.Items.Strings[i-1];
          MainListBox.Items.Strings[i-1]:=tomb;

          tomb:=PlayList.Strings[2*i];
          PlayList.Strings[2*i]:=PlayList.Strings[2*i-2];
          PlayList.Strings[2*i-2]:=tomb;

          tomb:=PlayList.Strings[2*i+1];
          PlayList.Strings[2*i+1]:=PlayList.Strings[2*i-1];
          PlayList.Strings[2*i-1]:=tomb;

          MainListBox.ItemIndex:=MainListBox.ItemIndex-1;
     end;
end;

{Move Down in PlayList} procedure TMainForm.MainBitBtn2Click(Sender: TObject);
var
   Tomb:string;
   i:integer;
begin
     if MainListBox.ItemIndex<0 then MainListBox.ItemIndex:=0;
     if MainListBox.ItemIndex<(MainListBox.Items.Count-1) then
     begin
          i:=MainListBox.ItemIndex;
          tomb:=MainListBox.Items.Strings[i];
          MainListBox.Items.Strings[i]:=MainListBox.Items.Strings[i+1];
          MainListBox.Items.Strings[i+1]:=tomb;

          tomb:=PlayList.Strings[2*i];
          PlayList.Strings[2*i]:=PlayList.Strings[2*i+2];
          PlayList.Strings[2*i+2]:=tomb;

          tomb:=PlayList.Strings[2*i+1];
          PlayList.Strings[2*i+1]:=PlayList.Strings[2*i+3];
          PlayList.Strings[2*i+3]:=tomb;

          MainListBox.ItemIndex:=MainListBox.ItemIndex+1;
     end;
end;

{Delete Item From PlayList} procedure TMainForm.MainBitBtn3Click(Sender: TObject);
var
   i:integer;
   tomb:Timage;
begin
     if MainListBox.ItemIndex>=0 then
     begin
          i:=MainListBox.ItemIndex;
          MainListBox.Items.Delete(i);
          PlayList.Delete(i*2);
          PlayList.Delete(i*2);
          if (i=mainlistbox.Count) and (mainlistbox.Count<>0) then MainListBox.ItemIndex:=i-1
          else MainListBox.ItemIndex:=i;
          if mainlistbox.Count<>0 then MainListBoxClick(MainBitbtn3);
          if mainlistbox.Count=0  then
          begin
               mainpreview.Picture:=nil;
               mainpreview.Refresh;
          end;
     end;
end;

{Preview Playlist Checkbox} procedure TMainForm.MainChPreviewClick(Sender: TObject);
begin
     if (MainListBox.Count>0) and (MainListBox.ItemIndex<0) then MainListBox.ItemIndex:=0;
     if MainListBox.ItemIndex>=0 then MainListBoxClick(MainListBox);
     if not MainChPreview.Checked then
     begin
          Mainpreview.Picture:=nil;
          MainPreview.Refresh;
     end;
end;

{Preview Playlist} procedure TMainForm.MainListBoxClick(Sender: TObject);
var
  OleGraphic: TOleGraphic;
  fs: TFileStream;
  iext:string;
  extension:string;

  f:file; tJPG:TJPEGimage;

  {bitmaps}
  fileheader: TBitmapfileheader;
  infoheader: TBitmapinfoheader;
  s: TFilestream;
  {bitmaps}

  procedure ScaleMainPreview(SourceImg:TPicture);
  var
     scalefactor:real;
  begin
       If SourceImg.Height>SourceImg.Width then
         begin
              MainPreview.Width:=trunc( SourceImg.Width*141/SourceImg.Height );
              MainPreview.Height:=141;
              Mainpreview.Left:=(Bevel1.Width div 2)- (MainPreview.Width div 2)+Bevel1.Left;
              MainPreview.Top:=Bevel1.Top+4;
         end
       else
         begin
              MainPreview.Height:=trunc( SourceImg.Height*141/SourceImg.Width );
              MainPreview.Width:=141;
              Mainpreview.Left:=Bevel1.Left+4;
              MainPreview.Top:=(Bevel1.Height div 2)- (MainPreview.Height div 2)+Bevel1.Top;
         end;
  end;
begin
  if mainlistbox.Count>0 then
  begin

    extension:=extupcase(ExtractFileExt(PlayList.Strings[MainListbox.ItemIndex*2]));

    if (extension='.JPG') or (extension='.JPEG') or (extension='.BMP')
           or (extension='.EMF') or (extension='.WMF') then
      begin
           moviedimensionlabel.Visible:=false;
           movieheightlabel.Visible:=false; movieheightspin.Visible:=false;
           moviewidthlabel.Visible:=false;  moviewidthspin.Visible:=false;


           mainwallpaperstylelabel.Visible:=true;
           combobox1.Visible:=true;
           label3.Visible:=true; spinedit1.Visible:=true;
           label4.Visible:=true; spinedit2.Visible:=true;

           lunglabel.Visible:=false;
           htmlpreviewbutton.Visible:=false;

           Locationval.Caption:=maketreipuncte(PlayList.Strings[MainListbox.ItemIndex*2]);

{           if extension='.BMP' then
           begin
             s := TFileStream.Create(PlayList.Strings[MainListbox.ItemIndex*2], fmOpenRead);
              try
                s.Read(fileheader, SizeOf(fileheader));
                s.Read(infoheader, SizeOf(infoheader));
              finally
                s.Free;
              end;
              Sizeval.Caption:=IntToStr(infoheader.biWidth)+'x'+ IntToStr(infoheader.biHeight);
              Propertiesval.Caption:=IntToStr(infoheader.biBitCount)+' Bit Color Depth';
              Typeval.Caption:='Bitmap image';
           end;}

           if (extension='.JPG') or (extension='.JPEG') then
           begin
              tjpg:=tjpegimage.Create;
              tjpg.LoadFromFile(PlayList.Strings[MainListbox.ItemIndex*2]);

              Sizeval.Caption:=IntToStr(tJPG.Width)+'x'+ IntToStr(tJPG.Height);
              Propertiesval.Caption:=IntToStr(tJPG.CompressionQuality)+'% Compression';

              Typeval.Caption:='JPEG image';
              tjpg.Free;
           end;
      end;

      if  (extension='.MPG') or (extension='.MPEG') or (extension='.AVI') then
      begin
           mainwallpaperstylelabel.Visible:=false;
           combobox1.Visible:=false;
           label3.Visible:=false; spinedit1.Visible:=false;
           label4.Visible:=false; spinedit2.Visible:=false;

           moviedimensionlabel.Visible:=true;
           movieheightlabel.Visible:=true; movieheightspin.Visible:=true;
           moviewidthlabel.Visible:=true;  moviewidthspin.Visible:=true;

           lunglabel.Visible:=false;
           htmlpreviewbutton.Visible:=false;

           s := TFileStream.Create(PlayList.Strings[MainListbox.ItemIndex*2], fmOpenRead);
           propertiesval.Caption:=IntToStr(GetFileSize(s.Handle,nil) div 1024)+' kb';
           s.Free;

           mainpreview.Picture.LoadFromFile(rootdir+'moviepreview.bmp'); ScaleMainPreview(Mainpreview.Picture);
      end;

      if  (extension='.HTM') or (extension='.HTML') then
      begin
           moviedimensionlabel.Visible:=false;
           movieheightlabel.Visible:=false; movieheightspin.Visible:=false;
           moviewidthlabel.Visible:=false;  moviewidthspin.Visible:=false;

           mainwallpaperstylelabel.Visible:=false;
           combobox1.Visible:=false;
           label3.Visible:=false; spinedit1.Visible:=false;
           label4.Visible:=false; spinedit2.Visible:=false;

           lunglabel.Visible:=true;
           htmlpreviewbutton.Visible:=true;

           mainpreview.Picture.LoadFromFile(rootdir+'htmlpreview.bmp'); ScaleMainPreview(Mainpreview.Picture);
      end;

     iext:=ExtractFileExt(PlayList.Strings[MainListbox.ItemIndex*2]);
     if (MainChPreview.Checked) and ( (iext<>'.avi') and (iext<>'.mpeg') and (iext<>'.mpg') and (iext<>'.htm') and (iext<>'.html') )
     then
     begin
          if FileExists(PlayList.Strings[MainListbox.ItemIndex*2]) then
          begin
            try
              OleGraphic := TOleGraphic.Create;
              fs         := TFileStream.Create(PlayList.Strings[MainListbox.ItemIndex*2], fmOpenRead or fmSharedenyNone);
              OleGraphic.LoadFromStream(fs);
              Mainpreview.picture.Assign(OleGraphic);
              ScaleMainPreview(Mainpreview.Picture);
            finally
              fs.Free;
              OleGraphic.Free
            end;
          end else MessageDlg(NOFILE_ERROR,mtERROR,[mbOk],0);
     end;
     LastIndex:=MainListBox.ItemIndex;
  end;
end;
{-------- Playlist control buttons -------- END}

{-------- Start page in explorer ---------------}
procedure TMainForm.htmlpreviewbuttonClick(Sender: TObject);
var
   path:string;
begin
     path:=PlayList.Strings[MainListbox.ItemIndex*2];
     ShellExecute(handle,'open',pchar(path),nil,nil,sw_show);
end;
{-------- Start page in explorer ---------- END}
procedure TMainForm.FormDestroy(Sender: TObject);
begin
{INI Settings}
     IniSettings:=TiniFile.Create(RootDir+IniName);
     IniSettings.WriteBool('Show Preview','Checked',MainChPreview.Checked);
     IniSettings.WriteBool('Change at Startup','Checked',CheckBox1.Checked); 
     IniSettings.WriteInteger('Last Wallpaper Index','Value',LastIndex);
     IniSettings.WriteBool('Shuffle Wallpapers','Checked',CheckBox2.Checked);
     IniSettings.WriteInteger('Timer interval','value',MainComboBox.ItemIndex);
     IniSettings.Writebool('Enable Timer','Checked',checkbox3.checked);
     IniSettings.WriteInteger('Interval Value','Value',MainTime.Value);
     IniSettings.WriteInteger('Wallpaper style','value',ComboBox1.ItemIndex);
     IniSettings.WriteInteger('ColorBox1','Color',ColorBox1.Color);

    IniSettings.ReadInteger('movie width','Value',moviewidthspin.Value);
    IniSettings.ReadInteger('movie height','Value',movieheightspin.Value);

     IniSettings.Free;
//     Settings.UnRegHK;
{INI Settings}

{Playlist}
     try
        PlayList.SaveToFile(RootDir+'DefPlayList.awc');
     except
        MessageDlg(WRITE_ERROR,mtERROR,[mbOk],0);
     end;

     PlayList.Free;
{Playlist}
{Drag and drop}
    MainListBox.WindowProc := OldLBWindowProc;
    DragAcceptFiles(MainListBox.Handle, False);
{Drag and drop}

end;
procedure TMainForm.SetasWallpaper1Click(Sender: TObject);
begin
     MainListBoxDblClick(Add2);
end;

procedure TMainForm.ScanDiskforWallpapers1Click(Sender: TObject);
begin
  ScanDiskForm.ShowModal;
end;

procedure TMainForm.Settings1Click(Sender: TObject);
begin
     Settings.Show;
end;

procedure TMainForm.Desktop1Click(Sender: TObject);
begin
  ScreenForm.Show;
  ScreenForm.Desktop1click(self);
end;

procedure TMainForm.SelectedArea1Click(Sender: TObject);
begin
  ScreenForm.Show;
  ScreenForm.Selection1Click(self);
end;

procedure TMainForm.ActiveWindow1Click(Sender: TObject);
begin
  ScreenForm.Show;
  ScreenForm.Window1Click(self);
end;

procedure TMainForm.SelectedObject1Click(Sender: TObject);
begin
  ScreenForm.Show;
  ScreenForm.Object1Click(self);
end;

procedure TMainForm.Language1AfterTranslation(Sender: TObject);
begin
  MainComboBox.ItemIndex:=index1;
  ComboBox1.ItemIndex:=index2;
  Settings.DefPozComboBox.ItemIndex:=index3;

  {-----------------------------------Hint's-----------------------------------}
    {MainForm}
    MainBitBtn1.Hint:=Language1.TranslateUserMessage('Message130');
    MainBitBtn2.Hint:=Language1.TranslateUserMessage('Message131');
    MainBitBtn3.Hint:=Language1.TranslateUserMessage('Message132');
    MainBitBtn4.Hint:=Language1.TranslateUserMessage('Message133');
    MainBitBtn5.Hint:=Language1.TranslateUserMessage('Message134');
    MainNew.Hint:=Language1.TranslateUserMessage('Message135');
    MainAppend.Hint:=Language1.TranslateUserMessage('Message136');
    MainLoad.Hint:=Language1.TranslateUserMessage('Message137');
    MainSave.Hint:=Language1.TranslateUserMessage('Message138');
    MainPrint.Hint:=Language1.TranslateUserMessage('Message139');
    MainPreview.Hint:=Language1.TranslateUserMessage('Message140');
    ColorBox1.Hint:=Language1.TranslateUserMessage('Message141');
    ComboBox1.Hint:=Language1.TranslateUserMessage('Message142');
    MainChPreview.Hint:=Language1.TranslateUserMessage('Message144');
    {Settings}
    with Settings do
      with Language1 do begin
        CheckBox1.Hint:=TranslateUserMessage('Message161');
        CheckBox2.Hint:=TranslateUserMessage('Message162');
        CheckBox3.Hint:=TranslateUserMessage('Message163');
        CheckBox4.Hint:=TranslateUserMessage('Message164');
        CheckBox5.Hint:=TranslateUserMessage('Message165');
        CheckBox7.Hint:=TranslateUserMessage('Message166');
        CheckBox6.Hint:=TranslateUserMessage('Message167');
        CheckBox8.Hint:=TranslateUserMessage('Message168');
        CheckBox9.Hint:=TranslateUserMessage('Message169');
        CheckBox10.Hint:=TranslateUserMessage('Message170');
        CheckBox11.Hint:=TranslateUserMessage('Message171');
        CheckBox17.Hint:=TranslateUserMessage('Message172');
        CheckBox12.Hint:=TranslateUserMessage('Message173');
        CheckBox18.Hint:=TranslateUserMessage('Message174');
        CheckBox13.Hint:=TranslateUserMessage('Message175');
        CheckBox14.Hint:=TranslateUserMessage('Message176');
        DefPozComboBox.Hint:=TranslateUserMessage('Message177');
        DefColorBox.Hint:=TranslateUserMessage('Message178');
        ColorBox2.Hint:=TranslateUserMessage('Message179');
        ColorBox3.Hint:=TranslateUserMessage('Message180');
        CheckBox15.Hint:=TranslateUserMessage('Message181');
        CheckBox16.Hint:=TranslateUserMessage('Message182');
        PlaySoundCheckBox.Hint:=TranslateUserMessage('Message183');
        BitBtn2.Hint:=TranslateUserMessage('Message184');
        MainNew.Hint:=TranslateUserMessage('Message185');
        MainAppend.Hint:=TranslateUserMessage('Message186');
        MainLoad.Hint:=TranslateUserMessage('Message187');
        MainSave.Hint:=TranslateUserMessage('Message188');
        ShuffleCheckBox.Hint:=TranslateUserMessage('Message189');
        Button1.Hint:=TranslateUserMessage('Message190');
        MainBitBtn1.Hint:=TranslateUserMessage('Message130');
        MainBitBtn2.Hint:=TranslateUserMessage('Message131');
        MainBitBtn3.Hint:=TranslateUserMessage('Message132');
        BitBtn1.Hint:=TranslateUserMessage('Message133');
      end;
    {ScreenForm}
    with ScreenForm do
      with Language1 do begin
        OpenButton.Hint:=TranslateUserMessage('Message148');
        CloseButton.Hint:=TranslateUserMessage('Message149');
        CloseAllButton.Hint:=TranslateUserMessage('Message150');
        SaveAsButton.Hint:=TranslateUserMessage('Message151');
        PrintButton.Hint:=TranslateUserMessage('Message152');
        CopyButton.Hint:=TranslateUserMessage('Message153');
        CropButton.Hint:=TranslateUserMessage('Message154');
        CaptureDesktopButton.Hint:=TranslateUserMessage('Message155');
        CaptureSelectionButton.Hint:=TranslateUserMessage('Message156');
        CaptureWindowButton.Hint:=TranslateUserMessage('Message157');
        CaptureObjectButton.Hint:=TranslateUserMessage('Message158');
        Click100Button.Hint:=TranslateUserMessage('Message159');
        ExitButton.Hint:=TranslateUserMessage('Message160');
      end;
  {----------------------------------------------------------------------------}
end;

procedure TMainForm.EnableHints(SHint: boolean);
begin
    {MainForm}
    MainBitBtn1.ShowHint:=SHint;
    MainBitBtn2.ShowHint:=SHint;
    MainBitBtn3.ShowHint:=SHint;
    MainBitBtn4.ShowHint:=SHint;
    MainBitBtn5.ShowHint:=SHint;
    MainNew.ShowHint:=SHint;
    MainAppend.ShowHint:=SHint;
    MainLoad.ShowHint:=SHint;
    MainSave.ShowHint:=SHint;
    MainPrint.ShowHint:=SHint;
    MainPreview.ShowHint:=SHint;
    ColorBox1.ShowHint:=SHint;
    ComboBox1.ShowHint:=SHint;
    MainChPreview.ShowHint:=SHint;
    {Settings}
    with Settings do begin
        CheckBox1.ShowHint:=SHint;
        CheckBox2.ShowHint:=SHint;
        CheckBox3.ShowHint:=SHint;
        CheckBox4.ShowHint:=SHint;
        CheckBox5.ShowHint:=SHint;
        CheckBox7.ShowHint:=SHint;
        CheckBox6.ShowHint:=SHint;
        CheckBox8.ShowHint:=SHint;
        CheckBox9.ShowHint:=SHint;
        CheckBox10.ShowHint:=SHint;
        CheckBox11.ShowHint:=SHint;
        CheckBox17.ShowHint:=SHint;
        CheckBox12.ShowHint:=SHint;
        CheckBox18.ShowHint:=SHint;
        CheckBox13.ShowHint:=SHint;
        CheckBox14.ShowHint:=SHint;
        DefPozComboBox.ShowHint:=SHint;
        DefColorBox.ShowHint:=SHint;
        ColorBox2.ShowHint:=SHint;
        ColorBox3.ShowHint:=SHint;
        CheckBox15.ShowHint:=SHint;
        CheckBox16.ShowHint:=SHint;
        PlaySoundCheckBox.ShowHint:=SHint;
        BitBtn2.ShowHint:=SHint;
        MainNew.ShowHint:=SHint;
        MainAppend.ShowHint:=SHint;
        MainLoad.ShowHint:=SHint;
        MainSave.ShowHint:=SHint;
        ShuffleCheckBox.ShowHint:=SHint;
        Button1.ShowHint:=SHint;
        MainBitBtn1.ShowHint:=SHint;
        MainBitBtn2.ShowHint:=SHint;
        MainBitBtn3.ShowHint:=SHint;
        BitBtn1.ShowHint:=SHint;
    end;
    {ScreenForm}
    with ScreenForm do begin
        OpenButton.ShowHint:=SHint;
        CloseButton.ShowHint:=SHint;
        CloseAllButton.ShowHint:=SHint;
        SaveAsButton.ShowHint:=SHint;
        PrintButton.ShowHint:=SHint;
        CopyButton.ShowHint:=SHint;
        CropButton.ShowHint:=SHint;
        CaptureDesktopButton.ShowHint:=SHint;
        CaptureSelectionButton.ShowHint:=SHint;
        CaptureWindowButton.ShowHint:=SHint;
        CaptureObjectButton.ShowHint:=SHint;
        Click100Button.ShowHint:=SHint;
        ExitButton.ShowHint:=SHint;
    end;
end;

procedure TMainForm.MainPrintClick(Sender: TObject);
begin
  if ScreenForm.PrinterSetupDialog1.Execute then
    ScreenForm.PrintImage(MainPreview, 100);
end;

procedure TMainForm.BitBtn4Click(Sender: TObject);
begin
  ScreenForm.Show;
end;

procedure TMainForm.BitBtn5Click(Sender: TObject);
begin
  Settings.ShowModal;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
     if CheckBox2.Checked then begin randomize; LastIndex:=random(mainlistbox.Count); end;
     if lastindex<>mainlistbox.Count-1 then LastIndex:=LastIndex+1 else lastindex:=0;
     MainListBox.ItemIndex:=LastIndex;
     MainListBoxDblClick(MainListBox);
end;

procedure TMainForm.CheckBox3Click(Sender: TObject);
begin
     timer1.Enabled:=checkbox3.Checked;
     if timer1.Enabled then timer1.Interval:=1000*MainTime.value*ct_time[MainComboBox.ItemIndex];
end;
procedure TMainForm.BitBtn3Click(Sender: TObject);
      procedure SendMail(Subject, Body, RecvAddress : string; Attachs : array of string);
      var
        MM, MS : Variant;
        i : integer;
      begin
        MS := CreateOleObject('MSMAPI.MAPISession');
        try
          MM := CreateOleObject('MSMAPI.MAPIMessages');
          try
            MS.DownLoadMail := False;
            MS.NewSession := False;
            MS.LogonUI := True;
            MS.SignOn;
            MM.SessionID := MS.SessionID;

            MM.Compose;

            MM.RecipIndex := 0;
            MM.RecipAddress := RecvAddress;
            MM.MsgSubject := Subject;
            MM.MsgNoteText := Body;

            for i := Low(Attachs) to High(Attachs) do
            begin
              MM.AttachmentIndex := i;
              MM.AttachmentPathName := Attachs[i];
            end;
            MM.Send(True);
            MS.SignOff;
          finally
            VarClear(MS);
          end;
        finally
          VarClear(MM);
        end;
      end;
begin
     MailForm.showmodal;
     if mailadress<>'' then SendMail('Wallpaper', '', mailadress, [PlayList.Strings[mainlistbox.itemindex*2]]);
end;

procedure TMainForm.AboutWallpaperXE1Click(Sender: TObject);
begin
     AboutForm.show;
end;

procedure TMainForm.AddHTMLandMovieWallpapers1Click(Sender: TObject);
begin
     if (opendialog2.Execute) and (opendialog2.Files.Count<>0) then
     begin
         AddItemsToPlayList(opendialog2.Files);
         MainListBox.clear; LoadItemsToMainListBox(ShowFullpath1.Checked);
     end;
end;


procedure TMainForm.MainTimeChange(Sender: TObject);
begin
  if timer1.Enabled then timer1.Interval:=1000*MainTime.value*ct_time[MainComboBox.ItemIndex];
end;

procedure TMainForm.MainComboBoxChange(Sender: TObject);
begin
  if timer1.Enabled then timer1.Interval:=1000*MainTime.value*ct_time[MainComboBox.ItemIndex];
end;

procedure TMainForm.Language1BeforeTranslation(Sender: TObject);
begin
  index1:=MainComboBox.ItemIndex;
  index2:=ComboBox1.ItemIndex;
  index3:=Settings.DefPozComboBox.ItemIndex;
end;

procedure TMainForm.ColorBox1Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    ColorBox1.Color:=ColorDialog1.Color;
end;

procedure TMainForm.ColorBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ColorBox1.BevelOuter:=bvLowered;
end;

procedure TMainForm.ColorBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ColorBox1.BevelOuter:=bvRaised;
end;

procedure TMainForm.AddFromFolder2Click(Sender: TObject);
begin
  Addfromfolder1Click(Self);
end;

procedure TMainForm.AddHTMLWallpaper1Click(Sender: TObject);
begin
  AddHTMLandMovieWallpapers1Click(Self);
end;

procedure TMainForm.ScanDiskForWallpapers2Click(Sender: TObject);
begin
  ScanDiskForm.ShowModal;
end;

procedure TMainForm.BitBtn2Click(Sender: TObject);
begin
  ClearWallpaper1Click(Self);
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
  MainListBoxDblClick(Self);  
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if EnableApplicationClose then CanClose:=true
  else begin
    CanClose:=false;
    Application.Minimize;
  end;
end;

end.
