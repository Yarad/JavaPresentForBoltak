unit OtherFunctions;

interface

uses UsesUnit, StdCtrls;

procedure ofDeleteComments(var str: string);
procedure LoadTextFromFileToMemo(const fileName: string; memoCode: TMemo);
procedure ofDeleteInnerFigure(var Input: string; BrakeSymbolOpen: Char = '('; BrakeSymbolClose: Char = ')'); //удаляет инфромацию между скобками, тип которых задан BrakeSymbol. По умолчанию скобки ()

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

procedure ofDeleteStringPartFromTo(var str: string; const strBegin, strEnd: string; const with1, with2: boolean);
var tempStr: string;
    posSymb, commentLen, strLen, strEndLen, strBeginLen: integer;
begin
  strLen:=Length(str);
  strEndLen:=Length(strEnd);
  strBeginLen:=Length(strBegin);
  while pos(strBegin, str)<>0
  do begin
    posSymb:=pos(strBegin, str);
    tempStr:=copy(str, posSymb, strLen+1-posSymb);
    commentLen:=pos(strEnd, tempStr);
    if commentLen<>0
    then begin
      if (with1) and (with2)
      then delete(str, posSymb, commentLen-1+strEndLen)
      else
        if with1
        then delete(str, posSymb, commentLen-1)
        else
          if with2
          then delete(str, posSymb+strBeginLen, commentLen-1+strEndLen)
          else delete(str, posSymb+strBeginLen, commentLen-1);
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

procedure ofDeleteComments(var str: string);
begin
  ofDeleteStringPartFromTo(str, '//', #13#10, true, false);
  ofDeleteStringPartFromTo(str, '/*', '*/', true, true);
  //ofDeleteStringPartFromTo(str, '(', ')', false, false);
  //ofDeleteStringPartFromTo(str, '[', ']', false, false);
  ofReplaceAll(str, #9, ' ');
  ofReplaceAll(str, #13#10+' ', #13#10);
  ofReplaceAll(str, ' '+#13#10, #13#10);
  AddNewLinesAfterSymbol(str, '{'+ #13#10);
  AddNewLinesAfterSymbol(str, 'else');
  AddNewLinesAfterSymbol(str, #13#10+'}');
  ofReplaceAll(str, '  ', ' ');
  ofReplaceAll(str, #13#10+' '+#13#10, #13#10);
  ofReplaceAll(str, #13#10#13#10, #13#10);
  ofReplaceAll(str, #13#13#10#10, #13#10);
  if pos(#13#10, str)=1
  then delete(str, 1, 2);
end;

procedure ofDeleteInnerFigure;
var
  i, BrakesOpenPos, BrakesClosePos: Integer;
  WasFound: Boolean;
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
  for i := 0 to Length(Input) - 1 do
    if Input[i] = BrakeSymbolClose then
      BrakesClosePos := i;
      
  if (BrakesOpenPos <> -1) and (BrakesClosePos <> -1) then
    Delete(Input, BrakesOpenPos + 1, BrakesClosePos - BrakesOpenPos - 1);
end;

end.
