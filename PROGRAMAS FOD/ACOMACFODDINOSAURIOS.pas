	{
   ACOMACFODDINOSAURIOS.pas
   
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
program dinosaurios;
const
	valorAlto = 9999;
type
	especie = record
		cod : integer;
		tipo : string;
		altura : real;
		peso : real;
		descripcion : string;
		zona : string;
	end;
	tArchDinos = file of especie;
	
procedure agregarDinosaurios (var a: tArchDinos ; registro: especie);
var
	header:especie;
begin
	reset(a);
	read(a,header);
	if (header.cod < 0) then begin
		seek(a,(header.cod * -1));
		read(a,header);
		seek(a,filepos(a)-1);
		write(a,registro);
		seek(a,0);
		write(a,header);
	end
	else begin
		seek(a,filesize(a));
		write(a,registro);
	end;
end;

procedure listarContenidoEnTxt (var a:tArchDinos);
var
	aTxt:text;
	regm:especie;
begin
	assign(aTxt,'Archivo de texto');
	rewrite(aTxt);
	read(a,regm);
	while (not eof(a)) do begin
		if (regm.cod > 0) then begin
			writeln(aTxt,regm.cod,' ',regm.tipo,' ');
			writeln(aTxt,regm.altura,' ',regm.peso,' ');
			writeln(aTxt,regm.descripcion,' ');
			writeln(aTxt,regm.zona,' ');
		end;
		read(a,regm);
	end;
end;

procedure leer (var mae:maestro; var reg:especie);
begin
	if (not eof(mae)) then begin
		read(mae,reg);
	end
	else begin
		reg.cod:= valorAlto;
	end;
end;

var
	a:tArchDinos;
	tipo,pos:integer;
	header,regm:especie;
begin
	assign(a,'archivo');
	reset(a);
	writeln ('Ingrese el codigo del tipo de dinosaurio a eliminar: (-1 para salir)'); readln (tipo);
	while (tipo <> -1) do begin
		reset(a);
		read(a,header);
		read(a,regm);
		pos:= 1;
		while ((regm.cod <> valorAlto) and (regm.cod <> tipo)) do begin
			leer(mae,regm);
			pos:= pos+1;
		end;
		//while ((not eof(a)) and (regm.cod <> tipo)) do begin
		//	read(a,regm);
		//	pos:= pos+1;
		//end; Es mejor usar el leer 
		if (regm.cod = tipo) then begin
			//seek(a,filepos(a)-1); en este caso no debo retroceder
			write(a,header);
			seek(a,0);
			header.cod := pos * -1;
			write(a,header);
			writeln ('Se borro exitosamente...');
			writeln ('Ingrese el codigo del tipo de dinosaurio a eliminar: (-1 para salir)'); readln (tipo);
		end
		else begin
			writeln('El codigo ingresado no fue encontrado...');
			writeln ('Ingrese el codigo del tipo de dinosaurio a eliminar: (-1 para salir)'); readln (tipo);
		end;
	end;
end.
