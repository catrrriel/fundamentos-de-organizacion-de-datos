{
Realizar un algoritmo que cree un archivo binario de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde el teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del archivo
debe ser proporcionado por el usuario desde el teclado.
}

program NumerosEnteros;
const
	numSalida=30000;
type
    archivoEnteros = file of integer;
var
	enteros:archivoEnteros;
	nombreFisico:string[10];
	num:integer;
begin
	//write('ingrese nombre del archivo: ');
    //readln(nombreFisico);
    assign(enteros, 'E1_enteros');
    rewrite(enteros);
    write('ingrese un numero: ');
	readln(num);
    while (num<>numSalida)do begin
		write(enteros,num);
		write('ingrese un numero: ');
		readln(num);
	end;
    writeln(fileSize(enteros),' numeros almacenados');
    close(enteros);
end.
