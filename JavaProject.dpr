program JavaProject;

uses
  Forms,
  Java in 'Java.pas' {frmMain},
  UsesUnit in 'UsesUnit.pas',
  Tree in 'Tree.pas',
  ConstrFunctions in 'ConstrFunctions.pas',
  OtherFunctions in 'OtherFunctions.pas',
  ParseAndRecognise in 'ParseAndRecognise.pas',
  Metrix in 'Metrix.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
