object frmScheduleEditor: TfrmScheduleEditor
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Add/Edit Schedule'
  ClientHeight = 105
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = [seFont, seClient]
  OnShow = FormShow
  DesignSize = (
    282
    105)
  PixelsPerInch = 96
  TextHeight = 14
  object Group_ScheduleEditor: TGroupBox
    Left = 8
    Top = 8
    Width = 266
    Height = 89
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Schedule'
    Padding.Left = 5
    Padding.Top = 15
    Padding.Right = 5
    Padding.Bottom = 5
    TabOrder = 0
    DesignSize = (
      266
      89)
    object Label1: TLabel
      Left = 8
      Top = 21
      Width = 27
      Height = 14
      Caption = 'Time'
    end
    object Label3: TLabel
      Left = 105
      Top = 21
      Width = 32
      Height = 14
      Caption = 'Event'
    end
    object Combo_Event: TComboBox
      Left = 143
      Top = 18
      Width = 115
      Height = 22
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemIndex = 0
      TabOrder = 0
      TabStop = False
      Text = 'Suspend Bot'
      Items.Strings = (
        'Suspend Bot'
        'Resume Bot')
    end
    object Button_Cancel: TButton
      Left = 102
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      TabStop = False
      OnClick = Button_CancelClick
    end
    object Button_Save: TButton
      Left = 183
      Top = 56
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 2
      TabStop = False
      OnClick = Button_SaveClick
    end
    object TimePicker1: TTimePicker
      Left = 41
      Top = 18
      Width = 58
      Height = 21
      DropDownCount = 10
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      StyleElements = [seFont, seClient]
      TabOrder = 3
      TabStop = False
      Time = 0.750000000000000000
      TimeFormat = 'hh:mm'
    end
  end
end
