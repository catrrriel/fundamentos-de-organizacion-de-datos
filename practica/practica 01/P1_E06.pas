{
Agregar al menú del programa del ejercicio 5, opciones para:

a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.

b. Modificar el stock de un celular dado.

c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”,
con aquellos celulares que tengan stock 0.

NOTA: Las búsquedas deben realizarse por nombre de celular.
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
	write(' | Precio: $',c.precio:0:2);
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
	assign(archExport,'E5_celularesExport.txt');
	rewrite(archExport);
	while(not eof(archCelulares))do begin
		read(archCelulares, c);
		writeln(archExport,c.cod,' ',c.precio,' ',c.marca);
		writeln(archExport,c.stockDisp,' ',c.stockMin,' ',c.desc);
		writeln(archExport,c.nom);
	end;
	close(archCelulares);
	close(archExport);
	writeln('Exportados correctamente.');
end;

procedure agregarCelulares(var archCelulares:archivoCelulares);
var 
	c:rCelular;
	op:int8;
begin
	reset(archCelulares);
	seek(archCelulares, filesize(archCelulares));
	writeln('Agregar un celular al archivo? 1 = si / 0 = no');
	write('Opcion: ');
	readln(op);
	while(op<>opcionSalida)do begin
		if(op=1)then begin
			write('Ingrese codigo: ');readln(c.cod);
			write('Ingrese nombre: ');readln(c.nom);
			write('Ingrese descripcion: ');readln(c.desc);
			write('Ingrese marca: ');readln(c.marca);
			write('Ingrese precio: ');readln(c.precio);
			write('Ingrese stock minimo: ');readln(c.stockMin);
			write('Ingrese stock disponible: ');readln(c.stockDisp);
			write(archCelulares, c);
			writeln('Celular agregado correctamente.');
		end
		else
			writeln('Opcion invalida.');
		writeln();
		writeln('Agregar un celular al archivo? 1 = si / 0 = no');
		write('Opcion: ');
		readln(op);
	end;
	writeln('Proceso finalizado.');
	close(archCelulares);
end;

procedure modificarStock(var archCelulares:archivoCelulares);
var
	c:rCelular;
	cNom:string15;
	encontre:boolean;
begin
	reset(archCelulares);
	write('Ingrese nombre del celular a modificar stock: ');
	readln(cNom);
	writeln();
	encontre:=false;
	while(not eof(archCelulares))do begin
		read(archCelulares,c);
		if(c.nom = cNom)and(not encontre)then begin
			writeln('Stock disponible de "',c.nom,'": ',c.stockDisp);
			writeln('Stock minimo de "',c.nom,'": ',c.stockMin);
			writeln();
			write('Ingrese nuevo stock disponible para "',c.nom,'": ');
			readln(c.stockDisp);
			seek(archCelulares, filepos(archCelulares)-1);
			write(archCelulares,c);
			encontre:=true;
		end
	end;
	if(encontre)then
		writeln('Stock de "',cNom,'" modificado correctamente.')
	else
		writeln('No se encontro el celular "',cNom,'" en el archivo.');
	close(archCelulares);
end;

procedure exportarCelularesSinStock(var archCelulares:archivoCelulares; var archSinStock:text);
var c:rCelular;
begin
	reset(archCelulares);
	assign(archSinStock,'E6_celularesSinStock.txt');
	rewrite(archSinStock);
	while(not eof(archCelulares))do begin
		read(archCelulares, c);
		if(c.stockDisp=0)then begin
			writeln(archSinStock,c.cod,' ',c.precio,' ',c.marca);
			writeln(archSinStock,c.stockDisp,' ',c.stockMin,' ',c.desc);
			writeln(archSinStock,c.nom);
		end;
	end;
	close(archCelulares);
	close(archSinStock);
	writeln('Exportados celulares sin stock correctamente.');
end;

procedure leerOpcion(var opcion:int8);
begin
	writeln('~~~ MENU DE OPCIONES ~~~');
	writeln();
	writeln('Opcion 1: Crear y cargar archivo binario de celulares');
	writeln('Opcion 2: Listar celulares con stock menor al minimo');
	writeln('Opcion 3: Buscar celular por descripcion');
	writeln('Opcion 4: Listar todos los celulares en el archivo binario');
	writeln('Opcion 5: Exportar los celulares a un archivo de texto');
	writeln('Opcion 6: Agregar celulares al archivo binario desde teclado');
	writeln('Opcion 7: Modificar stock de un celular');
	writeln('Opcion 8: Exportar celulares sin stock a un archivo de texto');
	writeln('Opcion 0: Salir del menu');
	write('Ingrese opcion: ');readln(opcion);
	writeln();
end;

procedure abrirMenu(var archCelulares:archivoCelulares; var archCarga:text; var archExport:text; var archSinStock:text);
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
			6:agregarCelulares(archCelulares);
			7:modificarStock(archCelulares);
			8:exportarCelularesSinStock(archCelulares,archSinStock);
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
	archCarga, archExport, archSinStock:text;
BEGIN
	randomize;
	assign(archCarga,'E5_celulares.txt');
	assign(archCelulares,'E5_celulares');
	cargarArchivoCarga(archCarga);
	abrirMenu(archCelulares,archCarga,archExport,archSinStock);
END.

