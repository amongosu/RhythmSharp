unit TaskEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Mask;

type
  TfrmTaskEditor = class(TForm)
    Group_EditTask: TGroupBox;
    Label1: TLabel;
    Edit_SearchFilter: TEdit;
    Button_KeywordHelp: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Edit_PlayCountMin: TEdit;
    Edit_PlayCountMax: TEdit;
    Label4: TLabel;
    Combo_Profile: TComboBox;
    Label5: TLabel;
    Combo_IfFails: TComboBox;
    Button_Cancel: TButton;
    Button_Save: TButton;
    Check_ProMode: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure Button_KeywordHelpClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure Edit_PlayCountMaxChange(Sender: TObject);
    procedure Edit_PlayCountMinChange(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTaskEditor: TfrmTaskEditor;
  bEditing: Boolean;
  CurrentItem: TListItem;
  SelectedItemIndex: Cardinal;

implementation

{$R *.dfm}

uses Main;

procedure TfrmTaskEditor.Button_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTaskEditor.Button_KeywordHelpClick(Sender: TObject);
begin
  ShowMessage('[ Search Filters ]' + #13#10 + #13#10 +
              'Keywords : keys, stars, status, unplayed' + #13#10 +
              'Example : keys>=4 stars>4.5 stars<=5.5 status=ranked unplayed=' + #13#10 +
              'Example : keys=7 stars>3.5 status=loved unplayed!=');
end;

procedure TfrmTaskEditor.Button_SaveClick(Sender: TObject);
var
  Item: TListItem;
begin
  if StrToInt(Edit_PlayCountMin.Text) <= StrToInt(Edit_PlayCountMax.Text) then
  begin
    if (bEditing) then
    begin
      Item := frmMain.ListView_Tasks.Items[SelectedItemIndex];
      Item.Caption := Edit_SearchFilter.Text;
      Item.SubItems[0] := Edit_PlayCountMin.Text;
      Item.SubItems[1] := Edit_PlayCountMax.Text;
      Item.SubItems[2] := Combo_Profile.Text;
      Item.SubItems[3] := Combo_IfFails.Text;
      Item.SubItems[4] := BoolToStr(Check_ProMode.Checked, True);
    end
    else
    begin
      Item := frmMain.ListView_Tasks.Items.Add;
      Item.Caption := Edit_SearchFilter.Text;
      Item.SubItems.Add(Edit_PlayCountMin.Text);
      Item.SubItems.Add(Edit_PlayCountMax.Text);
      Item.SubItems.Add(Combo_Profile.Text);
      Item.SubItems.Add(Combo_IfFails.Text);
      Item.SubItems.Add(BoolToStr(Check_ProMode.Checked, True));
    end;
    ShowMessage('Task saved!');
    Close;
    Exit;
  end;
  ShowMessage('Error! "PlayCount Min > Max"');
end;

procedure TfrmTaskEditor.FormShow(Sender: TObject);
begin
  if (bEditing) then
  begin
    Edit_SearchFilter.Text := CurrentItem.Caption;
    Edit_PlayCountMin.Text := CurrentItem.SubItems[0];
    Edit_PlayCountMax.Text := CurrentItem.SubItems[1];
    Combo_Profile.ItemIndex := Combo_Profile.Items.IndexOf(CurrentItem.SubItems[2]);
    Combo_IfFails.ItemIndex := Combo_IfFails.Items.IndexOf(CurrentItem.SubItems[3]);
    Check_ProMode.Checked := StrToBool(CurrentItem.SubItems[4]);
  end
  else
  begin
    Edit_SearchFilter.Text := '';
    Edit_PlayCountMin.Text := '1';
    Edit_PlayCountMax.Text := '1';
    Combo_Profile.ItemIndex := 0;
    Combo_IfFails.ItemIndex := 0;
    Check_ProMode.Checked := False;
  end;
  //ShowMessage('bEditing: ' + BoolToStr(bEditing, True));
end;

procedure TfrmTaskEditor.Edit_PlayCountMaxChange(Sender: TObject);
begin
  if (Edit_PlayCountMax.Text = '') then
  begin
    Edit_PlayCountMax.Text := '1';
  end;
end;

procedure TfrmTaskEditor.Edit_PlayCountMinChange(Sender: TObject);
begin
  if (Edit_PlayCountMin.Text = '') then
  begin
    Edit_PlayCountMin.Text := '1';
  end;
end;

end.
