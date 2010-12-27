{----------------------------------------------------------------------------
| Library: ASG Screen Capture ( Apprehend 2001 )
| Adirondack Software & Graphics Capture RectForm Unit
| for Delphi 5
| (C) Copyright Adirondack Software & Graphics 1996-2001
|
| Module: CaptureRect
|
| Description: TASGCapture Capture Rect Form.
|
| Known Problems: None
|
| History:  Previously developed as an application in the 1990's.
|           July 4, 2000. William Miller, first BETA version
|          July 13, 2000. William Miller, 2nd BETA version
|          Changed CaptureRect.Pas to paint the rubberband
|          on the form instead of a TImage to eliminate screen flicker.
|          July 15, 2000. William Miller, 3nd BETA version
|          Eliminated non-animated rubberbanding added version property
|---------------------------------------------------------------------------}

unit CaptureRect;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;
   
type
   TCaptureRectForm = class(TForm)
    Timer1: TTimer;
      procedure FormCreate(Sender: TObject);
      procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
      procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
      procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
      procedure FormPaint(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure Timer1Timer(Sender: TObject);
   private
      { Private declarations }
      X1,Y1,X2,Y2 : Integer;
      procedure RemoveTheRect;
      procedure DrawTheRect;
      procedure WMEraseBkGnd(Var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
   public
      { Public declarations }
      fRect: TRect;
      fBmp: TBitmap;
      RectBitmap: TBitmap;
   end;
      
var
   CaptureRectForm: TCaptureRectForm;
   Counter : Byte;
   CounterStart : Byte;
   Looper : LongInt;

implementation

{$R *.DFM}

{ Animated Rubbanding }
{--------------------------------------------------------------------------}
procedure MovingDots(X,Y: Integer; TheCanvas: TCanvas); stdcall;
begin
  Inc(Looper);
  Counter := Counter shl 1;              // Shift the bit left one
  if Counter = 0 then Counter := 1;      // If it shifts off left, reset it
  if (Counter and 224) > 0 then          // Are any of the left 3 bits set?
    TheCanvas.Pixels[X,Y] := clRed      // Erase the pixel
  else
    TheCanvas.Pixels[X,Y] := clWhite;   // Draw the pixel
end;

{ Animated Rubbanding }
{--------------------------------------------------------------------------}
function NormalizeRect(R: TRect): TRect;
begin
  // This routine normalizes a rectangle. It makes sure that the Left,Top
  // coords are always above and to the left of the Bottom,Right coords.
  with R do
    if Left > Right then
      if Top > Bottom then
        Result := Rect(Right,Bottom,Left,Top)
      else
        Result := Rect(Right,Top,Left,Bottom)
    else
      if Top > Bottom then
        Result := Rect(Left,Bottom,Right,Top)
      else
        Result := Rect(Left,Top,Right,Bottom);
end;

{ Animated Rubbanding }
{--------------------------------------------------------------------------}
procedure TCaptureRectForm.RemoveTheRect;
var
  R : TRect;
begin
  R := NormalizeRect(Rect(X1,Y1,X2,Y2));  // Rectangle might be flipped
  InflateRect(R,1,1);                     // Make the rectangle 1 pixel larger
  InvalidateRect(Handle,@R,True);         // Mark the area as invalid
  InflateRect(R,-2,-2);                   // Now shrink the rectangle 2 pixels
  ValidateRect(Handle,@R);                // And validate this new rectangle.
  // This leaves a 2 pixel band all the way around
  // the rectangle that will be erased & redrawn
  UpdateWindow(Handle);
end;

{ Animated Rubbanding }
{--------------------------------------------------------------------------}
procedure TCaptureRectForm.DrawTheRect;
begin
  // Determines starting pixel color of Rect
  Counter := CounterStart;
  // Use LineDDA to draw each of the 4 edges of the rectangle
  LineDDA(X1,Y1,X2,Y1,@MovingDots,LongInt(Canvas));
  LineDDA(X2,Y1,X2,Y2,@MovingDots,LongInt(Canvas));
  LineDDA(X2,Y2,X1,Y2,@MovingDots,LongInt(Canvas));
  LineDDA(X1,Y2,X1,Y1,@MovingDots,LongInt(Canvas));
end;

{--------------------------------------------------------------------------}
procedure TCaptureRectForm.FormCreate(Sender: TObject);
var
   aDC: HDC;
begin
   // Setup to capture image
   fBMP        := TBitmap.Create;
   RectBitmap  := TBitmap.Create;
   fBMP.Width  := Screen.Width;
   fBMP.Height := Screen.Height;
   aDC         := GetDC(0);
   BitBlt(fBMP.Canvas.handle, 0, 0, Screen.Width, Screen.Height,
   aDC, 0, 0, srcCopy);
   ReleaseDC(0, aDC  );
   SetBounds(0, 0, Screen.Width, Screen.Height);

   // Setup Animated Rubberband
   X1 := 0; Y1 := 0;
   X2 := 0; Y2 := 0;
   Canvas.Pen.Color := clRed;
   Canvas.Brush.Color := clWhite;
   CounterStart := 128;
   Timer1.Interval := 100;
   Timer1.Enabled := True;
   Looper := 0;
end;

{--------------------------------------------------------------------------}
procedure TCaptureRectForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
begin
  RemoveTheRect;                               // Erase any existing rectangle
  X1 := X; Y1 := Y; X2 := X; Y2 := Y;
  SetRect(fRect, X, Y, X, Y);                  // Set initial rectangle position
end;

{--------------------------------------------------------------------------}
procedure TCaptureRectForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
Y: Integer);
begin
if ssLeft in Shift then
    begin
      RemoveTheRect;         // Erase any existing rectangle
      X2 := X; Y2 := Y;      // Save the new corner where the mouse is
      DrawTheRect;           // Draw the Rect now... don't wait for the timer!
      fRect.Right  := X;     // Set the position of the rectangle to capture
      fRect.Bottom := Y;
    end;
end;

{--------------------------------------------------------------------------}
procedure TCaptureRectForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Integer);
var
  ScreenDC: HDC;
  Bitmap: TBitmap;
begin
   if Button = mbLeft then begin
  Bitmap := TBitmap.Create;
   // Set fRect
  fRect.Left := X1;
  fRect.Top := Y1;
  fRect.Right := X2;
  fRect.Bottom := Y2;
   // Exit if improper rectangle drawn
  if ( fRect.Right > fRect.Left ) and ( fRect.Bottom > fRect.Top ) then
  begin
    Bitmap.Width := fRect.Right - fRect.Left;
    Bitmap.Height := fRect.Bottom - fRect.Top;
    RemoveTheRect;
    ScreenDC := GetDC ( 0 );
    try
      BitBlt ( Bitmap.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height, ScreenDC, fRect.Left, fRect.Top,
        SRCCOPY );
      RectBitmap.Assign ( Bitmap );
    finally
      ReleaseDC ( 0, ScreenDC );
      Bitmap.Free;
    end;
  end; // if
  ModalResult := mrOK;
  end;
end;

{--------------------------------------------------------------------------}
procedure TCaptureRectForm.FormPaint(Sender: TObject);
begin
   Canvas.Draw(0, 0, fBMP);
end;

{--------------------------------------------------------------------------}
procedure TCaptureRectForm.FormDestroy(Sender: TObject);
begin
   fBMP.Free;
   RectBitmap.Free;
end;

{--------------------------------------------------------------------------}
Procedure TCaptureRectForm.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
   Msg.Result := 1;
end;

{ Animated Rubbanding }
{--------------------------------------------------------------------------}
procedure TCaptureRectForm.Timer1Timer(Sender: TObject);
begin
  CounterStart := CounterStart shr 2;           // Shl 1 will move rect slower
  if CounterStart = 0 then CounterStart := 128; // If bit is lost, reset it
  DrawTheRect;                                  // Draw the rectangle
end;

end.





