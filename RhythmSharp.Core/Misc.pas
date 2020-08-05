unit Misc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DSiWin32, RoKo_Lib, System.Diagnostics, System.TimeSpan,
  Vcl.ExtCtrls, System.Generics.Collections, System.Math, System.StrUtils, Offset, TaskEditor, ScheduleEditor,
  Vcl.ComCtrls, Vcl.Menus, IniFiles, Types;

{ Global Functions }
function DoEvent(event: string): Boolean;
function GetStatusString(Status: Cardinal) : String;
function ListViewSaveToString(ListView: TListView): string;
procedure ListViewLoadFromString(ListView: TListView; const SavedString: string);
function IfThen(c: boolean; a, b: integer): integer;

implementation

uses Main;

//존재하지 않는 이벤트이거나 이벤트처리에 실패할경우 False 리턴.
function DoEvent(event: string): Boolean;
begin
  Result := False;

  if (event = 'Suspend Bot') then
  begin
    bBotSuspended := True;
    Result := True;
  end
  else if (event = 'Resume Bot') then
  begin
    bBotSuspended := False;
    Result := True;
  end;
end;

function IfThen(c: boolean; a, b: integer): integer;
begin
  if c then
    Result := a
  else
    Result := b;
end;

function GetStatusString(Status: Cardinal) : String;
begin
  Case Status Of
    00: Result := 'Menu';
    01: Result := 'Edit';
    02: Result := 'Play';
    03: Result := 'Exit';
    04: Result := 'SelectEdit';
    05: Result := 'SelectPlay';
    06: Result := 'SelectDrawings';
    07: Result := 'Rank';
    08: Result := 'Update';
    09: Result := 'Busy';
    10: Result := 'Unknown';
    11: Result := 'Lobby';
    12: Result := 'MatchSetup';
    13: Result := 'SelectMulti';
    14: Result := 'RankingVs';
    15: Result := 'OnlineSelection';
    16: Result := 'OptionsOffsetWizard';
    17: Result := 'RankingTagCoop';
    18: Result := 'RankingTeam';
    19: Result := 'BeatmapImport';
    20: Result := 'PackageUpdater';
    21: Result := 'Benchmark';
    22: Result := 'Tourney';
    23: Result := 'Charts';
  else
    Result := 'Unknown'; //error while handle result
  end;
end;

procedure AddTextToLine(var Line: string; const Text: string);
begin
  Line := Line + Text + '#';
end;

procedure MoveCompletedLineToList(const Strings: TStringList; var Line: string);
begin
  Strings.Add(System.Copy(Line, 1, Length(Line)-1));//remove trailing tab
  Line := '';
end;

function ListViewSaveToString(ListView: TListView): string;
var
  Strings: TStringList;
  ResultString: string;
  LatestLine: string;
  i, j: Integer;

begin
  LatestLine := '';
  ResultString := '';

  Strings := TStringList.Create;
  try
    for i := 0 to ListView.Items.Count-1 do
    begin
      AddTextToLine(LatestLine, ListView.Items[i].Caption);
      for j := 0 to ListView.Items[i].SubItems.Count-1 do
      begin
        AddTextToLine(LatestLine, ListView.Items[i].SubItems[j]);
      end;
      MoveCompletedLineToList(Strings, LatestLine);
    end;

    for i := 0 to Strings.Count-1 do
    begin
      ResultString := ResultString + Strings[i] + '$';
    end;
    Result := ResultString;
  finally
    Strings.Free;
  end;
end;

procedure ListViewLoadFromString(ListView: TListView; const SavedString: string);
  procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
  begin
     Assert(Assigned(Strings));
     Strings.Clear;
     Strings.StrictDelimiter := true;
     Strings.Delimiter := Delimiter;
     Strings.DelimitedText := Input;
  end;
var
  //Strings: TStringList;
  StringLst: TStringDynArray;
  i, j: Integer;
  Fields: TStringDynArray;
  Item: TListItem;
begin
  //Strings := TStringList.Create;
  try
    StringLst := SplitString(SavedString, '$');
    //Split(':', SavedString, Strings);
    ListView.Clear;
    for i := 0 to High(StringLst)-1 do
    begin
      Fields := SplitString(StringLst[i], '#');
      Item := ListView.Items.Add;
      Item.Caption := Fields[0];
      for j := 1 to high(Fields) do
      begin
        Item.SubItems.Add(Fields[j]);
      end;
    end;
  finally
    //Strings.Free;
  end;
end;

end.


