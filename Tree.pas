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
  result^:=CreateElement(0, C_modul, 0);
end;

function trAddElement;
var tempLen: Integer;
    addedElement: tRec;
begin
  addedElement:=CreateElement(fLevel, fConstr, fAmount);
  tempLen := Length(ptNode^.fInternal);
  SetLength(ptNode^.fInternal, tempLen+1);
  New(ptNode^.fInternal[tempLen]);
  ptNode^.fInternal[tempLen]^:=addedElement;
  result:=ptNode^.fInternal[tempLen];
end;

end.

