object EditFilterForm: TEditFilterForm
  Left = 552
  Top = 347
  Width = 225
  Height = 206
  BorderIcons = [biSystemMenu]
  Caption = 'Filter Edit'
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
  object FilterListBox: TListBox
    Left = 8
    Top = 8
    Width = 121
    Height = 97
    ItemHeight = 13
    Items.Strings = (
      '*.jpg'
      '*.jpeg'
      '*.bmp'
      '*.ico'
      '*.emf'
      '*.wmf')
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 8
    Top = 112
    Width = 121
    Height = 21
    MaxLength = 4
    TabOrder = 1
  end
  object Button1: TButton
    Left = 136
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 136
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Remove'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Apply: TButton
    Left = 136
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 4
    OnClick = ApplyClick
  end
end
