{
El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos
que comercializa. Para ello, dispone de un archivo maestro en el que se registran todos los productos.
De cada producto se almacena la siguiente información: código de producto, nombre comercial, precio de venta,
stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas realizadas. De cada venta se
almacena: código de producto y cantidad de unidades vendidas.

Se solicita desarrollar un programa que permita:

a) Actualizar el archivo maestro a partir del archivo detalle, teniendo en cuenta que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del archivo maestro puede ser actualizado por cero, uno o más registros del archivo detalle.
● El archivo detalle sólo contiene registros cuyos códigos existen en el archivo maestro.

b) Generar un archivo de texto llamado “stock_minimo.txt” que contenga aquellos productos cuyo stock actual se
encuentre por debajo del stock mínimo permitido.
}
program ProductosDeLimpieza;
const
	opSalida = 0;
	valorAlto = 999;
type
	string15=string[15];
	rProd=record
		cod:integer;
		nom:string15;
		precio:real;
		stockAct:integer;
		stockMin:integer;
	end;
	rVenta=record
		cod:integer;
		cantVendidos:integer;
	end;
	archivoProd=file of rProd;
	archivoVentas=file of rVenta;

function randomString(long:integer):string15;
var
	i: int8;
	auxString: string;
begin
	auxString := '';
	for i := 1 to long do
		auxString := auxString + chr(ord('a') + random(26));
	randomString := auxString;
end;

procedure leerProducto(var p:rProd);
begin
	p.nom := randomString(4);
	p.precio := random * 50;
	p.stockAct := random(50);
	p.stockMin := random(15);
end;

procedure imprimirProd(p:rProd);
begin
	write('Codigo: ',p.cod);
	write(' | Nombre: ',p.nom);
	write(' | Precio: $',p.precio:0:2);
	write(' | Stock actual: ',p.stockAct);
	writeln(' | Stock min: ',p.stockMin);
end;
procedure listarProductos(var archProd:archivoProd);
var p:rProd;
begin
	reset(archProd);
	writeln('------ Listado de productos ------');
	while(not eof(archProd))do begin
		read(archProd,p);
		imprimirProd(p);
	end;
	close(archProd);
end;

procedure imprimirVenta(v:rVenta);
begin
	write('Codigo: ',v.cod);
	writeln(' | Unidades vendidas: ',v.cantVendidos);
end;
procedure listarVentas(var archVentas:archivoVentas);
var v:rVenta;
begin
	reset(archVentas);
	writeln('------ Listado de ventas ------');
	while(not eof(archVentas))do begin
		read(archVentas,v);
		imprimirVenta(v);
	end;
	close(archVentas);
end;

procedure leer(var archVentas:archivoVentas; var v:rVenta);
begin
	if(not eof(archVentas))then
		read(archVentas,v)
	else
		v.cod := valorAlto;
end;

procedure cargarArchivoProductos(var archProd:archivoProd);
var p:rProd; i:integer;
begin
	rewrite(archProd);
	for i := 1 to 20 do begin
		p.cod := i;
		leerProducto(p);
		write(archProd, p);
	end;
	close(archProd);
	writeln('Archivo binario de productos cargado correctamente.');
end;

procedure cargarArchivoVentas(var archVentas:archivoVentas);
var v:rVenta; i, aux:integer;
begin
	rewrite(archVentas);
	for i := 1 to 20 do begin
		aux := random(4);
		while (aux > 0) do begin
			v.cod := i;
			v.cantVendidos := random(15);
			write(archVentas, v);
			aux := aux - 1;
		end;
	end;
	close(archVentas);
	writeln('Archivo binario de ventas cargado correctamente.');
end;

procedure actualizarStock(var archProd:archivoProd; var archVentas:archivoVentas);
var
	p:rProd; v:rVenta;
	codAct, totalVentas:integer;
begin
	reset(archProd);
	reset(archVentas);
	
	read(archProd, p);
	leer(archVentas, v);
	
	while(v.cod <> valorAlto)do begin
		codAct := v.cod;
		totalVentas := 0;
		
		while(v.cod = codAct)do begin
			totalVentas := totalVentas + v.cantVendidos;
			leer(archVentas, v);
		end;
		
		while(p.cod <> codAct)do
			read(archProd, p);
		
		p.stockAct := p.stockAct - totalVentas;
		seek(archProd, filepos(archProd) - 1);
		write(archProd, p);
		if(not eof(archProd))then
			read(archProd, p);
	end;
	writeln('Archivo de productos actualizado.');
	close(archProd);
	close(archVentas);
end;

procedure exportarProductosStockMin(var archProd:archivoProd);
var 
	p:rProd;
	archStockMin:text;
begin
	reset(archProd);
	assign(archStockMin,'E2_productosStockMin.txt');
	rewrite(archStockMin);
	while(not eof(archProd))do begin
		read(archProd, p);
		if(p.stockAct < p.stockMin)then
			writeln(archStockMin,p.cod,' ',p.nom,' $',p.precio:0:2,' ',p.stockAct,' ',p.stockMin);
	end;
	close(archProd);
	close(archStockMin);
	writeln('Exportados productos con stock minimo');
end;

procedure leerOpcion(var op:int8);
begin
	writeln('~~~ MENU DE OPCIONES ~~~');
	writeln();
	writeln('Opcion 1: Actualizar stock');
	writeln('Opcion 2: Exportar productos con stock minimo');
	writeln('Opcion 3: Listar productos');
	writeln('Opcion 4: Listar ventas');
	writeln('Opcion 0: Salir del menu');
	write('Ingrese opcion: ');readln(op);
	writeln();
end;

procedure abrirMenu(var archProd:archivoProd; var archVentas:archivoVentas);
var op:int8;
begin
	leerOpcion(op);
	while(op<>opSalida)do begin
		case op of
			1:actualizarStock(archProd,archVentas);
			2:exportarProductosStockMin(archProd);
			3:listarProductos(archProd);
			4:listarVentas(archVentas);
		else
			writeln('Opcion invalida');
		end;
		writeln();
		leerOpcion(op);
	end;
end;

//pp
var 
	archProd:archivoProd;
	archVentas:archivoVentas;
BEGIN
	randomize;
	assign(archProd,'E2_productos');
	assign(archVentas,'E2_ventas');
	cargarArchivoProductos(archProd);
	cargarArchivoVentas(archVentas);
	abrirMenu(archProd,archVentas);
END.
