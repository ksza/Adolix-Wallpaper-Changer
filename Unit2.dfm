object Form2: TForm2
  Left = 472
  Top = 342
  Width = 397
  Height = 158
  Caption = 'Adolix Wallpaper Changer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCanResize = FormCanResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 292
    Height = 26
    Caption = 
      'Please register and immediately experience the full power and ef' +
      'fectiveness that AWC has to offer!'
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 8
    Top = 83
    Width = 369
    Height = 9
    Shape = bsBottomLine
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 349
    Height = 20
    Caption = 'Your evaluation period of AWC has expired!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button2: TButton
    Left = 144
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Buy now'
    TabOrder = 0
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 224
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Enter key'
    TabOrder = 1
  end
  object Button4: TButton
    Left = 304
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    OnClick = Button4Click
  end
end
