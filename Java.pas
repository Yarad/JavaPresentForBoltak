unit Java;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, UsesUnit;

type
  TfrmMain = class(TForm)
    memoCode: TMemo;
    btnLoadText: TButton;
    lbFileNameChosen: TLabel;
    dlgFileOpen: TOpenDialog;
    alMain: TActionList;
    aLoadCode: TAction;
    procedure aLoadCodeExecute(Sender: TObject);
  private
    procedure CalcMetriks(const fileName: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses OtherFunctions, ConstrFunctions;

procedure TfrmMain.aLoadCodeExecute(Sender: TObject);
begin
  if dlgFileOpen.Execute
  then CalcMetriks(dlgFileOpen.Files[0]);
end;

procedure TfrmMain.CalcMetriks(const fileName: string);
var tempStr: string;
begin
  memoCode.Lines.BeginUpdate;
  memoCode.Lines.Clear;
  LoadTextFromFileToMemo(fileName, memoCode);
  tempStr:=memoCode.Lines.Text;
  ofDeleteComments(tempStr);
  memoCode.Lines.Text:=tempStr;
  memoCode.Lines.EndUpdate;
end;

end.
