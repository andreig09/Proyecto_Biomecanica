function str = num2str_2(num)
%Funcion que permite llevar los numero a string en un formato adecuado para
%el xml y las resoluciones que se necesitan
str = num2str(num, '%30.13g');
end