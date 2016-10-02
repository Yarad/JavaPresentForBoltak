unit ConstrFunctions;

interface

uses UsesUnit, Classes;

function cfDecodeString(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings): boolean;
procedure cfIf_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
procedure cfSwitch_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
procedure cfPreCycle_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
procedure cfPostCycle_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
function GetStringFromMemo(const memoPos: integer; const memoCode: TStrings): string;

implementation

uses Tree, ParseAndRecognise;

function GetStringFromMemo(const memoPos: integer; const memoCode: TStrings): string;
begin
  result:=memoCode[memoPos];
end;

procedure cfDefineTypeOfExpression(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings; const expression: TConstructionType);
begin
  case expression of
    c_if: cfIf_Operate(memoPos, ptNode, memoCode);
    c_switch: cfSwitch_Operate(memoPos, ptNode, memoCode);
    c_precycle: cfPreCycle_Operate(memoPos, ptNode, memoCode);
    c_postcycle: cfPostCycle_Operate(memoPos, ptNode, memoCode);
  end;
end;

function cfDecodeString(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings): boolean;
var tempStr: string;
    constrType: TConstructionType;
begin
  result:=false;
  tempStr:=GetStringFromMemo(memoPos, memoCode);
  constrType:=RecogniseOperation(tempStr);
  if (constrType in [c_Operation, c_modul, C_other, C_go])
  then result:=true;
  if (constrType=C_go)
  then inc(ptNode^.fAmount);
  if constrType=c_Operation
  then ptNode^.fAmount:=ptNode^.fAmount+AmountOfOperations(tempStr)
  else cfDefineTypeOfExpression(memoPos, ptNode, memoCode, constrType);
end;

function cfDefineEndSymbol(const memoPos: integer; const memoCode: TStrings; findSymb, thenSymb, elseSymb: string): string;
begin
  if pos(findSymb, GetStringFromMemo(memoPos, memoCode))<>0
  then result:=thenSymb
  else result:=elseSymb;
end;

procedure cfCycleFindOperationsUntilFoundEndSymbol(const endIfSign: string; var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
var logic: boolean;
begin
  logic:=true;
  repeat
    if logic
    then inc(memoPos);
    logic:=cfDecodeString(memoPos, ptNode, memoCode);
  until pos(endIfSign, GetStringFromMemo(memoPos, memoCode))<>0;
end;

procedure cfCycleLoopUntilFoundEndSymbol(const endIfSign: string; var memoPos: integer; const memoCode: TStrings);
begin
  while pos(endIfSign, GetStringFromMemo(memoPos, memoCode))=0
  do inc(memoPos);
end;

procedure cfCycleFindOperationsInSwitch(const endIfSign1, endIfSign2, endIfSign3: string; var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
var tempStr: string;
    logic: boolean;
begin
  logic:=true;
  repeat
    if logic
    then inc(memoPos);
    logic:=cfDecodeString(memoPos, ptNode, memoCode);
    tempStr:=GetStringFromMemo(memoPos+1, memoCode);
  until (pos(endIfSign1, tempStr)<>0) or (pos(endIfSign2, tempStr)<>0) or (pos(endIfSign3, tempStr)<>0);
end;

procedure cfIf_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
var ptCurNode: ptRec;
    logic: boolean;
begin
  logic:=true;
  ptCurNode:=trAddElement(ptNode, ptNode^.fLevel+1, c_if);
  inc(memoPos);
  if cfDefineEndSymbol(memoPos, memoCode, '{', '}', ';')='}'
  then cfCycleFindOperationsUntilFoundEndSymbol('}', memoPos, ptCurNode, memoCode)
  else logic:=cfDecodeString(memoPos, ptCurNode, memoCode);
  if logic
  then inc(memoPos);
  if pos('else', GetStringFromMemo(memoPos, memoCode))<>0
  then begin
    inc(memoPos);
    if cfDefineEndSymbol(memoPos, memoCode, '{', '}', ';')='}'
    then cfCycleFindOperationsUntilFoundEndSymbol('}', memoPos, ptCurNode, memoCode)
    else logic:=cfDecodeString(memoPos, ptCurNode, memoCode);
    if logic
    then inc(memoPos);
  end;
end;

procedure cfSwitch_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
var ptCurNode: ptRec;
    subTreeCount, curMemoPos: integer;
    tempStr: string;
begin
  curMemoPos:=memoPos;
  subTreeCount:=0;
  repeat
    inc(curMemoPos);
    tempStr:=GetStringFromMemo(curMemoPos, memoCode);
    if (pos('case', tempStr)<>0) or (pos('default', tempStr)<>0)
    then inc(subTreeCount);
  until pos('}', tempStr)<>0;
  memoPos:=memoPos+2;
  if subTreeCount>0
  then begin
    ptCurNode:=trAddElement(ptNode, ptNode^.fLevel+1, c_switch);
    repeat
      cfCycleFindOperationsInSwitch('case', 'default', '}', memoPos, ptCurNode, memoCode);
      if subTreeCount>2
      then begin
        dec(subTreeCount);
        ptCurNode:=trAddElement(ptCurNode, ptCurNode^.fLevel+1, ptCurNode^.fConstr);
      end;
      inc(memoPos);
    until pos('}', GetStringFromMemo(memoPos, memoCode))<>0;
  end
  else cfCycleLoopUntilFoundEndSymbol('}', memoPos, memoCode);
  inc(memoPos);
end;

procedure cfPreCycle_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
var ptCurNode: ptRec;
begin
  ptCurNode:=trAddElement(ptNode, ptNode^.fLevel+1, c_precycle);
  cfCycleFindOperationsUntilFoundEndSymbol('}', memoPos, ptCurNode, memoCode);
  inc(memoPos);
end;

procedure cfPostCycle_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
var ptCurNode: ptRec;
begin
  ptCurNode:=trAddElement(ptNode, ptNode^.fLevel+1, c_postcycle);
  cfCycleFindOperationsUntilFoundEndSymbol('}', memoPos, ptCurNode, memoCode);
  memoPos:=memoPos+2;
end;

end.

