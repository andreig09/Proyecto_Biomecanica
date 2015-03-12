fileID = fopen('Marcador_en_origen.bvh');

n=1;%variable auxiliar
C = cell(1, 200);
%formo un cell array C con las filas del bvh
while ~feof(fileID) 
   leer_linea = fgetl(fileID);
   if isempty(leer_linea) || ~ischar(leer_linea), break, end
   C(n)= cellstr(leer_linea);
   if strfind(C{n}, 'MOTION') %encuentro donde se tiene la linea 'MOTION'
       index_data = n+3;
   end
   n=n+1;
end
fclose(fileID);
C=C';
InfoFrames = C(index_data:n-1);%Me quedo solo con los datos de cada frame
InfoFrames = str2num(char(InfoFrames));%llevo toda la info a una matriz
InfoHipTraslation= InfoFrames(:,1:3);%Me quedo solo con la traslacion del HIP origen
%Modifico la traslacion de HIP destino
InfoHipTraslation(:,1)=2;
InfoFrames(:,1:3)=InfoHipTraslation;


InfoFrames= num2str_2(InfoFrames);%llevo nuevamente a string la informacion de cada frame
[row, ~]= size(InfoFrames);
for k=1:row
    C{k-1+index_data}=InfoFrames(k, :);
end
%%Llevo numeros nuevamente a un string
%InfoHipTraslation_str =cellfun(@num2str_2, InfoHipTraslation, 'UniformOutput', false);
%a=InfoHipTraslation_str{:};
%C{index_MOTION+3} = a

fid=fopen('salida.bvh','wt');
[rows,cols]=size(C);
for i=1:rows
      fprintf(fid,'%s \n',C{i, end});      
end
fclose(fid);
