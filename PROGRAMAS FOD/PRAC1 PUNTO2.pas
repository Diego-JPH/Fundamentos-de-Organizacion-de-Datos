{
   PRAC1 PUNTO2.pas
   
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
program PRAC1PUNTO2;
Type
	archivo = file of integer;
var
	nombre:string; arch:archivo; cantMenores,cantDatos,prom,dato:integer;
begin
	cantMenores:=0; cantDatos:=0; prom:=0;
	writeln ('Ingrese el nombre del archivo a procesar: '); readln (nombre);
	assign (arch,nombre);
	reset (arch);
	while (not eof (arch)) do begin
		read (arch,dato); {avanza en 1 en el archivo}
		if (dato < 1500) then begin
			cantMenores:=cantMenores+1;
		end;
		prom:=prom+dato;
		cantDatos:=cantDatos+1;
		writeln ('Dato numero ',cantDatos,' contenido en el archivo: ',dato);
	end;
	writeln ('Cantidad de numeros menores a 1500: ',cantMenores);
	writeln ('Promedio de los numeros del archivo: ',(prom / cantDatos):0:2);
end.

