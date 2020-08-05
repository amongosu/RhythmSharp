program RhythmSharp;





{$R *.dres}

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmMain},
  Vcl.Themes,
  Vcl.Styles,
  DSiWin32 in 'DSiWin32.pas',
  RoKo_Lib in 'RoKo_Lib.pas',
  Offset in 'Offset.pas',
  TaskEditor in 'TaskEditor.pas' {frmTaskEditor},
  ScheduleEditor in 'ScheduleEditor.pas' {frmScheduleEditor},
  Misc in 'Misc.pas',
  WinHttp_TLB in 'WinHttp_TLB.pas',
  Discord in 'Discord.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Light');
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmTaskEditor, frmTaskEditor);
  Application.CreateForm(TfrmScheduleEditor, frmScheduleEditor);
  Application.Run;
end.
