{
Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados creado en el
ejercicio 1, informe por pantalla cantidad de números menores a 15000 y el promedio de los
números ingresados. El nombre del archivo a procesar debe ser proporcionado por el usuario
una única vez. Además, el algoritmo deberá listar el contenido del archivo en pantalla. Resolver
el ejercicio realizando un único recorrido del archivo.
}

program ProcesarNumeros;
const
	numCorte=15000;
type
	archivoEnteros=file of integer;
	
procedure procesarEnteros(var enteros:archivoEnteros; var numsCorte:integer; var prom:real);
var
	suma:int32;
	n:integer;
begin
	reset(enteros);
	suma:=0;
	writeln('listado de numeros:');
	while(not eof(enteros))do begin
		read(enteros, n);
		if(n<numCorte)then
			numsCorte:=numsCorte+1;
		suma:=suma+n;
		writeln('n',filePos(enteros),': ',n);
	end;
	if(fileSize(enteros)>0)then
		prom:=suma/fileSize(enteros);
	close(enteros);
end;

var 
	enteros:archivoEnteros;
	numsCorte:integer;
	prom:real;
BEGIN
	numsCorte:=0;
	prom:=0;
	assign(enteros,'E1_enteros');
	procesarEnteros(enteros,numsCorte,prom);
	writeln();
	writeln('cantidad de numeros menores a ',numCorte,': ',numsCorte);
	writeln('promedio de numeros ingresados: ',prom:0:2);
	
END.

