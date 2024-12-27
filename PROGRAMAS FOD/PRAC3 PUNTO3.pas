{
   PRAC3 PUNTO3.pas
   
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
program novelas;
type
	novel = record
		cod:integer;
		gender:string;
		name:string;
		duration:string;
		director:string;
		price:real;
	end;
	archive = file of novel;

procedure create (var mae:archive); 
var
	regm:novel;
	continue:boolean; opt:integer;
begin
	regm.cod:= 0;
	write(mae,regm); {cabecera}
	continue:= true;
	while (continue) do begin
		writeln('Ingrese el codigo de novela: '); readln(regm.cod);
		writeln('Ingrese el genero: '); readln(regm.gender);
		writeln('Ingrese el nombre de la novela: '); readln(regm.name);
		writeln('Ingrese la duracion: '); readln(regm.duration);
		writeln('Ingrese el nombre del director: '); readln(regm.director);
		writeln('Ingrese el precio de la novela: '); readln(regm.price);
		write(mae,regm);
		writeln('Desea ingresar otra novela? (1=si 2=no)'); readln(opt);
		if (opt = 2) then
			continue:= false;
	end;
end;

procedure addNovel (var mae:archive);
var
	header,regm,aux:novel;
begin
	reset(mae); read(mae,header);
	writeln('Ingrese el codigo de novela: '); readln(regm.cod);
	writeln('Ingrese el genero: '); readln(regm.gender);
	writeln('Ingrese el nombre de la novela: '); readln(regm.name);
	writeln('Ingrese la duracion: '); readln(regm.duration);
	writeln('Ingrese el nombre del director: '); readln(regm.director);
	writeln('Ingrese el precio de la novela: '); readln(regm.price);
	if (header.cod <> 0) then begin
		seek(mae,(header.cod * -1));
		read(mae,aux);
		seek(mae,filepos(mae)-1);
		write(mae,regm);
		seek(mae,0);
		write(mae,aux);
	end
	else begin
		seek(mae,filesize(mae));
		write(mae,regm);
	end;
end;

procedure modifyNovel (var mae:archive);
var
	regm,aux:novel;
begin
	reset(mae);
	read(mae,regm);
	writeln('Ingrese el cod de la novela a modificar: '); readln(aux.cod);
	while ((not eof(mae)) and (regm.cod <> aux.cod)) do
		read(mae,regm);
	if (regm.cod = aux.cod) then begin
		writeln('Ingrese el genero: '); readln(aux.gender);
		writeln('Ingrese el nombre de la novela: '); readln(aux.name);
		writeln('Ingrese la duracion: '); readln(aux.duration);
		writeln('Ingrese el nombre del director: '); readln(aux.director);
		writeln('Ingrese el precio de la novela: '); readln(aux.price);
		seek(mae,filepos(mae)-1);
		write(mae,aux);
	end
	else begin
		writeln('La novela no fue encontrada...');
	end;
end;

procedure eliminate (var mae:archive);
var
	header,regm:novel;
	cod,pos:integer;
begin
	reset(mae); read(mae,header); pos:= 1; 
	writeln('Ingrese el cod de la novela a eliminar: '); readln(cod);
	read(mae,regm);
	while ((not eof(mae)) and (regm.cod <> cod)) do begin
		pos:= pos+1;
		read(mae,regm);
	end;
	if (regm.cod = cod) then begin
		seek(mae,filepos(mae)-1);
		write(mae,header);
		seek(mae,0);
		header.cod:= pos * -1;
		write(mae,header);
	end
	else begin
		writeln('El cod ingresado no pertenece a ninguna novela...');
	end;
end;

procedure menu (var mae:archive);
var
	continue:boolean;
	opt:integer;
begin
	continue:= true;
	while (continue = true) do begin
		writeln('Elija una de las siguientes opciones...');
		writeln('---------------------------------------');
		writeln('0.Salir.');
		writeln('1.Agregar una novela.');
		writeln('2.Modificar los datos de una novela existente.');
		writeln('3.Eliminar una novela.');
		writeln('---------------------------------------');
		readln(opt);
		case opt of
			0: continue:=false;
			1: addNovel(mae);
			2: modifyNovel(mae);
			3: eliminate(mae);
		end;
	end;
end;

procedure importToText (var mae:archive);
var
	regm:novel;
	textNovels:text;
begin
	assign(textNovels,'novelas.txt'); rewrite(textNovels);
	reset(mae);
	read(mae,regm); {me salto el header que contiene la lista inversa}
	while (not eof(mae)) do begin
		read(mae,regm);
		writeln(textNovels,regm.cod,' ',regm.gender,' '); 
		writeln(textNovels,regm.name,' ');
		writeln(textNovels,regm.price,' ',regm.duration,' ');
		writeln(textNovels,regm.director,' ');
		writeln(textNovels,'-----------------');
	end;
	close(textNovels);
end;

var
	mae:archive;
	name:string;
begin
	writeln('Ingrese el nombre del nuevo archivo con novelas: '); readln(name);
	assign(mae,name); rewrite(mae);
	create(mae);
	menu(mae);
	importToText(mae);
	close(mae);
end.
