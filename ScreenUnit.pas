unit ScreenUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, ToolWin, ImgList, ASGCapture, Jpeg, ExtCtrls,
  ExtDlgs, StdCtrls, ClipBrd, Printers, Buttons;

const MAX_SIZE = 20;
      TrackBarPoz = 15;
      ScaleFactor = 15;

type
  TScreenForm = class(TForm)
    ScreenToolbar: TToolBar;
    ScreenStatusBar: TStatusBar;
    ScreenPageControl: TPageControl;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    ToolButton5: TToolButton;
    ToolButton7: TToolButton;
    ToolButton10: TToolButton;
    ToolButton15: TToolButton;
    MyTrackBar: TTrackBar;
    ToolButton17: TToolButton;
    Saveas1: TMenuItem;
    Close1: TMenuItem;
    Closeall1: TMenuItem;
    N1: TMenuItem;
    Print1: TMenuItem;
    PrintSetup1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Copy1: TMenuItem;
    CopySelection1: TMenuItem;
    N3: TMenuItem;
    Crop1: TMenuItem;
    Capture1: TMenuItem;
    Desktop1: TMenuItem;
    Selection1: TMenuItem;
    Window1: TMenuItem;
    Object1: TMenuItem;
    Options1: TMenuItem;
    Minimize1: TMenuItem;
    Automatic1: TMenuItem;
    Delay1: TMenuItem;
    ASGScreenCapture: TASGScreenCapture;
    SavePictureDialog: TSavePictureDialog;
    OpenPictureDialog: TOpenPictureDialog;
    Open1: TMenuItem;
    HorizScroll: TScrollBar;
    VertScroll: TScrollBar;
    PrinterSetupDialog1: TPrinterSetupDialog;
    ImageList5: TImageList;
    OpenButton: TSpeedButton;
    CloseButton: TSpeedButton;
    CloseAllButton: TSpeedButton;
    SaveAsButton: TSpeedButton;
    PrintButton: TSpeedButton;
    CopyButton: TSpeedButton;
    CropButton: TSpeedButton;
    CaptureDesktopButton: TSpeedButton;
    CaptureSelectionButton: TSpeedButton;
    CaptureWindowButton: TSpeedButton;
    CaptureObjectButton: TSpeedButton;
    Click100Button: TSpeedButton;
    ExitButton: TSpeedButton;
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Desktop1Click(Sender: TObject);
    procedure Selection1Click(Sender: TObject);
    procedure Window1Click(Sender: TObject);
    procedure Object1Click(Sender: TObject);
    procedure ScreenPageControlChange(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Closeall1Click(Sender: TObject);
    procedure Crop1Click(Sender: TObject);
    procedure HorizScrollChange(Sender: TObject);
    procedure VertScrollChange(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure CopySelection1Click(Sender: TObject);
    procedure MyTrackBarChange(Sender: TObject);
    procedure Click100ButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PrintSetup1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Minimize1Click(Sender: TObject);
    procedure Automatic1Click(Sender: TObject);
    procedure Delay1Click(Sender: TObject);
  private
    { Private declarations }
    nr: byte; // current tabs total
    nr_total: byte; // total tabs ever
    k: LongInt; // current tab
  public
    { Public declarations }
    ImageVector: array[0..MAX_SIZE]of TImage;
    VectorDeStare: array[0..MAX_SIZE]of record
      HPoz, VPoz, TrackPoz, HMax, VMax: integer;
    end;
    Optiune: 0..2;
    selection_ready: boolean;
    procedure Captureaza(w: byte);
    function ExtractName(sir: string): string;
    function ExtractExtension(sir: string): string;
    procedure MiscaMouse(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ChangeButtonStatus(nr: integer);
    //for printing
    procedure DrawImage(Canvas: TCanvas; DestRect: TRect; ABitmap: TBitmap);
    procedure PrintImage(Image: TImage; ZoomPercent: Integer);
  end;

var
  ScreenForm: TScreenForm;
  {-----------------}
  Counter: Byte;
  CounterStart: Byte;
  Looper: LongInt;
  {-----------------}

implementation

uses selection, DelayUnit;

{$R *.dfm}

{--------------------------------------------------------------------------}
procedure TScreenForm.Captureaza(w: byte);
var MyTabSheet: TTabSheet;
    MyBitmap: TBitmap;
begin
  //Bitmap := TBitMap.create;
  MyBitmap:=TBitmap.Create;
  case w of
    1: MyBitmap := ASGScreenCapture.CaptureDesktop;
    2: MyBitmap := ASGScreenCapture.CaptureSelection;
    3: MyBitmap := ASGScreenCapture.CaptureActiveWindow;
    4: MyBitmap := ASGScreenCapture.CaptureObject;
  end;

//  MyBitmap.SaveToFile('temp.bmp');
  ScreenStatusBar.Panels[0].text:='Height: ' + IntToStr(MyBitmap.Height) + ' pixels';
  ScreenStatusBar.Panels[1].text:='Width: ' + IntToStr(MyBitmap.Width) + ' pixels';

  MyTabSheet:=TTabSheet.Create(self);
  MyTabSheet.PageControl:=ScreenPageControl;
  MyTabSheet.caption:='Image' + IntToStr(nr_total);
  MyTabSheet.Name:='MyTabSheet' + IntToStr(nr_total);
  case w of
    1: MyTabSheet.ImageIndex:=7;
    2: MyTabSheet.ImageIndex:=8;
    3: MyTabSheet.ImageIndex:=9;
    4: MyTabSheet.ImageIndex:=10;
  end;
  MyTabSheet.Visible:=true;
  MyTabSheet.enabled:=true;

  k:=nr;

  ImageVector[k]:=TImage.create(self);
  ImageVector[k].parent:=MyTabSheet;
  ImageVector[k].Name:='MyImage' + IntToStr(nr_total);
  ImageVector[k].AutoSize:=true;
//  ImageVector[k].Picture.LoadFromFile('temp.bmp');
  ImageVector[k].Picture.Bitmap := MyBitmap;
  MyBitmap.Free;
  ImageVector[k].OnMouseMove:=MiscaMouse;
  MyTabSheet.show;

  inc(nr); inc(nr_total);

  ScreenStatusBar.Panels[2].Text := '';

  if (ImageVector[k].Width > ScreenPageControl.ActivePage.Width) then begin
    VectorDeStare[k].HPoz:=0;
    VectorDeStare[k].HMax:=abs(ScreenPageControl.ActivePage.Width - ImageVector[k].Width);
    HorizScroll.Max:=VectorDeStare[k].HMax;
    HorizScroll.Position:=0;
    HorizScroll.Visible:=true;
  end
  else HorizScroll.Visible:=false;
  if (ImageVector[k].Height > ScreenPageControl.ActivePage.Height) then begin
    VectorDeStare[k].VPoz:=0;
    VectorDeStare[k].VMax:=abs(ImageVector[k].Height - ScreenPageControl.ActivePage.Height);
    VertScroll.Max:=VectorDeStare[k].VMax;
    VertScroll.Position:=0;
    VertScroll.Visible:=true;
  end
  else VertScroll.Visible:=false;
  VectorDeStare[k].TrackPoz:=TrackBarPoz;
  MyTrackBar.Position:=TrackBarPoz;
  ChangeButtonStatus(nr);
end;

function TScreenForm.ExtractName(sir: string): string;
var s: string;
    i, lung: integer;
begin
  lung:=length(sir);
  for i:=lung downto 1 do
    if sir[i] = '\' then break;
  s:=copy(sir, i + 1, lung - i);

  ExtractName:=s;
end;

function TScreenForm.ExtractExtension(sir: string): string;
var s: string;
    i, lung: integer;
begin
  lung:=length(sir);
  for i:=lung downto 1 do
    if sir[i] = '.' then break;
  s:=copy(sir, i + 1, lung - i);

  for i:=1 to length(s) do
    s[i]:=UpCase(s[i]);

  ExtractExtension:=s;
end;

procedure TScreenForm.MiscaMouse(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ScreenStatusBar.Panels[2].Text := '(' + IntToStr(X) + ',' + IntToStr(Y) + ')';
end;

procedure TScreenForm.ChangeButtonStatus(nr: integer);
begin
  if (nr = 0) then begin
    CloseButton.Enabled:=false;
    CloseAllButton.Enabled:=false;
    SaveAsButton.Enabled:=false;
    CopyButton.Enabled:=false;
    CropButton.Enabled:=false;
    MyTrackBar.Enabled:=false;
    Click100Button.Enabled:=false;
  end
  else begin
    CloseButton.Enabled:=true;
    CloseAllButton.Enabled:=true;
    SaveAsButton.Enabled:=true;
    CopyButton.Enabled:=true;
    CropButton.Enabled:=true;
    MyTrackBar.Enabled:=true;
    Click100Button.Enabled:=true;
  end;
end;

//for printing -> begin
procedure TScreenForm.DrawImage(Canvas: TCanvas; DestRect: TRect; ABitmap: TBitmap);
var
  Header, Bits: Pointer;
  HeaderSize: DWORD;
  BitsSize: DWORD;
begin
  GetDIBSizes(ABitmap.Handle, HeaderSize, BitsSize);
  Header := AllocMem(HeaderSize);
  Bits := AllocMem(BitsSize);
  try
    GetDIB(ABitmap.Handle, ABitmap.Palette, Header^, Bits^);
    StretchDIBits(Canvas.Handle, DestRect.Left, DestRect.Top,
      DestRect.Right, DestRect.Bottom,
      0, 0, ABitmap.Width, ABitmap.Height, Bits, TBitmapInfo(Header^),
      DIB_RGB_COLORS, SRCCOPY);
  finally
    FreeMem(Header, HeaderSize);
    FreeMem(Bits, BitsSize);
  end;
end;

procedure TScreenForm.PrintImage(Image: TImage; ZoomPercent: Integer);
  // if ZoomPercent=100, Image will be printed across the whole page
var
  relHeight, relWidth: integer;
begin
  Screen.Cursor := crHourglass;
  Printer.BeginDoc;
  with Image.Picture.Bitmap do
  begin
    if ((Width / Height) > (Printer.PageWidth / Printer.PageHeight)) then
    begin
      // Stretch Bitmap to width of PrinterPage
      relWidth := Printer.PageWidth;
      relHeight := MulDiv(Height, Printer.PageWidth, Width);
    end
    else
    begin
      // Stretch Bitmap to height of PrinterPage
      relWidth  := MulDiv(Width, Printer.PageHeight, Height);
      relHeight := Printer.PageHeight;
    end;
    relWidth := Round(relWidth * ZoomPercent / 100);
    relHeight := Round(relHeight * ZoomPercent / 100);
    DrawImage(Printer.Canvas, Rect(0, 0, relWidth, relHeight), Image.Picture.Bitmap);
  end;
  Printer.EndDoc;
  Screen.cursor := crDefault;
end;
//for printing -> end
{---------------------------------------------------------------------------------}

procedure TScreenForm.Exit1Click(Sender: TObject);
begin
  close;
end;

procedure TScreenForm.FormCreate(Sender: TObject);
begin
  nr:=0;
  nr_total:=0;
  k:=-1;
//  ChangeButtonStatus(nr);
end;

procedure TScreenForm.Desktop1Click(Sender: TObject);
begin
  Captureaza(1);
end;

procedure TScreenForm.Selection1Click(Sender: TObject);
begin
  Captureaza(2);
end;

procedure TScreenForm.Window1Click(Sender: TObject);
begin
  Captureaza(3);
end;

procedure TScreenForm.Object1Click(Sender: TObject);
begin
  Captureaza(4);
end;

procedure TScreenForm.ScreenPageControlChange(Sender: TObject);
begin
  k:=ScreenPageControl.TabIndex;

  ScreenStatusBar.Panels[0].text:='Height: ' + IntToStr(ImageVector[k].Height) + ' pixels';
  ScreenStatusBar.Panels[1].text:='Width: ' + IntToStr(ImageVector[k].Width) + ' pixels';
  ScreenStatusBar.Panels[2].Text := '';

  if (ImageVector[k].Width <= ScreenPageControl.ActivePage.Width) then
    HorizScroll.Visible:=false
  else begin
    HorizScroll.Visible:=true;
    HorizScroll.Max:=VectorDeStare[k].HMax;
    HorizScroll.Position:=VectorDeStare[k].HPoz;
  end;
  if (ImageVector[k].Height <= ScreenPageControl.ActivePage.Height) then
    VertScroll.Visible:=false
  else begin
    VertScroll.Visible:=true;
    VertScroll.Max:=VectorDeStare[k].VMax;
    VertScroll.Position:=VectorDeStare[k].VPoz;
  end;
  MyTrackBar.Position:=VectorDeStare[k].TrackPoz;
end;

procedure TScreenForm.Saveas1Click(Sender: TObject);
var nume_fis, extensie: string;
begin
  if SavePictureDialog.Execute then begin
    nume_fis:=SavePictureDialog.FileName;
    if (nume_fis <> '') then begin
      extensie:=ExtractFileExt(nume_fis);//ExtractExtension(nume_fis);

      if Extensie = '' then begin
        case SavePictureDialog.FilterIndex of
          1, 2: extensie:='jpg';
          3: extensie:='jpeg';
          4: extensie:='bmp';
        end;
        nume_fis:=nume_fis + '.' + extensie;
        SavePictureDialog.FileName:=nume_fis;
      end;

      ImageVector[k].Picture.SaveToFile(nume_fis);
      ScreenPageControl.Pages[k].Caption:=ExtractName(nume_fis);
    end;
  end;
end;

procedure TScreenForm.Open1Click(Sender: TObject);
var nume_fis: string;
    MyTabSheet: TTabSheet;
begin
  if OpenPictureDialog.Execute then begin
    nume_fis:=OpenPictureDialog.FileName;

    MyTabSheet:=TTabSheet.Create(self);
    MyTabSheet.PageControl:=ScreenPageControl;
    MyTabSheet.caption:='Image' + IntToStr(nr_total);
    MyTabSheet.Name:='MyTabSheet' + IntToStr(nr_total);
    MyTabSheet.ImageIndex:=0;
    MyTabSheet.Visible:=true;
    MyTabSheet.enabled:=true;

    k:=nr;

    ImageVector[k]:=TImage.create(self);
    ImageVector[k].parent:=MyTabSheet;
    ImageVector[k].Name:='MyImage' + IntToStr(nr_total);
    ImageVector[k].AutoSize:=true;
    ImageVector[k].Picture.LoadFromFile(nume_fis);
    ImageVector[k].OnMouseMove:=MiscaMouse;

    MyTabSheet.show;

    ScreenPageControl.Pages[k].Caption:=ExtractName(nume_fis);

    ScreenStatusBar.Panels[2].Text := '';

    inc(nr); inc(nr_total);

    if (ImageVector[k].Width > ScreenPageControl.ActivePage.Width) then begin
      VectorDeStare[k].HPoz:=0;
      VectorDeStare[k].HMax:=abs(ScreenPageControl.ActivePage.Width - ImageVector[k].Width);
      HorizScroll.Max:=VectorDeStare[k].HMax;
      HorizScroll.Position:=0;
      HorizScroll.Visible:=true;
    end
    else HorizScroll.Visible:=false;
    if (ImageVector[k].Height > ScreenPageControl.ActivePage.Height) then begin
      VectorDeStare[k].VPoz:=0;
      VectorDeStare[k].VMax:=abs(ImageVector[k].Height - ScreenPageControl.ActivePage.Height);
      VertScroll.Max:=VectorDeStare[k].VMax;
      VertScroll.Position:=0;
      VertScroll.Visible:=true;
    end
    else VertScroll.Visible:=false;
    VectorDeStare[k].TrackPoz:=TrackBarPoz;
    MyTrackBar.position:=TrackBarPoz;
  end;
  ChangeButtonStatus(nr);
end;

procedure TScreenForm.Close1Click(Sender: TObject);
var i: integer;
begin
  if ((nr - 1) >= 0) then begin
    MyTrackBar.Position:=TrackBarPoz;

    ImageVector[k].Free;
    ScreenStatusBar.Panels[2].Text := '';
    ScreenPageControl.ActivePage.Free;
    dec(nr);
    for i:=k to (nr - 1) do
      ImageVector[i]:=ImageVector[i + 1];
    if (k = 0) then k:=0
    else dec(k);
    ScreenStatusBar.Panels[0].text:='Height: ' + IntToStr(ImageVector[k].Height) + ' pixels';
    ScreenStatusBar.Panels[1].text:='Width: ' + IntToStr(ImageVector[k].Width) + ' pixels';

    if (ImageVector[k].Width <= ScreenPageControl.ActivePage.Width) then
      HorizScroll.Visible:=false
    else begin
      HorizScroll.Visible:=true;
      HorizScroll.Max:=VectorDeStare[k].HMax;
      HorizScroll.Position:=VectorDeStare[k].HPoz;
    end;
    if (ImageVector[k].Height <= ScreenPageControl.ActivePage.Height) then
      VertScroll.Visible:=false
    else begin
      VertScroll.Visible:=true;
      VertScroll.Max:=VectorDeStare[k].VMax;
      VertScroll.Position:=VectorDeStare[k].VPoz;
    end;
    MyTrackBar.Position:=VectorDeStare[k].TrackPoz;
  end;

  if (nr = 0) then begin
    ScreenStatusBar.Panels[0].text:='';
    ScreenStatusBar.Panels[1].text:='';

    HorizScroll.Visible:=false;
    VertScroll.Visible:=false;
  end;
  ChangeButtonStatus(nr);
end;

procedure TScreenForm.Closeall1Click(Sender: TObject);
var j: integer;
begin
  ScreenStatusBar.Panels[2].Text := '';
  if ((nr - 1) >= 0) then begin
    ScreenStatusBar.Panels[0].text:='';
    ScreenStatusBar.Panels[1].text:='';
    for j:=(nr - 1) downto 0 do begin
      MyTrackBar.Position:=TrackBarPoz;

      ImageVector[j].Free;
      ScreenPageControl.Pages[j].Free;
    end;
    nr:=0;
    k:=-1;

    HorizScroll.Visible:=false;
    VertScroll.Visible:=false;
  end;
  ChangeButtonStatus(nr);
end;

procedure TScreenForm.Crop1Click(Sender: TObject);
begin
  with SelectionForm do begin
    SelectedBitmap:=TBitmap.Create;
    MyImage.Picture:=ImageVector[k].Picture;
    //Height:=MyImage.Height + ScreenForm.ScreenToolbar.Height + 25;
    //Width:=MyImage.Width + 9;
    Optiune:=1; selection_ready:=false;
    ShowModal;
    if selection_ready then
      with ImageVector[k] do begin
        Picture:=nil;
        Refresh;
  //      SelectedBitmap.SaveToFile('temp.bmp');
  //      Picture.LoadFromFile('temp.bmp');
        Picture.Bitmap := SelectedBitmap;
        Refresh;
      end;
    SelectedBitmap.Free;

    if (ImageVector[k].Width > ScreenPageControl.ActivePage.Width) then begin
      VectorDeStare[k].HPoz:=0;
      VectorDeStare[k].HMax:=abs(ScreenPageControl.ActivePage.Width - ImageVector[k].Width);
      HorizScroll.Max:=VectorDeStare[k].HMax;
      HorizScroll.Position:=0;
      HorizScroll.Visible:=true;
    end
    else HorizScroll.Visible:=false;
    if (ImageVector[k].Height > ScreenPageControl.ActivePage.Height) then begin
      VectorDeStare[k].VPoz:=0;
      VectorDeStare[k].VMax:=abs(ImageVector[k].Height - ScreenPageControl.ActivePage.Height);
      VertScroll.Max:=VectorDeStare[k].VMax;
      VertScroll.Position:=0;
      VertScroll.Visible:=true;
    end
    else VertScroll.Visible:=false;
    VectorDeStare[k].TrackPoz:=TrackBarPoz;
  end;
end;

procedure TScreenForm.HorizScrollChange(Sender: TObject);
begin
  with HorizScroll do begin
    if (Position > VectorDeStare[k].HPoz) then
      ImageVector[k].Left := ImageVector[k].Left - (Position - VectorDeStare[k].HPoz)
    else
      ImageVector[k].Left := ImageVector[k].Left + (VectorDeStare[k].HPoz - Position);

    VectorDeStare[k].HPoz:=Position;
  end;
end;

procedure TScreenForm.VertScrollChange(Sender: TObject);
begin
  with VertScroll do begin
    if (Position > VectorDeStare[k].VPoz) then
      ImageVector[k].Top := ImageVector[k].Top - (Position - VectorDeStare[k].VPoz)
    else
      ImageVector[k].Top := ImageVector[k].Top + (VectorDeStare[k].VPoz - Position);

    VectorDeStare[k].VPoz:=Position;
  end;
end;

procedure TScreenForm.Copy1Click(Sender: TObject);
begin
  ClipBoard.Assign(ImageVector[k].Picture.Bitmap);
end;

procedure TScreenForm.CopySelection1Click(Sender: TObject);
begin
  optiune:=2;
  if selection_ready then
    with SelectionForm do begin
      SelectedBitmap:=TBitmap.Create;
      MyImage.Picture:=ImageVector[k].Picture;
      ShowModal;
      ClipBoard.Assign(SelectedBitmap);
      SelectedBitmap.Free;
    end;
end;

procedure TScreenForm.MyTrackBarChange(Sender: TObject);
begin
  if MyTrackBar.Position <> 0 then
    with ImageVector[k] do begin
      if autosize = true then Autosize:=false;
      if Stretch = false then Stretch := true;

      if (MyTrackBar.Position >= VectorDeStare[k].TrackPoz) then begin
        width := width + (MyTrackBar.Position - VectorDeStare[k].TrackPoz)*ScaleFactor;
        height := height + (MyTrackBar.Position - VectorDeStare[k].TrackPoz)*ScaleFactor;

        if (width > ScreenPageControl.ActivePage.Width)and(HorizScroll.Visible = false) then begin
          VectorDeStare[k].HPoz:=0;
          VectorDeStare[k].HMax:=abs(ScreenPageControl.ActivePage.Width - ImageVector[k].Width);
          HorizScroll.Max:=VectorDeStare[k].HMax;
          HorizScroll.Position:=0;
          HorizScroll.Visible:=true;
        end
        else;
        if (height > ScreenPageControl.ActivePage.Height)and(VertScroll.Visible = false) then begin
          VectorDeStare[k].VPoz:=0;
          VectorDeStare[k].VMax:=abs(ImageVector[k].Height - ScreenPageControl.ActivePage.Height);
          VertScroll.Max:=VectorDeStare[k].VMax;
          VertScroll.Position:=0;
          VertScroll.Visible:=true;
        end
        else;
      end
      else begin
        width := width - (VectorDeStare[k].TrackPoz - MyTrackBar.Position)*ScaleFactor;
        height := height - (VectorDeStare[k].TrackPoz - MyTrackBar.Position)*ScaleFactor;

        if (width <= ScreenPageControl.ActivePage.Width) then HorizScroll.Visible:=false;
         if (height <= ScreenPageControl.ActivePage.Width) then VertScroll.Visible:=false;
      end;

      VectorDeStare[k].TrackPoz:=MyTrackBar.Position;
    end;
end;

procedure TScreenForm.Click100ButtonClick(Sender: TObject);
begin
  MyTrackBar.Position:=TrackBarPoz;
end;

procedure TScreenForm.FormResize(Sender: TObject);
begin
  if (nr > 0) then begin
    if (ImageVector[k].Width > ScreenPageControl.ActivePage.Width) then begin
      VectorDeStare[k].HPoz:=0;
      VectorDeStare[k].HMax:=abs(ScreenPageControl.ActivePage.Width - ImageVector[k].Width);
      HorizScroll.Max:=VectorDeStare[k].HMax;
      HorizScroll.Position:=0;
      HorizScroll.Visible:=true;
    end
    else HorizScroll.Visible:=false;
    if (ImageVector[k].Height > ScreenPageControl.ActivePage.Height) then begin
      VectorDeStare[k].VPoz:=0;
      VectorDeStare[k].VMax:=abs(ImageVector[k].Height - ScreenPageControl.ActivePage.Height);
      VertScroll.Max:=VectorDeStare[k].VMax;
      VertScroll.Position:=0;
      VertScroll.Visible:=true;
    end
    else VertScroll.Visible:=false;
  end;
end;

procedure TScreenForm.PrintSetup1Click(Sender: TObject);
begin
  if PrinterSetupDialog1.Execute then;
end;

procedure TScreenForm.Print1Click(Sender: TObject);
begin
  PrintImage(ImageVector[k], 100);
end;

procedure TScreenForm.Minimize1Click(Sender: TObject);
begin
  with Minimize1 do
    Checked := not Checked;
  ASGScreenCapture.Minimize:=Minimize1.Checked;
end;

procedure TScreenForm.Automatic1Click(Sender: TObject);
begin
  with Automatic1 do
    Checked := not Checked;
  ASGScreenCapture.Auto:=Automatic1.Checked;
end;

procedure TScreenForm.Delay1Click(Sender: TObject);
begin
  DelayForm.ShowModal;
end;

end.
