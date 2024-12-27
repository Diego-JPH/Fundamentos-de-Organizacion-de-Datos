{
   PARCIAL2018.pas
   
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
program parcial2018;
const
	valorAlto = 9999;
type
	acceso = record
		anio : integer;
		mes : integer;
		dia : integer;
		id : integer;
		tiempoAcceso : real;
	end;
	
	maestro = file of acceso;
	
procedure leer (var mae:maestro; var reg:acceso);
begin
	if (not eof(mae)) then begin
		read(mae,reg);
	end
	else begin
		reg.anio := valorAlto;
		reg.mes := valorAlto;
		reg.dia := valorAlto;
	end;
end;
	
procedure corteControl (var mae : maestro; anio : integer);
var
	regm:acceso;
	totalAnio, totalMes, totalDia:real;
	anioAct, mesAct, diaAct:integer;
begin
	reset(mae);
	read (mae,regm);
	while ((regm.anio <> valorAlto) and (regm.anio <> anio)) do
		leer (mae,regm);
	if (regm.anio <> valorAlto) then begin
		while (regm.anio <> valorAlto) do begin
			writeln ('Anio: ',regm.anio);
			anioAct := regm.anio;
			totalAnio := 0;
			while (regm.anio = anioAct) do begin
				writeln ('Mes: ',regm.mes);
				mesAct := regm.mes;
				totalMes := 0;
				while (regm.mes = mesAct) do begin
					writeln ('Dia: ',regm.dia);
					diaAct := regm.dia;
					totalDia := 0;
					while (regm.dia = diaAct) do begin
						writeln ('-',regm.id,':',' ',regm.tiempoAcceso:0:2);
						totalDia := totalDia + regm.tiempoAcceso;
						totalMes := totalMes + regm.tiempoAcceso;
						totalAnio := totalAnio + regm.tiempoAcceso;
						leer (mae,regm);
					end;
					writeln ('Tiempo total acceso dia: ',totalDia,' mes: ',mesAct);
				end;
				writeln('Tiempo total acceso en el mes: ',totalMes);
			end;
			writeln ('Tiempo total acceso en el anio: ',totalAnio);
		end;
	end
	else begin
		writeln ('Anio no encontrado');
	end;
	close(mae);
end;

begin
end.
