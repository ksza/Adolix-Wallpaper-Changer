object DelayForm: TDelayForm
  Left = 493
  Top = 385
  Width = 293
  Height = 126
  BorderIcons = [biSystemMenu]
  Caption = 'Screen Delay'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 10
    Width = 177
    Height = 79
    Caption = 'Delay'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 161
      Height = 13
      Caption = 'Enter Screen Refresh Delay: '
    end
    object SpinEdit1: TSpinEdit
      Left = 8
      Top = 40
      Width = 113
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 500
    end
  end
  object Button1: TButton
    Left = 200
    Top = 24
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
end
