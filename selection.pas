unit selection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, ExtDlgs, StdCtrls, Buttons;

type
  TSelectionForm = class(TForm)
    MyImage: TImage;
    ToolBar1: TToolBar;
    SavePictureDialog1: TSavePictureDialog;
    ToolButton1: TBitBtn;
    ToolButton2: TBitBtn;
    procedure MyImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MyImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MyImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { Private declarations }
    fRect: TRect;
    fBmp: TBitmap;
    RectBitmap: TBitmap;
    X1, Y1, X2, Y2: Integer;
    apasat: boolean;
  public
    { Public declarations }
    SelectedBitmap: TBitmap;
    procedure RemoveTheRect;
    procedure DrawTheRect;
  end;

var
  SelectionForm: TSelectionForm;
  {-----------------}
  Counter: Byte;
  CounterStart: Byte;
  Looper: LongInt;
  {-----------------}

implementation

uses ScreenUnit;

{$R *.dfm}

{ Animated Rubbanding }
{--------------------------------------------------------------------------}
procedure MovingDots ( X, Y: Integer;TheCanvas: TCanvas );stdcall;
begin
  Inc ( Looper );
  Counter := Counter shl 1; // Shift the bit left one
  if Counter = 0 then Counter := 1; // If it shifts off left, reset it
  if ( Counter and 224 ) > 0 then // Are any of the left 3 bits set?
    TheCanvas.Pixels[ X, Y ] := clRed // Erase the pixel
  else
    TheCanvas.Pixels[ X, Y ] := clWhite; // Draw the pixel
end;

{ Animated Rubbanding }
{--------------------------------------------------------------------------}
function NormalizeRect ( R: TRect ): TRect;
begin
  // This routine normalizes a rectangle. It makes sure that the Left,Top
  // coords are always above and to the left of the Bottom,Right coords.
  with R do
    if Left > Right then
      if Top > Bottom then
        Result := Rect ( Right, Bottom, Left, Top )
      else
        Result := Rect ( Right, Top, Left, Bottom )
    else
      if Top > Bottom then
        Result := Rect ( Left, Bottom, Right, Top )
      else
        Result := Rect ( Left, Top, Right, Bottom );
end;

{ Animated Rubbanding }
{--------------------------------------------------------------------------}
procedure TSelectionForm.RemoveTheRect;
var
  R: TRect;
begin
  R := NormalizeRect ( Rect ( X1, Y1, X2, Y2 ) ); // Rectangle might be flipped
  InflateRect ( R, 1, 1 ); // Make the rectangle 1 pixel larger
  InvalidateRect ( Handle, @R, True ); // Mark the area as invalid
  InflateRect ( R, -2, -2 ); // Now shrink the rectangle 2 pixels
  ValidateRect ( Handle, @R ); // And validate this new rectangle.
  // This leaves a 2 pixel band all the way around
  // the rectangle that will be erased & redrawn
  UpdateWindow ( Handle );
end;

{ Animated Rubbanding }
{--------------------------------------------------------------------------}
procedure TSelectionForm.DrawTheRect;
begin
  // Determines starting pixel color of Rect
  Counter := CounterStart;
  // Use LineDDA to draw each of the 4 edges of the rectangle
  LineDDA ( X1, Y1, X2, Y1, @MovingDots, LongInt ( Canvas ) );
  LineDDA ( X2, Y1, X2, Y2, @MovingDots, LongInt ( Canvas ) );
  LineDDA ( X2, Y2, X1, Y2, @MovingDots, LongInt ( Canvas ) );
  LineDDA ( X1, Y2, X1, Y1, @MovingDots, LongInt ( Canvas ) );
end;

{--------------------------------------------------------------------------}
procedure TSelectionForm.MyImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  apasat:=true;
  RemoveTheRect; // Erase any existing rectangle
  with MyImage do begin
    X1 := X + left; Y1 := Y + top; X2 := X + left; Y2 := Y + top;
  end;
  SetRect ( fRect, X1, Y1, X2, Y2 ); // Set initial rectangle position
end;

procedure TSelectionForm.MyImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var XLimit, YLimit: integer;
begin
  with MyImage do begin
    XLimit:=Left + Width ;//- 1;
    YLimit:=Top + Height - ScreenForm.ScreenToolBar.Height + 3;
  end;

  if apasat then begin
    with MyImage do begin
      if (X <= XLimit)and(Y > YLimit) then begin
        RemoveTheRect;
        X2:=X + Left;
        DrawTheRect;
        fRect.Right:=X + Left;
      end
      else
      if (X > XLimit)and(Y <= YLimit) then begin
        RemoveTheRect;
        Y2:=Y + Top;
        DrawTheRect;
        fRect.Bottom:=Y + Top;
      end
      else
      if (X > XLimit)and(Y > YLimit) then begin
      end
      else
      if (X <= XLimit)and(Y <= YLimit) then begin
        RemoveTheRect; // Erase any existing rectangle
        X2 := X + left; Y2 := Y + top; // Save the new corner where the mouse is
        DrawTheRect; // Draw the Rect now... don't wait for the timer!
        fRect.Right := X + left; // Set the position of the rectangle to capture
        fRect.Bottom := Y + top;
      end;
    end;
  end;
end;

procedure TSelectionForm.MyImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    //Bitmap := TBitmap.Create;
    // Set fRect
    with MyImage do begin
      fRect.Left := X1;// - Left;
      fRect.Top := Y1;// - Top;
      fRect.Right := X2;// - Left;
      fRect.Bottom := Y2;// - Top;
    end;
   // Exit if improper rectangle drawn
    if ( fRect.Right > fRect.Left ) and ( fRect.Bottom > fRect.Top ) then
    begin
      SelectedBitmap.Width := fRect.Right - fRect.Left;
      SelectedBitmap.Height := fRect.Bottom - fRect.Top;
      //RemoveTheRect;
    end; // if
    //ModalResult := mrOK;
  end;

  apasat:=false;
end;

procedure TSelectionForm.FormCreate(Sender: TObject);
begin
  apasat:=false;
  // Setup to capture image
  fBMP := TBitmap.Create;
  RectBitmap := TBitmap.Create;
  fBMP.Width := MyImage.Width;
  fBMP.Height := MyImage.Height;

  with MyImage do begin
    SetBounds ( Left, Top, Width, Height );
    // Setup Animated Rubberband
    X1 := Left; Y1 := Top;
    X2 := Left; Y2 := Top;
  end;
  Canvas.Pen.Color := clRed;
  Canvas.Brush.Color := clWhite;
  CounterStart := 128;
  Looper := 0;
end;

procedure TSelectionForm.ToolButton2Click(Sender: TObject);
begin
  ScreenForm.selection_ready:=false;
  Close;
end;

procedure TSelectionForm.ToolButton1Click(Sender: TObject);
begin
  try
    RemoveTheRect;
    with SelectedBitmap do
      Canvas.CopyRect(Rect(0, 0, width, height), SelectionForm.Canvas,
                      NormalizeRect(fRect));
      //SelectedBitmap:=Bitmap;
  finally
    //Bitmap.Free;
  end;

  if ScreenForm.Optiune = 0 then
    if SavePictureDialog1.Execute then begin
      SelectedBitmap.SaveToFile(SavePictureDialog1.FileName);
    end;
  ScreenForm.selection_ready:=true;    
  close;
end;

end.
