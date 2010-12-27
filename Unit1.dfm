object Form1: TForm1
  Left = 458
  Top = 284
  Width = 399
  Height = 160
  BorderIcons = [biSystemMenu]
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
    Top = 8
    Width = 368
    Height = 52
    Caption = 
      'This program is not free. It is a limited evaluation version of ' +
      'copyrighted software and will expire after 15 days. To remove al' +
      'l limitations you are welcome to register at any time and immedi' +
      'ately experience the full power and effectiveness Wallpaper Xe h' +
      'as to offer.  We hope you enjoy your evaluation!'
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 8
    Top = 83
    Width = 369
    Height = 9
    Shape = bsBottomLine
  end
  object Button1: TButton
    Left = 8
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Continue'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 144
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Buy now'
    TabOrder = 1
  end
  object Button3: TButton
    Left = 224
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Enter key'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 304
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 3
    OnClick = Button4Click
  end
end
