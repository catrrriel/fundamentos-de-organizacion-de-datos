program NumerosEnteros;
const
	numSalida=30000;
type
    archivoNumeros = file of integer;
var
	numeros:archivoNumeros;
	nombreFisico:string[10];
	num:integer;
begin
	writeln('ingrese nombre del archivo');
    readln(nombreFisico);
    assign(numeros, nombreFisico);
    reset(numeros);
    write('ingrese numero: ');
	readln(num);
    while (num<>0)do begin
		write(numeros,num);
		write('ingrese numero: ');
		readln(num);
	end;
    writeln(fileSize(numeros));
    close(numeros);
    
end.
