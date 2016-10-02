unit OtherFunctions;

interface

uses UsesUnit, StdCtrls;

procedure ofDeleteComments(var str: string);
procedure LoadTextFromFileToMemo(const fileName: string; memoCode: TMemo);
procedure ofDeleteFiguresFromText(memoCode: TMemo);
function ofConvertRealToString(const expierence: real): string;

implementation

uses SysUtils;

procedure LoadTextFromFileToMemo(const fileName: string; memoCode: TMemo);
var tempFile: text;
    tempStr: string;
begin
  AssignFile(tempFile, fileName);
  Reset(tempFile);
  while (not eof(tempFile))
  do begin
    readln(tempFile, tempStr);
    memoCode.Lines.Add(tempStr);
  end;
  CloseFile(tempFile);
  memoCode.Lines.Text:=trim(memoCode.Lines.Text);
end;

procedure ofDeleteStringPartFromTo(var str: string; const strBegin, strEnd: string; const with2: boolean);
var tempStr: string;
    posSymb, commentLen, strLen, strEndLen: integer;
begin
  strLen:=Length(str);
  strEndLen:=Length(strEnd);
  while pos(strBegin, str)<>0
  do begin
    posSymb:=pos(strBegin, str);
    tempStr:=copy(str, posSymb, strLen+1-posSymb);
    commentLen:=pos(strEnd, tempStr);
    if commentLen<>0
    then begin
      if with2
      then delete(str, posSymb, commentLen-1+strEndLen)
      else delete(str, posSymb, commentLen-1);
    end
    else delete(str, posSymb, strLen+1-posSymb);
  end;
end;

procedure ofReplaceAll(var str: string; const expression, replacement: string);
var expressionLen: integer;
    posSymb: integer;
begin
  expressionLen:=Length(expression);
  while pos(expression, str)<>0
  do begin
    posSymb:=pos(expression, str);
    delete(str, posSymb, expressionLen);
    insert(replacement, str, posSymb)
  end;
end;

procedure AddNewLinesAfterSymbol(var str: string; const expression: string);
var posSymb, addedLen: integer;
    tempStr: string;
begin
  tempStr:=str;
  addedLen:=0;
  while pos(expression, tempStr)<>0
  do begin
    posSymb:=pos(expression, tempStr);
    addedLen:=addedLen+posSymb;
    insert(#13#10, str, addedLen+Length(expression));
    insert(#13#10, str, addedLen);
    addedLen:=addedLen+4;
    delete(tempStr, 1, posSymb);
  end;
end;

procedure ofDeleteInnerFigure(var Input: string; BrakeSymbolOpen: Char = '('; BrakeSymbolClose: Char = ')'); //удаляет инфромацию между скобками, тип которых задан BrakeSymbol. По умолчанию скобки ()
var
  i, BrakesOpenPos, BrakesClosePos: Integer;
begin
  BrakesOpenPos := -1;
  BrakesClosePos := -1;
  for i := 0 to Length(Input) - 1 do
  begin
    if Input[i] = BrakeSymbolOpen then
    begin
      BrakesOpenPos := i;
      Break;
    end
  end;
  for i := 1 to Length(Input) do
    if Input[i] = BrakeSymbolClose then
      BrakesClosePos := i;
      
  if (BrakesOpenPos <> -1) and (BrakesClosePos <> -1) then
    Delete(Input, BrakesOpenPos + 1, BrakesClosePos - BrakesOpenPos - 1);
end;

procedure ofDeleteFiguresFromText(memoCode: TMemo);
var count: integer;
    tempStr: string;
begin
  for count:=0 to (memoCode.Lines.Count-1)
  do begin
    tempStr:=memoCode.Lines[count];
    ofDeleteInnerFigure(tempStr);
    ofDeleteInnerFigure(tempStr, '[', ']');
    memoCode.Lines[count]:=tempStr;
  end;
end;

procedure ofAddEnterAfterConstr(var Input: string; const ConstrBegin, ConstrEnd: string);
var
  LenFirstConstr,LenSecondConstr,i,j: Integer;
  Enter, TempStr: string;
begin
  SetLength(Enter, 2);
  Enter[1] := #13;
  Enter[2] := #10;

  LenFirstConstr := Length(ConstrBegin);
  LenSecondConstr := Length(ConstrEnd);

  for i:= 1 to (Length(Input)-LenFirstConstr) do
  begin
     TempStr := Copy(Input,i,LenFirstConstr);
     if LowerCase(TempStr) = LowerCase(ConstrBegin) then
        for j := i+LenFirstConstr to Length(Input) do
        begin
           TempStr := Copy(Input,j,LenSecondConstr);
           if LowerCase(TempStr) = LowerCase(ConstrEnd) then
              Insert(Enter, Input, j+LenSecondConstr);
        end;
  end;
end;

procedure ofDeleteComments(var str: string);
begin
  ofDeleteStringPartFromTo(str, '//', #13#10, false);
  ofDeleteStringPartFromTo(str, '/*', '*/', true);
  ofReplaceAll(str, #9, ' ');
  ofReplaceAll(str, #13#10+' ', #13#10);
  ofReplaceAll(str, '  ', ' ');
  AddNewLinesAfterSymbol(str, 'else');
  AddNewLinesAfterSymbol(str, '{'+ #13#10);
  AddNewLinesAfterSymbol(str, #13#10+'}');
  ofAddEnterAfterConstr(str, 'if', ')');
  ofAddEnterAfterConstr(str, 'case', ':');
  ofAddEnterAfterConstr(str, 'default', ':');
  ofReplaceAll(str, #13#10+' ', #13#10);
  ofReplaceAll(str, ' '+#13#10, #13#10);
  ofReplaceAll(str, #13#10+' '+#13#10, #13#10);
  ofReplaceAll(str, #13#10#13#10, #13#10);
  if pos(#13#10, str)=1
  then delete(str, 1, 2);
end;

function ofConvertRealToString(const expierence: real): string;
begin
  result:=FloatToStr(expierence);
  delete(result, 6, Length(result)-5);
end;

end.
