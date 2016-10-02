unit Metrix;

interface

uses UsesUnit;

procedure mtrJilb(node: ptRec; var metrRes: tMetrixRec);
procedure mtrGran(node: ptRec; var absGarn: integer);
procedure mtrCalcGranichnuy(node: ptRec);

implementation

procedure mtrJilb(node: ptRec; var metrRes: tMetrixRec);
var count: integer;
begin
  if node<>nil
  then begin
    if (node^.fConstr in CONDITION_CONSTR)
    then inc(metrRes.fCond);
    metrRes.fOper:=metrRes.fOper+node^.fAmount;
    if (node^.fConstr <> c_modul)
    then inc(metrRes.fOper);
    if (metrRes.fLevel < node^.fLevel)
    then metrRes.fLevel:=node^.fLevel;
    for count:=0 to Length(node^.fInternal)-1
    do mtrJilb(node^.fInternal[count], metrRes);
  end;
end;

procedure mtrGran(node: ptRec; var absGarn: integer);
var count: integer;
begin
  if node<>nil
  then begin
    for count:=0 to Length(node^.fInternal)-1
    do
      mtrGran(node^.fInternal[count], absGarn);
    absGarn:=absGarn+node^.fGran+node^.fAmount;
  end;
end;

function mtrCalcEveryGran(node: ptRec): integer;
var count: integer;
begin
  result:=0;
  if node<>nil
  then begin
    for count:=0 to Length(node^.fInternal)-1
    do
      result:=result+mtrCalcEveryGran(node^.fInternal[count]);
    result:=result+node^.fAmount;
    if (node^.fConstr = c_modul)
    then result:=0;
    inc(result);
    node^.fGran:=result;
    if (node^.fConstr in [c_precycle, c_postcycle])
    then inc(node^.fGran);
  end;
end;

procedure mtrCalcGranichnuy(node: ptRec);
begin
  mtrCalcEveryGran(node);
end;

end.
