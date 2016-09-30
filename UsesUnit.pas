unit UsesUnit;

interface

type
  TConstructionType = (C_modul, C_other, c_if, c_switch, c_cycle, c_operation, c_go);

  pTRec = ^tRec;

  TInternalConstr = array of pTRec;

  tRec = record
    fLevel: Integer;
    fConstr: TConstructionType;
    fAmount: Integer;
    fInternal: TInternalConstr;
  end;

const
  COperationsUsed: array[0..6] of string = ('=', '+=', '-=', '*=', '/=', '++', '--');
  CIDsOfOperations: array[0..6] of string = ('if', 'switch', 'for', 'while', 'do', 'break', 'continue'); //строки, которые соответвуют TConstructionType;
  MS_NO_TEXR_FILE: string = 'Файл не выбран!';

function CreateElement(fLevel: Integer; fConstr: TConstructionType;fAmount: Integer = 0): tRec;

implementation

function CreateElement;
begin
  Result.fLevel := fLevel;
  Result.fConstr := fConstr;
  Result.fAmount := fAmount;
end;

end.

