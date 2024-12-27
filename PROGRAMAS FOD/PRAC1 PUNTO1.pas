{
   PRAC1 PUNTO1.pas
   
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
program practica1l;
Type
	archivo = file of integer;
procedure cargarArchivo (var A:archivo);
var
	nro:integer;
begin
	rewrite (A);
	writeln ('Ingrese el numero a almacenar: '); readln (nro);
	while (nro <> 30000) do begin
		write (A, nro);
		readln (nro);
	end;
	close (A);
end;
	
var
	arc_logico:archivo; nombre:string; suma:integer;
begin
	suma:=0;
	writeln ('Ingrese el nombre del archivo: '); readln (nombre);
	assign (arc_logico, nombre);
	cargarArchivo (arc_logico);
end.
