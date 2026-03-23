{
 Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por teclado.
Tener en cuenta que no se debe agregar al archivo un empleado con un número de
empleado ya registrado (control de unicidad).

b. Modificar la edad de un empleado dado.

c. Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.

d. Exportar a un archivo de texto llamado “faltaDNIEmpleado.txt”, los empleados que no
tengan cargado el DNI (DNI en 0).

NOTA: Las búsquedas deben realizarse por número de empleado.
}

program SistemaEmpleados;
const
	apellidoSalida='fin'; opcionSalida=0;
	edadCorte=70;
type
	string10=string[10];
	empleado=record
		numEmp:integer;
		apellido:string10;
		nombre:string10;
		edad:integer;
		dni:int32;
	end;
	archivoEmpleados=file of empleado;
	
function randomString(long:integer):string10;
var
	i:int8;
	auxString:string;
begin
	auxString:='';
	for i:=1 to long do
		auxString:=auxString+chr(ord('a')+random(26));
	randomString:=auxString;
end;

procedure leerEmpleado(var e:empleado);
var aux:integer;
begin
	{
	aux:=random(70);
	if(aux=0)then
		e.apellido:=apellidoSalida
	else
		e.apellido:=randomString(5+random(5));
	}
	write('Ingrese apellido del empleado: ');
	readln(e.apellido);	
	if(e.apellido<>apellidoSalida)then begin
		//e.nombre:=randomString(5+random(5));
		write('Ingrese nombre del empleado: ');
		readln(e.nombre);
		aux:=random(40);
		if(aux=0)then
			e.dni:=0
		else
			e.dni:=random(40000000)+10000000;
		e.edad:=random(60)+20;
		e.numEmp:=random(3000)+1000;
	end;
end;
	
procedure cargarArchivo(var empleados:archivoEmpleados);
var
	e:empleado;
begin
	rewrite(empleados);
	writeln('======== Comienza la carga de datos ========');
	leerEmpleado(e);
	while(e.apellido<>apellidoSalida)do begin
		write(empleados,e);
		leerEmpleado(e);
	end;
	writeln('Empleados cargados: ',fileSize(empleados));
	close(empleados);
end;

procedure imprimirEmpleado(e:empleado);
begin
	write('Numero: ',e.numEmp);
	write(' | Apellido: ',e.apellido);
	write(' | Nombre: ',e.nombre);
	write(' | Edad: ',e.edad);
	writeln(' | DNI: ',e.dni);
end;

procedure listarEmpleadosPorNombre(var empleados:archivoEmpleados);
var
	e:empleado;
	txt:string10;
begin
	reset(empleados);
	write('Ingrese nombre o apellido para filtrar empleados:');
	readln(txt);
	writeln();
	writeln('------ Listado de empleados filtrados por nombre/apellido ------');
	while(not eof(empleados))do begin
		read(empleados,e);
		if((e.apellido = txt) or (e.nombre = txt))then
			imprimirEmpleado(e);
	end;
	close(empleados);
end;

procedure listarEmpleadosAJubilar(var empleados:archivoEmpleados);
var e:empleado;
begin
	reset(empleados);
	writeln();
	writeln('------ Listado de empleados mayores de ',edadCorte,' ------');
	while(not eof(empleados))do begin
		read(empleados,e);
		if(e.edad>edadCorte)then
			imprimirEmpleado(e);
	end;
	close(empleados);
end;

procedure listarEmpleados(var empleados:archivoEmpleados);
var e:empleado;
begin
	reset(empleados);
	writeln();
	writeln('------ Listado de empleados ------');
	while(not eof(empleados))do begin
		read(empleados,e);
		imprimirEmpleado(e);
	end;
	close(empleados);
end;

procedure leerOpcion(var opcion:int8);
begin
	writeln('~~~~~~~~ MENU DE OPCIONES ~~~~~~~~');
	writeln();
	writeln('Opcion 1: Crear y cargar archivo de empleados');
	writeln('Opcion 2: Listar empleados filtrando por nombre o apellido');
	writeln('Opcion 3: Listar todos los empleados');
	writeln('Opcion 4: Listar empleados prontos a jubilarse');
	writeln('Opcion 0: Salir del menu');
	write('Ingrese opcion: ');readln(opcion);
end;

procedure abrirMenu(var empleados:archivoEmpleados);
var opcion:int8;
begin
	leerOpcion(opcion);
	while(opcion<>opcionSalida)do begin
		case opcion of
			1:cargarArchivo(empleados);
			2:listarEmpleadosPorNombre(empleados);
			3:listarEmpleados(empleados);
			4:listarEmpleadosAJubilar(empleados);
		else
			writeln('La opcion ingresada no corresponde a ninguna accion');
		end;
		writeln();
		leerOpcion(opcion);
	end;
end;

function controlUnicidad(var empleados:archivoEmpleados; num: integer):boolean;
var 
	encontre:boolean
	e:empleado;
begin
	encontre:=false;
	reset(empleados);
	while (not eof(empleados)) and (encontre=false)do begin
		read(empleados,e);
		if(e.numEmp=num)then
			encontre:=true;
	end;
	close(empleados);
	controlUnicidad:=encontre;
end;

procedure agregarEmpleados(var empleados:archivoEmpleados);
var
	e:empleado;
begin
	reset(empleados);
	writeln('======== Empleados a agregar ========');
	leerEmpleado(e);
	while(e.apellido<>apellidoSalida)do begin
	
	end;
	
end;

//PP
var 
	empleados:archivoEmpleados;

BEGIN
	randomize;
	assign(empleados,'E3_empleados');
	abrirMenu(empleados);
END.

