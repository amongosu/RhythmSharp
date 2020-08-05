object frmTaskEditor: TfrmTaskEditor
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Add/Edit Task'
  ClientHeight = 174
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  StyleElements = [seFont, seClient]
  OnShow = FormShow
  DesignSize = (
    344
    174)
  PixelsPerInch = 96
  TextHeight = 14
  object Group_EditTask: TGroupBox
    Left = 8
    Top = 8
    Width = 328
    Height = 158
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Task'
    Padding.Left = 5
    Padding.Top = 15
    Padding.Right = 5
    Padding.Bottom = 5
    TabOrder = 0
    ExplicitHeight = 145
    DesignSize = (
      328
      158)
    object Label1: TLabel
      Left = 8
      Top = 21
      Width = 26
      Height = 14
      Caption = 'Filter'
    end
    object Label2: TLabel
      Left = 8
      Top = 49
      Width = 76
      Height = 14
      Caption = 'PlayCount Min'
    end
    object Label3: TLabel
      Left = 180
      Top = 49
      Width = 79
      Height = 14
      Caption = 'PlayCount Max'
    end
    object Label4: TLabel
      Left = 8
      Top = 77
      Width = 33
      Height = 14
      Caption = 'Profile'
    end
    object Label5: TLabel
      Left = 180
      Top = 77
      Width = 33
      Height = 14
      Caption = 'If Fails'
    end
    object Edit_SearchFilter: TEdit
      Left = 40
      Top = 18
      Width = 252
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object Button_KeywordHelp: TButton
      Left = 298
      Top = 18
      Width = 22
      Height = 22
      Caption = '?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button_KeywordHelpClick
    end
    object Edit_PlayCountMin: TEdit
      Left = 90
      Top = 46
      Width = 55
      Height = 22
      Alignment = taCenter
      NumbersOnly = True
      TabOrder = 2
      OnChange = Edit_PlayCountMinChange
    end
    object Edit_PlayCountMax: TEdit
      Left = 265
      Top = 46
      Width = 55
      Height = 22
      Alignment = taCenter
      NumbersOnly = True
      TabOrder = 3
      OnChange = Edit_PlayCountMaxChange
    end
    object Combo_Profile: TComboBox
      Left = 47
      Top = 74
      Width = 97
      Height = 22
      Style = csDropDownList
      TabOrder = 4
    end
    object Combo_IfFails: TComboBox
      Left = 219
      Top = 74
      Width = 101
      Height = 22
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 5
      Text = 'Retry'
      Items.Strings = (
        'Retry'
        'Play other map'
        'Do next task')
    end
    object Button_Cancel: TButton
      Left = 164
      Top = 125
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 6
      OnClick = Button_CancelClick
    end
    object Button_Save: TButton
      Left = 245
      Top = 125
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 7
      OnClick = Button_SaveClick
    end
    object Check_ProMode: TCheckBox
      Left = 8
      Top = 102
      Width = 137
      Height = 17
      Caption = 'Professional Mode'
      TabOrder = 8
    end
  end
end
