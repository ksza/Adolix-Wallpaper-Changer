{----------------------------------------------------------------------------
| Library: ASG Screen Capture ( Apprehend 2000 )
| Adirondack Software & Graphics ScreenCapture Component
| for Delphi 5 (C) Copyright Adirondack Software & Graphics 1996-2000
|
| Module: ASGCapture
|
| Description: TASGScreenCapture class and non-visible component.
|
| Contact Information:
|  The lateset version will always be available on the web at:
|    http://www.software.adirondack.ny.us
|  If you have any questions, comments or suggestions, you may contact us at
|  w2m@netheaven.com
|
| Known Problems: None
|
| History: 1996-1999 - Developed screen capture routines
|          July 4, 2000. William Miller, first BETA version
|          July 13, 2000. William Miller, 2nd BETA version
|          Changed CaptureRect.Pas to paint the rubberband
|          on the form instead of a TImage to eliminate screen flicker.
|          July 15, 2000. William Miller, 3nd BETA version
|          Added animated rubberbanding and version property
|          September 21, 2000. William Miller. Compiled Release 1.0
|
| Installation:  This component has only been tested with Delphi 5
|                1. Install the ASG_Capture package
|                2. Be sure you set the path to the folder
|                containing the component in the Delphi 5 IDE
|
|---------------------------------------------------------------------------}

unit ASGCapture;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Menus, Clipbrd;

const
  ASG_COMPONENT_VERSION = 'TASGScreenCapture v1.0';

type

  TASGScreenCapture = class ( TComponent )
  private
    fAutomatic: Boolean; // send image to clipboard
    fBitmap: TBitmap; // captured bitmap
    fDelay: Integer; // delay for screen refresh - may be set by enduser in Delay property
    fMinimized: Boolean;
    fOnCapture: TNotifyEvent; // fires after capture
    procedure SetDelay ( const Value: Integer );
    procedure SetAutomatic ( const Value: Boolean );
    procedure SetMinimized ( const Value: Boolean );
    function GetVersion: string;
    procedure SetVersion ( const Val: string );
    procedure CopyToClipboard;
  public
    constructor Create ( AOwner: TComponent );override;
    destructor Destroy;override;
    // Capture the desktop
    function CaptureDesktop: TBitmap;
    // Capture a bitmap image of the active window
    function CaptureActiveWindow: TBitmap;
    // Capture a bitmap of a selected object (Window, button, toolbar)
    function CaptureObject: TBitmap;
    // Capture a bitmap of a selected area
    function CaptureSelection: TBitmap;
  published
        // If Automatic is true then copy captured bitmap to clipboard
    property Auto: Boolean read fAutomatic write fAutomatic default True;
       // Setting for Screen Refresh Time
    property Delay: Integer read fDelay write fDelay default 500;
      // If Minimize is true then the mainform of the application is
      // minimized and restored during screen capture
    property Minimize: Boolean read fMinimized write fMinimized default True;
    property OnCapture: TNotifyEvent read fOnCapture write fOnCapture;
      // Show component version
    property Version: string read GetVersion write SetVersion stored FALSE;
  end;

procedure Register;

implementation

uses
  CaptureTheObject, { for CaptureTheObject Form  - needed for cursor }
  CaptureTheRect; { for CaptureTheRect Form  - needed for animated rubberbanding }

// create the component
constructor TASGScreenCapture.Create ( AOwner: TComponent );
begin
  inherited Create ( AOwner );
  fAutomatic := True;
  fMinimized := True;
  fDelay := 500;
  fBitmap := TBitmap.Create;
  SetDelay(fDelay);
  SetAutomatic(fAutomatic);
  SetMinimized(FMinimized);
end;

{--------------------------------------------------------------------------}
// destroy the component
destructor TASGScreenCapture.Destroy;
begin
  inherited Destroy;
  fBitmap.Free;
end;

{--------------------------------------------------------------------------}
// set delay for screen refresh
procedure TASGScreenCapture.SetDelay ( const Value: Integer );
begin
  fDelay := Value;
end;

{--------------------------------------------------------------------------}

procedure TASGScreenCapture.SetMinimized ( const Value: Boolean );
begin
  if Value <> fMinimized then
    fMinimized := Value;
end;

{--------------------------------------------------------------------------}

procedure TASGScreenCapture.SetAutomatic ( const Value: Boolean );
begin
  fAutomatic := Value;
end;

{--------------------------------------------------------------------------}

function TASGScreenCapture.GetVersion: string;
begin
  Result := ASG_COMPONENT_VERSION;
end;

{--------------------------------------------------------------------------}

procedure TASGScreenCapture.SetVersion ( const Val: string );
begin
  { empty write method, just needed to get it to show up in Object Inspector }
end;

{--------------------------------------------------------------------------}

// copies bitmap to clipboard
procedure TASGScreenCapture.CopyToClipboard;
begin
  Clipboard.Assign ( fBitmap );
end;

{--------------------------------------------------------------------------}
// Captures Image of Screen or windows Desktop
function TASGScreenCapture.CaptureDesktop: TBitmap;
var
  Handles: HWND;
  ScreenDC: HDC;
  Rect: TRect;
  lpPal: PLogPalette;
begin
    // Get mainform out of the way
  if fMinimized then
    Application.Minimize;
    // Give screen time to refresh by delay
  Sleep ( fDelay );
  Handles := GetDesktopWindow ( );
  ScreenDC := GetDC ( Handles );
  GetWindowRect ( Handles, Rect );
  // do we have a palette device? - Thanks to Joe C. Hecht
  if ( GetDeviceCaps ( ScreenDC, RASTERCAPS ) and RC_PALETTE = RC_PALETTE ) then
  begin
    // allocate memory for a logical palette
    GetMem ( lpPal, sizeof ( TLOGPALETTE ) + ( 255 * sizeof ( TPALETTEENTRY ) ) );
    // zero it out to be neat
    FillChar ( lpPal^, sizeof ( TLOGPALETTE ) + ( 255 * sizeof ( TPALETTEENTRY ) ), #0 );
    // fill in the palette version
    lpPal^.palVersion := $300;
    // grab the system palette entries
    lpPal^.palNumEntries :=
      GetSystemPaletteEntries ( ScreenDC, 0, 256, lpPal^.palPalEntry );
    if ( lpPal^.PalNumEntries <> 0 ) then
      // create the palette
      fBitmap.Palette := CreatePalette ( lpPal^ );
    FreeMem ( lpPal, sizeof ( TLOGPALETTE ) + ( 255 * sizeof ( TPALETTEENTRY ) ) );
  end;
  try
    fBitmap.Width := Rect.Right - Rect.Left;
    fBitmap.Height := Rect.Bottom - Rect.Top;
    BitBlt ( fBitmap.Canvas.Handle, 0, 0, fBitmap.Width, fBitmap.Height, ScreenDC, 0, 0, SRCCOPY );
    ReleaseDC ( Handles, ScreenDC );
    Result := TBitmap.Create;
    Result.Assign ( fBitmap );
    if fAutomatic then CopyToClipboard;
    if Assigned ( fOnCapture ) then fOnCapture ( Self );
  finally
    ReleaseDC ( Handles, ScreenDC );
    if fMinimized then
      // Restore mainform to original state
      Application.Restore;
  end;
end;

{--------------------------------------------------------------------------}
// Capture Active Window. If window not active then it captures desktop
function TASGScreenCapture.CaptureActiveWindow: TBitmap;
var
  Handles: HWnd;
  Rect: TRect;
  ScreenDC: HDC;
  lpPal: PLogPalette;
begin
  // Get mainform out of the way
  if fMinimized then
    Application.Minimize;
  // Give screen time to refresh by delay
  Sleep ( fDelay );
  Handles := GetForegroundWindow ( );
  ScreenDC := GetWindowDC ( Handles );
  // do we have a palette device? - Thanks to Joe C. Hecht
  if ( GetDeviceCaps ( ScreenDC, RASTERCAPS ) and RC_PALETTE = RC_PALETTE ) then
  begin
    // allocate memory for a logical palette
    GetMem ( lpPal, sizeof ( TLOGPALETTE ) + ( 255 * sizeof ( TPALETTEENTRY ) ) );
    // zero it out to be neat
    FillChar ( lpPal^, sizeof ( TLOGPALETTE ) + ( 255 * sizeof ( TPALETTEENTRY ) ), #0 );
    // fill in the palette version
    lpPal^.palVersion := $300;
    // grab the system palette entries
    lpPal^.palNumEntries :=
      GetSystemPaletteEntries ( ScreenDC, 0, 256, lpPal^.palPalEntry );
    if ( lpPal^.PalNumEntries <> 0 ) then
      // create the palette
      fBitmap.Palette := CreatePalette ( lpPal^ );
    FreeMem ( lpPal, sizeof ( TLOGPALETTE ) + ( 255 * sizeof ( TPALETTEENTRY ) ) );
  end;
  GetWindowRect ( Handles, Rect );
  try
    fBitmap.Width := Rect.Right - Rect.Left;
    fBitmap.Height := Rect.Bottom - Rect.Top;
    BitBlt ( fBitmap.Canvas.Handle, 0, 0, fBitmap.Width, fBitmap.Height, ScreenDC, 0, 0, SRCCOPY );
    ReleaseDC ( Handles, ScreenDC );
    Result := TBitmap.Create;
    Result.Assign ( fBitmap );
    if fAutomatic then CopyToClipboard;
    if assigned ( fOnCapture ) then fOnCapture ( Self );
  finally
    ReleaseDC ( Handles, ScreenDC );
      // Restore mainform to original state
    if fMinimized then
      Application.Restore;
  end;
end;

{--------------------------------------------------------------------------}
// Capture Selected Object
function TASGScreenCapture.CaptureObject: TBitmap;
var
  Rect: TRect;
  P1: TPoint;
  Handles: HWnd;
  ScreenDC: HDC;
  lpPal: PLogPalette;
begin
  Result := nil;
  // Get mainform out of the way
  if fMinimized then
    Application.Minimize;
  // Give screen time to refresh by delay
  Sleep ( Delay );
  CaptureObjectForm := TCaptureObjectForm.Create ( Application );
  try
    if CaptureObjectForm.ShowModal = mrOK then
    begin
      Sleep ( Delay );
        // Get cursor position
      GetCursorPos ( P1 );
      Handles := WindowFromPoint ( P1 );
        // Get mainform out of the way
      GetWindowRect ( Handles, Rect );
      with fBitmap, Rect do
      begin
        Width := Right - Left;
        Height := Bottom - Top;
        ScreenDC := GetDC ( 0 );
        // do we have a palette device? - Thanks to Joe C. Hecht
        if ( GetDeviceCaps ( ScreenDC, RASTERCAPS ) and RC_PALETTE = RC_PALETTE ) then
        begin
          // allocate memory for a logical palette
          GetMem ( lpPal, sizeof ( TLOGPALETTE ) + ( 255 * sizeof ( TPALETTEENTRY ) ) );
          // zero it out to be neat
          FillChar ( lpPal^, sizeof ( TLOGPALETTE ) + ( 255 * sizeof ( TPALETTEENTRY ) ), #0 );
         // fill in the palette version
          lpPal^.palVersion := $300;
         // grab the system palette entries
          lpPal^.palNumEntries :=
            GetSystemPaletteEntries ( ScreenDC, 0, 256, lpPal^.palPalEntry );
          if ( lpPal^.PalNumEntries <> 0 ) then
          // create the palette
            fBitmap.Palette := CreatePalette ( lpPal^ );
          FreeMem ( lpPal, sizeof ( TLOGPALETTE ) + ( 255 * sizeof ( TPALETTEENTRY ) ) );
        end;
      end;

      BitBlt ( fBitmap.Canvas.Handle, 0, 0, fBitmap.Width, fBitmap.Height, ScreenDC, Rect.Left, Rect.Top,
        SRCCOPY );
      try
        // copy bitmap to function result
        Result := TBitmap.Create;
        Result.Assign ( fBitmap );
        if fAutomatic then CopyToClipboard;
        if Assigned ( fOnCapture ) then fOnCapture ( Self );
      finally
        ReleaseDC ( 0, ScreenDC );
      end;
    end;
  finally
      // Restore mainform to original state
    if fMinimized then
      Application.Restore;
  end;
end;

{--------------------------------------------------------------------------}
// Capture Selection
function TASGScreenCapture.CaptureSelection: TBitmap;
begin
  Result := nil;
    // Get mainform out of the way
  if fMinimized then
    Application.Minimize;
   // Give screen time to refresh by delay
  Sleep ( Delay );
  // Create and show form to capture Rect
  CaptureRectForm := TCaptureRectForm.Create ( Application );
  try
    if CaptureRectForm.ShowModal = mrOK then
    begin
      Sleep ( Delay );
      Result := TBitmap.Create;
      FBitmap.Assign ( CaptureRectForm.RectBitmap );
      Result.Assign ( fBitmap );
      if fAutomatic then CopyToClipboard;
      if Assigned ( fOnCapture ) then fOnCapture ( Self );
    end;
  finally
       // Restore mainform to original state
    if fMinimized then
      Application.Restore;
  end;
end;

{--------------------------------------------------------------------------}

procedure Register;
begin
  RegisterComponents ( 'ASG', [ TASGScreenCapture ] );
end;

end.

