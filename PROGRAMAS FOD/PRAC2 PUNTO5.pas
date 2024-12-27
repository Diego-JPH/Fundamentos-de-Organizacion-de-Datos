{
   PRAC2 PUNTO5.pas
   
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
program empresa;
uses
	SysUtils;
const dimF = 30;
	  valorAlto = 9999;
type
	producto = record
		cod:integer;
		nombre:string;
		descripcion:string;
		stockDisp:integer;
		stockMin:integer;
		precio:real;
	end;
	venta = record
		cod:integer;
		cantVendida:integer;
	end;
	maestro = file of producto;
	detalle = file of venta;
	arc_detalle = array [1..dimF] of file of venta;
	reg_detalle = array [1..dimF] of venta;
	
procedure leer (var arch:detalle; var reg:venta);
begin
	if (not eof (arch)) then begin
		read (arch,reg);
	end
	else begin
		reg.cod:=valorAlto;
	end;
end;
procedure minimo (var archV:arc_detalle; var regV:reg_detalle; var min:venta);
var
	i,pos:integer;
begin
	min.cod:=valorAlto;
	for i:= 1 to dimF do begin
		if (regV[i].cod < min.cod) then begin
			min:=regV[i];
			pos:=i;
		end;
	end;
	leer (archV[pos],regV[pos]);
end;
procedure importarSinStock (var mae:maestro);
var
	texto:text; regm:producto;
begin
	reset (mae); assign (texto,'PorDebajoDelStock.txt'); rewrite (texto);
	if (not eof (mae)) then
		read (mae,regm);
	while (not eof (mae)) do begin
		if (regm.stockDisp < regm.stockMin) then begin
			writeln (texto,regm.precio,' ',regm.nombre,' ');
			writeln (texto,regm.stockDisp,' ',regm.descripcion,' ');
		end;
		read (mae,regm);
	end;
	close (mae); close (texto);
end;

var
	deta:arc_detalle; reg_det:reg_detalle; min:venta; regm:producto; mae:maestro;
	i,totalVentas:integer;
begin
	for i:=1 to dimF do begin
		assign (deta[i],'deta'+IntToStr(i));
		reset (deta[i]);
		leer (deta[i],reg_det[i]);
	end;
	assign (mae,'maestro'); reset (mae); read (mae,regm);
	minimo (deta,reg_det,min);
	while (min.cod <> valorAlto) do begin
		while (regm.cod <> min.cod) do begin
			read (mae,regm);
		end;
		totalVentas:=0;
		while (regm.cod = min.cod) do begin
			totalVentas:=totalVentas+min.cantVendida;
			minimo (deta,reg_det,min);
		end;
		regm.stockDisp:=regm.stockDisp-totalVentas;
		seek (mae,filepos(mae)-1);
		write (mae,regm);
		if (not eof (mae)) then
			read (mae,regm);
	end;
	for i:=1 to dimF do begin
		close (deta[i]);
	end;
	importarSinStock (mae);
	close (mae);
end.
