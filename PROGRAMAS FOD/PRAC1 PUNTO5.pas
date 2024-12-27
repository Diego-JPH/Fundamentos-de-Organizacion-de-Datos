{
   PRAC1 PUNTO5.pas
   
   Copyright 2024 Diego <Diego@DESKTOP-B4BHKKN>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
}
program celulares;
Type
	celular = record
		codigo:integer;
		precio:real;
		marca:String;
		stockDisponible:integer;
		stockMinimo:integer;
		descripcion:String;
		nombre:String;
	end;
	archivo = file of celular;
	
procedure cargarArchivoBinario (var nombreBinario:string);
var
	nombre:string; A:archivo; A2:text; C:celular;
begin
	writeln ('Ingrese el nombre para el nuevo archivo binario: '); readln (nombre);
	assign (A,nombre); assign (A2,'celulares.txt'); rewrite (A); reset (A2);
	while (not eof (A2)) do begin
		readln (A2,C.codigo,C.precio,C.marca);
		readln (A2,C.stockDisponible,C.stockMinimo,C.descripcion);
		readln (A2,C.nombre);
		write (A,C);
	end;
	nombreBinario:= nombre;
	close (A); close (A2);
end;
procedure imprimirStockMinimo;
var
	A:archivo; C:celular; nombre:string;
begin
	writeln ('Ingrese el nombre del archivo binario: '); readln (nombre);
	assign (A,nombre); reset (A);
	while (not eof (A)) do begin
		read (A,C);
		if (C.stockDisponible < C.stockMinimo) then
			writeln (C.nombre,' ',C.descripcion,' ',C.marca,' ',C.precio,' ',C.codigo,' ',C.stockDisponible,' ',C.stockMinimo)
	end;
	close (A);
end;
procedure exportarBinario (nombre:string);
var
	A:archivo; A2:text; C:celular;
begin
	nombre:='archivoBinario';
	assign (A,nombre); reset (A); assign (A2,'celulares.txt'); rewrite (A2);
	while (not eof (A)) do begin
		read (A,C);
		writeln (A2,C.codigo,' ',C.precio,' ',C.marca,' ');
		writeln (A2,C.stockDisponible,' ',C.stockMinimo,' ',C.descripcion,' ');
		writeln (A2,C.nombre,' ');
	end;
	close (A); close (A2);
end;
procedure leer (var C:celular);
begin
	writeln ('Ingrese el codigo de celular: (-1 para finalizar)'); readln (C.codigo);
	if (C.codigo <> -1) then begin
		writeln ('Ingrese el precio del celular: '); readln (C.precio);
		writeln ('Ingrese la marca del celular: '); readln (C.marca);
		writeln ('Ingrese el stock disponible: '); readln (C.stockDisponible);
		writeln ('Ingrese el stock minimo: '); readln (C.stockMinimo);
		writeln ('Ingrese la descripcion del celular: '); readln (C.descripcion);
		writeln ('Ingrese el nombre del celular: '); readln (C.nombre);
	end;
end;
procedure aniadirCelular (nombreBinario:string);
var
	A:archivo; C:celular; continuar:integer;
begin
	assign (A,nombreBinario); reset (A); seek (A,filesize(A)); continuar:=1;
	leer (C);
	while (C.codigo <> -1) and (continuar = 1) do begin
		write (A,C);
		writeln ('Desea ingresar otro celular? (1 = si, 2 = no)'); readln (continuar);
		if (continuar = 1) then begin
			leer (C);
		end
		else begin
			continuar:=2;
		end;
	end;
	close (A);
end;
procedure modificarStock (nombreBinario:string);
var
	C:celular; nombre:string; A:archivo;
begin
	writeln ('Ingrese el nombre del celular que quiere modificar stock: '); readln (nombre);
	assign (A,nombreBinario); reset (A);
	read (A,C);
	while (C.nombre <> nombre) do begin
		read (A,C);
	end;
	writeln ('Stock actual: ',C.stockDisponible);
	writeln ('Ingrese el nuevo stock: '); readln (C.stockDisponible);
	seek (A,filepos(A)-1);
	write (A,C);
	close (A);
end;
procedure importarSinStock (nombreBinario:string);
var
	A:archivo; A2:text; C:celular;
begin
	assign (A,nombreBinario); reset (A); assign (A2,'SinStock.txt'); rewrite (A2);
	while (not eof (A)) do begin
		read (A,C);
		if (C.stockDisponible = 0) then begin
			writeln (A2,C.codigo,' ',C.precio,' ',C.marca,' ');
			writeln (A2,C.stockDisponible,' ',C.stockMinimo,' ',C.descripcion,' ');
			writeln (A2,C.nombre,' ');
		end;
	end;
	close (A); close (A2);
end;

var
	nombreBinario:string; opc:integer; continuar:boolean;
begin
	continuar:=true;
	while (continuar = true) do begin
		writeln ('__________________________________________________');
		writeln ('0.Abrir archivo binario');
		writeln ('1.Crear archivo binario de registros');
		writeln ('2.Listar en pantalla celulares con stock inferior al minimo');
		writeln ('3.Exportar archivo binario a "celulares.txt"');
		writeln ('4.Agregar un nuevo celular');
		writeln ('5.Cambiar stock de un celular');
		writeln ('6.Importar celulares sin stock a "SinStock.txt"');
		writeln ('7.Salir del programa');
		writeln ('__________________________________________________');
		writeln ('Elija una opcion... (0 - 1 - 2 - 3 - 4 - 5 - 6)'); readln (opc);
		case opc of
			0:begin 
				writeln ('Ingrese el nombre del archivo: ');
				readln(nombreBinario);
			  end;	
			1:cargarArchivoBinario(nombreBinario);
			2:imprimirStockMinimo;
			3:exportarBinario(nombreBinario);
			4:aniadirCelular(nombreBinario);
			5:modificarStock(nombreBinario);
			6:importarSinStock(nombreBinario);
			7:begin writeln ('Saliendo del programa...'); 
					continuar:= false;
			  end; 
		else
			writeln ('Valor invalido...');
		end;
	end;
end.
