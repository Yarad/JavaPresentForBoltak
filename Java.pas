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
    procedure LoadTextAndDecode(const fileName: string);
    procedure CreateTreeFromCode(memoCode: TMemo);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses OtherFunctions, ConstrFunctions, Tree;

procedure TfrmMain.aLoadCodeExecute(Sender: TObject);
begin
  if dlgFileOpen.Execute
  then CalcMetriks(dlgFileOpen.Files[0]);
end;

procedure TfrmMain.LoadTextAndDecode(const fileName: string);
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

procedure TfrmMain.CalcMetriks(const fileName: string);
begin
  LoadTextAndDecode(fileName);
  CreateTreeFromCode(memoCode);
end;

procedure TfrmMain.CreateTreeFromCode(memoCode: TMemo);
var memoPos: integer;
    tree: ptRec;
begin
  tree:=trCreateRoot;
  memoPos:=0;
  while (memoPos<memoCode.Lines.Count)
  do begin
    if cfDecodeString(memoPos, tree, memoCode.Lines)
    then inc(memoPos);
  end;
end;

end.
