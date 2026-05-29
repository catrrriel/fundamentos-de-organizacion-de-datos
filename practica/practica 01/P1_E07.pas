{
Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de texto. El
nombre del archivo de texto es: “novelas.txt”. La información en el archivo de texto
consiste en: código de novela, nombre, género y precio de diferentes novelas argentinas.
Los datos de cada novela se almacenan en dos líneas en el archivo de texto. La primera
línea contendrá la siguiente información: código novela, precio y género, y la segunda
línea almacenará el nombre de la novela.

b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar una
novela y modificar una existente. Las búsquedas se realizan por código de novela.

NOTA: El nombre del archivo binario es proporcionado por el usuario desde el 5rteclado.  
}
program Novelas;
const
	codSalida=0;
	opSalida=0;
type
	string15=string[15];
	rNovela=record
		cod:integer;
		nom:string15;
		gen:string15;
		precio:real;
	end;
	archivoNovelas=file of rNovela;

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

procedure leerNovela (var v:rNovela);
var 
	aux:integer;
	vGeneros:array [1..6] of string15=('Comedia', 'Terror', 'Drama', 'Accion', 'Ciencia ficcion', 'Romantica');
begin
	aux:=random(100);
	if(aux<5)then
		v.cod:=codSalida
	else
		v.cod:=100+random(900);
	if(v.cod<>codSalida)then begin
		v.nom:=randomString(4+random(4));
		v.gen:=vGeneros[1+random(6)];
		v.precio:=20+random(180);
	end;
end;

procedure imprimirNovela(n:rNovela);
begin
	write('Codigo: ',n.cod);
	write(' | Genero: ',n.gen);
	write(' | Precio: $',n.precio:0:2);
	writeln(' | Nombre: ',n.nom);
end;

procedure listarNovelas(var archNovelas:archivoNovelas);
var n:rNovela;
begin
	reset(archNovelas);
	writeln('------ Listado de novelas ------');
	while(not eof(archNovelas))do begin
		read(archNovelas,n);
		imprimirNovela(n);
	end;
	close(archNovelas);
end;

procedure cargarArchivoCarga(var archCarga:text);
var n:rNovela;
begin
	rewrite(archCarga);
	leerNovela(n);
	while(n.cod<>codSalida)do begin
		writeln(archCarga,n.cod,' ',n.precio:0:2,' ',n.gen);
		writeln(archCarga,n.nom);
		leerNovela(n);
	end;
	writeln('Archivo de carga cargado.');
	close(archCarga);
end;

procedure cargarArchivoNovelas(var archNovelas:archivoNovelas; var archCarga:text);
var 
	n:rNovela;
	espacio:char;
begin
	rewrite(archNovelas);
	reset(archCarga);
	while(not eof(archCarga))do begin
        // leemos codigo, precio y el ESPACIO. despues leemos el genero
		read(archCarga, n.cod, n.precio, espacio);
        readln(archCarga, n.gen); 
        
        // el nombre esta en una línea solo, no requiere absorber un espacio previo
		readln(archCarga, n.nom);
		
		write(archNovelas,n);
	end;
	close(archNovelas);
	close(archCarga);
	writeln('Archivo binario de novelas cargado.');
end;

procedure agregarNovela(var archNovelas:archivoNovelas);
var n:rNovela;
begin
	reset(archNovelas);
	leerNovela(n);
	seek(archNovelas, filesize(archNovelas));
	write(archNovelas,n);
	close(archNovelas);
	writeln('Novela agregada exitosamente.');
end;

procedure leerOpcionModificar(var op:int8);
begin
	writeln('Que campo modificar?');
	writeln();
	writeln('1: Codigo');
	writeln('2: Nombre');
	writeln('3: Precio');
	writeln('3: Genero');
	writeln('0: Salir del menu');
	write('Ingrese opcion: ');readln(op);
	writeln();
end;

procedure modificarArchivoNovelas(var archNovelas:archivoNovelas);
var 
	n:rNovela;
	codNovela:integer;
	encontre:boolean;
	op:int8;
begin
	reset(archNovelas);
	write('Ingrese codigo de la novela a modificar: ');
	readln(codNovela);
	encontre:=false;
	while(not eof(archNovelas) and (not encontre))do begin
		read(archNovelas,n);
		if(n.cod=codNovela)then begin
			leerOpcionModificar(op);
			while(op<>opSalida)do begin
				case op of
					1:	begin write('Ingrese nuevo codigo: ');readln(n.cod) end;
					2:	begin write('Ingrese nuevo nombre: ');readln(n.nom) end;
					3:	begin write('Ingrese nuevo precio: ');readln(n.precio) end;
					4:	begin write('Ingrese nuevo genero: ');readln(n.gen) end;
					else
						writeln('Opcion invalida');
				end;
				writeln();
				writeln('Codigo actual: ',n.cod);
				writeln('Nombre actual: ',n.nom);
				writeln('Precio actual: $',n.precio:0:2);
				writeln('Genero actual: ',n.gen);
				writeln();
				leerOpcionModificar(op);
			end;
			seek(archNovelas, filepos(archNovelas)-1);
			write(archNovelas,n);
			encontre:=true;
		end;
	end;
	if(encontre)then
		writeln('Novela modificada exitosamente')
	else
		writeln('No se encontro la novela, pruebe otro codigo');
	close(archNovelas);
end;

procedure leerOpcion(var op:int8);
begin
	writeln('~~~ MENU DE OPCIONES ~~~');
	writeln();
	writeln('Opcion 1: Crear y cargar archivo binario de novelas');
	writeln('Opcion 2: Agregar una novela al archivo binario');
	writeln('Opcion 3: Modificar los datos de una novela');
	writeln('Opcion 4: Listar novelas');
	writeln('Opcion 0: Salir del menu');
	write('Ingrese opcion: ');readln(op);
	writeln();
end;

procedure abrirMenu(var archNovelas:archivoNovelas; var archCarga:text);
var op:int8;
begin
	leerOpcion(op);
	while(op<>opSalida)do begin
		case op of
			1:cargarArchivoNovelas(archNovelas,archCarga);
			2:agregarNovela(archNovelas);
			3:modificarArchivoNovelas(archNovelas);
			4:listarNovelas(archNovelas);
		else
			writeln('Opcion invalida');
		end;
		writeln();
		leerOpcion(op);
	end;
end;

//pp
var
	archNovelas:archivoNovelas;
	archCarga:text;
BEGIN
	randomize;
	assign(archCarga,'E7_novelas.txt');
	assign(archNovelas,'E7_novelas');
	cargarArchivoCarga(archCarga);
	abrirMenu(archNovelas,archCarga);
END.

