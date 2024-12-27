{
   PRAC2 PUNTO6.pas
   
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
program oficina;
uses
	SysUtils;
const cantMaquinas = 5;
	  valorAlto = 9999;
type
	dias = 1..31; meses = 1..12; 
	fechas = record
		dia:dias;
		mes:meses;
		anio:integer;
	end;
	recopilacion = record
		cod:integer;
		fecha:fechas;
		tmpTotal:real;
	end;
	sesion = record
		cod:integer;
		fecha:fechas;
		tmpSesion:real;
	end;
	maestro = file of recopilacion;
	detalle = file of sesion;
	vecDetalle = array [1..cantMaquinas] of file of sesion;
	vecRegistro = array [1..cantMaquinas] of sesion;

procedure leer (var det:detalle; var dato:sesion);
begin
	if (not eof (det)) then begin
		read (det,dato);
	end
	else begin
		dato.cod:=valorAlto;
	end;
end;
procedure minimo (var vecDet:vecDetalle; var vecReg:vecRegistro; var min:sesion);
var
	i,pos:integer;
begin
	min.cod:=valorAlto; min.fecha.dia:=31; min.fecha.mes:=12; min.fecha.anio:=valorAlto;
	for i:=1 to cantMaquinas do begin
		if ((vecReg[i].cod < min.cod) and (vecReg[i].fecha.dia < min.fecha.dia) and (vecReg[i].fecha.mes < min.fecha.mes) and (vecReg[i].fecha.anio < min.fecha.anio)) then begin
			pos:=i;
			min:=vecReg[i];
		end;
	end;
	leer (vecDet[pos],vecReg[pos]);
end;

var
	vecDet:vecDetalle; vecReg:vecRegistro; mae:maestro; min:sesion; regm:recopilacion;
	i:integer;
	totalSesion:real;
begin
	for i:=1 to cantMaquinas do begin
		assign (vecDet[i],'det'+IntToStr(i));
		reset (vecDet[i]);
		leer (vecDet[i],vecReg[i]);
	end;
	assign (mae,'maestro'); rewrite (mae); read (mae,regm);
	minimo (vecDet,vecReg,min);
	while (min.cod <> valorAlto) do begin
		totalSesion:=0;
		while (regm.cod = min.cod) do begin
			totalSesion:=totalSesion+min.tmpSesion;
			minimo (vecDet,vecReg,min);
		end;
		regm.tmpTotal:=totalSesion;
		seek (mae,filepos(mae)-1);
		write (mae,regm);
		if (not eof (mae)) then
			read (mae,regm);
	end;
	for i:=1 to cantMaquinas do begin
		close (vecDet[i]);
	end;
	close (mae);
end.
