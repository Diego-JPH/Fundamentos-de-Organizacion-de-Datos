{
   PRAC3 PUNTO10.pas
   
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
program elecciones;
type
	information = record
		cod:integer;
		nroTable:integer;
		cantVotes:integer;
	end;
	master = file of information;

procedure inform (var mas:master);
var
	pos,totalVotes,cantVotes,codAct:integer;
	regm:information;
begin
	pos:=-1; totalVotes:= 0;
	writeln('Codigo de localidad      Total de Votos');
	while (not eof(mas)) do begin
		pos:= pos+1;
		seek(mas,pos);
		read(mas,regm);
		codAct:= regm.cod;
		cantVotes:= 0;
		seek(mas,0);
		while (not eof(mas)) do begin
			read(mas,regm);
			if (codAct = regm.cod) then begin
				cantVotes:= cantVotes + regm.cantVotes;
				totalVotes:= totalVotes + regm.cantVotes;
			end;
		end;
		writeln (codAct,'                       ',cantVotes);
	end;
	writeln('Total General de Votos: ',totalVotes);
end;
{Otra solucion seria crear un nuevo archivo en el que ir guardando los codigos
* e ir recorriendo solo una vez el archivo maestro, buscar una coincidencia en el
* nuevo archivo y actualizar el contador, en caso de que no este, lo agrego al final
* eso reduciria un poco la ineficiencia actual, ya que estoy recorriendo multiples 
* veces el archivo maestro}
begin
end.
