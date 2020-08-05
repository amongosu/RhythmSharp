unit ScheduleEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXPickers, Vcl.ComCtrls;

type
  TfrmScheduleEditor = class(TForm)
    Group_ScheduleEditor: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Combo_Event: TComboBox;
    Button_Cancel: TButton;
    Button_Save: TButton;
    TimePicker1: TTimePicker;
    procedure FormShow(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmScheduleEditor: TfrmScheduleEditor;
  bEditing_S: Boolean;
  CurrentItem_S: TListItem;
  SelectedItemIndex_S: Cardinal;

implementation

{$R *.dfm}
uses Main;

procedure TfrmScheduleEditor.Button_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmScheduleEditor.Button_SaveClick(Sender: TObject);
var
  Item: TListItem;
  FmtStngs: TFormatSettings;
begin
  FmtStngs.LongTimeFormat := 'hh:mm';
  FmtStngs.TimeSeparator := ':';

  if (bEditing_S) then
  begin
    Item := frmMain.ListView_Schedules.Items[SelectedItemIndex_S];
    Item.Caption :=  TimeToStr(TimePicker1.Time, FmtStngs);
    Item.SubItems[0] := Combo_Event.Text;
  end
  else
  begin
    Item := frmMain.ListView_Schedules.Items.Add;
    Item.Caption := TimeToStr(TimePicker1.Time, FmtStngs);
    Item.SubItems.Add(Combo_Event.Text);
  end;
  ShowMessage('Task saved!');
  Close;
  Exit;
end;

procedure TfrmScheduleEditor.FormShow(Sender: TObject);
begin
  if (bEditing_S) then
  begin
    TimePicker1.Time := StrToTime(CurrentItem_S.Caption);
    Combo_Event.ItemIndex := Combo_Event.Items.IndexOf(CurrentItem_S.SubItems[0]);
  end
  else
  begin
    TimePicker1.Time := StrToTime('00:00:00');
    Combo_Event.ItemIndex := 0;
  end;
end;

end.
