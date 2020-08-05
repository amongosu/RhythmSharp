unit RoKo_Lib;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, PSApi,
  TLHelp32, SHFolder, IdGlobal, IdHash, IdHashMessageDigest, DSiWin32, Offset;


function DSiGetProcessID(const processName: string): Cardinal;
function GetHandle(): Boolean;
function ReadMemoryDouble(Addr: DWORD): Double;
function ReadMemoryFloat(Addr: DWORD): Single;
function ReadMemoryStr(Addr, Len: DWORD): string;
function ReadMemoryInt(Addr: DWORD): DWORD;
function GetCurrentStatus(): Integer;
function GetTimeOffset() : Integer;
function GetInGameData(): Integer;
function GetRulesetInfo(): Integer;
function GetKeyInfo(): Integer;
function GetOsuPath: String;
function SleepEx(delay: dword) : dword;
function GetCurrentHP(RulesetInfo_Base: Cardinal): Double;
function GetCurrentMods(RulesetInfo_Base: Cardinal): Mods;
function CompareMod(Mod1, Mod2: Mods): Boolean;
function HasMod(RulesetInfo_Base: Cardinal; PlayMod: Mods): Boolean;
function LoadResourceFontByID(ResourceID : Integer; ResType: PChar): Boolean;
function LoadResourceFontByName(const ResourceName : string; ResType: PChar): Boolean;

var
  ASD : NativeUint;
  Addr : TStringList;
  dwID : DWORD;
  hProcess_osu: THandle = 0;

type
  TArrayScan = record
  Start: DWORD;
  Finish: DWORD;
  Array_of_bytes: String;
end;

implementation

{$region 'Process'}
//Get PID by process name
function DSiGetProcessID(const processName: string): Cardinal;
var
  hSnapshot: THandle;
  procEntry: TProcessEntry32;
begin
  Result := 0;
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if hSnapshot = 0 then
    Exit;
  try
    procEntry.dwSize := Sizeof(procEntry);
    if not Process32First(hSnapshot, procEntry) then
      Exit;
    repeat
      if AnsiSameText(procEntry.szExeFile, processName) then begin
        DSiGetProcessID := procEntry.th32ProcessID;
        Result := procEntry.th32ProcessID;
        break; // repeat
      end;
    until not Process32Next(hSnapshot, procEntry);
  finally DSiCloseHandleAndNull(hSnapshot); end;
end;

function GetHandle(): Boolean;
var
  PID: Cardinal;
begin
  PID := DSiGetProcessID('osu!.exe');

  if PID = 0 then
  begin
    hProcess_osu := 0;
    Result := False;
    Exit;
  end;

  hProcess_osu := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
  Result := True;
end;

//Mask like '?? ?? ?? ??'
Function GetMask(Array_of_bytes: String): String;
var
  x, y: integer;
  St: string;
  Mask: string;
begin
  St := StringReplace(Array_of_bytes, ' ', '', [rfReplaceAll]);
  y := 1;
  for x := 1 to (Length(St) div 2) do
  begin
    if (St[y] + St[y + 1]) <> '??' then
    begin
      Mask := Mask + 'O';
      y := y + 2;
    end
    else
    begin
      Mask := Mask + 'X';
      y := y + 2;
    end;
  end;
  Result := Mask;
end;

//String to AoB
Procedure StringToArrayByte(Str: string; var Buffer: array of byte);
var
  x, y, z: integer;
  St: string;
begin
  St := StringReplace(Str, ' ', '', [rfReplaceAll]);
  y := 1;
  for x := 0 to Length(St) div 2 - 1 do
  begin
    if St[y] + St[y + 1] <> '??' then
    begin
      Buffer[x] := StrToInt('$' + St[y] + St[y + 1]);
      y := y + 2;
    end
    else
    begin
      Buffer[x] := $00;
      y := y + 2;
    end;
  end;
end;

//Compare Array
Function CompareArray(DestAddress: DWORD; const Dest: array of byte; Source: array of byte;
  ALength: integer; Mask: String; var ReTurn : TStringList) : Boolean;
var
  x, y: integer;
  a, b, c: integer;
  begin
  for x := 0 to Length(Dest) - Length(Source) do
  begin
   a := 0;
    for y := 0 to Length(Source) - 1 do
    begin
      if (Dest[x + y] = Source[y]) or (Mask[y + 1] = 'X') then
      begin
        if y = (Length(Source) - 1) then
        begin
          Return.Add(IntToStr(DestAddress + x));
          Result := True;
          Exit;
        end;
      end
      else
      begin
        Break;
      end;
    end;
  end;
  Result := True;
end;

//Array scanner
Function ArrayScan(Struct: TArrayScan): TStringList;
var
  x, y, z: integer;
  ArrayStruct: TArrayScan;
  mbi: Memory_Basic_Information;
  StartAdr: DWORD;
  FinishAdr: DWORD;
  Mask: String;
  Str : String;
  Buffer: Array of Byte;
  ScanBuffer: Array of Byte;
  data : COPYDATASTRUCT;
  reTurn: TStringList;
  hProcess: THandle;
begin
  hProcess := hProcess_osu;
  Str := StringReplace(Struct.Array_of_bytes, ' ', '', [rfReplaceAll]);
  StartAdr := Struct.Start;
  FinishAdr := Struct.Finish;
  Mask := GetMask(Str);
  SetLength(ScanBuffer, Length(Str) div 2);
  StringToArrayByte(Str, ScanBuffer);
  reTurn := TStringList.Create;
  while StartAdr <= FinishAdr - $1000 do
  begin
    VirtualQueryEx(hProcess, PDWORD(StartAdr), mbi, sizeof(mbi));
    if ((mbi.RegionSize > 0) and ((mbi.Type_9 = MEM_IMAGE) or
      (mbi.Type_9 = MEM_PRIVATE)) and (mbi.State = MEM_COMMIT) and
      ((mbi.Protect = PAGE_WRITECOPY) or (mbi.Protect = PAGE_EXECUTE_WRITECOPY)
      or (mbi.Protect = PAGE_EXECUTE_READWRITE) or
      (mbi.Protect = PAGE_READWRITE))) then
    begin
      SetLength(Buffer, 0);
      SetLength(Buffer, mbi.RegionSize);
      ReadProcessMemory(hProcess, mbi.BaseAddress, @Buffer[0], mbi.RegionSize, ASD);
      CompareArray(DWORD(mbi.BaseAddress), Buffer, ScanBuffer, Length(ScanBuffer), Mask, reTurn);
      StartAdr := DWORD(MBI.BaseAddress) + MBI.RegionSize;
      if return.Count <> 0 then
      begin
        Result := reTurn;
        Exit;
      end;
    end
    else
    begin
      StartAdr := DWORD(MBI.BaseAddress) + MBI.RegionSize;
    end;
  end;
  Result := reTurn;
end;
{$endregion}

{$region 'ReadDouble'}
function ReadMemoryDouble(Addr: DWORD): Double;
var
  value: Double;
  hProcess: THandle;
begin
try
  Result:= 0;
  hProcess := hProcess_osu;
  if (hProcess <> 0) then
  begin
    ReadProcessMemory(hProcess, Pointer(Addr), @value, 8, ASD);
    Result := value;
  end;
except
end;
end;
{$endregion}

{$region 'ReadFloat'}
function ReadMemoryFloat(Addr: DWORD): Single;
var
  value: Single;
  hProcess: THandle;
begin
try
  Result:= 0;
  hProcess := hProcess_osu;
  if (hProcess <> 0) then
  begin
    ReadProcessMemory(hProcess, Pointer(Addr), @value, 4, ASD);
    Result := value;
  end;
except
end;
end;
{$endregion}

{$region 'ReadDword'}
function ReadMemoryInt(Addr: DWORD): DWORD;
var
  value: Integer;
  hProcess: THandle;
begin
try
  Result:= 0;
  hProcess := hProcess_osu;
  if (hProcess <> 0) then
  begin
    ReadProcessMemory(hProcess, Pointer(Addr), @value, 4, ASD);
    Result := value;
  end;
except
end;
end;
{$endregion}

{$region 'ReadString'}
function ReadMemoryStr(Addr, Len: DWORD): string;
var str: widechar;
    i: integer;
    hProcess: THandle;
begin
try
  Result:= '';
  hProcess := hProcess_osu;
  if (hProcess <> 0) then
  begin
    for i := 0 to Len - 1 do
    begin
      ReadProcessMemory(hProcess, Pointer(Addr+i*2), @str, 2, ASD);
      Result := Result + string(str);
    end;
  end;
except
end;
end;
{$endregion}

{$region 'RPM - Get TimeOffset'}
function GetTimeOffset(): Integer;
var
  Arrays : TArrayScan;
begin
  if (DSiGetProcessID('osu!.exe') <> 0) then
  begin
    try
      Arrays.Start:= StrToInt('$00000000');
      Arrays.Finish:= StrToInt('$7FFFFFFF');
      Arrays.Array_of_bytes:= TimeOffset_AoB;
      Addr := ArrayScan(Arrays);
      //ShowMessage(Addr.Strings[0]);
    except;
    end;
    if (Addr.Count <> 0) then
      Result := StrToInt(Addr.Strings[0]) + TimeOffset_Ptr_1 // +$D
    else
      Result := 0;
  end
  else
    Result := 0;
end;
{$endregion}

{$region 'RPM - Get Current Status'}
function GetCurrentStatus(): Integer;
var
  Arrays : TArrayScan;
begin
  if (DSiGetProcessID('osu!.exe') <> 0) then
  begin
    try
      Arrays.Start:= StrToInt('$00000000');
      Arrays.Finish:= StrToInt('$7FFFFFFF');
      Arrays.Array_of_bytes:= Status_AoB;
      Addr := ArrayScan(Arrays);
      //ShowMessage(Addr.Strings[0]);
    except;
    end;
    if (Addr.Count <> 0) then
      Result := StrToInt(Addr.Strings[0]) + Status_Ptr_1 // +$1
    else
      Result := 0;
  end
  else
    Result := 0;
end;
{$endregion}

{$region 'RPM - Get InGameData'}
function GetInGameData(): Integer;
var
  Arrays : TArrayScan;
begin
  if (DSiGetProcessID('osu!.exe') <> 0) then
  begin
    try
      Arrays.Start:= StrToInt('$00000000');
      Arrays.Finish:= StrToInt('$7FFFFFFF');
      Arrays.Array_of_bytes:= InGameData_AoB;
      Addr := ArrayScan(Arrays);
      //ShowMessage(Addr.Strings[0]);
    except;
    end;
    if (Addr.Count <> 0) then
      Result := StrToInt(Addr.Strings[0]) + InGameData_Ptr_1 // +$1
    else
      Result := 0;
  end
  else
    Result := 0;
end;
{$endregion}

{$region 'RPM - Get RulesetInfo'}
function GetRulesetInfo(): Integer;
var
  Arrays : TArrayScan;
begin
  if (DSiGetProcessID('osu!.exe') <> 0) then
  begin
    try
      Arrays.Start:= StrToInt('$00000000');
      Arrays.Finish:= StrToInt('$7FFFFFFF');
      Arrays.Array_of_bytes:= RulesetInfo_AoB;
      Addr := ArrayScan(Arrays);
      //ShowMessage(Addr.Strings[0]);
    except;
    end;
    if (Addr.Count <> 0) then
      Result := StrToInt(Addr.Strings[0]) + RulesetInfo_Ptr_1
    else
      Result := 0;
  end
  else
    Result := 0;
end;
{$endregion}

{$region 'RPM - Get KeyInfo'}
function GetKeyInfo(): Integer;
var
  Arrays : TArrayScan;
begin
  if (DSiGetProcessID('osu!.exe') <> 0) then
  begin
    try
      Arrays.Start:= StrToInt('$00000000');
      Arrays.Finish:= StrToInt('$7FFFFFFF');
      Arrays.Array_of_bytes:= KeyInfo_AoB;
      Addr := ArrayScan(Arrays);
      //ShowMessage(Addr.Strings[0]);
    except;
    end;
    if (Addr.Count <> 0) then
      Result := StrToInt(Addr.Strings[0]) + KeyInfo_Ptr_1
    else
      Result := 0;
  end
  else
    Result := 0;
end;
{$endregion}

function GetCurrentMods(RulesetInfo_Base: Cardinal): Mods;
var
  Value: Integer;
  Key, Data: Integer;
begin
  try
    Value := ReadMemoryInt(ReadMemoryInt(RulesetInfo_Base));
    Value := ReadMemoryInt(Value + ScoreManager_Base_Ptr);
    Value := ReadMemoryInt(Value + ScoreManager_Base_Mods);
    Key := ReadMemoryInt(Value + ScoreManager_Base_Mods_Key);
    Data := ReadMemoryInt(Value + ScoreManager_Base_Mods_Data);
    Result := Mods(Data xor Key);
  except
    Result := Mods.Unknown;
  end;
end;

function HasMod(RulesetInfo_Base: Cardinal; PlayMod: Mods): Boolean;
begin
  Result := CompareMod(GetCurrentMods(RulesetInfo_Base), PlayMod);
end;

function CompareMod(Mod1, Mod2: Mods): Boolean;
begin
  Result := (Integer(Mod1) and Integer(Mod2)) > 0;
end;

function GetCurrentHP(RulesetInfo_Base: Cardinal): Double;
begin
  Result := ReadMemoryDouble(ReadMemoryInt(ReadMemoryInt(ReadMemoryInt(RulesetInfo_Base)) + GameDataManager_Base_Ptr) + GameDataManager_Base_HP);
end;

{$region 'GetOsuPath'}
function GetOsuPath: String;
var
  Path: array[0..MAX_PATH] of Char;
begin
  if SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, Path) = S_OK then
  begin
    Result := IncludeTrailingPathDelimiter(Path) + 'osu!\';
    //ShowMessage(Result);
  end
  else
    Result := '';
end;
{$endregion}

{$region 'SleepWithNoFreeze'}
function SleepEx(delay: dword) : dword;
var Elapsed, Start: DWORD;
begin;
  Start := GetTickCount;
  Elapsed := 0;
  repeat
    if MsgWaitForMultipleObjects(0, Pointer(nil)^, FALSE, delay-Elapsed, QS_ALLINPUT) <> WAIT_OBJECT_0 then Break;
    Application.ProcessMessages;
    Elapsed := GetTickCount - Start;
  until Elapsed >= delay;
end;
{$endregion}

function LoadResourceFontByID(ResourceID : Integer; ResType: PChar): Boolean;
var
  ResStream : TResourceStream;
  FontsCount : DWORD;
begin
  ResStream := TResourceStream.CreateFromID(hInstance, ResourceID, ResType);
  try
    Result := (AddFontMemResourceEx(ResStream.Memory, ResStream.Size, nil, @FontsCount) <> 0);
  finally
    ResStream.Free;
  end;
end;

function LoadResourceFontByName(const ResourceName : string; ResType: PChar): Boolean;
var
  ResStream : TResourceStream;
  FontsCount : DWORD;
begin
  ResStream := TResourceStream.Create(hInstance, ResourceName, ResType);
  try
    Result := (AddFontMemResourceEx(ResStream.Memory, ResStream.Size, nil, @FontsCount) <> 0);
  finally
    ResStream.Free;
  end;
end;

end.
