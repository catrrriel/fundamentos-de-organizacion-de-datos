{
Realizar un programa para una tienda de celulares, que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados
desde un archivo de texto denominado “celulares.txt”. Los registros correspondientes a
los celulares deben contener: código de celular, nombre, descripción, marca, precio,
stock mínimo y stock disponible. El formato del archivo de texto de carga se especifica en
la NOTA 2 ubicada al final del ejercicio.

b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock
mínimo.

c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de
caracteres proporcionada por el usuario.

d. Exportar el archivo binario creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado podría ser
utilizado en un futuro como archivo de carga (ver inciso a), por lo que debería respetar el
formato dado para este tipo de archivos en la NOTA 2.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en tres
líneas consecutivas. En la primera se especifica: código de celular, el precio y marca, en la
segunda el stock disponible, stock mínimo y la descripción y en la tercera nombre en ese orden.
Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.  
}
program TiendaDeCelulares;
const
	 codSalida=0;
	 opcionSalida=0;
type
	string15=string[15];
	rCelular=record
		cod:integer;
		nom:string15;
		desc:string15;
		marca:string15;
		precio:real;
		stockMin:integer;
		stockDisp:integer;
	end;
	archivoCelulares=file of rCelular;

function randomString(long:integer):string15;
var
	i:int8;
	auxString:string;
begin
	auxString:='';
	for i:=1 to long do
		auxString:=auxString+chr(ord('a')+random(26));
	randomString:=auxString;
end;

procedure leerCelular (var c:rCelular);
var 
	aux:integer;
	vMarcas:array [1..5] of string15=('Samsung', 'Motorola', 'LG', 'Apple', 'Nokia');
	vDesc:array [1..3] of string15=('Gama baja', 'Gama media', 'Gama alta');
begin
	aux:=random(100);
	if(aux<5)then
		c.cod:=codSalida
	else
		c.cod:=1+random(1000);
	if(c.cod<>codSalida)then begin
		c.nom:=randomString(4+random(3));
		c.desc:=vDesc[1+random(3)];
		c.marca:=vMarcas[1+random(5)];
		c.precio:=1+random(100);
		c.stockMin:=1+random(15);
		c.stockDisp:=random(20);
	end;
end;

procedure cargarArchivoCarga(var archCarga:text);
var c:rCelular;
begin
	rewrite(archCarga);
	leerCelular(c);
	while(c.cod<>codSalida)do begin
		writeln(archCarga,c.cod,' ',c.precio:0:2,' ',c.marca);
		writeln(archCarga,c.stockDisp,' ',c.stockMin,' ',c.desc);
		writeln(archCarga,c.nom);
		leerCelular(c);
	end;
	writeln('Archivo de carga cargado.');
	close(archCarga);
end;

//procedure cargarArchivoCelulares(var archCelulares:archivoCelulares; var archCarga:text);
//var c:rCelular;
//begin
//	rewrite(archCelulares);
//	reset(archCarga);
//	while(not eof(archCarga))do begin
//		readln(archCarga,c.cod,c.precio,c.marca);
//		readln(archCarga,c.stockDisp,c.stockMin,c.desc);
//		readln(archCarga,c.nom);
//		write(archCelulares,c);
//	end;
//	close(archCelulares);
//	close(archCarga);
//	writeln('Archivo binario de celulares cargado.');
//end;

procedure cargarArchivoCelulares(var archCelulares:archivoCelulares; var archCarga:text);
var 
    c: rCelular;
    espacio: char; // Variable auxiliar para consumir el espacio en blanco
begin
	rewrite(archCelulares);
	reset(archCarga);
	while(not eof(archCarga))do begin
        // Leemos código, precio y el ESPACIO. Luego leemos la marca
		read(archCarga, c.cod, c.precio, espacio);
        readln(archCarga, c.marca); 
        
        // Leemos stock, stock mínimo y el ESPACIO. Luego leemos la descripción
		read(archCarga, c.stockDisp, c.stockMin, espacio);
        readln(archCarga, c.desc);
        
        // El nombre está en una línea solo, no requiere absorber un espacio previo
		readln(archCarga, c.nom);
		
		write(archCelulares,c);
	end;
	close(archCelulares);
	close(archCarga);
	writeln('Archivo binario de celulares cargado.');
end;


procedure imprimirCelular(c:rCelular);
begin
	write('Codigo: ',c.cod);
	write(' | Nombre: ',c.nom);
	write(' | Descripcion: ',c.desc);
	write(' | Marca: ',c.marca);
	write(' | Precio: ',c.precio:0:2);
	write(' | Stock: ',c.stockDisp);
	writeln(' | Stock min: ',c.stockMin);
end;

procedure imprimirCelulares(var archCelulares:archivoCelulares);
var c:rCelular;
begin
	reset(archCelulares);
	writeln('------ Listado de celulares ------');
	while(not eof(archCelulares))do begin
		read(archCelulares,c);
		imprimirCelular(c);
	end;
	close(archCelulares);
end;

procedure imprimirCelularesStockMin(var archCelulares:archivoCelulares);
var c:rCelular;
begin
	reset(archCelulares);
	writeln('------ Listado de celulares con stock menor al minimo ------');
	while(not eof(archCelulares))do begin
		read(archCelulares, c);
		if(c.stockDisp<c.stockMin)then
			imprimirCelular(c);
	end;
	close(archCelulares);
end;

procedure imprimirCelularesDesc(var archCelulares:archivoCelulares);
var 
	c:rCelular;
	st:string15;
begin
	writeln('Ingrese una descripcion a buscar: ');
	readln(st);
	reset(archCelulares);
	writeln('------ Listado de celulares con la descripcion ingresada ------');
	while(not eof(archCelulares)) do begin
		read(archCelulares,c);
		if(c.Desc=st)then begin
			imprimirCelular(c);
		end;
	end;
	close(archCelulares);
end;

procedure exportarCelulares(var archCelulares:archivoCelulares; var archExport:text);
var c:rCelular;
begin
	reset(archCelulares);
	assign(archExport,'E5_celularesExport');
	rewrite(archExport);
	while(not eof(archCelulares))do begin
		read(archCelulares, c);
		writeln(archExport,c.cod,' ',c.precio:0:3,' ',c.marca);
		writeln(archExport,c.stockDisp,' ',c.stockMin,' ',c.desc);
		writeln(archExport,c.nom);
	end;
	close(archCelulares);
	close(archExport);
	writeln('Exportados correctamente.');
end;

procedure leerOpcion(var opcion:int8);
begin
	writeln('~~~ MENU DE OPCIONES ~~~');
	writeln();
	writeln('Opcion 1: Crear y cargar archivo de celulares');
	writeln('Opcion 2: Listar celulares con stock menor al minimo');
	writeln('Opcion 3: Buscar celular por descripcion');
	writeln('Opcion 4: Listar todos los celulares');
	writeln('Opcion 5: Exportar los celulares a un archivo de texto');
	writeln('Opcion 0: Salir del menu');
	write('Ingrese opcion: ');readln(opcion);
	writeln();
end;


procedure abrirMenu(var archCelulares:archivoCelulares; var archCarga:text; var archExport:text);
var opcion:int8;
begin
	leerOpcion(opcion);
	while(opcion<>opcionSalida)do begin
		case opcion of
			1:cargarArchivoCelulares(archCelulares,archCarga);
			2:imprimirCelularesStockMin(archCelulares);
			3:imprimirCelularesDesc(archCelulares);
			4:imprimirCelulares(archCelulares);
			5:exportarCelulares(archCelulares,archExport);
		else
			writeln('La opcion ingresada no corresponde a ninguna accion');
		end;
		writeln();
		leerOpcion(opcion);
	end;
end;

//pp
var 
	archCelulares:archivoCelulares;
	archCarga, archExport:text;
BEGIN
	randomize;
	assign(archCarga,'E5_celulares.txt');
	assign(archCelulares,'E5_celulares');
	cargarArchivoCarga(archCarga);
	abrirMenu(archCelulares,archCarga,archExport);
END.

