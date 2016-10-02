unit ParseAndRecognise;

interface

uses
  UsesUnit, Classes;

function AmountOfOperations(const s: string): Integer; //кол-во операций в строке
function RecogniseOperation(const Input: string): TConstructionType;

implementation

function ConvertStrToType(const s: string): TConstructionType; //ставит в соответствие 'if'-строке тип C_if
begin
  if s = 'if' then
  begin
    Result := c_if;
    Exit;
  end;
  if s = 'switch' then
  begin
    Result := c_switch;
    Exit;
  end;
  if (s = 'while') or (s = 'for') then
  begin
    Result := c_precycle;
    Exit;
  end;
  if (s = 'do') then
  begin
    Result := c_postcycle;
    Exit;
  end;
  if (s = 'break') or (s = 'continue') then
  begin
    Result := c_go;
    Exit;
  end;
end;

function RecogniseOperation;
var
  i, FoundPos: Integer;
  NextSymbolAfterID: Char; // символ после ключевого слова, котрое мы ищем

begin
  Result := C_other;    //<-если ничего не найдём

  for i := Low(CIDsOfOperations) to High(CIDsOfOperations) do
  begin
    FoundPos := Pos(CIDsOfOperations[i], Input);
    if FoundPos <> 0 then
      NextSymbolAfterID := Input[FoundPos + Length(CIDsOfOperations[i])];
    if (FoundPos <> 0) and ((FoundPos + Length(CIDsOfOperations[i]) - 1 = Length(Input)) or (NextSymbolAfterID = ' ') or (NextSymbolAfterID = '(') or (NextSymbolAfterID = ';')) and ((FoundPos = 1) or (Input[FoundPos - 1] = ' ')) then
    begin
      Result := ConvertStrToType(CIDsOfOperations[i]);
      Exit;
    end;
  end;
  
  //если ничего не нашли, то ищем операцию
  for i := Low(COperationsUsed) to High(COperationsUsed) do
  begin
    FoundPos := Pos(COperationsUsed[i], Input);
    if (FoundPos <> 0) then
    begin
      Result := c_operation;
      Exit;
    end;
  end;

end;

function AmountOfOperations;
var
  i, Oper: Integer;
  UnParsedString: string;
begin
  Result := 0;
  UnParsedString := s;
  for Oper := 0 to High(COperationsUsed) do
    repeat
      i := Pos(COperationsUsed[Oper], UnParsedString);

      if i <> 0 then //если нашли
      begin
        Inc(Result);
        Delete(UnParsedString, i, Length(COperationsUsed[Oper]));
      end

    until i = 0
end;

end.

 
