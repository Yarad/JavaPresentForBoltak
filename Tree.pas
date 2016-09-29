unit Tree;

interface

uses
  usesUnit;

function trCreateRoot: ptRec;
function trAddElement(const ptNode: pTRec; fLevel: Integer; fConstr: TConstructionType; fAmount: Integer = 0): pTRec;

implementation

function trCreateRoot;
begin
  New(result);
  CreateElement(0, C_modul);
end;

function trAddElement;
var tempLen: Integer;
    addedElement: tRec;
begin
  addedElement:=CreateElement(fLevel, fConstr, fAmount);
  tempLen := Length(ptNode^.fInternal);
  SetLength(ptNode^.fInternal, tempLen+1);
  ptNode^.fInternal[tempLen]:=@AddedElement;
  result:=ptNode^.fInternal[tempLen];
end;

end.

