uses SysUtils;

type pole = array[1..500] of string;

var lines : pole;
    numberOfLines, lineNumber : integer;
    fileName, lineToInsert, newFileName : string;

function getNumberOfLines(fileName : string) : integer;
var numberOfLines : integer;
    sourceCodeFile : text;
begin
    assign(sourceCodeFile, fileName);

    reset(sourceCodeFile);
    numberOfLines := 0;
    while not eof(sourceCodeFile) do
    begin
        numberOfLines := numberOfLines + 1;
        readln(sourceCodeFile, lines[numberOfLines]);
    end;

    close(sourceCodeFile);
    getNumberOfLines := numberOfLines;
end;

procedure readFile(fileName : string; numberOfLines : integer);
var sourceCodeFile : text;
    i : integer;
begin
    assign(sourceCodeFile, fileName);

    reset(sourceCodeFile);
    for i := 1 to numberOfLines do
    begin
        readln(sourceCodeFile, lines[i]);
    end;

    close(sourceCodeFile);
end;

procedure printArray(numberOfLines : integer);
var i : integer;
begin
    for i := 1 to numberOfLines do
    begin
        writeln(lines[i]);
    end;
end;

procedure insertLine(lineToInsert : string; lineNumber : integer);
var i : integer;
begin
    for i := numberOfLines downto lineNumber do
    begin
        lines[i + 1] := lines[i];
    end;

    lines[lineNumber] := lineToInsert;

    numberOfLines := numberOfLines + 1;
end;

function getNewFileName(fileName : string) : string;
var fileNameLength, i, number : integer;
begin
    fileNameLength := length(fileName);
    
    for i := 1 to fileNameLength do
    begin
        if (fileName[i] = 'c') or (fileName[i] = '.') or (fileName[i] = 'p') or (fileName[i] = 'a') or (fileName[i] = 's') then
            fileName[i] := Char('');
    end;
    
    number := strToInt(Trim(fileName));
    number := number + 1;
    fileName := 'c' + intToStr(number) + '.pas';
    
    getNewFileName := fileName;
end;

procedure replaceLine(lineToReplace : string; lineNumber : integer);
begin
    lines[lineNumber] := lineToReplace;
end;

procedure createSourceCodeFile(fileName : string);
var newSourceCodeFile : text;
    i : integer;
begin
    assign(newSourceCodeFile, fileName);
    rewrite(newSourceCodeFile);

    for i := 1 to numberOfLines do
    begin
        writeln(newSourceCodeFile, lines[i]);
    end;

    close(newSourceCodeFile);
end;

function replacePasWithExe(fileName : string) : string;
var i : integer;
begin
    for i := 1 to length(fileName) do
    begin
        if fileName[i] = '.' then
        begin
            fileName[i + 1] := 'e';
            fileName[i + 2] := 'x';
            fileName[i + 3] := 'e';
            break;
        end;
    end;

    replacePasWithExe := fileName;
end;

begin
    fileName := 'c1.pas';
    lineToInsert := '    writeln(''Hello World, from ' + fileName + ''');';

    // count number of lines
    numberOfLines := getNumberOfLines(fileName);

    lineNumber := numberOfLines - 3;

    // read file into array
    readFile(fileName, numberOfLines);

    // insert a line at Nth position in the array
    insertLine(lineToInsert, lineNumber);

    // get new file name
    newFileName := getNewFileName(fileName);

    // change the file name in the array
    replaceLine('    fileName := ' + '''' + newFileName + '''' + ';', 120);

    // create a new source code file
    createSourceCodeFile(newFileName);

    // compile the new source code file
    ExecuteProcess('fpc', newfileName, []);

    // edit the file name to .exe
    newFileName := replacePasWithExe(newFileName);

    // hello worlds
    
    // run the new source code file
    ExecuteProcess('' + newFileName, '', []);
end.