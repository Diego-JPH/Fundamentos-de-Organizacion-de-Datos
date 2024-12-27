{
   PRAC1 PUNT03.pas
   
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
program punto3;
Type
	empleado = record
		nro:integer;
		apellido:string[20];
		nombre:string[20];
		edad:integer;
		dni:integer; 
	end;
	archivo = file of empleado;
procedure leer (var E:empleado);
begin
	writeln ('Ingrese el apellido: '); readln (E.apellido);
	if (E.apellido <> 'fin') then begin
		writeln ('Ingrese el nombre: '); readln (E.nombre);
		writeln ('Ingrese el numero de empleado: '); readln (E.nro);
		writeln ('Ingrese la edad: '); readln (E.edad);
		writeln ('Ingrese el dni: '); readln (E.dni);
	end;
end;
procedure cargarArchivo (var A:archivo);
var
	E:empleado;
begin
	rewrite (A);
	leer (E);
	while (E.apellido <> 'fin') do begin
		write (A,E);
		leer (E);
	end;
	close (A);
end;
procedure buscarNombre (var A:archivo);
var
	dato:string; aux:empleado; resultados:boolean;
begin
	resultados:=false;
	writeln ('Ingrese el nombre o apellido a buscar: '); readln (dato);
	writeln ('Coincidencias...');
	reset(A);
	while (not eof (A)) do begin
		read(A,aux);
		if (aux.nombre = dato) or (aux.apellido = dato) then begin
			writeln (aux.nombre,' ',aux.apellido,', ',aux.edad,' ',aux.dni,' ',aux.nro);
			resultados:=true;
		end;
	end;
	close (A);
	if (resultados = false) then 
		writeln ('No se hayaron resultados para: ',dato);
end;
procedure imprimirArchivo (var A:archivo);
var
	aux:empleado;
begin
	reset (A);
	while (not eof (A)) do begin
		read(A,aux);
		writeln (aux.nombre,' ',aux.apellido,', ',aux.edad,' ',aux.dni,' ',aux.nro);
	end;
	close(A);
end;
procedure proximosJubilados (var A:archivo);
var
	aux:empleado; resultados:boolean;
begin
	resultados:=false;
	writeln ('Proximos a jubilarse...');
	reset (A);
	while (not eof (A)) do begin
		read(A,aux);
		if (aux.edad > 70) then begin
			writeln (aux.nombre,' ',aux.apellido,', ',aux.edad,' ',aux.dni,' ',aux.nro);
			resultados:=true;
		end;
	end;
	close(A);
	if (resultados = false) then 
		writeln ('No hay empleados proximos a jubilarse...');
end;
procedure aniadirEmpleado (var A:archivo);
var
	continuar:boolean; E,aux:empleado; otro:integer;
begin
	continuar:=true;
	reset (A);
	repeat
		leer (E);
		while ((continuar) and (not eof(A))) do begin
			read (A,aux);
			if (aux.nro = E.nro) then begin
				continuar:=false;
			end;
		end;
		if (continuar) then begin
			seek (A,filesize(A));
			write (A,E);
		end
		else begin
			writeln ('El empleado ya fue registrado...');
		writeln ('Desea ingresar otro empleado? (1 = Si) (2 = No)'); readln (otro);
		end;
	until otro = 2;
	close (A);
end;
procedure modificarEdad (var A:archivo);
var
	E:empleado; continuar,nro,edad:integer;
begin
	continuar:=1;
	reset (A);
	writeln ('Ingrese el numero de empleado: '); readln (nro);
	while (continuar = 1) do begin
		while (not eof (A)) do begin
			read (A,E);
			if (E.nro = nro) then begin
				writeln ('Ingrese la nueva edad: '); readln (edad);
				E.edad:=edad;
				seek (A,filepos(A)-1);
				write (A,E);
				writeln ('Desea modificar la edad de otro empleado? 1 = Si) (2 = No)'); readln (continuar);
			end;
		end;
		if (continuar = 1) then begin
			writeln ('Ingrese el numero de empleado: '); readln (nro);
		end
		else begin
			continuar:=2;
		end;
	end;
	close (A);
end;
procedure exportarArchivo (var A:archivo; var A2:text);
var
	E:empleado;
begin
	assign (A2,'todos_empleados.txt');
	rewrite (A2);
	reset (A);
	while (not eof (A)) do begin
		read (A,E);
		writeln (A2,E.nro,' ',E.edad,' ',E.dni,' ',E.nombre,' ',E.apellido);
	end;
	close (A);
	close (A2);
end;
procedure exportarDniFaltantes (var A:archivo; var A2:text);
var
	E:empleado;
begin
	Assign (A2,'faltaDNIEmpleado.txt');
	rewrite (A2);
	reset (A);
	while (not eof (A)) do begin
		read (A,E);
		if (E.dni = 00) then begin
			writeln (A2,E.nro,' ',E.edad,' ',E.dni,' ',E.nombre,' ',E.apellido);
		end;
	end;
	close (A);
	close (A2);
end;

procedure eliminar (var A:archivo);
var
	nro:integer;
	last,act:empleado;
begin
	writeln ('Ingrese el numero de empleado a borrar: (-1 para salir)'); readln (nro);
	while (nro <> -1) do begin
		reset(A);
		seek (A,filesize(A)-1);
		read (A,last);
		seek (A,0);
		read (A,act);
		while (act.nro <> nro) and (not eof (A)) do 
			read (A,act);
		if (act.nro = nro) then begin
			seek (A,filepos(A)-1);
			write (A,last);
			seek (A,filesize(A)-1);
			truncate(A);
		end
		else begin
			writeln ('Valor no encontrado...');
		end;
		writeln ('Ingrese el numero de empleado a borrar: (-1 para salir)'); readln (nro);
	end;
end;

var
	A:archivo; A2,A3:text; nombre:string; opcion:integer;
begin
	opcion:=99;
	writeln ('Elija una opcion...');
	writeln ('____________________________________________________');
	writeln ('Opcion 1: Crear nuevo archivo.');
	writeln ('Opcion 2: Abrir archivo.');
	writeln ('____________________________________________________');
	readln (opcion);
	if (opcion = 1) then begin
		writeln ('Ingrese el nombre de su nuevo archivo: '); readln (nombre); {punto A}
		assign (A,nombre);
		cargarArchivo (A);
	end
	else begin
		writeln ('Ingrese el nombre del archivo sobre el cual se trabajara: '); readln (nombre); {punto B}
		assign (A,nombre);
	end;
	while (opcion <> 0) do begin
		writeln ('Elija una opcion...');
		writeln ('____________________________________________________');
		writeln ();
		writeln ('Opcion 0: Salir.');
		writeln ('Opcion 1: Sobreescribir archivo.');
		writeln ('Opcion 2: Buscar un nombre.');
		writeln ('Opcion 3: Imprimir todo el archivo.');
		writeln ('Opcion 4: Imprimir los empleados proximos a jubilarse.');
		writeln ('Opcion 5: Aniadir empleado.');
		writeln ('Opcion 6: Modificar la edad de uno/s empleado/s.');
		writeln ('Opcion 7: Exportar archivo (todos_empleados.txt).');
		writeln ('Opcion 8: Exportar archivo con empleados sin dni (faltaDNIEmpleado.txt).');
		writeln ('Opcion 9: Eliminar empleados.');
		writeln ('____________________________________________________');
		readln (opcion);
		if (opcion = 0) then begin
			opcion:=0;
		end
		else begin
			if (opcion = 1) then begin
				cargarArchivo (A);
			end
			else begin
				if (opcion = 2) then begin
					buscarNombre (A);
				end
				else begin
					if (opcion = 3) then begin
						imprimirArchivo (A);
					end
					else begin
						if (opcion = 4) then begin
							proximosJubilados (A);
						end
						else begin
							if (opcion = 5) then begin
								aniadirEmpleado (A);
							end
							else begin
								if (opcion = 6) then begin
									modificarEdad (A);
								end
								else begin
									if (opcion = 7) then begin
										exportarArchivo (A,A2);
									end
									else begin
										if (opcion = 8) then begin
											exportarDniFaltantes (A,A3);
										end
										else begin
											eliminar (A);
										end;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
	end;
end.
