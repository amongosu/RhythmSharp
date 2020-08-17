unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DSiWin32, RoKo_Lib, System.Diagnostics, System.TimeSpan,
  Vcl.ExtCtrls, System.Generics.Collections, Generics.Defaults, System.Math, System.StrUtils, Offset, TaskEditor, ScheduleEditor,
  Vcl.ComCtrls, Vcl.Menus, IniFiles, Types, Misc, System.ImageList, Vcl.ImgList,
  Vcl.Buttons, Vcl.Grids, Vcl.ValEdit, UCL.ScrollBox;

{ Global Functions }
procedure ParseBeatmapFromMemory();
function GetOsuData(): Boolean;
procedure UpdateChangedPreset();
function GetKeycode(key: Cardinal; fake: Boolean = false): Byte;
function GetKeycodeFromMemory(key: Cardinal; fake: Boolean = false): Byte;

type
  HitObjectData = record
    Key: Cardinal;
    NoteType: Integer;
    Timing: Cardinal;
  end;

  BeatmapData = record
    Path0: string;
    Path1: string;
    Path2: string;
    FullPath: string;
    CircleSize: Single;
    HitObjects: TList<HitObjectData>;
  end;

  UpdateThread = class(TThread)
  protected
    procedure Execute; override;
  public
    Mode: Cardinal;
  end;

  KeyThread = class(TThread)
  protected
    procedure Execute; override;
  public
    HitObjects: TList<HitObjectData>;
    Key: Integer;
  end;

  MainThread = class(TThread)
  protected
    procedure Execute; override;
  private
    LastOffset: Cardinal;
  end;

  ScheduleThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TaskThread = class(TThread)
  protected
    procedure Execute; override;
  private
    TmpString: String;
  end;

  TfrmMain = class(TForm)
    Panel_Status: TPanel;
    Button_ManualParse: TButton;
    Page_Menus: TPageControl;
    Tab_Humanizer: TTabSheet;
    Label1: TLabel;
    Track_Ratio_Cool: TTrackBar;
    Label4: TLabel;
    Track_KeyTiming: TTrackBar;
    Check_Humanizer: TCheckBox;
    Combo_Preset: TComboBox;
    Timer_Hotkey: TTimer;
    Check_StreamKeyProof: TCheckBox;
    Tab_Tasks: TTabSheet;
    Check_Tasks: TCheckBox;
    ListView_Tasks: TListView;
    Label5: TLabel;
    Group_kps: TGroupBox;
    Group_KeySwitch: TGroupBox;
    Tab_General: TTabSheet;
    Group_GeneralKey: TGroupBox;
    Group_Debugging: TGroupBox;
    Check_KeySwitch: TCheckBox;
    ListView_KeySwitch: TListView;
    Group_Tasks: TGroupBox;
    PopupMenu_TaskEditor: TPopupMenu;
    AddNew: TMenuItem;
    DeleteItem: TMenuItem;
    EditItem: TMenuItem;
    Tab_Scheduler: TTabSheet;
    Group_Scheduler: TGroupBox;
    ListView_Schedules: TListView;
    Check_Scheduler: TCheckBox;
    PopupMenu_ScheduleEditor: TPopupMenu;
    AddNew_S: TMenuItem;
    EditItem_S: TMenuItem;
    DeleteItem_S: TMenuItem;
    Button_SuspendBot: TButton;
    Button_ResumeBot: TButton;
    Group_Profile: TGroupBox;
    PopupMenu_Profile: TPopupMenu;
    LoadProfile: TMenuItem;
    SaveProfileOverwrite: TMenuItem;
    SaveProfileNew: TMenuItem;
    ReloadProfileList: TMenuItem;
    ListView_GlobalProfile: TListView;
    DeleteProfile: TMenuItem;
    N1: TMenuItem;
    Check_ProMode: TCheckBox;
    Button_TabGeneral: TSpeedButton;
    Button_TabHumanizer: TSpeedButton;
    Button_TabTasks: TSpeedButton;
    Button_TabScheduler: TSpeedButton;
    UScrollBox_General: TUScrollBox;
    UScrollBox_Humanizer: TUScrollBox;
    Combo_HumanizerMethod: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    Track_Ratio_Kool: TTrackBar;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Track_Ratio_200: TTrackBar;
    Label18: TLabel;
    Label19: TLabel;
    Track_Ratio_100: TTrackBar;
    Track_Ratio_Miss: TTrackBar;
    Label20: TLabel;
    Track_Acc_300: TTrackBar;
    Combo_Language: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button_ManualParseClick(Sender: TObject);
    procedure Track_Ratio_CoolChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Combo_PresetChange(Sender: TObject);
    procedure Timer_HotkeyTimer(Sender: TObject);
    procedure PopupMenu_TaskEditorPopup(Sender: TObject);
    procedure AddNewClick(Sender: TObject);
    procedure EditItemClick(Sender: TObject);
    procedure DeleteItemClick(Sender: TObject);
    procedure PopupMenu_ScheduleEditorPopup(Sender: TObject);
    procedure AddNew_SClick(Sender: TObject);
    procedure EditItem_SClick(Sender: TObject);
    procedure DeleteItem_SClick(Sender: TObject);
    procedure Button_SuspendBotClick(Sender: TObject);
    procedure Button_ResumeBotClick(Sender: TObject);
    procedure PopupMenu_ProfilePopup(Sender: TObject);
    procedure SaveProfileNewClick(Sender: TObject);
    procedure ReloadProfileListClick(Sender: TObject);
    procedure LoadProfileClick(Sender: TObject);
    procedure DeleteProfileClick(Sender: TObject);
    procedure SaveProfileOverwriteClick(Sender: TObject);
    procedure Button_TabGeneralClick(Sender: TObject);
    procedure Button_TabHumanizerClick(Sender: TObject);
    procedure Button_TabTasksClick(Sender: TObject);
    procedure Button_TabSchedulerClick(Sender: TObject);
    procedure Track_Ratio_KoolChange(Sender: TObject);
    procedure Track_Ratio_200Change(Sender: TObject);
    procedure Track_Ratio_100Change(Sender: TObject);
    procedure Track_Ratio_MissChange(Sender: TObject);
    procedure Combo_LanguageChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  CurrentStatus_Base, CurrentOffset_Base, InGameData_Base, RulesetInfo_Base, KeyInfo_Base: Cardinal;
  CurrentStatus, CurrentOffset: Cardinal;
  LastStatus: Cardinal;
  bData: BeatmapData;
  OffsetThread, StatusThread: UpdateThread;
  TMainThread: MainThread;
  TTaskThread: TaskThread;
  TScheduleThread: ScheduleThread;
  KeyManager: TList<KeyThread>;
  bFirstLoad: Boolean = True;
  bTasksToggle: Boolean = False;
  DD_str: function (str: AnsiString): Integer; stdcall;
  AimedPlayCount: Integer = 1;
  CurrentPlayCount: Integer = 0;
  CurrentTaskIndex: Integer = 0;
  CurrentHP: Integer = 200;
  PrevTimeOffset: Cardinal;
  bBotSuspended: Boolean = False;

implementation

procedure Profile_Save(FileName: string);
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.Exename) + 'Profiles\' + FileName + '.cfg');
  try
    { General }
    ini.WriteInteger('General', 'KeyTiming', frmMain.Track_KeyTiming.Position);
    ini.WriteBool('General', 'StreamKeyProof', frmMain.Check_StreamKeyProof.Checked);

    { Humanizer }
    ini.WriteBool('Humanizer', 'Humanizer', frmMain.Check_Humanizer.Checked);
    ini.WriteInteger('Humanizer', 'Preset', frmMain.Combo_Preset.ItemIndex);
    ini.WriteBool('Humanizer', 'ProMode', frmMain.Check_ProMode.Checked);

    { Tasks }
    ini.WriteBool('Tasks', 'Tasks', frmMain.Check_Tasks.Checked);
    ini.WriteString('Tasks', 'TasksList', ListViewSaveToString(frmMain.ListView_Tasks));

    { Scheduler }
    ini.WriteBool('Scheduler', 'Scheduler', frmMain.Check_Scheduler.Checked);
    ini.WriteString('Scheduler', 'SchedulerList', ListViewSaveToString(frmMain.ListView_Schedules));

  finally
    ini.Free;
  end;
end;

procedure Profile_Load(FileName: string);
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.Exename) + 'Profiles\' + FileName + '.cfg');
  try
    { General }
    frmMain.Track_KeyTiming.Position := ini.ReadInteger('General', 'KeyTiming', 5);
    frmMain.Check_StreamKeyProof.Checked := ini.ReadBool('General', 'StreamKeyProof', False);

    { Humanizer }
    frmMain.Check_Humanizer.Checked := ini.ReadBool('Humanizer', 'Humanizer', True);
    frmMain.Combo_Preset.ItemIndex := ini.ReadInteger('Humanizer', 'Preset', 5);
    frmMain.Check_ProMode.Checked := ini.ReadBool('Humanizer', 'ProMode', False);

    { Tasks }
    frmMain.Check_Tasks.Checked := ini.ReadBool('Tasks', 'Tasks', False);
    ListViewLoadFromString(frmMain.ListView_Tasks, ini.ReadString('Tasks', 'TasksList', ''));

    { Scheduler }
    frmMain.Check_Scheduler.Checked := ini.ReadBool('Scheduler', 'Scheduler', False);
    ListViewLoadFromString(frmMain.ListView_Schedules, ini.ReadString('Scheduler', 'SchedulerList', ''));

    UpdateChangedPreset();
  finally
    ini.Free;
  end;
end;

procedure LoadProfileList;
Var
  Path    : String;
  SR      : TSearchRec;
  DirList : TStrings;
  i: Integer;
begin
  Path := ExtractFilePath(Application.Exename) + 'Profiles\'; //Get the path of the selected file
  DirList := TStringList.Create;
  try
    if FindFirst(Path + '*.cfg', faArchive, SR) = 0 then
    begin
      repeat
        DirList.Add(Copy(SR.Name,  0, Pos('.cfg', SR.Name) - 1)); //Fill the list
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;

    frmMain.ListView_GlobalProfile.Clear;

    for i := 0 to DirList.Count - 1 do
    begin
      frmMain.ListView_GlobalProfile.Items.Add.Caption := DirList[i];
    end;

  finally
   DirList.Free;
  end;
end;

function LoadDD(): Boolean;
var
  hDll: THandle;
begin
  hDll := LoadLibrary('DD94687.32.dll');

  if (Integer(hDll) = 0) or (Integer(hDll) = -1) then
  begin
    Result := False;
    Exit;
  end;

  @DD_str := GetProcAddress(hDll, 'DD_str');
  Result := True;
end;

function GetKeycodeFromMemory_Init(): Boolean;
var
  i: Integer;
begin
  try
    SetLength(arr_keycodes, round(bData.CircleSize));
    for i := 0 to round(bData.CircleSize) - 1 do
    begin
      arr_keycodes[i] := GetKeycodeFromMemory(i);
      if (arr_keycodes[i] = 0) then arr_keycodes[i] := GetKeycode(i);
      //OutputDebugString(PChar(i.ToString() + ' : ' + IntToStr(arr_keycodes[i])));
    end;

    Result := True;
  except
    Result := False;
  end;
end;

function GetKeycodeFromMemory(key: Cardinal; fake: Boolean = false): Byte;
var
  nK: Cardinal;
  Temp: Cardinal;
begin
  try
    nk := ReadMemoryInt(ReadMemoryInt(ReadMemoryInt(KeyInfo_Base)) + KeyManager_Base_Ptr + round(bData.CircleSize) * KeyManager_Base_KeyTable_Size);
    Temp := ReadMemoryInt(nK + KeyManager_Base_KeyTable_Binding_Ptr_1);
    Temp := ReadMemoryInt(Temp + KeyManager_Base_KeyTable_Binding_Ptr_2);
    Temp := ReadMemoryInt(Temp + KeyManager_Base_KeyTable_Binding_Ptr_3);
    Temp := ReadMemoryInt(Temp + KeyManager_Base_KeyTable_Binding_Ptr_4);
    Result := ReadMemoryInt(Temp + KeyManager_Base_KeyTable_Binding_Keys + KeyManager_Base_KeyTable_Binding_KeyCode_Size * key);
  except
    Result := 0;
  end;

end;

function GetKeycode(key: Cardinal; fake: Boolean = false): Byte;
begin
  if (fake) then
  begin
    case round(bData.CircleSize) of
      4:
        Result := arr_4k_fake[key];
      5:
        Result := arr_5k[key];
      6:
        Result := arr_6k[key];
      7:
        Result := arr_7k_fake[key];
      8:
        Result := arr_8k[key];
      9:
        Result := arr_9k[key];
    end;
  end
  else
  begin
    case round(bData.CircleSize) of
      1:
        Result := byte_1k;
      4:
        Result := arr_4k[key];
      5:
        Result := arr_5k[key];
      6:
        Result := arr_6k[key];
      7:
        Result := arr_7k[key];
      8:
        Result := arr_8k[key];
      9:
        Result := arr_9k[key];
    end;
  end;
end;

function KeyPressShort(keycode: Cardinal): Boolean;
begin
  keybd_event(keycode, MapVirtualKey(keycode, 0), 0, 0);
  Sleep(20 + RandomRange(-10, 15));
  keybd_event(keycode, MapVirtualKey(keycode, 0), KEYEVENTF_KEYUP, 0);
end;

function KeyPressLong(keycode: Cardinal): Boolean;
begin
  keybd_event(keycode, MapVirtualKey(keycode, 0), 0, 0);
  Sleep(1000 + RandomRange(-100, 100));
  keybd_event(keycode, MapVirtualKey(keycode, 0), KEYEVENTF_KEYUP, 0);
end;

function KeyInput(key: Cardinal; event: Cardinal): Boolean;
var
  keycode: Integer;
begin
  keycode := arr_keycodes[key];

  case event of
    0:
    begin
      keybd_event(keycode, MapVirtualKey(keycode, 0), 0, 0);
      if (frmMain.Check_Humanizer.Checked) then
        Sleep(40 + RandomRange(-10, 45))
      else
        Sleep(15);
      keybd_event(keycode, MapVirtualKey(keycode, 0), KEYEVENTF_KEYUP, 0);
    end;

    1:
    begin
      keybd_event(keycode, MapVirtualKey(keycode, 0), 0, 0);
    end;

    2:
    begin
      keybd_event(keycode, MapVirtualKey(keycode, 0), KEYEVENTF_KEYUP, 0);
    end;
  end;

  Result := True;
end;

function GetHumanizeValue(kps: Integer; Mode: Integer): Integer;
var
  tmp: Integer;
begin
  if (Mode = 0) then
  begin
    if kps < frmMain.Track_Acc_300.Position then
    begin
      if (RandomRange(1, 100) < frmMain.Track_Ratio_Kool.Position) then
      begin
        if (RandomRange(1, 100) > 10) then //10%
          Result := RandomRange(-14, 15) + RandomRange(-4, 5) //Kool ~ 16.5
        else
          Result := Floor(RandomRange(-38, 39) * (kps / frmMain.Track_Acc_300.Position)); //Cool ~ 38.5
      end
      else
      begin
        if (RandomRange(1, 100) > 5) then //5%
          Result := RandomRange(-33, 34) + RandomRange(-10, 11) //Cool ~ 38.5
        else
          Result := RandomRange(-55, 56) + RandomRange(-5 - Floor(1.7 * kps), 6 + Floor(1.7 * kps)); //200~
      end;
      Exit;
    end
    else
    begin
      tmp := RandomRange(1, 100);
      if (tmp <= frmMain.Track_Ratio_200.Position) then
      begin
        Result := Floor(RandomRange(-38, 38) * (kps / frmMain.Track_Acc_300.Position)); //200 38.5 ~ 71.5ms
        if Abs(Result) > 72 then
          Result := (RandomRange(50, 80) * IfThen(RandomRange(0, 2) = 1, -1, 1));
      end
      else if (tmp > frmMain.Track_Ratio_200.Position) and
              (tmp <= (frmMain.Track_Ratio_200.Position + frmMain.Track_Ratio_100.Position)) then
      begin
        Result := (RandomRange(70, 86) * IfThen(RandomRange(0, 2) = 1, -1, 1)) + RandomRange(-25, 26) //100 71.5 ~ 101.5ms
      end
      else
      begin
        if RandomRange(1, 100) < 40 then
        begin
          Result := (RandomRange(101, 126) * IfThen(RandomRange(0, 2) = 1, -1, 1)) + RandomRange(-12, 13) //50 101.5 ~ 125.5ms
        end
        else
          Result := (RandomRange(125, 141) * IfThen(RandomRange(0, 2) = 1, -1, 1)) + RandomRange(-12, 13); //Miss
      end;
    end;
  end;
end;

procedure UpdateThread.Execute;
var
  TempAdr: Cardinal;
begin
  inherited;

  while not Terminated do
  begin
    Sleep(1);

    if (bBotSuspended) then continue;

    try
      if (Mode = 0) then
      begin
        Sleep(100);
        if (DSiGetProcessID('osu!.exe') <> 0) and (CurrentStatus_Base <> 0) and (CurrentOffset_Base <> 0) then
        begin
          CurrentStatus := ReadMemoryInt(ReadMemoryInt(CurrentStatus_Base));
          CurrentHP := Floor(GetCurrentHP(RulesetInfo_Base));
        end
        else
        begin
          CurrentStatus_Base := 0;
          CurrentOffset_Base := 0;
          InGameData_Base := 0;
          RulesetInfo_Base := 0;

          if (GetHandle()) then
          begin
            if not (GetOsuData()) then
            begin
              //error - osu not initiated or offset cahgned
            end;
          end;
        end;
      end;

      if (Mode = 1) then
      begin
        if (hProcess_osu <> 0) and (CurrentStatus_Base <> 0) and (CurrentOffset_Base <> 0) then
        begin
          CurrentOffset := ReadMemoryInt(ReadMemoryInt(CurrentOffset_Base));
        end;
      end;

      //Visual Sync w/ MainForm
      Synchronize(
      procedure()
      begin
        if (Mode = 0) then
        begin
          if (DSiGetProcessID('osu!.exe') = 0) then
          begin
            frmMain.Panel_Status.Color := clRed;
            frmMain.Panel_Status.Font.Color := clWhite;
            if (frmMain.Combo_Language.ItemIndex = 0) then
              frmMain.Panel_Status.Caption := '게임을 실행해주세요!'
            else if (frmMain.Combo_Language.ItemIndex = 1) then
              frmMain.Panel_Status.Caption := 'Please run the game!';
            Exit;
          end;

          frmMain.Panel_Status.Caption := 'Status: ' + GetStatusString(CurrentStatus) +
                                          ' / Time: ' + CurrentOffset.ToString() +
                                          ' / Tasks: ' + BoolToStr(bTasksToggle, True) +
                                          ' / HP: ' + CurrentHP.ToString();

          if (CurrentStatus <> 2) then
          begin
            frmMain.Panel_Status.Color := clBlack;
            frmMain.Panel_Status.Font.Color := clWhite;
            Exit;
          end
          else
          begin
            frmMain.Panel_Status.Color := clBlue;
            frmMain.Panel_Status.Font.Color := clWhite;
            Exit;
          end;
        end;
      end);
    except

    end;
  end;
end;

procedure KeyThread.Execute;
var
  cur_i: Integer; //this thread is processing HitObjects[cur_i]
  lastPressed: Integer;
begin
  inherited;
  cur_i := 0;
  while not Terminated do
  begin
    Sleep(1);

    if (frmMain.Check_KeySwitch.Checked) then
    begin
      if (frmMain.ListView_KeySwitch.Items[Key].Checked <> True) then
      begin
        continue;
      end;
    end;

    try
      //pass useless hitpoints
      if (CurrentOffset < $7FFFFFFF) and (CurrentOffset > 120) and (CurrentStatus = 2) then
      begin
        if (HitObjects[cur_i].Timing < (CurrentOffset - 120)) and ((cur_i <> 0) or (HitObjects[0].Timing < CurrentOffset)) then
        begin
          if HitObjects[cur_i].Timing < (CurrentOffset - 120) then
          begin
            KeyInput(HitObjects[cur_i].Key, HitObjects[cur_i].NoteType);
          end;
          cur_i := cur_i + 1;
          continue;
        end;
      end;

      //main loop
      if (cur_i >= HitObjects.Count) then //if finish playing game
      begin
        Exit;
      end;

      if (CurrentStatus <> 2) then //if not playing game
      begin
        Exit;
      end;

      if (frmMain.Check_StreamKeyProof.Checked) then
      begin
        if (GetKeyState(GetKeycode(HitObjects[cur_i].Key, true)) And $80) <> 0 then
        begin
          lastPressed := GetTickCount;
        end;

        if HitObjects[cur_i].NoteType = 2 then
        begin
          if (lastPressed + 100) < GetTickCount then
          KeyInput(HitObjects[cur_i].Key, 2);
        end;

        if (lastPressed + 150) < GetTickCount then
        begin
          continue;
        end;
      end;

      if (Abs(HitObjects[cur_i].Timing - CurrentOffset) <= frmMain.Track_KeyTiming.Position) then
      begin
        KeyInput(HitObjects[cur_i].Key, HitObjects[cur_i].NoteType);
        cur_i := cur_i + 1;
        //lastPressed := 0;
      end
      else if (frmMain.Check_StreamKeyProof.Checked) and ((lastPressed + 150) > GetTickCount) and (Abs(HitObjects[cur_i].Timing - CurrentOffset) >= 450) and (HitObjects[cur_i].NoteType <> 2) then
      begin
        KeyInput(HitObjects[cur_i].Key, 0);
        //lastPressed := 0;
      end;
    except

    end;
  end;

  KeyInput(Key, 2);
end;

procedure MainThread.Execute;
var
  i: Integer;
begin
  inherited;

  OffsetThread := UpdateThread.Create(true);
  OffsetThread.SetFreeOnTerminate(true);
  OffsetThread.Mode := 1;
  OffsetThread.Resume;

  StatusThread := UpdateThread.Create(true);
  StatusThread.SetFreeOnTerminate(true);
  StatusThread.Mode := 0;
  StatusThread.Resume;

  TTaskThread := TaskThread.Create(true);
  TTaskThread.SetFreeOnTerminate(true);
  TTaskThread.Resume;

  TScheduleThread := ScheduleThread.Create(true);
  TScheduleThread.SetFreeOnTerminate(true);
  TScheduleThread.Resume;

  LastStatus := 0;

  while not Terminated do
  begin
    Sleep(400);

    if (bBotSuspended) then continue;
    
    try
      if (CurrentStatus <> 2) then
      begin
        LastStatus := CurrentStatus;
      end;

      if (CurrentStatus = 2) and (LastStatus <> 2) then
      begin
        Sleep(1000);
        ParseBeatmapFromMemory();
        LastStatus := 2;
        LastOffset := CurrentOffset;
      end;

      if (CurrentStatus = 2) and (LastStatus = 2) then
      begin
        //when game is reset
        if Integer(LastOffset) > Integer(CurrentOffset) then
        begin
          {Synchronize(
          procedure()
          begin
            OutputDebugString(PChar('Reset Detected!'));
          end);}

          for i := 0 to KeyManager.Count - 1 do
          begin
            KeyManager[i].DoTerminate;
            KeyManager[i].Terminate;
          end;

          ParseBeatmapFromMemory();
        end;
        LastOffset := CurrentOffset;
      end;
    except
      
    end; 
  end;
end;

procedure ScheduleThread.Execute;
var
  i: Integer;
  Item: TListItem;
  FmtStngs: TFormatSettings;
begin
  inherited;

  FmtStngs.LongTimeFormat := 'hh:mm';
  FmtStngs.TimeSeparator := ':';

  while not Terminated do
  begin
    Sleep(10000);

    try
      if (frmMain.Check_Scheduler.Checked) and (frmMain.ListView_Schedules.Items.Count <> 0) then
      begin
        for i := 0 to frmMain.ListView_Schedules.Items.Count - 1 do
        begin
          Item := frmMain.ListView_Schedules.Items[i];

          //Duplicate check enable
          if (Item.Checked = False) and (Item.Caption = TimeToStr(Now, FmtStngs)) then
          begin
            Misc.DoEvent(Item.SubItems[0]);
            Item.Checked := True;
          end;

          //Duplicate check disable
          if (Item.Checked) and (Item.Caption <> TimeToStr(Now, FmtStngs)) then
          begin
            Item.Checked := False;
          end;
        end;
      end;
    except

    end;
  end;
end;

procedure TaskThread.Execute;
begin
  inherited;

  while not Terminated do
  begin
    Sleep(1000);

    if (bBotSuspended) and (CurrentStatus <> 2) then continue;

    try
      if (bTasksToggle) then
      begin
        if (CurrentPlayCount >= AimedPlayCount) then
        begin
          CurrentTaskIndex := CurrentTaskIndex + 1;

          if (CurrentTaskIndex > frmMain.ListView_Tasks.Items.Count - 1) then
          begin
            CurrentTaskIndex := 0;
          end;

          AimedPlayCount := RandomRange(StrToInt(frmMain.ListView_Tasks.Items[CurrentTaskIndex].SubItems[0]), StrToInt(frmMain.ListView_Tasks.Items[CurrentTaskIndex].SubItems[1]));
          CurrentPlayCount := 0;
        end;

        if (CurrentStatus = 2) then //Playing
        begin
          if ((PrevTimeOffset = CurrentOffset) and
              (CurrentOffset > 10) and
              (CurrentOffset < $7FFFFFFF) and
              (CurrentHP < 140)) then //game over
          begin
            TmpString := frmMain.ListView_Tasks.Items[CurrentTaskIndex].SubItems[3];
            if (TmpString = 'Retry') then
            begin
              KeyPressLong($C0); //` key
            end
            else if (TmpString = 'Play other map') then
            begin
              KeyPressShort($1B); //ESC key
              Sleep(2000);
            end
            else if (TmpString = 'Do next task') then
            begin
              KeyPressShort($1B); //ESC key
              Sleep(2000);
              CurrentPlayCount := 9999999;
            end;

            CurrentPlayCount := CurrentPlayCount + 1;
          end;
          PrevTimeOffset := CurrentOffset;
        end;

        if (CurrentStatus = 5) then //SelectPlay
        begin
          Sleep(3000); //선택화면 로드 다됐는지 확인할방법이 없음
          KeyPressShort($4B); //K key
          Sleep(40);
          KeyPressShort($1B); //ESC Key
          Sleep(200);
          DD_str(frmMain.ListView_Tasks.Items[CurrentTaskIndex].Caption);
          Sleep(1500);
          KeyPressShort($71); //F2 Key
          Sleep(100);
          KeyPressShort($71); //F2 Key
          Sleep(1000);
          KeyPressShort($0D); //Enter Key
        end;

        if (CurrentStatus = 7) then //Rank
        begin
          CurrentPlayCount := CurrentPlayCount + 1;
          KeyPressShort($1B); //ESC Key
          Sleep(500);
        end;

        if (frmMain.ListView_Tasks.Items.Count <> 0) then
        begin
          Synchronize(
          procedure()
          begin
            frmMain.Combo_Preset.ItemIndex := frmMain.Combo_Preset.Items.IndexOf(frmMain.ListView_Tasks.Items[CurrentTaskIndex].SubItems[2]);
            frmMain.Check_ProMode.Checked := StrToBool(frmMain.ListView_Tasks.Items[CurrentTaskIndex].SubItems[4]);
            UpdateChangedPreset;
          end);
        end;
      end;
    except

    end;
  end;
end;

function GetOsuData(): Boolean;
var
  intdata: Integer;
begin
  //get current offset
  intdata := GetCurrentStatus();
  if (intdata = 0) then
  begin
    Result := false;
    Exit;
  end;
  CurrentStatus_Base := intdata;

  //get current status
  intdata := GetTimeOffset();
  if (intdata = 0) then
  begin
    Result := false;
    Exit;
  end;
  CurrentOffset_Base := intdata;

  //get ingamedata base
  intdata := GetInGameData();
  if (intdata = 0) then
  begin
    Result := false;
    Exit;
  end;
  InGameData_Base := intdata;

  //get rulesetinfo base
  intdata := GetRulesetInfo();
  if (intdata = 0) then
  begin
    Result := false;
    Exit;
  end;
  RulesetInfo_Base := intdata;

  //get keyinfo base
  intdata := GetKeyInfo();
  if (intdata = 0) then
  begin
    Result := false;
    Exit;
  end;
  KeyInfo_Base := intdata;

  Result := true;
end;

procedure ParseBeatmapFromMemory();
var
  HitObjectManager, HeaderManager_Base, HitObjectManager_Base, HitObjectManager_List: Cardinal;
  HitObject_Base: Cardinal;
  Keys: Single;
  HitObjectManager_Count: Integer;
  i, j: Integer;
  HitObject: HitObjectData;
  timestart, timeend: Cardinal;
  tempkps: Integer;
  AverageKPS: array of Integer;
  KeyLists: TStringList;
  HumanizeVal: Integer;
begin
  HitObjectManager := ReadMemoryInt(ReadMemoryInt(InGameData_Base)) + HitObjectManager_Ptr;

  HitObjectManager_Base := ReadMemoryInt(HitObjectManager) + HitObjectManager_Base_Ptr;
  HeaderManager_Base := ReadMemoryInt(HitObjectManager) + HeaderManager_Base_Ptr;
  HitObjectManager_List := ReadMemoryInt(HitObjectManager_Base) + HitObjectManager_Base_List_Ptr;
  HitObjectManager_Count := ReadMemoryInt(ReadMemoryInt(HitObjectManager_Base) + HitObjectManager_Base_Length_Ptr);

  KeyLists := TStringList.Create;
  KeyLists.Sorted := true;
  KeyLists.Duplicates := dupIgnore;

  for i := 0 to HitObjectManager_Count - 1 do
  begin
    HitObject_Base := ReadMemoryInt(ReadMemoryInt(HitObjectManager_List) + $8 + $4 * i);
    KeyLists.Add(IntToStr(ReadMemoryInt(HitObject_Base + HitObjectManager_Base_List_Key_Ptr)));
  end;

  Keys := KeyLists.Count;

  bData.HitObjects := nil;
  bData.HitObjects := TList<HitObjectData>.Create; //reset
  bData.CircleSize := Keys;

  GetKeycodeFromMemory_Init(); //key ready

  for i := 0 to HitObjectManager_Count - 1 do
  begin
    HitObject_Base := ReadMemoryInt(ReadMemoryInt(HitObjectManager_List) + $8 + $4 * i);

    //mirror mod
    if HasMod(RulesetInfo_Base, Mods.Mirror) then
    begin
      HitObject.Key := KeyLists.Count - 1 - ReadMemoryInt(HitObject_Base + HitObjectManager_Base_List_Key_Ptr);
    end
    else
    begin
      HitObject.Key := ReadMemoryInt(HitObject_Base + HitObjectManager_Base_List_Key_Ptr);
    end;

    timestart := ReadMemoryInt(HitObject_Base + HitObjectManager_Base_List_TimeStart_Ptr);
    timeend := ReadMemoryInt(HitObject_Base + HitObjectManager_Base_List_TimeEnd_Ptr);

    //isLongNote
    if (timestart < timeend) then
    begin
      HitObject.NoteType := 1; //long note down
      HitObject.Timing := timestart;
      bData.HitObjects.Add(HitObject);

      HitObject.NoteType := 2; //long note up
      HitObject.Timing := timeend;
      bData.HitObjects.Add(HitObject);
    end
    else
    begin
      HitObject.NoteType := 0; //short note
      HitObject.Timing := timestart;
      bData.HitObjects.Add(HitObject);
    end;
  end;

  //Humanizer
  if (frmMain.Check_Humanizer.Checked) then
  begin
    SetLength(AverageKPS, bData.HitObjects.Count);

    for i := 0 to bData.HitObjects.Count - 11 do
    begin
      tempkps := 1;

      for j := 0 to 9 do
      begin
        if (Abs(bData.HitObjects[i + j].Timing - bData.HitObjects[i + j + 1].Timing) <> 0) then
        begin
          if (bData.HitObjects[i].NoteType <> 0) then
            tempkps := tempkps + Floor(Abs(bData.HitObjects[i + j].Timing - bData.HitObjects[i + j + 1].Timing) * 0.6) //Long note nerf
          else
            tempkps := tempkps + Abs(bData.HitObjects[i + j].Timing - bData.HitObjects[i + j + 1].Timing);
        end
        else
          tempkps := tempkps + 100; //to-do: customizable var
      end;

      AverageKPS[i] := Floor((20000 / tempkps) * ((round(bData.CircleSize) + 2) / 8));

      if (frmMain.Check_ProMode.Checked) then
      begin
        AverageKPS[i] := Floor(AverageKPS[i] * 0.75); //to-do: not kps, key timing
      end;

      if HasMod(RulesetInfo_Base, Mods.DoubleTime) or HasMod(RulesetInfo_Base, Mods.Nightcore) then
      begin
        AverageKPS[i] := Floor(AverageKPS[i] * 1.5);
      end
      else if HasMod(RulesetInfo_Base, Mods.HalfTime) then
      begin
        AverageKPS[i] := Floor(AverageKPS[i] * 0.75);
      end;
    end;
  end;

  //create keymanagers
  KeyManager := nil;
  KeyManager := TList<KeyThread>.Create;

  for i := 0 to Floor(bData.CircleSize) - 1 do
  begin
    KeyManager.Add(KeyThread.Create(true));
    KeyManager[i].Key := i;
    KeyManager[i].HitObjects := TList<HitObjectData>.Create;
  end;

  //classify by key
  for i := 0 to bData.HitObjects.Count - 1 do
  begin
    HitObject := bData.HitObjects[i];

    {if ((i + 1) < bData.HitObjects.Count) then
    begin
      // 1 1 1 1 pattern
      if (bData.HitObjects[i].Timing = bData.HitObjects[i + 1].Timing) then
      begin
        HitObject.Timing := HitObject.Timing + GetHumanizeValue(AverageKPS[i]);
        HitObject := bData.HitObjects[i + 1];
        KeyManager[HitObject.Key].HitObjects.Add(HitObject);

        HitObject.Timing := bData.HitObjects[i].Timing;
        KeyManager[HitObject.Key].HitObjects.Add(HitObject);

        continue;
      end;
    end;}
    if (frmMain.Check_Humanizer.Checked) then
    begin
      HumanizeVal := GetHumanizeValue(AverageKPS[i], 0);
      if HasMod(RulesetInfo_Base, Mods.DoubleTime) or HasMod(RulesetInfo_Base, Mods.Nightcore) then
      begin
        HumanizeVal := Floor(HumanizeVal * 1.15);
      end
      else if HasMod(RulesetInfo_Base, Mods.HalfTime) then
      begin
        HumanizeVal := Floor(HumanizeVal * 0.95);
      end;
      if HumanizeVal < -110 then
      begin
        HitObject.Timing := HitObject.Timing + HumanizeVal;
        KeyManager[bData.HitObjects[i].Key].HitObjects.Add(HitObject);

        HitObject.Timing := HitObject.Timing + RandomRange(30, 80);
        KeyManager[bData.HitObjects[i].Key].HitObjects.Add(HitObject);
      end
      else if HumanizeVal > 110 then
      begin
        HitObject.Timing := HitObject.Timing + RandomRange(-80, -30);
        KeyManager[bData.HitObjects[i].Key].HitObjects.Add(HitObject);

        HitObject.Timing := HitObject.Timing + HumanizeVal;
        KeyManager[bData.HitObjects[i].Key].HitObjects.Add(HitObject);
      end
      else
      begin
        HitObject.Timing := HitObject.Timing + HumanizeVal;
        KeyManager[bData.HitObjects[i].Key].HitObjects.Add(HitObject);
      end;
    end
    else
    begin
      KeyManager[bData.HitObjects[i].Key].HitObjects.Add(HitObject);
    end;
  end;

  //sort
  for i := 0 to KeyManager.Count - 1 do
  begin
    KeyManager[i].HitObjects.Sort(
      TComparer<HitObjectData>.Construct(
      function(const Left, Right: HitObjectData): Integer
      begin
        Result := Left.Timing - Right.Timing;
      end))
  end;

  //start thread
  for i := 0 to KeyManager.Count - 1 do
  begin
    KeyManager[i].SetFreeOnTerminate(True);
    KeyManager[i].Resume;
  end;
end;

{$R *.dfm}

procedure TfrmMain.AddNewClick(Sender: TObject);
var
  EditForm: TfrmTaskEditor;
begin
  bEditing := False;
  CurrentItem := nil;
  Application.CreateForm(TfrmTaskEditor, EditForm);
  EditForm.Combo_Profile.Items := Combo_Preset.Items;
  EditForm.Show;
end;

procedure TfrmMain.AddNew_SClick(Sender: TObject);
var
  EditForm: TfrmScheduleEditor;
begin
  bEditing_S := False;
  CurrentItem_S := nil;
  Application.CreateForm(TfrmScheduleEditor, EditForm);
  EditForm.Show;
end;

procedure TfrmMain.Button_ManualParseClick(Sender: TObject);
begin
  ParseBeatmapFromMemory();
  //ParseBeatmap;
end;

procedure TfrmMain.Button_ResumeBotClick(Sender: TObject);
begin
  bBotSuspended := False;
end;

procedure TfrmMain.Button_SuspendBotClick(Sender: TObject);
begin
  bBotSuspended := True;
end;

procedure TfrmMain.Button_TabGeneralClick(Sender: TObject);
begin
  Page_Menus.ActivePageIndex := 0;
end;

procedure TfrmMain.Button_TabHumanizerClick(Sender: TObject);
begin
  Page_Menus.ActivePageIndex := 1;
end;

procedure TfrmMain.Button_TabSchedulerClick(Sender: TObject);
begin
  Page_Menus.ActivePageIndex := 3;
end;

procedure TfrmMain.Button_TabTasksClick(Sender: TObject);
begin
  Page_Menus.ActivePageIndex := 2;
end;

procedure UpdateChangedPreset();
begin
  if frmMain.Combo_Preset.ItemIndex = 0 then //Level10
  begin
    frmMain.Track_Acc_300.Position := 40;
    frmMain.Track_Ratio_Kool.Position := 65;
    frmMain.Track_Ratio_Cool.Position := 35;
    frmMain.Track_Ratio_200.Position := 95;
    frmMain.Track_Ratio_100.Position := 5;
    frmMain.Track_Ratio_Miss.Position := 0;
  end;

  if frmMain.Combo_Preset.ItemIndex = 1 then //Level9
  begin
    frmMain.Track_Acc_300.Position := 30;
    frmMain.Track_Ratio_Kool.Position := 60;
    frmMain.Track_Ratio_Cool.Position := 40;
    frmMain.Track_Ratio_200.Position := 92;
    frmMain.Track_Ratio_100.Position := 7;
    frmMain.Track_Ratio_Miss.Position := 1;
  end;

  if frmMain.Combo_Preset.ItemIndex = 2 then //Level8
  begin
    frmMain.Track_Acc_300.Position := 25;
    frmMain.Track_Ratio_Kool.Position := 60;
    frmMain.Track_Ratio_Cool.Position := 40;
    frmMain.Track_Ratio_200.Position := 91;
    frmMain.Track_Ratio_100.Position := 8;
    frmMain.Track_Ratio_Miss.Position := 1;
  end;

  if frmMain.Combo_Preset.ItemIndex = 3 then //Level7
  begin
    frmMain.Track_Acc_300.Position := 19;
    frmMain.Track_Ratio_Kool.Position := 55;
    frmMain.Track_Ratio_Cool.Position := 45;
    frmMain.Track_Ratio_200.Position := 86;
    frmMain.Track_Ratio_100.Position := 11;
    frmMain.Track_Ratio_Miss.Position := 3;
  end;

  if frmMain.Combo_Preset.ItemIndex = 4 then //Level6
  begin
    frmMain.Track_Acc_300.Position := 16;
    frmMain.Track_Ratio_Kool.Position := 50;
    frmMain.Track_Ratio_Cool.Position := 50;
    frmMain.Track_Ratio_200.Position := 84;
    frmMain.Track_Ratio_100.Position := 11;
    frmMain.Track_Ratio_Miss.Position := 5;
  end;

  if frmMain.Combo_Preset.ItemIndex = 5 then //Level5
  begin
    frmMain.Track_Acc_300.Position := 15;
    frmMain.Track_Ratio_Kool.Position := 45;
    frmMain.Track_Ratio_Cool.Position := 55;
    frmMain.Track_Ratio_200.Position := 83;
    frmMain.Track_Ratio_100.Position := 10;
    frmMain.Track_Ratio_Miss.Position := 7;
  end;

  if frmMain.Combo_Preset.ItemIndex = 6 then //Level4
  begin
    frmMain.Track_Acc_300.Position := 10;
    frmMain.Track_Ratio_Kool.Position := 30;
    frmMain.Track_Ratio_Cool.Position := 70;
    frmMain.Track_Ratio_200.Position := 77;
    frmMain.Track_Ratio_100.Position := 13;
    frmMain.Track_Ratio_Miss.Position := 10;
  end;

  if frmMain.Combo_Preset.ItemIndex = 7 then //Level3
  begin
    frmMain.Track_Acc_300.Position := 6;
    frmMain.Track_Ratio_Kool.Position := 30;
    frmMain.Track_Ratio_Cool.Position := 70;
    frmMain.Track_Ratio_200.Position := 70;
    frmMain.Track_Ratio_100.Position := 11;
    frmMain.Track_Ratio_Miss.Position := 19;
  end;

  if frmMain.Combo_Preset.ItemIndex = 8 then //Level2
  begin
    frmMain.Track_Acc_300.Position := 4;
    frmMain.Track_Ratio_Kool.Position := 15;
    frmMain.Track_Ratio_Cool.Position := 85;
    frmMain.Track_Ratio_200.Position := 60;
    frmMain.Track_Ratio_100.Position := 15;
    frmMain.Track_Ratio_Miss.Position := 25;
  end;

  if frmMain.Combo_Preset.ItemIndex = 9 then //Level1
  begin
    frmMain.Track_Acc_300.Position := 2;
    frmMain.Track_Ratio_Kool.Position := 10;
    frmMain.Track_Ratio_Cool.Position := 90;
    frmMain.Track_Ratio_200.Position := 45;
    frmMain.Track_Ratio_100.Position := 35;
    frmMain.Track_Ratio_Miss.Position := 20;
  end;
end;

procedure TfrmMain.Combo_LanguageChange(Sender: TObject);
begin
  if Combo_Language.ItemIndex = 0 then
  begin
    Button_TabGeneral.Caption := '일반';
    Button_TabHumanizer.Caption := '휴머나이저';
    Button_TabTasks.Caption := '작업 편집기';
    Button_TabScheduler.Caption := '일정';

    //TabGeneral
    Group_GeneralKey.Caption := '일반';
      Label4.Caption := '키 타이밍 범위';
      Label8.Caption := '컴퓨터의 성능이 안 좋아 놓치는 노트가 있을경우 수치를 늘려주세요.';
      Check_StreamKeyProof.Caption := '방송용 키 오토';
      Label9.Caption := '체크시 실제 키를 눌렀을때만 자동입력이 작동합니다.';
    Group_Profile.Caption := '프로필';
      Label10.Caption := '조정 가능한 모든 설정값들을 로드/저장 할 수 있습니다. 우클릭 = 메뉴';
    Group_Debugging.Caption := '디버그 전용';
      Button_ManualParse.Caption := '비트맵 수동으로 파싱';


    //Tab Humanizer
    Group_kps.Caption := 'KPS 기반 휴머나이저';
      Check_Humanizer.Caption := '활성화';
      Label6.Caption := '처리 방식';
      Label11.Caption := '최신 : Cool~Miss까지의 비율이 자연스럽습니다 / 옛날방식 : 테스트용';
      Combo_HumanizerMethod.Items[0] := '최신 (300->200->100->Miss->50 순으로)';
      Combo_HumanizerMethod.Items[1] := '옛날방식 (300/100/Bad 각각 조절)';
      Combo_HumanizerMethod.ItemIndex := 0;
      Label20.Caption := 'Kool+Cool KPS';
      Label7.Caption := 'Kool비율(%) (무지개 300)';
      Label1.Caption := 'Cool비율(%) (일반 300)';
      Label17.Caption := '200비율(%)';
      Label18.Caption := '100비율(%)';
      Label19.Caption := '미스비율(%)';
      Label5.Caption := '프리셋';
      Label12.Caption := 'KPS 기반 휴머나이저의 설정값을 간단하게 불러옵니다. 개인이 추가 불가능.';
      Check_ProMode.Caption := '프로모드 (x0.75 KPS)';
      Label13.Caption := 'Level10으로도 처리 안되는곡을 처리 할 수 있습니다. 랭킹 3자리대 이상 전용.';
    Group_KeySwitch.Caption := '키 스위치';
      Check_KeySwitch.Caption := '활성화';
      Label14.Caption := '체크를 해제한 키는 작동하지 않습니다. EZ2의 페달오토를 생각하면 됩니다.';


    //TabTasks
    Group_Tasks.Caption := '작업';
      Check_Tasks.Caption := '작업 활성화 (단축키 - PgUp:시작 / PgDn:종료)';
      Label15.Caption := '활성화시 곡선택부터 게임까지 자동으로 진행됩니다. 우클릭 = 메뉴';
      ListView_Tasks.Columns.Items[0].Caption := '필터';
      ListView_Tasks.Columns.Items[1].Caption := '최소';
      ListView_Tasks.Columns.Items[2].Caption := '최대';
      ListView_Tasks.Columns.Items[3].Caption := '프로필';
      ListView_Tasks.Columns.Items[4].Caption := '죽을경우';
      ListView_Tasks.Columns.Items[5].Caption := '프로모드';


    //TabScheduler
    Group_Scheduler.Caption := '일정';
      Check_Scheduler.Caption := '일정 활성화';
      Label16.Caption := '일정에 맞게 봇이 이벤트를 실행합니다. 주로 작업과 같이 쓰입니다.';
      ListView_Schedules.Columns.Items[0].Caption := '시간';
      ListView_Schedules.Columns.Items[0].Caption := '이벤트';


    //Menus
    ReloadProfileList.Caption := '새로고침';
    LoadProfile.Caption := '불러오기';
    SaveProfileOverwrite.Caption := '저장(덮어쓰기)';
    SaveProfileNew.Caption := '저장(신규)';
    DeleteProfile.Caption := '삭제';

    AddNew_S.Caption := '새 일정 추가';
    EditItem_S.Caption := '수정';
    DeleteItem_S.Caption := '삭제';

    AddNew_S.Caption := '새 작업 추가';
    EditItem_S.Caption := '수정';
    DeleteItem_S.Caption := '삭제';

  end
  else if Combo_Language.ItemIndex = 1 then
  begin
    Button_TabGeneral.Caption := 'General';
    Button_TabHumanizer.Caption := 'Humanizer';
    Button_TabTasks.Caption := 'Tasks';
    Button_TabScheduler.Caption := 'Scheduler';

    //TabGeneral
    Group_GeneralKey.Caption := 'General';
      Label4.Caption := 'Key-Timing Range';
      Label8.Caption := 'If bot misses some notes by lag, please increase the value.';
      Check_StreamKeyProof.Caption := 'Streaming proof';
      Label9.Caption := 'When enabled, bot will work only when the actual key is pressed.';
    Group_Profile.Caption := 'Profile';
      Label10.Caption := 'All adjustable settings can be loaded/saved. Right click = menu';
    Group_Debugging.Caption := 'Debugging only';
      Button_ManualParse.Caption := 'Manual Parse';


    //Tab Humanizer
    Group_kps.Caption := 'Humanizer based on KPS';
      Check_Humanizer.Caption := 'Enable';
      Label6.Caption := 'Methods';
      Label11.Caption := 'New : Cool~Miss ratio is human-like / Old : Disabled';
      Combo_HumanizerMethod.Items[0] := 'New (300->200->100->Miss->50)';
      Combo_HumanizerMethod.Items[1] := 'Old (300/100/Bad Only)';
      Combo_HumanizerMethod.ItemIndex := 0;
      Label20.Caption := 'Kool+Cool KPS';
      Label7.Caption := 'Kool(%) (Rainbow 300)';
      Label1.Caption := 'Cool(%) (Normal 300)';
      Label17.Caption := '200(%)';
      Label18.Caption := '100(%)';
      Label19.Caption := 'Miss(%)';
      Label5.Caption := 'Preset';
      Label12.Caption := 'These are humanizer presets added by developer. Cannot be modified.';
      Check_ProMode.Caption := 'Pro-Mode (x0.75 KPS)';
      Label13.Caption := 'Pro-Mode clear songs that cannot cleared with Level10. 3Digits Rank++ only.';
    Group_KeySwitch.Caption := 'Key Switch';
      Check_KeySwitch.Caption := 'Enable';
      Label14.Caption := 'Unchecked keys will not work.';


    //TabTasks
    Group_Tasks.Caption := 'Tasks';
      Check_Tasks.Caption := 'Enable Tasks (Hotkey - PgUp:Start / PgDn:Stop)';
      Label15.Caption := 'When enabled, bot plays game full-automatically by tasks. Right click = menu';
      ListView_Tasks.Columns.Items[0].Caption := 'Filter';
      ListView_Tasks.Columns.Items[1].Caption := 'Min';
      ListView_Tasks.Columns.Items[2].Caption := 'Max';
      ListView_Tasks.Columns.Items[3].Caption := 'Profile';
      ListView_Tasks.Columns.Items[4].Caption := 'When fails';
      ListView_Tasks.Columns.Items[5].Caption := 'Pro-Mode';


    //TabScheduler
    Group_Scheduler.Caption := 'Scheduler';
      Check_Scheduler.Caption := 'Enable Scheduler';
      Label16.Caption := 'The bot will run events on specific times. It is mainly used for tasks.';
      ListView_Schedules.Columns.Items[0].Caption := 'Time';
      ListView_Schedules.Columns.Items[1].Caption := 'Event';

    //Menus
    ReloadProfileList.Caption := 'Reload list';
    LoadProfile.Caption := 'Load';
    SaveProfileOverwrite.Caption := 'Save(Overwrite)';
    SaveProfileNew.Caption := 'Save(New)';
    DeleteProfile.Caption := 'Delete';

    AddNew_S.Caption := 'Add new schedule';
    EditItem_S.Caption := 'Edit';
    DeleteItem_S.Caption := 'Delete';

    AddNew_S.Caption := 'Add new tast';
    EditItem_S.Caption := 'Edit';
    DeleteItem_S.Caption := 'Delete';
  end;
end;

procedure TfrmMain.Combo_PresetChange(Sender: TObject);
begin
  UpdateChangedPreset;
end;

procedure TfrmMain.DeleteItemClick(Sender: TObject);
begin
  ListView_Tasks.Selected.Delete;
end;

procedure TfrmMain.DeleteItem_SClick(Sender: TObject);
begin
  ListView_Schedules.Selected.Delete;
end;

procedure TfrmMain.DeleteProfileClick(Sender: TObject);
var
  btn_select : integer;
  Itm: TListItem;
begin
  Itm := ListView_GlobalProfile.Selected;

  if (frmMain.Combo_Language.ItemIndex = 0) then
    btn_select :=  MessageDlg(Itm.Caption + '.cfg 를 삭제하시겠습니까?' + #13#10 +
                            '실제 파일도 영구적으로 삭제됩니다!', mtConfirmation, [mbYes, mbNo], 0)
  else if (frmMain.Combo_Language.ItemIndex = 1) then
    btn_select :=  MessageDlg('Are you sure delete ' + Itm.Caption + '.cfg?' + #13#10 +
                            'File will deleted from the disk permanently!', mtConfirmation, [mbYes, mbNo], 0);


  if btn_select = mrYes then
  begin
    DeleteFile(ExtractFilePath(Application.Exename) + 'Profiles\' + Itm.Caption + '.cfg');
    Itm.Delete;
  end
end;

procedure TfrmMain.EditItemClick(Sender: TObject);
var
  EditForm: TfrmTaskEditor;
begin
  bEditing := True;
  CurrentItem := ListView_Tasks.Selected;
  SelectedItemIndex := ListView_Tasks.ItemIndex;
  Application.CreateForm(TfrmTaskEditor, EditForm);
  EditForm.Combo_Profile.Items := Combo_Preset.Items;
  EditForm.Show;
end;

procedure TfrmMain.EditItem_SClick(Sender: TObject);
var
  EditForm: TfrmScheduleEditor;
begin
  bEditing_S := True;
  CurrentItem_S := ListView_Schedules.Selected;
  SelectedItemIndex_S := ListView_Schedules.ItemIndex;
  Application.CreateForm(TfrmScheduleEditor, EditForm);
  EditForm.Show;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  TerminateProcess(GetCurrentProcess, 0);
  if OffsetThread.Terminated = false then OffsetThread.DoTerminate;
  if StatusThread.Terminated = false then StatusThread.DoTerminate;
  if TMainThread.Terminated = false then TMainThread.DoTerminate;
  if (KeyManager.Count <> 0) then
  begin
    for i := 0 to KeyManager.Count - 1 do
    begin
      try
        KeyManager[i].DoTerminate;
      except
      end;
    end;
  end;
  Halt; //prevent exception
  Application.Terminate;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //frmMain.Width := 460;
  //frmMain.Height := 284;
  LoadResourceFontByID(1, RT_RCDATA);

  Application.ShowMainForm := false;
  TMainThread := MainThread.Create(True);
  TMainThread.SetFreeOnTerminate(True);
  TMainThread.Resume;

  if not (LoadDD()) then
  begin
    ShowMessage('LoadDD error!');
  end;

  if (GetHandle()) then
  begin
    if not (GetOsuData()) then
    begin
      ShowMessage('Memory scanner error!');
    end
    else
    begin
      //ShowMessage('OK!');
    end;
  end;

  LoadProfileList;
end;


procedure TfrmMain.LoadProfileClick(Sender: TObject);
begin
  Profile_Load(ListView_GlobalProfile.Selected.Caption);
end;

procedure TfrmMain.PopupMenu_ProfilePopup(Sender: TObject);
var
  itm: TListItem;
begin
  itm := ListView_GlobalProfile.Selected;

  if (itm <> nil) then
  begin
    LoadProfile.Enabled := True;
    LoadProfile.Visible := True;
    SaveProfileOverwrite.Enabled := True;
    SaveProfileOverwrite.Visible := True;
  end
  else
  begin
    LoadProfile.Enabled := False;
    LoadProfile.Visible := False;
    SaveProfileOverwrite.Enabled := False;
    SaveProfileOverwrite.Visible := False;
  end;
end;

procedure TfrmMain.PopupMenu_ScheduleEditorPopup(Sender: TObject);
var
  itm: TListItem;
begin
  itm := ListView_Schedules.Selected;

  if (itm = nil) then
  begin
    EditItem_S.Enabled := False;
    EditItem_S.Visible := False;
    DeleteItem_S.Enabled := False;
    DeleteItem_S.Visible := False;
  end
  else
  begin
    EditItem_S.Enabled := True;
    EditItem_S.Visible := True;
    DeleteItem_S.Enabled := True;
    DeleteItem_S.Visible := True;
  end;
end;

procedure TfrmMain.PopupMenu_TaskEditorPopup(Sender: TObject);
var
  itm: TListItem;
begin
  itm := ListView_Tasks.Selected;

  if (itm = nil) then
  begin
    EditItem.Enabled := False;
    EditItem.Visible := False;
    DeleteItem.Enabled := False;
    DeleteItem.Visible := False;
  end
  else
  begin
    EditItem.Enabled := True;
    EditItem.Visible := True;
    DeleteItem.Enabled := True;
    DeleteItem.Visible := True;
  end;
end;

procedure TfrmMain.ReloadProfileListClick(Sender: TObject);
begin
  LoadProfileList;
end;

procedure TfrmMain.SaveProfileNewClick(Sender: TObject);
var
  ProfileName: string;
begin
  repeat
    ProfileName := InputBox('Save new profile', 'Profile Name', '');
  until ProfileName <> '' ;

  Profile_Save(ProfileName);
  LoadProfileList;
end;

procedure TfrmMain.SaveProfileOverwriteClick(Sender: TObject);
begin
  Profile_Save(ListView_GlobalProfile.Selected.Caption);
  LoadProfileList;
end;

procedure TfrmMain.Timer_HotkeyTimer(Sender: TObject);
begin
  if (GetKeyState(VK_HOME) and $80) <> 0 then
  begin
    frmMain.Visible := not frmMain.Visible;
    SleepEx(200);
  end;

  if ((GetKeyState(VK_PRIOR) and $80) <> 0) and (Check_Tasks.Checked) then
  begin
    bTasksToggle := True;
    SleepEx(200);
  end;

  if (GetKeyState(VK_NEXT) and $80) <> 0 then
  begin
    bTasksToggle := False;
    SleepEx(200);
  end;
end;

procedure TfrmMain.Track_Ratio_100Change(Sender: TObject);
begin
  if (Track_Ratio_200.Position + Track_Ratio_100.Position + Track_Ratio_Miss.Position <> 100) then
  begin
    Track_Ratio_Miss.Position := 100 - Track_Ratio_200.Position - Track_Ratio_100.Position;
    Track_Ratio_100.Position := 100 - Track_Ratio_200.Position - Track_Ratio_Miss.Position;
  end;
end;

procedure TfrmMain.Track_Ratio_200Change(Sender: TObject);
begin
  if (Track_Ratio_200.Position + Track_Ratio_100.Position + Track_Ratio_Miss.Position <> 100) then
  begin
    Track_Ratio_100.Position := 100 - Track_Ratio_200.Position - Track_Ratio_Miss.Position;
    Track_Ratio_Miss.Position := 100 - Track_Ratio_200.Position - Track_Ratio_100.Position;
  end;
end;

procedure TfrmMain.Track_Ratio_MissChange(Sender: TObject);
begin
  if (Track_Ratio_200.Position + Track_Ratio_100.Position + Track_Ratio_Miss.Position <> 100) then
  begin
    Track_Ratio_100.Position := 100 - Track_Ratio_200.Position - Track_Ratio_Miss.Position;
    Track_Ratio_200.Position := 100 - Track_Ratio_100.Position - Track_Ratio_Miss.Position;
  end;
end;

procedure TfrmMain.Track_Ratio_CoolChange(Sender: TObject);
begin
  Track_Ratio_Kool.Position := 100 - Track_Ratio_Cool.Position;
end;

procedure TfrmMain.Track_Ratio_KoolChange(Sender: TObject);
begin
  Track_Ratio_Cool.Position := 100 - Track_Ratio_Kool.Position;
end;

end.
