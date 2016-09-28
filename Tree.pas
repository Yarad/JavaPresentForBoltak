unit Tree;

interface

uses
  usesUnit;

function trCreateRoot: ptRec;
function trAddElement(const ptNode: pTRec; var AddedElement: tRec): pTRec;

implementation

function trCreateRoot;
begin
  New(result);
  CreateElement(0, C_modul);
end;

function trAddElement;
var tempLen: Integer;
begin
  tempLen := Length(ptNode^.fInternal);
  SetLength(ptNode^.fInternal, tempLen+1);
  ptNode^.fInternal[tempLen]:=@AddedElement;
end;

end.

