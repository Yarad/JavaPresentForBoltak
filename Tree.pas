unit Tree;

interface

uses
  usesUnit;

function CreateElement(fLevel: Integer; fConstr: TConstructionType; fAmount: Integer = 0): tRec;
function trCreateRoot: ptRec;
function trAddElement(const ptNode: pTRec; fLevel: Integer; fConstr: TConstructionType; fAmount: Integer = 0): pTRec;

implementation

uses SysUtils;

function CreateElement;
begin
  Result.fLevel := fLevel;
  Result.fConstr := fConstr;
  Result.fAmount := fAmount;
end;

function trCreateRoot;
begin
  New(result);
  result^:=CreateElement(-1, C_modul, 0);
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

