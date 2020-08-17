object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Rhythm#'
  ClientHeight = 329
  ClientWidth = 571
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #45208#45588#48148#47480#44256#46357
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  StyleElements = [seFont, seClient]
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    571
    329)
  PixelsPerInch = 96
  TextHeight = 14
  object Button_TabGeneral: TSpeedButton
    Left = 8
    Top = 31
    Width = 121
    Height = 33
    GroupIndex = 1
    Down = True
    Caption = #51068#48152
    Spacing = 0
    OnClick = Button_TabGeneralClick
  end
  object Button_TabHumanizer: TSpeedButton
    Left = 8
    Top = 70
    Width = 121
    Height = 33
    GroupIndex = 1
    Caption = #55092#47672#45208#51060#51200
    OnClick = Button_TabHumanizerClick
  end
  object Button_TabTasks: TSpeedButton
    Left = 8
    Top = 109
    Width = 121
    Height = 33
    GroupIndex = 1
    Caption = #51089#50629' '#54200#51665#44592
    OnClick = Button_TabTasksClick
  end
  object Button_TabScheduler: TSpeedButton
    Left = 8
    Top = 148
    Width = 121
    Height = 33
    GroupIndex = 1
    Caption = #51068#51221
    OnClick = Button_TabSchedulerClick
  end
  object Panel_Status: TPanel
    Left = 0
    Top = 0
    Width = 571
    Height = 25
    Align = alTop
    BevelEdges = [beBottom]
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = #44172#51076#51012' '#49892#54665#54644#51452#49464#50836'!'
    Color = clRed
    DoubleBuffered = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = #45208#45588#48148#47480#44256#46357
    Font.Style = []
    ParentBackground = False
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 0
    StyleElements = [seBorder]
  end
  object Page_Menus: TPageControl
    Left = 135
    Top = 31
    Width = 428
    Height = 291
    ActivePage = Tab_Humanizer
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabHeight = 25
    TabOrder = 1
    object Tab_General: TTabSheet
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        420
        281)
      object UScrollBox_General: TUScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 275
        HorzScrollBar.Tracking = True
        VertScrollBar.Range = 400
        VertScrollBar.Tracking = True
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoScroll = False
        Color = 15132390
        ParentColor = False
        TabOrder = 0
        AniSet.AniKind = akOut
        AniSet.AniFunctionKind = afkCubic
        AniSet.DelayStartTime = 0
        AniSet.Duration = 120
        AniSet.Step = 10
        CustomBackColor.Enabled = False
        CustomBackColor.Color = 15132390
        CustomBackColor.LightColor = 15132390
        CustomBackColor.DarkColor = 2039583
        object Group_Debugging: TGroupBox
          Left = 3
          Top = 347
          Width = 391
          Height = 50
          Caption = #46356#48260#44536' '#51204#50857
          Padding.Left = 5
          Padding.Top = 15
          Padding.Right = 5
          Padding.Bottom = 5
          TabOrder = 1
          DesignSize = (
            391
            50)
          object Button_ManualParse: TButton
            Left = 8
            Top = 18
            Width = 169
            Height = 25
            Anchors = [akLeft, akTop, akRight]
            Caption = #48708#53944#47605' '#49688#46041#51004#47196' '#54028#49905
            TabOrder = 0
            OnClick = Button_ManualParseClick
          end
          object Button_SuspendBot: TButton
            Left = 183
            Top = 18
            Width = 97
            Height = 25
            Caption = 'Suspend'
            TabOrder = 1
            OnClick = Button_SuspendBotClick
          end
          object Button_ResumeBot: TButton
            Left = 286
            Top = 18
            Width = 97
            Height = 25
            Caption = 'Resume'
            TabOrder = 2
            OnClick = Button_ResumeBotClick
          end
        end
        object Group_GeneralKey: TGroupBox
          Left = 3
          Top = 3
          Width = 391
          Height = 130
          Caption = #51068#48152
          Padding.Left = 5
          Padding.Top = 15
          Padding.Right = 5
          Padding.Bottom = 5
          TabOrder = 2
          DesignSize = (
            391
            130)
          object Label4: TLabel
            Left = 8
            Top = 18
            Width = 72
            Height = 14
            Caption = #53412' '#53440#51060#48141' '#48276#50948
          end
          object Label8: TLabel
            Left = 8
            Top = 38
            Width = 299
            Height = 12
            Caption = #52980#54504#53552#51032' '#49457#45733#51060' '#50504' '#51339#50500' '#45459#52824#45716' '#45432#53944#44032' '#51080#51012#44221#50864' '#49688#52824#47484' '#45720#47140#51452#49464#50836'.'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentFont = False
          end
          object Label9: TLabel
            Left = 8
            Top = 110
            Width = 233
            Height = 12
            Caption = #52404#53356#49884' '#49892#51228' '#53412#47484' '#45580#47104#51012#46412#47564' '#51088#46041#51077#47141#51060' '#51089#46041#54633#45768#45796'.'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentFont = False
          end
          object Track_KeyTiming: TTrackBar
            Left = 8
            Top = 56
            Width = 375
            Height = 25
            Anchors = [akLeft, akTop, akRight]
            Max = 35
            Position = 6
            PositionToolTip = ptBottom
            TabOrder = 0
            TickMarks = tmBoth
            TickStyle = tsNone
          end
          object Check_StreamKeyProof: TCheckBox
            Left = 8
            Top = 87
            Width = 375
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = #48169#49569#50857' '#53412' '#50724#53664
            TabOrder = 1
          end
        end
        object Group_Profile: TGroupBox
          Left = 3
          Top = 139
          Width = 391
          Height = 202
          Caption = #54532#47196#54596
          Padding.Left = 5
          Padding.Top = 15
          Padding.Right = 5
          Padding.Bottom = 5
          TabOrder = 3
          DesignSize = (
            391
            202)
          object Label10: TLabel
            Left = 8
            Top = 18
            Width = 304
            Height = 12
            BiDiMode = bdLeftToRight
            Caption = #51312#51221' '#44032#45733#54620' '#47784#46304' '#49444#51221#44050#46308#51012' '#47196#46300'/'#51200#51109' '#54624' '#49688' '#51080#49845#45768#45796'. '#50864#53364#47533' = '#47700#45684
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentBiDiMode = False
            ParentFont = False
          end
          object ListView_GlobalProfile: TListView
            Left = 8
            Top = 36
            Width = 375
            Height = 158
            Anchors = [akLeft, akTop, akRight, akBottom]
            Columns = <
              item
                AutoSize = True
                Caption = 'Profiles'
              end>
            ReadOnly = True
            RowSelect = True
            PopupMenu = PopupMenu_Profile
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
          end
        end
      end
    end
    object Tab_Humanizer: TTabSheet
      ImageIndex = 1
      TabVisible = False
      DesignSize = (
        420
        281)
      object UScrollBox_Humanizer: TUScrollBox
        Left = 3
        Top = 3
        Width = 414
        Height = 275
        HorzScrollBar.Tracking = True
        VertScrollBar.Range = 640
        VertScrollBar.Tracking = True
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoScroll = False
        Color = 15132390
        ParentColor = False
        TabOrder = 0
        AniSet.AniKind = akOut
        AniSet.AniFunctionKind = afkCubic
        AniSet.DelayStartTime = 0
        AniSet.Duration = 120
        AniSet.Step = 10
        CustomBackColor.Enabled = False
        CustomBackColor.Color = 15132390
        CustomBackColor.LightColor = 15132390
        CustomBackColor.DarkColor = 2039583
        DesignSize = (
          397
          275)
        object Group_KeySwitch: TGroupBox
          Left = 3
          Top = 383
          Width = 391
          Height = 241
          Anchors = [akLeft, akTop, akBottom]
          Caption = #53412' '#49828#50948#52824
          Padding.Left = 5
          Padding.Top = 15
          Padding.Right = 5
          Padding.Bottom = 5
          TabOrder = 1
          object Label14: TLabel
            Left = 8
            Top = 41
            Width = 332
            Height = 12
            Caption = #52404#53356#47484' '#54644#51228#54620' '#53412#45716' '#51089#46041#54616#51648' '#50506#49845#45768#45796'. EZ2'#51032' '#54168#45804#50724#53664#47484' '#49373#44033#54616#47732' '#46121#45768#45796'.'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentFont = False
          end
          object Check_KeySwitch: TCheckBox
            Left = 8
            Top = 18
            Width = 193
            Height = 17
            Caption = #54876#49457#54868
            TabOrder = 0
          end
          object ListView_KeySwitch: TListView
            AlignWithMargins = True
            Left = 7
            Top = 56
            Width = 377
            Height = 175
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Align = alBottom
            Anchors = [akLeft, akTop, akRight]
            Checkboxes = True
            Columns = <
              item
                AutoSize = True
              end>
            GridLines = True
            Items.ItemData = {
              0544010000090000000000000001000000FFFFFFFF00000000FFFFFFFF000000
              00054B0065007900200031000000000001000000FFFFFFFF00000000FFFFFFFF
              00000000054B0065007900200032000000000001000000FFFFFFFF00000000FF
              FFFFFF00000000054B0065007900200033000000000001000000FFFFFFFF0000
              0000FFFFFFFF00000000054B0065007900200034000000000001000000FFFFFF
              FF00000000FFFFFFFF00000000054B0065007900200035000000000001000000
              FFFFFFFF00000000FFFFFFFF00000000054B0065007900200036000000000001
              000000FFFFFFFF00000000FFFFFFFF00000000054B0065007900200037000000
              000001000000FFFFFFFF00000000FFFFFFFF00000000054B0065007900200038
              000000000001000000FFFFFFFF00000000FFFFFFFF00000000054B0065007900
              20003900}
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 1
            ViewStyle = vsReport
          end
        end
        object Group_kps: TGroupBox
          Left = 3
          Top = 3
          Width = 391
          Height = 374
          Anchors = [akLeft, akTop, akBottom]
          Caption = 'KPS '#44592#48152' '#55092#47672#45208#51060#51200
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #45208#45588#48148#47480#44256#46357
          Font.Style = []
          Padding.Left = 5
          Padding.Top = 15
          Padding.Right = 5
          Padding.Bottom = 5
          ParentFont = False
          TabOrder = 2
          DesignSize = (
            391
            374)
          object Label1: TLabel
            Left = 206
            Top = 158
            Width = 127
            Height = 14
            Caption = 'Cool'#48708#50984'(%) ('#51068#48152' 300)'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentFont = False
          end
          object Label5: TLabel
            Left = 8
            Top = 260
            Width = 33
            Height = 14
            Caption = #54532#47532#49483
          end
          object Label6: TLabel
            Left = 8
            Top = 41
            Width = 47
            Height = 14
            Caption = #52376#47532' '#48169#49885
          end
          object Label7: TLabel
            Left = 8
            Top = 158
            Width = 140
            Height = 14
            Caption = 'Kool'#48708#50984' (%) ('#47924#51648#44060' 300)'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentFont = False
          end
          object Label11: TLabel
            Left = 8
            Top = 61
            Width = 309
            Height = 12
            Caption = #52572#49888' : Cool~Miss'#44620#51648#51032' '#48708#50984#51060' '#51088#50672#49828#47101#49845#45768#45796' / '#50715#45216#48169#49885' : '#53580#49828#53944#50857
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentFont = False
          end
          object Label12: TLabel
            Left = 8
            Top = 280
            Width = 332
            Height = 12
            Caption = 'KPS '#44592#48152' '#55092#47672#45208#51060#51200#51032' '#49444#51221#44050#51012' '#44036#45800#54616#44172' '#48520#47084#50741#45768#45796'. '#44060#51064#51060' '#52628#44032' '#48520#44032#45733'.'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentFont = False
          end
          object Label13: TLabel
            Left = 8
            Top = 349
            Width = 341
            Height = 12
            Caption = 'Level10'#51004#47196#46020' '#52376#47532' '#50504#46104#45716#44257#51012' '#52376#47532' '#54624' '#49688' '#51080#49845#45768#45796'. '#47021#53433' 3'#51088#47532#45824' '#51060#49345' '#51204#50857'.'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentFont = False
          end
          object Label17: TLabel
            Left = 8
            Top = 209
            Width = 64
            Height = 14
            Caption = '200'#48708#50984'(%)'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentFont = False
          end
          object Label18: TLabel
            Left = 137
            Top = 209
            Width = 64
            Height = 14
            Caption = '100'#48708#50984'(%)'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentFont = False
          end
          object Label19: TLabel
            Left = 272
            Top = 208
            Width = 65
            Height = 14
            Caption = #48120#49828#48708#50984'(%)'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = #45208#45588#48148#47480#44256#46357
            Font.Style = []
            ParentFont = False
          end
          object Label20: TLabel
            Left = 8
            Top = 107
            Width = 81
            Height = 14
            Caption = 'Kool+Cool KPS'
          end
          object Track_Ratio_Cool: TTrackBar
            Left = 206
            Top = 178
            Width = 177
            Height = 25
            Anchors = [akLeft, akTop, akRight]
            Max = 100
            Position = 35
            PositionToolTip = ptBottom
            TabOrder = 0
            TickMarks = tmBoth
            TickStyle = tsNone
            OnChange = Track_Ratio_CoolChange
          end
          object Check_Humanizer: TCheckBox
            Left = 8
            Top = 18
            Width = 375
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = #54876#49457#54868
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object Combo_Preset: TComboBox
            Left = 8
            Top = 298
            Width = 375
            Height = 22
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            ItemIndex = 5
            TabOrder = 2
            Text = 'Level 5'
            OnChange = Combo_PresetChange
            Items.Strings = (
              'Level 10'
              'Level 9'
              'Level 8'
              'Level 7'
              'Level 6'
              'Level 5'
              'Level 4'
              'Level 3'
              'Level 2'
              'Level 1')
          end
          object Check_ProMode: TCheckBox
            Left = 8
            Top = 326
            Width = 375
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = #54532#47196#47784#46300' (x0.75 KPS)'
            TabOrder = 3
          end
          object Combo_HumanizerMethod: TComboBox
            Left = 8
            Top = 79
            Width = 375
            Height = 22
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            Enabled = False
            ItemIndex = 0
            TabOrder = 4
            Text = #52572#49888' (300->200->100->Miss->50 '#49692#51004#47196')'
            Items.Strings = (
              #52572#49888' (300->200->100->Miss->50 '#49692#51004#47196')'
              #50715#45216#48169#49885' (300/100/Bad '#44033#44033' '#51312#51208')')
          end
          object Track_Ratio_Kool: TTrackBar
            Left = 8
            Top = 178
            Width = 177
            Height = 25
            Max = 100
            Position = 65
            PositionToolTip = ptBottom
            TabOrder = 5
            TickMarks = tmBoth
            TickStyle = tsNone
            OnChange = Track_Ratio_KoolChange
          end
          object Track_Ratio_200: TTrackBar
            Left = 8
            Top = 229
            Width = 113
            Height = 25
            Max = 100
            Position = 88
            PositionToolTip = ptBottom
            TabOrder = 6
            TickMarks = tmBoth
            TickStyle = tsNone
            OnChange = Track_Ratio_200Change
          end
          object Track_Ratio_100: TTrackBar
            Left = 137
            Top = 229
            Width = 113
            Height = 25
            Max = 100
            Position = 7
            PositionToolTip = ptBottom
            TabOrder = 7
            TickMarks = tmBoth
            TickStyle = tsNone
            OnChange = Track_Ratio_100Change
          end
          object Track_Ratio_Miss: TTrackBar
            Left = 270
            Top = 228
            Width = 113
            Height = 25
            Max = 100
            Position = 5
            PositionToolTip = ptBottom
            TabOrder = 8
            TickMarks = tmBoth
            TickStyle = tsNone
            OnChange = Track_Ratio_MissChange
          end
          object Track_Acc_300: TTrackBar
            Left = 8
            Top = 127
            Width = 375
            Height = 25
            Max = 300
            Position = 5
            PositionToolTip = ptBottom
            TabOrder = 9
            TickMarks = tmBoth
            TickStyle = tsNone
          end
        end
      end
    end
    object Tab_Tasks: TTabSheet
      ImageIndex = 3
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        420
        281)
      object Group_Tasks: TGroupBox
        Left = 3
        Top = 3
        Width = 414
        Height = 275
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = #51089#50629
        Padding.Left = 5
        Padding.Top = 15
        Padding.Right = 5
        Padding.Bottom = 5
        TabOrder = 0
        DesignSize = (
          414
          275)
        object Label15: TLabel
          Left = 8
          Top = 41
          Width = 293
          Height = 12
          Caption = #54876#49457#54868#49884' '#44257#49440#53469#48512#53552' '#44172#51076#44620#51648' '#51088#46041#51004#47196' '#51652#54665#46121#45768#45796'. '#50864#53364#47533' = '#47700#45684
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #45208#45588#48148#47480#44256#46357
          Font.Style = []
          ParentFont = False
        end
        object Check_Tasks: TCheckBox
          Left = 8
          Top = 18
          Width = 398
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = #51089#50629' '#54876#49457#54868' ('#45800#52629#53412' - PgUp:'#49884#51089' / PgDn:'#51333#47308')'
          TabOrder = 0
        end
        object ListView_Tasks: TListView
          Left = 8
          Top = 59
          Width = 398
          Height = 208
          Anchors = [akLeft, akTop, akRight]
          Columns = <
            item
              Caption = #54596#53552
              Width = 120
            end
            item
              Caption = #52572#49548
              Width = 60
            end
            item
              Caption = #52572#45824
              Width = 60
            end
            item
              Caption = #54532#47196#54596
              Width = 80
            end
            item
              Caption = #51453#51012#44221#50864
              Width = 85
            end
            item
              Caption = #54532#47196#47784#46300
              Width = 65
            end>
          ColumnClick = False
          ReadOnly = True
          RowSelect = True
          PopupMenu = PopupMenu_TaskEditor
          TabOrder = 1
          ViewStyle = vsReport
        end
      end
    end
    object Tab_Scheduler: TTabSheet
      ImageIndex = 2
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        420
        281)
      object Group_Scheduler: TGroupBox
        Left = 3
        Top = 3
        Width = 414
        Height = 275
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = #51068#51221
        Padding.Left = 5
        Padding.Top = 15
        Padding.Right = 5
        Padding.Bottom = 5
        TabOrder = 0
        DesignSize = (
          414
          275)
        object Label16: TLabel
          Left = 8
          Top = 41
          Width = 292
          Height = 12
          Caption = #51068#51221#50640' '#47582#44172' '#48391#51060' '#51060#48292#53944#47484' '#49892#54665#54633#45768#45796'. '#51452#47196' '#51089#50629#44284' '#44057#51060' '#50416#51077#45768#45796'.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = #45208#45588#48148#47480#44256#46357
          Font.Style = []
          ParentFont = False
        end
        object ListView_Schedules: TListView
          Left = 8
          Top = 59
          Width = 398
          Height = 208
          Anchors = [akLeft, akTop, akRight]
          Columns = <
            item
              Caption = #49884#44036
              Width = 80
            end
            item
              Caption = #51060#48292#53944
              Width = 280
            end>
          ReadOnly = True
          RowSelect = True
          PopupMenu = PopupMenu_ScheduleEditor
          TabOrder = 0
          ViewStyle = vsReport
        end
        object Check_Scheduler: TCheckBox
          Left = 8
          Top = 18
          Width = 398
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = #51068#51221' '#54876#49457#54868
          TabOrder = 1
        end
      end
    end
  end
  object Combo_Language: TComboBox
    Left = 8
    Top = 299
    Width = 121
    Height = 22
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 2
    Text = #54620#44397#50612'(Korean)'
    OnChange = Combo_LanguageChange
    Items.Strings = (
      #54620#44397#50612'(Korean)'
      #50689#50612'(English)')
  end
  object Timer_Hotkey: TTimer
    Interval = 50
    OnTimer = Timer_HotkeyTimer
    Left = 88
    Top = 65520
  end
  object PopupMenu_TaskEditor: TPopupMenu
    OnPopup = PopupMenu_TaskEditorPopup
    Left = 24
    Top = 65520
    object AddNew: TMenuItem
      Caption = #49352' '#51089#50629' '#52628#44032
      OnClick = AddNewClick
    end
    object EditItem: TMenuItem
      Caption = #49688#51221
      OnClick = EditItemClick
    end
    object DeleteItem: TMenuItem
      Caption = #49325#51228
      OnClick = DeleteItemClick
    end
  end
  object PopupMenu_ScheduleEditor: TPopupMenu
    OnPopup = PopupMenu_ScheduleEditorPopup
    Left = 56
    Top = 65520
    object AddNew_S: TMenuItem
      Caption = #49352' '#51068#51221' '#52628#44032
      OnClick = AddNew_SClick
    end
    object EditItem_S: TMenuItem
      Caption = #49688#51221
      OnClick = EditItem_SClick
    end
    object DeleteItem_S: TMenuItem
      Caption = #49325#51228
      OnClick = DeleteItem_SClick
    end
  end
  object PopupMenu_Profile: TPopupMenu
    OnPopup = PopupMenu_ProfilePopup
    Left = 120
    Top = 65520
    object ReloadProfileList: TMenuItem
      Caption = #49352#47196#44256#52840
      OnClick = ReloadProfileListClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object LoadProfile: TMenuItem
      Caption = #48520#47084#50724#44592
      OnClick = LoadProfileClick
    end
    object SaveProfileOverwrite: TMenuItem
      Caption = #51200#51109'('#45934#50612#50416#44592')'
      OnClick = SaveProfileOverwriteClick
    end
    object SaveProfileNew: TMenuItem
      Caption = #51200#51109'('#49888#44508')'
      OnClick = SaveProfileNewClick
    end
    object DeleteProfile: TMenuItem
      Caption = #49325#51228
      OnClick = DeleteProfileClick
    end
  end
end
