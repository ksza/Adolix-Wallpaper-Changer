object FilterForm: TFilterForm
  Left = 363
  Top = 368
  Width = 305
  Height = 168
  BorderIcons = [biSystemMenu]
  Caption = 'Add Folder Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCanResize = FormCanResize
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 281
    Height = 89
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 169
    Height = 13
    Caption = 'Add only these types of wallpapers :'
  end
  object Button1: TButton
    Left = 128
    Top = 106
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 216
    Top = 106
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object FilterEdit: TEdit
    Left = 16
    Top = 40
    Width = 233
    Height = 21
    ReadOnly = True
    TabOrder = 2
    Text = '*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf'
  end
  object RecurseSubfoldersCheckBox: TCheckBox
    Left = 16
    Top = 72
    Width = 121
    Height = 17
    Caption = 'Recurse subfolders'
    TabOrder = 3
  end
  object Button3: TButton
    Left = 256
    Top = 40
    Width = 25
    Height = 23
    Caption = '...'
    TabOrder = 4
    OnClick = Button3Click
  end
end
