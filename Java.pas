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
    memoResult: TMemo;
    procedure aLoadCodeExecute(Sender: TObject);
  private
    tree: ptRec;
    procedure CalcMetriks(const fileName: string);
    procedure LoadTextAndDecode(const fileName: string);
    procedure CreateTreeFromCode(memoCode: TMemo);
    procedure CalcAndShowJilbMetrix;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses OtherFunctions, ConstrFunctions, Metrix, Tree;

procedure TfrmMain.aLoadCodeExecute(Sender: TObject);
begin
  if dlgFileOpen.Execute
  then begin
    trDeleteTree(tree);
    CalcMetriks(dlgFileOpen.Files[0]);
  end;
end;

procedure TfrmMain.LoadTextAndDecode(const fileName: string);
var tempStr: string;
begin
  memoSource.Lines.BeginUpdate;
  memoSource.Lines.Clear;
  LoadTextFromFileToMemo(fileName, memoSource);
  ofDeleteFiguresFromText(memoSource);
  memoSource.Lines.EndUpdate;
  tempStr:=memoSource.Lines.Text;
  ofDeleteComments(tempStr);
  memoCode.Lines.BeginUpdate;
  memoCode.Lines.Clear;
  memoCode.Lines.Text:=tempStr;
  memoCode.Lines.Text:=trim(memoCode.Lines.Text);
  memoCode.Lines.EndUpdate;
end;

procedure TfrmMain.CalcAndShowJilbMetrix;
var jilbM: tMetrixRec;
    absGran: integer;
begin
  jilbM.fCond:=0;
  jilbM.fOper:=0;
  jilbM.fLevel:=0;
  mtrJilb(tree, jilbM);
  memoResult.Lines.Add('Результаты метрики Джилба'+#13#10+'CL = '+IntToStr(jilbM.fCond)+#13#10+'cl = '+ofConvertRealToString(jilbM.fCond/jilbM.fOper)+' ('+IntToStr(jilbM.fCond)+'/'+IntToStr(jilbM.fOper)+')'+#13#10+'CLI = '+IntToStr(jilbM.fLevel)+#13#10+#13#10);
  mtrCalcGranichnuy(tree);
  absGran:=0;
  mtrGran(tree, absGran);
  memoResult.Lines.Add('Результаты метрики граничных значений'+#13#10+'Абсолютная граничная сложность = '+IntToStr(absGran)+#13#10+'Относительная граничная сложность = '+ofConvertRealToString(1-(jilbM.fOper+1)/absGran)+' (1 - ('+IntToStr(jilbM.fOper+2)+'-1)/'+IntToStr(absGran)+')');
end;

procedure TfrmMain.CalcMetriks(const fileName: string);
begin
  LoadTextAndDecode(fileName);
  CreateTreeFromCode(memoCode);
  memoResult.Lines.BeginUpdate;
  memoResult.Lines.Clear;
  CalcAndShowJilbMetrix;
  memoResult.Lines.EndUpdate;
end;

procedure TfrmMain.CreateTreeFromCode(memoCode: TMemo);
var memoPos: integer;
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
