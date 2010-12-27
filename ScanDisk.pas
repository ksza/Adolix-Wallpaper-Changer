unit ScanDisk;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, ComCtrls;

const MAX_SIZE = 47;

type
  INDEX = 0..MAX_SIZE;

  TMyThread = class(TThread)
    protected
      procedure GetAllFiles(mask: ANSIstring);
      procedure Execute; override;
      procedure AddToList;
      procedure ShowTotal;
    public
      { Public declarations }
      StrConst: ANSIstring;
      count: LongInt;
      function CheckExt(ext: string): boolean;
    end;

  TAddThread = class(TThread)
    protected
      procedure Execute; override;
      procedure AddOneFile(StrConst: string);
      procedure AddAllFiles;
      procedure AddOnlySelectedFiles;
      procedure AddAllButSelectedFiles;
    public
      { Public declarations }
      Nr: 1..3;
  end;

  TScanDiskForm = class(TForm)
    Bevel1: TBevel;
    SearchDirectoryEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    FileMaskEdit: TEdit;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Button3: TButton;
    Bevel2: TBevel;
    Label3: TLabel;
    SearchListBox: TListBox;
    Button4: TButton;
    Button5: TButton;
    SearchPreviewCheckBox: TCheckBox;
    Bevel3: TBevel;
    FileMaskPopupMenu: TPopupMenu;
    AllImageFiles1: TMenuItem;
    AllMovieFiles1: TMenuItem;
    HTMLFiles1: TMenuItem;
    N1: TMenuItem;
    AllsupportedFiles1: TMenuItem;
    AddPopupMenu: TPopupMenu;
    AddAllFilestoShowList1: TMenuItem;
    AddSelectedFilesOnly1: TMenuItem;
    AddAllbutSelectedFiles1: TMenuItem;
    CountLabel: TLabel;
    Animate1: TAnimate;
    SearchImage: TImage;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure AllImageFiles1Click(Sender: TObject);
    procedure AllMovieFiles1Click(Sender: TObject);
    procedure HTMLFiles1Click(Sender: TObject);
    procedure AllsupportedFiles1Click(Sender: TObject);
    procedure AddAllFilestoShowList1Click(Sender: TObject);
    procedure AddSelectedFilesOnly1Click(Sender: TObject);
    procedure AddAllbutSelectedFiles1Click(Sender: TObject);
    procedure SearchListBoxClick(Sender: TObject);
    procedure SearchPreviewCheckBoxClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    SIZE: INDEX;
    ListOfExt: array[INDEX]of string;
    procedure ChangeEditContent;
    procedure DoEnable(Sender: TObject);
  end;

var
  ScanDiskForm: TScanDiskForm;

implementation

uses AddFolder, main;

{$R *.dfm}

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
        inc(Count);
        Synchronize(ShowTotal);
      end;
    until FindNext(search) <> 0;
  end;

  // Subdirectories/ Unterverzeichnisse
  if ScanDiskForm.CheckBox1.Checked = true then
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
  with ScanDiskForm.Animate1 do
    Play(1, FrameCount, 0);

  GetAllFiles(ScanDiskForm.SearchDirectoryEdit.Text + '\' + '*.*');
end;

procedure TMyThread.ShowTotal;
begin
  ScanDiskForm.CountLabel.Caption:=IntToStr(Count);
end;

procedure TMyThread.AddToList;
begin
  ScanDiskForm.SearchListBox.Items.Add(StrConst);
end;

function TMyThread.CheckExt(ext: string): boolean;
var i: 1..MAX_SIZE;
    j: integer;
    b: boolean;
begin
  for j:=1 to Length(ext) do
    ext[j]:=UpCase(ext[j]);

  b:=false;
  with ScanDiskForm do
    for i:=1 to SIZE do
      if ext = ListOfExt[i] then begin
        b:=true;
        break;
      end;

  CheckExt:=b;
end;

{------------------------------------------------------------------------------}

{------------------------------ TAddThread ------------------------------------}

procedure TAddThread.Execute;
begin
  case nr of
    1: Synchronize(AddAllFiles);
    2: Synchronize(AddOnlySelectedFiles);
    3: Synchronize(AddAllButSelectedFiles);
  end;
end;

procedure TAddThread.AddAllFiles;
begin
  MainForm.AddItemsToPlayList(ScanDiskForm.SearchListBox.Items);
  MainForm.LoadItemsToMainListBox(MainForm.ShowFullPath1.Checked);
end;

procedure TAddThread.AddOneFile(StrConst: string);
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

procedure TAddThread.AddOnlySelectedFiles;
var i: LongInt;
begin
  for i:=0 to (ScanDiskForm.SearchListBox.Items.Count - 1) do
    if (ScanDiskForm.SearchListBox.Selected[i] = true) then
      AddOneFile(ScanDiskForm.SearchListBox.Items[i]);
end;

procedure TAddThread.AddAllButSelectedFiles;
var i: LongInt;
begin
  for i:=0 to (ScanDiskForm.SearchListBox.Items.Count - 1) do
    if (ScanDiskForm.SearchListBox.Selected[i] = false) then
      AddOneFile(ScanDiskForm.SearchListBox.Items[i]);
end;

{------------------------------------------------------------------------------}

function extupcase(a:string):string;
var
  tomb:string; i:integer;
begin
  tomb:=a;
  if tomb<>'' then for i:=1 to length(tomb) do tomb[i]:=upcase(tomb[i]);
  extupcase:=tomb;
end;


procedure TScanDiskForm.Button2Click(Sender: TObject);
var mouse_cursor: TMouse;
begin
  FileMaskPopupMenu.Popup(mouse_cursor.CursorPos.x,mouse_cursor.CursorPos.y);
end;

procedure TScanDiskForm.Button1Click(Sender: TObject);
begin
  AddFolderForm.ShowModal;

  with MainForm do
    if Cale <> '' then
      SearchDirectoryEdit.Text:=Cale;
end;

procedure TScanDiskForm.Button4Click(Sender: TObject);
var mouse_cursor: TMouse;
begin
  AddPopupMenu.Popup(mouse_cursor.CursorPos.x,mouse_cursor.CursorPos.y);
end;

procedure TScanDiskForm.FormCreate(Sender: TObject);
begin
  AllsupportedFiles1Click(Sender);
end;

procedure TScanDiskForm.DoEnable(Sender: TObject);
begin
  Button3.Enabled:=true;
  Button4.Enabled:=true;
  Button5.Enabled:=true;

  Animate1.Stop;
end;

procedure TScanDiskForm.Button3Click(Sender: TObject);
var MyThread: TMyThread;
begin
  SearchListBox.Clear;
  CountLabel.Caption:='0';

  Button3.Enabled:=false;
  Button4.Enabled:=false;
  Button5.Enabled:=false;

  MyThread:=TMyThread.Create(True);
  MyThread.StrConst:='';
  MyThread.count:=0;
  MyThread.FreeOnTerminate:=True;
  MyThread.OnTerminate:=DoEnable;
  MyThread.Resume;
end;

procedure TScanDiskForm.Button5Click(Sender: TObject);
var i: LongInt;
begin
  SearchListBox.DeleteSelected;
end;

procedure TScanDiskForm.ChangeEditContent;
var i: integer;
  function LowCase(s: string): string;
  var rez: string;
      i: integer;
  begin
    rez:='';

    for i:=2 to length(s) do
      rez:=rez + chr(Ord(UpCase(s[i])) + 32);

    LowCase:=rez;
  end;
begin
  FileMaskEdit.Text:='';

  for i:=1 to SIZE - 1 do
    FileMaskEdit.Text:=FileMAskEdit.Text + '*' + LowCase(ListOfExt[i]) + ';';

  FileMaskEdit.Text:=FileMAskEdit.Text + '*' + LowCase(ListOfExt[SIZE]);
end;

procedure TScanDiskForm.AllImageFiles1Click(Sender: TObject);
begin
  {ListOfExt[1]:='.JFIF'; ListOfExt[2]:='.JPE'; ListOfExt[3]:='.JPG';
  ListOfExt[4]:='.JPEG'; ListOfExt[5]:='.TIF'; ListOfExt[6]:='.TIFF';
  ListOfExt[7]:='.FAX'; ListOfExt[8]:='.SCR'; ListOfExt[9]:='.BW';
  ListOfExt[10]:='.RGB'; ListOfExt[11]:='.RGBA'; ListOfExt[12]:='.SGI';
  ListOfExt[13]:='.CEL'; ListOfExt[14]:='.PIC'; ListOfExt[15]:='.TGA';
  ListOfExt[16]:='.VST'; ListOfExt[17]:='.ICB'; ListOfExt[18]:='.VDA';
  ListOfExt[19]:='.WIN'; ListOfExt[20]:='.PCX'; ListOfExt[21]:='.PCC';
  ListOfExt[22]:='.PCD'; ListOfExt[23]:='.PPM'; ListOfExt[24]:='.PGM';
  ListOfExt[25]:='.PBM'; ListOfExt[26]:='.CUT'; ListOfExt[27]:='.PAL';
  ListOfExt[28]:='.GIF'; ListOfExt[29]:='.RLA'; ListOfExt[30]:='.RPF';
  ListOfExt[31]:='.BMP'; ListOfExt[32]:='.RLE'; ListOfExt[33]:='.DIB';
  ListOfExt[34]:='.PSD'; ListOfExt[35]:='.PDD'; ListOfExt[36]:='.PSP';
  ListOfExt[37]:='.PNG'; ListOfExt[38]:='.EPS'; ListOfExt[39]:='.ICO';
  ListOfExt[40]:='.EMF'; ListOfExt[41]:='.WMF';}

  ListOfExt[1]:='.JPG'; ListOfExt[2]:='.JPEG'; ListOfExt[3]:='.BMP';
  ListOfExt[4]:='.ICO'; ListOfExt[5]:='.EMF'; ListOfExt[6]:='.WMF';

  SIZE:=6; ChangeEditContent;
end;

procedure TScanDiskForm.AllMovieFiles1Click(Sender: TObject);
begin
  ListOfExt[1]:='.AVI'; ListOfExt[2]:='.MPG'; ListOfExt[3]:='.MPEG';
  ListOfExt[4]:='.SWF';

  SIZE:=4; ChangeEditContent;
end;

procedure TScanDiskForm.HTMLFiles1Click(Sender: TObject);
begin
  ListOfExt[1]:='.HTML'; ListOfExt[2]:='.HTM';

  SIZE:=2; ChangeEditContent;
end;

procedure TScanDiskForm.AllsupportedFiles1Click(Sender: TObject);
begin
  ListOfExt[1]:='.JPG'; ListOfExt[2]:='.JPEG'; ListOfExt[3]:='.BMP';
  ListOfExt[4]:='.ICO'; ListOfExt[5]:='.EMF'; ListOfExt[6]:='.WMF';
  ListOfExt[7]:='.WMF'; ListOfExt[8]:='.HTML'; ListOfExt[9]:='.HTM';
  ListOfExt[10]:='.AVI'; ListOfExt[11]:='.MPG'; ListOfExt[12]:='.MPEG';
  ListOfExt[13]:='.SWF';

  SIZE:=13; ChangeEditContent;
end;

procedure TScanDiskForm.AddAllFilestoShowList1Click(Sender: TObject);
var AddThread: TAddThread;
begin
  AddThread:=TAddThread.Create(true);
  AddThread.Nr:=1;
  AddThread.FreeOnTerminate:=true;
  AddThread.Resume;
end;

procedure TScanDiskForm.AddSelectedFilesOnly1Click(Sender: TObject);
var AddThread: TAddThread;
begin
  AddThread:=TAddThread.Create(true);
  AddThread.Nr:=2;
  AddThread.FreeOnTerminate:=true;
  AddThread.Resume;
end;

procedure TScanDiskForm.AddAllbutSelectedFiles1Click(Sender: TObject);
var AddThread: TAddThread;
begin
  AddThread:=TAddThread.Create(true);
  AddThread.Nr:=3;
  AddThread.FreeOnTerminate:=true;
  AddThread.Resume;
end;

procedure TScanDiskForm.SearchListBoxClick(Sender: TObject);
  var
     extension:string;

  procedure ScaleSearchImage(SourceImg:TPicture);
  var
     scalefactor:real;
  begin
{       If SourceImg.Height>SourceImg.Width then
         begin
              SearchImage.Width:=trunc( SourceImg.Width*79/SourceImg.Height );
              SearchImage.Height:=79;
              SearchImage.Left:=(Bevel3.Width div 2)- (Searchimage.Width div 2)+Bevel3.Left+2;
              SearchImage.Top:=Bevel3.Top+2;
         end
       else
         begin
              SearchImage.Height:=trunc( SourceImg.Height*113/SourceImg.Width );
              SearchImage.Width:=113;
              SearchImage.Left:=Bevel3.Left+2;
              SearchImage.Top:=(Bevel3.Height div 2)- (Searchimage.Height div 2)+Bevel3.Top+2;
         end;}
       If SourceImg.Height>SourceImg.Width then
         begin
              SearchImage.Width:=trunc( SourceImg.Width*113/SourceImg.Height );
              SearchImage.Height:=113;
              SearchImage.Left:=(Bevel3.Width div 2)- (SearchImage.Width div 2)+Bevel3.Left;
              SearchImage.Top:=Bevel3.Top+4;
         end
       else
         begin
              SearchImage.Height:=trunc( SourceImg.Height*113/SourceImg.Width );
              SearchImage.Width:=113;
              SearchImage.Left:=Bevel3.Left+4;
              SearchImage.Top:=(Bevel3.Height div 2)- (SearchImage.Height div 2)+Bevel3.Top;
         end;
end;
begin
     if SearchListBox.Items.Count>0 then
     begin
          If SearchlistBox.ItemIndex<0 then SearchListBox.ItemIndex:=0;
          if SearchPreviewCheckBox.Checked then
          begin
              extension:=extupcase(ExtractFileExt(Searchlistbox.Items.Strings[SearchListBox.itemindex]));
               if  (extension='.MPG') or (extension='.MPEG') or (extension='.AVI') then
               begin
                    SearchImage.Picture.LoadFromFile(mainform.rootdir+'moviepreview.bmp'); ScaleSearchImage(SearchImage.Picture);
               end;

               if (extension='.JPG') or (extension='.JPEG') or (extension='.BMP')
                 or (extension='.EMF') or (extension='.WMF') or (extension = '.ICO') then
               begin
                    SearchImage.Picture.LoadFromFile(Searchlistbox.Items.Strings[SearchListBox.itemindex]);
                    ScaleSearchimage(Searchimage.picture);
               end;
               if  (extension='.HTM') or (extension='.HTML') then
               begin
                    SearchImage.Picture.LoadFromFile(mainform.rootdir+'htmlpreview.bmp'); ScaleSearchImage(SearchImage.Picture);
               end;
          end;
     end;
end;

procedure TScanDiskForm.SearchPreviewCheckBoxClick(Sender: TObject);
begin
  if SearchPreviewCheckBox.Checked = false then
    begin
      SearchImage.Picture:=nil;
      SearchImage.Refresh;
    end
  else
    SearchListBoxClick(Self);    
end;

procedure TScanDiskForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:=false;
end;

end.
