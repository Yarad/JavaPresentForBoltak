unit Tree;

interface

uses
  usesUnit;

function CreateElement(fLevel: Integer; fConstr: TConstructionType; fAmount: Integer = 0): tRec;
function trCreateRoot: ptRec;
procedure trDeleteTree(var ptNode: ptRec);
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

procedure trDeleteTree(var ptNode: ptRec);
var tempPT: ptRec;
    count: integer;
begin
  tempPT:=ptNode;
  if tempPT<>nil
  then begin
    for count:=0 to Length(tempPT^.fInternal)-1
    do
      trDeleteTree(tempPT^.fInternal[count]);
    Dispose(tempPT);
  end;
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

