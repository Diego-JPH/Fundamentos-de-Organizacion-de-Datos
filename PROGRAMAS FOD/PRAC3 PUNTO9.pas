{
   PRAC3 PUNTO9.pas
   
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
program negocio;
type
	product = record
		cod:integer;
		name:string;
		price:real;
		stockAct:integer;
		stockMin:integer;
	end;
	sale = record
		cod:integer;
		amount:integer;
	end;
	master = file of product;
	detail = file of sale;
	
procedure updateMaster (var mas:master; var det:detail);
var
	regm:product;
	regd:sale;
begin
	while (not eof(det)) do begin
		read(det,regd);
		seek(mas,0);
		read(mas,regm);
		while ((not eof(mas)) and (regm.cod <> regd.cod)) do {el not eof(mas) podria no ser necesario si es que si o si existe el producto}
			read(mas,regm);
		if (regm.cod = regd.cod) then begin
			regm.stockAct:= regm.stockAct - regd.amount;
			seek(mas,filepos(mas)-1);
			write(mas,regm);
		end;
	end;
end;
{Para el punto B recorreria producto por producto del maestro y busco todas sus
* coincidencias en el detalle, llevo un contador de las ventas totales y ahi si
* actualizo el maestro, lo malo seria que recorreria TODOS los productos del
* archivo maestro, lo que podria no ser necesario.}
begin
end.
