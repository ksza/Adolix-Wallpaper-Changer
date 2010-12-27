object SelectionForm: TSelectionForm
  Left = 192
  Top = 142
  Width = 870
  Height = 640
  BorderIcons = []
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MyImage: TImage
    Left = 0
    Top = 45
    Width = 185
    Height = 188
    Cursor = crCross
    AutoSize = True
    OnMouseDown = MyImageMouseDown
    OnMouseMove = MyImageMouseMove
    OnMouseUp = MyImageMouseUp
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 862
    Height = 45
    BorderWidth = 2
    ButtonHeight = 30
    ButtonWidth = 30
    EdgeBorders = [ebRight, ebBottom]
    TabOrder = 0
    object ToolButton1: TBitBtn
      Left = 0
      Top = 2
      Width = 30
      Height = 30
      TabOrder = 0
      OnClick = ToolButton1Click
      Kind = bkOK
    end
    object ToolButton2: TBitBtn
      Left = 30
      Top = 2
      Width = 30
      Height = 30
      TabOrder = 1
      OnClick = ToolButton2Click
      Kind = bkCancel
    end
  end
  object SavePictureDialog1: TSavePictureDialog
    Filter = 
      'All (*.jpg;*.jpeg;*.bmp)|*.jpg;*.jpeg;*.bmp|JPEG Image File (*.j' +
      'pg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|Bitmaps (*.bmp)|*.bmp'
    Left = 824
    Top = 8
  end
end
