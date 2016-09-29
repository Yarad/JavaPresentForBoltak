unit OtherFunctions;

interface

uses UsesUnit, StdCtrls;

procedure ofDeleteComments(var str: string);
procedure LoadTextFromFileToMemo(const fileName: string; memoCode: TMemo);

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

procedure ofDeleteStringPartFromTo(var str: string; const strBegin, strEnd: string);
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
    then delete(str, posSymb, commentLen-1+strEndLen)
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

procedure ofDeleteComments(var str: string);
begin
  ofDeleteStringPartFromTo(str, '//', #13#10);
  ofDeleteStringPartFromTo(str, '/*', '*/');
  ofReplaceAll(str, '  ', ' ');
  ofReplaceAll(str, #13#10+' '+#13#10, #13#10);
  ofReplaceAll(str, #13#10#13#10, #13#10);
  if pos(#13#10, str)=1
  then delete(str, 1, 2);
end;

end.
