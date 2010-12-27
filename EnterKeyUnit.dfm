object EnterKeyForm: TEnterKeyForm
  Left = 443
  Top = 424
  Width = 372
  Height = 177
  Caption = 'Enter key'
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
    Width = 235
    Height = 13
    Caption = 'Please enter the registration name and key below:'
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object Label3: TLabel
    Left = 16
    Top = 72
    Width = 21
    Height = 13
    Caption = 'Key:'
  end
  object NameEdit: TEdit
    Left = 88
    Top = 48
    Width = 265
    Height = 21
    TabOrder = 0
  end
  object KeyEdit: TEdit
    Left = 88
    Top = 72
    Width = 265
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 16
    Top = 112
    Width = 81
    Height = 25
    Caption = 'Buy now'
    TabOrder = 2
  end
  object Button2: TButton
    Left = 184
    Top = 112
    Width = 81
    Height = 25
    Caption = 'OK'
    TabOrder = 3
  end
  object Button3: TButton
    Left = 272
    Top = 112
    Width = 81
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = Button3Click
  end
end
