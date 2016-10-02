unit UsesUnit;

interface

type
  TConstructionType = (C_modul, C_other, c_if, c_switch, c_precycle, c_postcycle, c_operation, c_go);
  pTRec = ^tRec;
  TInternalConstr = array of pTRec;
  tRec = record
    fLevel: Integer;
    fConstr: TConstructionType;
    fAmount: Integer;
    fInternal: TInternalConstr;
    fGran: integer;
  end;
  tMetrixRec = record
    fCond: integer;
    fOper: integer;
    fLevel: integer;
  end;

const
  COperationsUsed: array[0..6] of string = ('=', '+=', '-=', '*=', '/=', '++', '--');
  CIDsOfOperations: array[0..6] of string = ('if', 'switch', 'for', 'while', 'do', 'break', 'continue'); //строки, которые соответвуют TConstructionType;
  MS_NO_TEXR_FILE: string = 'Файл не выбран!';
  CONDITION_CONSTR: set of TConstructionType = [c_if, c_switch, c_precycle, c_postcycle];

implementation

end.

