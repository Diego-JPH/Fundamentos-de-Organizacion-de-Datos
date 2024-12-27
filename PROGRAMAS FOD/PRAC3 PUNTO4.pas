{
   PRAC3 PUNTO4.pas
   
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
program flores;
type
	reg_flower = record
		name:String[45];
		cod:integer;
	end;
	arch_flowers = file of reg_flower;
	
procedure addFlower (var A:arch_flowers; name:string; cod:integer);
var
	regm,aux,new_reg:reg_flower;
begin
	reset(A);
	read(A,regm);
	new_reg.name:= name; new_reg.cod:= cod;
	if (regm.cod < 0) then begin
		seek(A,(regm.cod * -1));
		read(A,aux);
		seek(A,filepos(A)-1);
		write(A,new_reg);
		seek(A,0);
		write(A,aux);
	end
	else begin
		seek(A,filesize(A));
		write(A,new_reg);
	end;
	close(A);
end;

procedure inform (var A:arch_flowers);
var
	regm:reg_flower;
begin
	while (not eof(A)) do begin
		read(A,regm);
		if (regm.cod > 0) then begin
			writeln('Nombre: ',regm.name);
			writeln('Codigo: ',regm.cod);
			writeln('--------------------');
		end;
	end;
end;

begin
end.
