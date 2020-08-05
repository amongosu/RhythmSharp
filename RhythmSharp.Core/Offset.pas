unit Offset;

interface

var
  arr_keycodes: array of byte;

type Mods = (
  NoMod = 0,
  NoFail = 1 shl 0,
  Easy = 1 shl 1,
  TouchDevice = 1 shl 2,
  Hidden = 1 shl 3,
  HardRock = 1 shl 4,
  SuddenDeath = 1 shl 5,
  DoubleTime = 1 shl 6,
  Relax = 1 shl 7,
  HalfTime = 1 shl 8,
  Nightcore = 1 shl 9,
  Flashlight = 1 shl 10,
  Autoplay = 1 shl 11,
  SpunOut = 1 shl 12,
  AutoPilot = 1 shl 13,
  Perfect = 1 shl 14,
  Key4 = 1 shl 15,
  Key5 = 1 shl 16,
  Key6 = 1 shl 17,
  Key7 = 1 shl 18,
  Key8 = 1 shl 19,
  FadeIn = 1 shl 20,
  Random = 1 shl 21,
  Cinema = 1 shl 22,
  Target = 1 shl 23,
  Key9 = 1 shl 24,
  KeyCoop = 1 shl 25,
  Key1 = 1 shl 26,
  Key3 = 1 shl 27,
  Key2 = 1 shl 28,
  ScoreV2 = 1 shl 29,
  Mirror = 1 shl 30,
  Unknown = $FFFFFFFF
);

//keys
const byte_1k : Byte = $20;
const arr_4k : array[0..3] of byte = ($44, $46, $4A, $4B);
const arr_5k : array[0..4] of byte = ($44, $46, $20, $4A, $4B);
const arr_6k : array[0..5] of byte = ($53, $44, $46, $4A, $4B, $4C);
const arr_7k : array[0..6] of byte = ($53, $44, $46, $20, $4A, $4B, $4C);
const arr_8k : array[0..7] of byte = ($A0, $53, $44, $46, $20, $4A, $4B, $4C);
const arr_9k : array[0..8] of byte = ($41, $53, $44, $46, $20, $4A, $4B, $4C, $BA);

const arr_4k_fake : array[0..3] of byte = ($45, $52, $55, $49); //ERUI
const arr_5k_fake : array[0..4] of byte = ($44, $46, $20, $4A, $4B);
const arr_6k_fake : array[0..5] of byte = ($53, $44, $46, $4A, $4B, $4C);
const arr_7k_fake : array[0..6] of byte = ($53, $44, $46, $20, $4A, $4B, $4C);
const arr_8k_fake : array[0..7] of byte = ($A0, $53, $44, $46, $20, $4A, $4B, $4C);
const arr_9k_fake : array[0..8] of byte = ($41, $53, $44, $46, $20, $4A, $4B, $4C, $BA);

//current status
const Status_AoB = 'A1 ?? ?? ?? ?? A3 ?? ?? ?? ?? A1 ?? ?? ?? ?? A3 ?? ?? ?? ?? 83 3D ?? ?? ?? ?? 00 0F 84 ?? ?? ?? ?? B9 ?? ?? ?? ?? E8';
const Status_Ptr_1 = $1;

//current timing
const TimeOffset_AoB = 'EB 0A A1 ?? ?? ?? ?? A3';
const TimeOffset_Ptr_1 = $D;

//ingame data
const InGameData_AoB = '33 D2 A1 ?? ?? ?? ?? 85 C0';
const InGameData_Ptr_1 = $3;
const HitObjectManager_Ptr = $40;

//RulesetInfo
const RulesetInfo_AoB = '73 7A 8B 0D ?? ?? ?? ?? 85 C9 74 1F';
const RulesetInfo_Ptr_1 = $4;

//Key Info
const KeyInfo_AoB = '83 C4 10 8D 15 ?? ?? ?? ?? E8 ?? ?? ?? ?? 5D C3';
const KeyInfo_Ptr_1 = $5;

//KeyManager <KeyInfo>
const KeyManager_Base_Ptr = $18;
const KeyManager_Base_KeyTable_Size = $8;
const KeyManager_Base_KeyTable_Binding_Ptr_1 = $4;
const KeyManager_Base_KeyTable_Binding_Ptr_2 = $4;
const KeyManager_Base_KeyTable_Binding_Ptr_3 = $8;
const KeyManager_Base_KeyTable_Binding_Ptr_4 = $4; //and binding exists...
const KeyManager_Base_KeyTable_Binding_Keys = $8;
const KeyManager_Base_KeyTable_Binding_KeyCode_Size = $4;

//ScoreManager <RulesetInfo>
const ScoreManager_Base_Ptr = $38;
const ScoreManager_Base_Mods = $1C;
const ScoreManager_Base_Mods_Key = $8;
const ScoreManager_Base_Mods_Data = $C;

//GameDataManager <RulesetInfo>
const GameDataManager_Base_Ptr = $40;
const GameDataManager_Base_HP = $1C; //double

//HeaderManager <ingame data>
const HeaderManager_Base_Ptr = $30;
const HeaderManager_Base_CircleSize_Ptr = $30;
const HeaderManager_Base_BeatmapPath2_Ptr = $8C;
const HeaderManager_Base_BeatmapPath2_Length_Ptr = $4;
const HeaderManager_Base_BeatmapPath2_String_Ptr = $8;

//HitObjectManager <ingame data>
const HitObjectManager_Base_Ptr = $48;
const HitObjectManager_Base_List_Ptr = $4;
const HitObjectManager_Base_List_TimeStart_Ptr = $10;
const HitObjectManager_Base_List_TimeEnd_Ptr = $14;
const HitObjectManager_Base_List_Key_Ptr = $9C;
const HitObjectManager_Base_Length_Ptr = $C;

implementation


end.
