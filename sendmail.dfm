object MailForm: TMailForm
  Left = 504
  Top = 273
  BorderStyle = bsDialog
  Caption = 'Send Mail to'
  ClientHeight = 57
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 16
    Top = 16
    Width = 265
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 304
    Top = 16
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
end
