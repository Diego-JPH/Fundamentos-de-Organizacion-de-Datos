{
   PRAC3PUNTO2.pas
   
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
program congreso;
type
	assistant = record
		nro:integer;
		last_name:string;
		name:string;
		email:string;
		phone_number:integer;
		dni:integer;
	end;
	archive = file of assistant;
	
procedure mark (var mae:archive);
var
	regm:assistant;
begin
	while (not eof(mae)) do begin
		read(mae,regm);
		if (regm.nro < 1000) then begin
			regm.name:= '@' + regm.name;
			seek(mae,filepos(mae)-1);
			write(mae,regm);
		end;
	end;
	close(mae);
end;

procedure eliminate;
var
	mae,new_file:archive;
	regm:assistant;
	name:string;
begin
	writeln('Ingrese el nombre del archivo: '); readln(name);
	assign(mae,name); reset(mae); assign(new_file,'asistentes_mayores_a_1000'); rewrite(new_file);
	mark(mae);
	reset(mae);
	while (not eof(mae)) do begin
		read(mae,regm);
		if (regm.name[1] <> '@') then
			write(new_file,regm);
	end;
	close(mae);
	close(new_file);
end;
