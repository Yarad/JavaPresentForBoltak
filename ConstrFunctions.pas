unit ConstrFunctions;

interface

uses UsesUnit, Classes;

procedure cfDecodeString(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
procedure cfIf_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
procedure cfSwitch_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
procedure cfCycle_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
function GetStringFromMemo(const memoPos: integer; const memoCode: TStrings): string;

implementation

uses Tree;

function GetStringFromMemo(const memoPos: integer; const memoCode: TStrings): string;
begin
  result:=memoCode[memoPos];
end;

procedure cfDefineTypeOfExpression(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings; const expression: TConstructionType);
begin
  case expression of
    c_if: cfIf_Operate(memoPos, ptNode, memoCode);
    c_switch: cfSwitch_Operate(memoPos, ptNode, memoCode);
    c_cycle: cfCycle_Operate(memoPos, ptNode, memoCode);
  end;
end;

procedure cfDecodeString(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
var tempStr: string;
    constrType: TConstructionType;
begin
  tempStr:=GetStringFromMemo(memoPos, memoCode);
  constrType:=RecogniseOperation(tempStr);
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
begin
  repeat
    inc(memoPos);
    cfDecodeString(memoPos, ptNode, memoCode);
  until pos(endIfSign, GetStringFromMemo(memoPos, memoCode))<>0;
end;

procedure cfIf_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
var endIfSign: string;
    ptCurNode: ptRec;
begin
  ptCurNode:=trAddElement(ptNode, ptNode^.fLevel+1, c_if);
  endIfSign:=cfDefineEndSymbol(memoPos+1, memoCode, '{', '}', ';');
  cfCycleFindOperationsUntilFoundEndSymbol(endIfSign, memoPos, ptCurNode, memoCode);
  if pos('else', GetStringFromMemo(memoPos+1, memoCode))<>0
  then begin
    endIfSign:=cfDefineEndSymbol(memoPos+1, memoCode, '{', '}', ';');
    cfCycleFindOperationsUntilFoundEndSymbol(endIfSign, memoPos, ptCurNode, memoCode);
  end;
  inc(memoPos);
end;

procedure cfSwitch_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
var ptCurNode: ptRec;
    subTreeCount, figureLevel, curMemoPos: integer;
    tempStr: string;
begin
  curMemoPos:=memoPos;
  repeat
    inc(curMemoPos);
    tempStr:=GetStringFromMemo(curMemoPos, memoCode);
    if (pos('case', tempStr)<>0) or (pos('default', tempStr)<>0)
    then inc(subTreeCount);
    if pos('{', tempStr)<>0
    then inc(figureLevel);
    if pos('}', tempStr)<>0
    then dec(figureLevel);
  until (pos('}', tempStr)<>0) and (figureLevel=-1);
  inc(memoPos);
  ptCurNode:=trAddElement(ptNode, ptNode^.fLevel+1, c_if);
  repeat
    if pos('case', GetStringFromMemo(memoPos, memoCode))<>0
    then begin
      cfCycleFindOperationsUntilFoundEndSymbol('break', memoPos, ptCurNode, memoCode);
      if subTreeCount>2
      then begin
        dec(subTreeCount);
        ptCurNode:=trAddElement(ptCurNode, ptCurNode^.fLevel+1, ptCurNode^.fConstr);
      end;
    end;
    inc(memoPos);
  until pos('}', GetStringFromMemo(memoPos, memoCode))<>0;
  inc(memoPos);
end;

procedure cfCycle_Operate(var memoPos: integer; var ptNode: pTRec; const memoCode: TStrings);
var ptCurNode: ptRec;
begin
  ptCurNode:=trAddElement(ptNode, ptNode^.fLevel+1, c_cycle);
  cfCycleFindOperationsUntilFoundEndSymbol('}', memoPos, ptCurNode, memoCode);
  inc(memoPos);
end;

end.

