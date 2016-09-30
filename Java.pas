unit Java;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, UsesUnit;

type
  TfrmMain = class(TForm)
    memoSource: TMemo;
    btnLoadText: TButton;
    dlgFileOpen: TOpenDialog;
    alMain: TActionList;
    aLoadCode: TAction;
    memoCode: TMemo;
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
  memoSource.Lines.BeginUpdate;
  memoSource.Lines.Clear;
  LoadTextFromFileToMemo(fileName, memoSource);
  memoSource.Lines.EndUpdate;
  tempStr:=memoSource.Lines.Text;
  ofDeleteComments(tempStr);
  memoCode.Lines.BeginUpdate;
  memoCode.Lines.Clear;
  memoCode.Lines.Text:=tempStr;
  memoCode.Lines.Text:=trim(memoCode.Lines.Text);
  ofDeleteFiguresFromText(memoCode);
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
