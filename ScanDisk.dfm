object ScanDiskForm: TScanDiskForm
  Left = 354
  Top = 168
  Width = 519
  Height = 420
  BorderIcons = [biSystemMenu]
  Caption = 'Adolix Wallpaper Changer - Scan Disk for Wallpapers'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCanResize = FormCanResize
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 361
    Height = 129
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 85
    Height = 13
    Caption = 'Search Directory :'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 51
    Height = 13
    Caption = 'File Mask :'
  end
  object Bevel2: TBevel
    Left = 8
    Top = 152
    Width = 497
    Height = 233
    Shape = bsFrame
  end
  object Label3: TLabel
    Left = 16
    Top = 160
    Width = 63
    Height = 13
    Caption = 'Files Found : '
  end
  object Bevel3: TBevel
    Left = 373
    Top = 256
    Width = 121
    Height = 121
  end
  object CountLabel: TLabel
    Left = 80
    Top = 160
    Width = 6
    Height = 13
    Caption = '0'
  end
  object SearchImage: TImage
    Left = 377
    Top = 261
    Width = 113
    Height = 113
    ParentShowHint = False
    ShowHint = True
    Stretch = True
  end
  object SearchDirectoryEdit: TEdit
    Left = 16
    Top = 32
    Width = 305
    Height = 21
    TabOrder = 0
    Text = 'C:\'
  end
  object FileMaskEdit: TEdit
    Left = 16
    Top = 80
    Width = 305
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 328
    Top = 32
    Width = 33
    Height = 25
    Caption = '...'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 328
    Top = 80
    Width = 33
    Height = 25
    Caption = '...'
    TabOrder = 3
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 112
    Width = 185
    Height = 17
    Caption = 'Recursive Search Subdirectories'
    TabOrder = 4
  end
  object Button3: TButton
    Left = 384
    Top = 8
    Width = 113
    Height = 25
    Caption = 'Start Searching'
    TabOrder = 5
    OnClick = Button3Click
  end
  object SearchListBox: TListBox
    Left = 24
    Top = 184
    Width = 337
    Height = 193
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 6
    OnClick = SearchListBoxClick
  end
  object Button4: TButton
    Left = 373
    Top = 168
    Width = 121
    Height = 25
    Caption = 'Add to ShowList'
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 373
    Top = 200
    Width = 121
    Height = 25
    Caption = 'Remove Selected'
    TabOrder = 8
    OnClick = Button5Click
  end
  object SearchPreviewCheckBox: TCheckBox
    Left = 376
    Top = 232
    Width = 65
    Height = 17
    Caption = 'Preview'
    TabOrder = 9
    OnClick = SearchPreviewCheckBoxClick
  end
  object Animate1: TAnimate
    Left = 400
    Top = 88
    Width = 80
    Height = 50
    CommonAVI = aviFindFolder
    StopFrame = 29
  end
  object FileMaskPopupMenu: TPopupMenu
    Left = 328
    Top = 104
    object AllImageFiles1: TMenuItem
      Caption = '&All Image Files'
      OnClick = AllImageFiles1Click
    end
    object AllMovieFiles1: TMenuItem
      Caption = 'A&ll Movie Files'
      OnClick = AllMovieFiles1Click
    end
    object HTMLFiles1: TMenuItem
      Caption = '&HTML Files'
      OnClick = HTMLFiles1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object AllsupportedFiles1: TMenuItem
      Caption = 'All &supported Files'
      OnClick = AllsupportedFiles1Click
    end
  end
  object AddPopupMenu: TPopupMenu
    Left = 312
    Top = 192
    object AddAllFilestoShowList1: TMenuItem
      Caption = '&Add All Files to ShowList'
      OnClick = AddAllFilestoShowList1Click
    end
    object AddSelectedFilesOnly1: TMenuItem
      Caption = 'A&dd Selected Files Only'
      OnClick = AddSelectedFilesOnly1Click
    end
    object AddAllbutSelectedFiles1: TMenuItem
      Caption = 'Add Al&l but Selected Files'
      OnClick = AddAllbutSelectedFiles1Click
    end
  end
end
