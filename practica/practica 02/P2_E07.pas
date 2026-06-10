{
Se dispone de un archivo maestro con información de los alumnos de la Facultad de Informática.
Cada registro del archivo maestro contiene: código de alumno, apellido, nombre, cantidad de cursadas
aprobadas y cantidad de materias con final aprobado. El archivo maestro está ordenado por código de
alumno.

Además, se dispone de dos archivos detalle con información sobre el desempeño académico de los
alumnos: un archivo de cursadas y un archivo de exámenes finales.

El archivo de cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa determinar si la
cursada fue aprobada o desaprobada).

Por su parte, el archivo de exámenes finales contiene información sobre los exámenes rendidos. Cada
registro incluye: código de alumno, código de materia, fecha del examen y nota obtenida.

Ambos archivos detalle están ordenados por código de alumno y código de materia, y pueden contener
cero, uno o más registros por alumno.

Un alumno puede cursar una misma materia varias veces, así como también rendir el examen final en
múltiples ocasiones.

Se solicita desarrollar un programa que actualice el archivo maestro, modificando la cantidad de cursadas
aprobadas y la cantidad de materias con final aprobado, a partir de la información contenida en los archivos
detalle.

Las reglas de actualización son las siguientes:
● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas aprobadas.
● Si un alumno aprueba un examen final (nota mayor o igual a 4), se incrementa en uno la cantidad de
materias con final aprobado.

Notas:
● Los archivos deben procesarse en un único recorrido.
● No es necesario verificar inconsistencias en la información de los archivos detalle. En particular, se
garantiza que un alumno no puede aprobar más de una vez la cursada de una misma materia. De
manera análoga, tampoco puede aprobar más de una vez el examen final de una misma materia.
}
program FacultadInformatica;
const
	opSalida = 0; valorAlto = 999;
type
	string15 = string[15];
	rAlumno = record
		cod:integer;
		ape:string15;
		nom:string15;
		cursadas:integer;
		finales:integer;
	end;
	rCursada = record
		codAlumno:integer;
		codMateria:integer;
		anio:integer;
		res:boolean;
	end;
	rFinal = record
		codAlumno:integer;
		codMateria:integer;
		fecha:string15;
		nota:real;
	end;
	archivoAlumnos = file of rAlumno;
	archivoCursadas = file of rCursada;
	archivoFinales = file of rFinal;

function randomString(long:integer):string15;
var i: int8; auxString: string;
begin
	auxString := '';
	for i := 1 to long do
		auxString := auxString + chr(ord('a') + random(26));
	randomString := auxString;
end;

procedure leerAlumno(var a:rAlumno);
begin
	//a.cod := 20000 + random(10000);
	a.nom := randomString(4);
	a.ape := randomString(5);
	a.cursadas := random(10);
	a.finales := random(10);
end;

procedure imprimirAlumno(a:rAlumno);
begin
	write('Codigo: ',a.cod);
	write(' | Apellido: ',a.ape);
	write(' | Nombre: ',a.nom);
	write(' | Cursadas: ',a.cursadas);
	writeln(' | Finales: ',a.finales);
end;
procedure listarAlumnos(var archAlumnos:archivoAlumnos);
var a:rAlumno;
begin
	reset(archAlumnos);
	writeln('------ Listado de alumnos ------');
	while(not eof(archAlumnos))do begin
		read(archAlumnos,a);
		imprimirAlumno(a);
	end;
	close(archAlumnos);
end;

procedure imprimirCursada(c:rCursada);
begin
	write('Cod. Alumno: ',c.codAlumno);
	write(' | Cod. Materia: ',c.codMateria);
	write(' | Anio: ',c.anio);
	write(' | Resultado: ');
	if(c.res)then
		writeln('Aprobado')
	else
		writeln('Desaprobado');
end;
procedure listarArchivoCursadas(var archCursadas:archivoCursadas);
var c:rCursada;
begin
	reset(archCursadas);
	writeln('------ Listado de cursadas ------');
	while(not eof(archCursadas))do begin
		read(archCursadas,c);
		imprimirCursada(c);
	end;
	close(archCursadas);
end;

procedure imprimirFinal(f:rFinal);
begin
	write('Cod. Alumno: ',f.codAlumno);
	write(' | Cod. Materia: ',f.codMateria);
	write(' | Fecha: ',f.fecha);
	writeln(' | Nota: ',f.nota:0:2);
end;
procedure listarArchivoFinales(var archFinales:archivoFinales);
var f:rFinal;
begin
	reset(archFinales);
	writeln('------ Listado de finales ------');
	while(not eof(archFinales))do begin
		read(archFinales,f);
		imprimirFinal(f);
	end;
	close(archFinales);
end;

procedure cargarArchivos(var archMae:archivoAlumnos; var archC:archivoCursadas; var archF:archivoFinales);
var
	a: rAlumno; c: rCursada; f: rFinal;
	i, j, cantCursadas, cantFinales: integer;
begin
	rewrite(archMae); rewrite(archC); rewrite(archF);
	
	// El for principal garantiza el orden por código de alumno
	for i := 1 to 20 do begin 
		a.cod := i;
		leerAlumno(a);
		write(archMae, a);
		
		// Generar detalle de cursadas ordenado por código de materia (j)
		cantCursadas := random(4); 
		for j := 1 to cantCursadas do begin
			c.codAlumno := i;
			c.codMateria := j; 
			c.anio := 2020 + random(4);
			c.res := random(2) = 1; // true o false aleatorio
			write(archC, c);
		end;
		
		// Generar detalle de finales ordenado por código de materia (j)
		cantFinales := random(3); 
		for j := 1 to cantFinales do begin
			f.codAlumno := i;
			f.codMateria := j; 
			f.fecha := '15/12/2023';
			f.nota := random * 10;
			write(archF, f);
		end;
	end;
	
	close(archMae); close(archC); close(archF);
	writeln('Archivos generados y ordenados correctamente.');
end;

procedure leerCursada(var archCursadas:archivoCursadas; var c:rCursada);
begin
	if(not eof(archCursadas))then
		read(archCursadas,c)
	else
		c.codAlumno:=valorAlto;
end;

procedure leerFinal(var archFinales:archivoFinales; var f:rFinal);
begin
	if(not eof(archFinales))then	
		read(archFinales,f)
	else
		f.codAlumno:=valorAlto;
end;

procedure actualizarArchivoAlumnos(var archAlumnos:archivoAlumnos; var archCursadas:archivoCursadas; var archFinales:archivoFinales);
var
	a:rAlumno; c:rCursada; f:rFinal;
	codMin:integer;
begin
	reset(archAlumnos);reset(archCursadas);reset(archFinales);
	read(archAlumnos,a);
	leerCursada(archCursadas,c);
	leerFinal(archFinales,f);
	
	// mientras haya datos en algun detalle
	while(c.codAlumno <> valorAlto) and (f.codAlumno <> valorAlto) do begin
		
		// determino el codigo minimo actual
		if(c.codAlumno <= f.codAlumno)then
			codMin := c.codAlumno
		else
			codMin := f.codAlumno;
		
		// busco en el maestro el alumno que tome del detalle
		while(a.cod <> codMin)do
			read(archAlumnos,a);
		
		// proceso cursadas y finales
		while(c.codAlumno = codMin)do begin
			if(c.res)then
				a.cursadas := a.cursadas + 1;
			leerCursada(archCursadas,c);
		end;
		while(f.codAlumno = codMin)do begin
			if(f.nota >= 4)then
				a.finales := a.finales + 1;
			leerFinal(archFinales,f);
		end;
		
		// sobreescribo en el maestro para actualizar
		seek(archAlumnos, filepos(archAlumnos)-1);
		write(archAlumnos,a);
	end;
	
	writeln('Archivo maestro de alumnos actualizado');
	close(archAlumnos);close(archCursadas);close(archFinales);
end;

procedure leerOpcion(var op:int8);
begin
	writeln('~~~ MENU DE OPCIONES ~~~');
	writeln();
	writeln('Opcion 1: Cargar archivos');
	writeln('Opcion 2: Listar alumnos');
	writeln('Opcion 3: Listar archivo cursadas');
	writeln('Opcion 4: Listar archivo finales');
	writeln('Opcion 5: Actualizar archivo de alumnos');
	writeln('Opcion 0: Salir del menu');
	write('Ingrese opcion: ');readln(op);
	writeln();
end;

procedure abrirMenu(var archAlumnos:archivoAlumnos; var archCursadas:archivoCursadas; var archFinales:archivoFinales);
var op:int8;
begin
	leerOpcion(op);
	while(op<>opSalida)do begin
		case op of
			1:cargarArchivos(archAlumnos,archCursadas,archFinales);
			2:listarAlumnos(archAlumnos);
			3:listarArchivoCursadas(archCursadas);
			4:listarArchivoFinales(archFinales);
			5:actualizarArchivoAlumnos(archAlumnos,archCursadas,archFinales);
		else
			writeln('Opcion invalida');
		end;
		writeln();
		leerOpcion(op);
	end;
end;

//main
var 
	archAlumnos:archivoAlumnos;
	archCursadas:archivoCursadas;
	archFinales:archivoFinales;
BEGIN
	randomize;
	assign(archAlumnos,'E7_alumnos');
	assign(archCursadas,'E7_cursadas');
	assign(archFinales,'E7_finales');
	abrirMenu(archAlumnos,archCursadas,archFinales);
END.

