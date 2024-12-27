{
   PRAC2 PUNTO7.pas
   
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
program covid;
uses
	SysUtils;
const
	valorAlto = 9999;
	dimF = 3;
type
	casos = record
		codLocalidad:integer;
		codCepa:integer;
		casosActivos:integer;
		casosNuevos:integer;
		casosRecuperados:integer;
		cantFallecidos:integer;
	end;
	localidad = record
		codLocalidad:integer;
		nomLocalidad:string;
		codCepa:integer;
		nomCepa:string;
		casosActivos:integer;
		casosNuevos:integer;
		casosRecuperados:integer;
		cantFallecidos:integer;
	end;
	maestro = file of localidad;
	detalle = file of casos;
	vecDet = array [1..dimF] of file of casos;
	vecReg = array [1..dimF] of casos;
	
procedure leer (var det:detalle; var dato:casos);
begin
	if (not eof (det)) then begin
		read (det,dato);
	end
	else begin
		dato.codLocalidad:=valorAlto;
		dato.codCepa:=valorAlto;
	end;
end;
procedure minimo (var det:vecDet;var reg:vecReg;var min:casos);
var
	pos,i:integer;
begin
	min.codLocalidad:=valorAlto; min.codCepa:=valorAlto;
	for i:=1 to dimF do begin
		if ((reg[i].codLocalidad < min.codLocalidad) and (reg[i].codCepa < min.codCepa)) then begin
			min:=reg[i];
			pos:=i;
		end;
	end;
	leer (det[pos],reg[pos]);
end;

procedure imprimirMaestro;
var
	mae:maestro; regm:localidad;
begin
	assign (mae,'maestro'); reset (mae);
	while (not eof (mae)) do begin
		read (mae,regm);
		if (regm.casosActivos > 50) then
			writeln (regm.codLocalidad,' ',regm.nomLocalidad,' ',regm.casosActivos);
	end;
	close (mae);
end;

procedure cargarDetalles;
var
	regd:casos; i:integer; det:vecDet;
begin
	for i:=1 to dimF do begin
		assign (det[i],'det'+IntToStr(i));
		rewrite (det[i]);
		writeln ('Ingrese el cod de localidad: '); readln (regd.codLocalidad);
		writeln ('Ingrese el cod de la cepa: '); readln (regd.codCepa);
		writeln ('Ingrese la cantidad de casos activos: '); readln (regd.casosActivos);
		writeln ('Ingrese la cantidad de casos nuevos: '); readln (regd.casosNuevos);
		writeln ('Ingrese la cantidad de casos recuperados: '); readln (regd.casosRecuperados);
		writeln ('Ingrese la cantidad de fallecidos: '); readln (regd.cantFallecidos);
		write (det[i],regd);
		close (det[i]);
	end;
end;

procedure cargarMaestro;
var
	mae:maestro; regm:localidad; continuar:integer;
begin
	assign (mae,'maestro'); rewrite (mae); continuar:=1;
	while (continuar = 1) do begin
		writeln	('Ingrese el cod de localidad: '); readln (regm.codLocalidad);
		writeln ('Ingrese el nombre de la localidad: '); readln (regm.nomLocalidad);
		writeln ('Ingrese el cod de cepa: '); readln (regm.codCepa);
		writeln ('Ingrese el nombre de la cepa: '); readln (regm.nomCepa);
		writeln ('Ingrese la cantidad de casos activos: '); readln (regm.casosActivos);
		writeln ('Ingrese la cantidad de casos nuevos: '); readln (regm.casosNuevos);
		writeln ('Ingrese la cantidad de casos recuperados: '); readln (regm.casosRecuperados);
		writeln ('Ingrese la cantidad de fallecidos: '); readln (regm.cantFallecidos);
		write (mae,regm);
		writeln ('Desea ingresar otra localidad? (1 = si, 2 = no)'); readln (continuar);
	end;
	close (mae);
end;

var
	regd:casos; det:vecDet; reg:vecReg; mae:maestro; regm:localidad;
	i,cantFallecidos,cantRecuperados,cantActivos,cantNuevos,codLoc,codCepa:integer;
begin
	cargarMaestro;
	cargarDetalles;
	for i:=1 to dimF do begin
		assign (det[i],'det'+IntToStr(i));
		reset (det[i]);
		leer (det[i],reg[i]);
	end;
	assign (mae,'maestro'); reset (mae); read (mae,regm);
	minimo (det,reg,regd);
	while (regd.codLocalidad <> valorAlto) do begin
		cantFallecidos:=0; cantRecuperados:=0; cantActivos:=0; cantNuevos:=0; codLoc:=regd.codLocalidad; codCepa:=regd.codCepa;
		while ((regd.codLocalidad = codLoc) and (regd.codCepa = codCepa)) do begin {es necesario preguntar por ambas condiciones, sino acumularia todas segun la localidad o la cepa segun la comparacion que elija}
			cantFallecidos:=cantFallecidos+regd.cantFallecidos;
			cantRecuperados:=cantRecuperados+regd.casosRecuperados;
			cantActivos:=cantActivos+regd.casosActivos;
			cantNuevos:=cantNuevos+regd.casosNuevos;
			minimo (det,reg,regd);
		end;
		regm.cantFallecidos:=regm.cantFallecidos+cantFallecidos; regm.casosRecuperados:=regm.casosRecuperados+cantRecuperados;
		regm.casosActivos:=cantActivos; regm.casosNuevos:=cantNuevos;
		while ((codLoc <> regm.codLocalidad) or (codCepa <> regm.codCepa)) do begin {si almenos uno es distinto debe continuar buscando}
			read (mae,regm);
		end;
		seek (mae,filepos(mae)-1);
		write (mae,regm);
		if (not eof (mae)) then
			read (mae,regm);
	end;
	for i:=1 to dimF do begin
		close (det[i]);
	end;
	close (mae);
	imprimirMaestro;
end.
