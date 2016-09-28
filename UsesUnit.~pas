unit UsesUnit;

interface

type
  TConstructionType = (C_modul, C_comment, C_other, c_if, c_case, c_for, c_WhileDo, c_DoWhile);

  pTRec = ^tRec;

  TInternalConstr = array of pTRec;

  tRec = record
    fLevel: Integer;
    fConstr: TConstructionType;
    fAmount: Integer;
    fInternal: TInternalConstr;
  end;

function CreateElement(fLevel: Integer; fConstr: TConstructionType;fAmount: Integer = 0): tRec;

implementation

function CreateElement;
begin
  Result.fLevel := fLevel;
  Result.fConstr := fConstr;
  Result.fAmount := fAmount;
end;

end.

