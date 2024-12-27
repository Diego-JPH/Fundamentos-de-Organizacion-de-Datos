{
   PRAC2 PUNTO2.pas
   
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
program facultad;
const valorAlto = 'ZZZZ';
type
	alumno = record
		cod:string;
		apellido:string;
		nombre:string;
		cursadas:integer;
		finales:integer;
	end;
	nota = record
		cod:string;
		situacion:string; {cursada/final}
	end;
	maestro = file of alumno;
	detalle = file of nota;

procedure leer (var D:detalle; var dato:nota);
begin
	if (not eof (D)) then begin
		read (D,dato);
	end
	else begin
		dato.situacion:=valorAlto;
	end;
end;
procedure actualizarDatos (var nomM:string; var nomD:string);
var
	M:maestro; D:detalle; aux:nota; alu:alumno;
	cantFinales,cantCursadas:integer;
	codActual:string;
begin
	assign (M,nomM); assign (D,nomD); reset (M); reset (D);
	leer (D,aux); read (M,alu);
	while (aux.situacion <> valorAlto) do begin
		cantFinales:=0; cantCursadas:=0; codActual:=aux.situacion;
		while (aux.situacion = codActual) do begin
			if (aux.situacion = 'cursada') then begin
				cantCursadas:=cantCursadas+1;
			end
			else begin
				cantCursadas:=cantCursadas-1;
				cantFinales:=cantFinales+1;
			end;
			leer (D,aux);
		end;
		while (alu.cod <> codActual) do begin
			read (M,alu);
		end;
		alu.cursadas:=alu.cursadas+cantCursadas;
		alu.finales:=alu.finales+cantFinales;
		seek (M,filepos(M)-1);
		write (M,alu);
		if (not eof (M)) then
			read (M,alu);
	end;
end;
begin
end.
