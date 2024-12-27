{
   PRAC 2 PUNTO3.pas
   
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
program stock;
const valorAlto = 9999;
type
	producto = record
		cod:integer;
		nombre:string;
		precio:real;
		stockAct:integer;
		stockMin:integer;
	end;
	venta = record
		cod:integer;
		cantVendida:integer;
	end;
	maestro = file of producto; detalle = file of venta;
	
procedure leer (var arch:detalle; var dato:venta);
begin
	if (not eof (arch)) then begin
		read (arch,dato);
	end
	else begin
		dato.cod:=valorAlto;
	end;
end;

procedure actualizarStock (nomM,nomD:string);
var
	regm:producto; regd:venta; mae:maestro; det:detalle; 
	cantVendida,codAct:integer;
begin
	assign (mae,nomM); assign (det,nomD); reset (mae); reset (det);
	read (mae,regm); leer (det,regd);
	while (regd.cod <> valorAlto) do begin
		codAct:=regd.cod; cantVendida:=0;
		while (regd.cod = codAct) do begin
			cantVendida:=cantVendida + regd.cantVendida;
			leer (det,regd);
		end;
		while (regm.cod <> codAct) do begin
			read (mae,regm);
		end;
		regm.stockAct:=regm.stockAct - cantVendida;
		seek (mae,filepos(mae)-1);
		write (mae,regm);
		if (not eof (mae)) then
			read (mae,regm);
	end;
	close (mae); close (det);
end;

procedure importarStockMinimo (nomM,nomD:string);
var
	mae:maestro; texto:text; regm:producto; 
begin
	assign (mae,nomM); assign (texto,'stock_minimo.txt'); reset (mae); rewrite (texto);
	read  (mae,regm);
	while (not eof (mae)) do begin
		if (regm.stockAct < regm.stockMin) then
			writeln (texto,regm.cod,' ', regm.precio,' ',regm.stockAct,' ',regm.stockMin,' ',regm.nombre);
		read (mae,regm);
	end;
	close (mae); close (texto);
end;
 
begin
end.
