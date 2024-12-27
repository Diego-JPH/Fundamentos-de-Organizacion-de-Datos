{
   PRAC2 PUNTO 9.pas
   
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
program cortecontrol;
const
	valorAlto = 9999;
type
	informacion = record
		codProv:integer;
		codLocal:integer;
		nroMesa:integer;
		cantVotos:integer;
	end;
	maestro = file of informacion;
	
procedure leer (var mae:maestro; var dato:informacion);
begin
	if (not eof (mae)) then begin
		read (mae,dato);
	end
	else begin
		dato.codProv:=valorAlto;
		dato.codLocal:=valorAlto;
	end;
end;

var
begin
	assign (mae,'maestro'); reset (mae); read (mae,regm);
	while (remg.codProv <> valorAlto) do begin
		provAct:=regm.codProv; totalProv:=0;
		writeln ('Codigo de provincia actual: ',provAct);
		while ((regm.codProv = provAct) do begin
			locAct:=regm.codLocal; totalVotos:=0;
			while (regm.codLocal = locAct) do begin
				totalVotos:=totalVotos+regm.cantVotos;
				totalProv:=totalProv+regm.cantVotos;
				leer (mae,regm);
			end;
			write ('Codigo de localidad: ',locAct); writeln (' Total de votos: ',totalVotos);
		end;
		writeln ('Total de votos en la provincia: ',totalProv);
		if (remg.codProv <> valorAlto) then
			read (mae,regm);
	end; 
end.
