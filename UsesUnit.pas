unit UsesUnit;

interface

type
  TConstructionType = (C_modul, C_other, c_if, c_switch, c_cycle, c_Operation);

  pTRec = ^tRec;

  TInternalConstr = array of pTRec;

  tRec = record
    fLevel: Integer;
    fConstr: TConstructionType;
    fAmount: Integer;
    fInternal: TInternalConstr;
  end;

const
  CArrayOperators: array[0..4] of string = ('=', '+=', '-=', '*=', '/=');

function CreateElement(fLevel: Integer; fConstr: TConstructionType;fAmount: Integer = 0): tRec;

implementation

function CreateElement;
begin
  Result.fLevel := fLevel;
  Result.fConstr := fConstr;
  Result.fAmount := fAmount;
end;

end.

