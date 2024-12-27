{
   PRAC2 PUNTO1.pas
   
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
program comisiones;
Type
	empleado = record
		cod:integer;
		nombre:string;
		monto:real;
	end;
	archivo = file of empleado;

procedure leer (var detalle:archivo; var reg:empleado);
begin
	if (not eof (detalle)) then begin
		read (detalle,reg);
	end
	else begin
		reg.cod:=0000;
	end;
end;
procedure compactar (var maestro:archivo);
var
	detalle:archivo; nombre:string; actual,aux:empleado; montoTotal:real;
begin
	writeln ('Ingrese el nombre del archivo detalle: '); readln (nombre);
	assign (detalle,nombre); reset (detalle);
	writeln ('Ingrese el nombre del nuevo archivo compactado: '); readln (nombre);
	assign (maestro,nombre); rewrite (maestro);
	leer (detalle,aux);
	while (aux.cod <> 0000) do begin
		montoTotal:=0;
		actual:=aux;
		while (actual.cod = aux.cod) do begin
			montoTotal:=montoTotal+aux.monto;
			leer (detalle,aux);
		end;
		actual.monto:=montoTotal;
		write (maestro,actual);
	end;
end;

