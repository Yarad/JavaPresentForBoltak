unit ParseAndRecognise;

interface

uses
  UsesUnit, Classes;

function AmountOfOperations(const s: string): Integer; //кол-во операций в строке

function RecogniseOperation(const Input: string): TConstructionType;

function ConvertStrToType(const s: string): TConstructionType; //ставит в соответствие 'if'-строке тип C_if


procedure DeleteComments(var Input: TStrings);

implementation

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

function ConvertStrToType;
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
  if (s = 'while') or (s = 'for') or (s = 'do') then
  begin
    Result := c_cycle;
    Exit;
  end;

  if (s = 'break') or (s = 'continue') then
  begin
    Result := c_go;
    Exit;
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

procedure DeleteComments;
var
  CommentPosB, CommentPosE, CommentStrB, CommentStrE, i: Integer;
  TempStr: string;
begin
  i := 0;
  while i < Input.Capacity do   //возможно, нужно уменьшить на 1
  begin
     //1. Удаление однострочного комментария
    CommentPosB := Pos('//', Input[i]);
    if i <> 0 then
    begin
      TempStr := Input.Strings[i];
      Delete(TempStr, CommentPosB, Length(Input.Strings[i]) - CommentPosB + 1);
      Input.Strings[i] := TempStr;
    end;
  end;

  i := 0;
  while i < Input.Capacity do   //возможно, нужно уменьшить на 1
  begin
     //1. Удаление однострочного комментария
    CommentPosB := Pos('/*', Input[i]);
    CommentStrB := i;
    if i <> 0 then
    begin

      repeat
        CommentPosE := Pos('*/', Input[i]);
        Inc(i);
      until CommentPosE <> 0;
      CommentStrE := i - 1;

      if CommentStrB = CommentStrE then  //здесь ещё не дописано
      begin
        TempStr := Input.Strings[i];
        Delete(TempStr, CommentPosB, Length(Input.Strings[i]) - CommentPoE + 1);
        Input.Strings[i] := TempStr;
      end;
    end;
  end;

end;

end.

 
