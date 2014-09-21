function varargout = main_gui(varargin)
% MAIN_GUI MATLAB code for main_gui.fig
%      MAIN_GUI, by itself, creates a new MAIN_GUI or raises the existing
%      singleton*.
%
%      H = MAIN_GUI returns the handle to a new MAIN_GUI or the handle to
%      the existing singleton*.
%
%      MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI.M with the given input arguments.
%
%      MAIN_GUI('Property','Value',...) creates a new MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_gui

% Last Modified by GUIDE v2.5 19-Sep-2014 20:56:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @main_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main_gui is made visible.
function main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_gui (see VARARGIN)

% Choose default command line output for main_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
input = get(hObject,'String'); %Obtiene input, que es el string que se ingresa
handles.videoDirectory = input;
guidata(hObject,handles); %Guarda el string en videoDirectory


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
input = str2double(get(hObject,'string'));
if isnan(input)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
    handles.thresh = input;
    guidata(hObject,handles); %Guarda el string en videoDirectory
end


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
input = str2double(get(hObject,'string'));
if isnan(input)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  handles.areaMax = input;
  guidata(hObject,handles); %Guarda el string en videoDirectory
end


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
input = str2double(get(hObject,'string'));
if isnan(input)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  handles.areaMin = input;
  guidata(hObject,handles); %Guarda el string en videoDirectory
end


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
if get(hObject, 'Value')
    set(handles.edit2, 'enable', 'on');
else
    set(handles.edit2, 'enable', 'off');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
if get(hObject, 'Value')
    set(handles.edit3, 'enable', 'on');
else
    set(handles.edit3, 'enable', 'off');
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
if get(hObject, 'Value')
    set(handles.edit4, 'enable', 'on');
else
    set(handles.edit4, 'enable', 'off');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if (get(handles.checkbox9,'Value') && get(handles.checkbox10,'Value') && get(handles.checkbox11,'Value'))
	processMethod = 0; %LOS 3 BLOQUES, el m�todo por defecto
elseif (get(handles.checkbox9,'Value') && not(get(handles.checkbox10,'Value')) && not(get(handles.checkbox11,'Value')))
	processMethod = 1; %solo SEGMENTACION
elseif (not(get(handles.checkbox9,'Value')) && get(handles.checkbox10,'Value') && not(get(handles.checkbox11,'Value')))
	processMethod = 2; %solo RECONSTRUCCION
elseif (not(get(handles.checkbox9,'Value')) && not(get(handles.checkbox10,'Value')) && get(handles.checkbox11,'Value'))
	processMethod = 3; %solo TRACKING
elseif (get(handles.checkbox9,'Value') && get(handles.checkbox10,'Value') && not(get(handles.checkbox11,'Value')))
	processMethod = 4; %SEGMENTACION y RECONSTRUCCION
elseif (not(get(handles.checkbox9,'Value')) && get(handles.checkbox10,'Value') && get(handles.checkbox11,'Value'))
	processMethod = 5; %RECONSTRUCCION y TRACKING
else
	errordlg('You must enter a valid combination of blocks','Invalid blocks','modal')
  	uicontrol(hObject)
  	return
end

n_markers = handles.TotMarkers;%obtengo el numero de marcadores
names = 1:n_markers;%genero los nombres de los marcadores
names = cellstr(num2str(names'));

path_vid = handles.videoDirectory;
type_vid = handles.videoExtension; %el nombre de la extension siempre debe escribirse como '*.extension'
path_XML = handles.xmlPath ; %donde se quieren los archivos xml luego de la segmentacion
save_segmentation_mat = get(handles.checkbox7, 'Value'); % indica si se quiere guardar la estructura .mat al final de la segmentacion
path_mat = handles.MatPath; %donde se guardan las estructuras .mat luego de la segmentacion
reconsThr_on = get(handles.checkbox8, 'Value'); %indica si se encuentra habilitado el umbral en la reconstruccion
reconsThr = handles.reconsThr; %valor del umbral en reconstruccion %POR DEFECTO DEBERIA SER 0.05
switch processMethod    
    case 0
        %ACA VAN LOS 3 BLOQUES         
        cam_segmentacion = main_segmentacion(names, path_vid, type_vid, path_XML, save_segmentation_mat, path_mat); %ejecuto segmentacion
        
        
    case 1
        %ACA VA SOLO LA SEGMENTACION
        cam_segmentacion = main_segmentacion(names, path_vid, type_vid, path_XML, save_segmentation_mat, path_mat); %ejecuto segmentacion
        
    case 2
        %ACA VA SOLO LA RECONSTRUCCION
        if ~exist('cam_segmentacion') %existe en el workspace una estructura cam_segmentacion        
            load([path_mat, '/cam.mat'])%cargo el archivo cam.mat que contiene la variable cam_segmentacion
        end
        n_frames = get_info(cam_segmentacion(1), 'n_frames');%obtengo el numero de frames de la primera camara, todas las camaras deberian tener igual nro de frame
        %inicializo una estructura skeleton
        [~ , skeleton]=init_structs(n_markers, n_frames, names);            
        skeleton=set_info(skeleton, 'name', 'skeleton');
        
        init_frame=1
        end_frame=10
        
        skeleton = reconstruccion(cam_segmentacion, skeleton, reconsThr, init_frame, end_frame);
    case 3
        %ACA VA SOLO el TRACKING
    case 4
        %ACA VA SEGMENTACION + RECONSTRUCCION
        cam_segmentacion = main_segmentacion(names, path_vid, type_vid, path_XML, save_segmentation_mat, path_mat); %ejecuto segmentacion
        
    case 5
        %ACA va RECONSTRUCCION + TRACKING
end

 
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
input = get(hObject,'String'); %Obtiene input, que es el string que se ingresa
handles.xmlPath = input;
guidata(hObject,handles); %Guarda el string en videoDirectory



% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
input = get(hObject,'String'); %Obtiene input, que es el string que se ingresa
handles.videoExtension = input;
guidata(hObject,handles); %Guarda el string en videoDirectory



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
input = get(hObject,'String'); %Obtiene input, que es el string que se ingresa
handles.videoExtension = input;
guidata(hObject,handles); %Guarda el string en videoDirectory


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
input = str2double(get(hObject,'string'));
if isnan(input)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
  handles.reconsThr = input;
  guidata(hObject,handles); %Guarda el string en videoDirectory
end

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8
if get(hObject, 'Value')
    set(handles.edit9, 'enable', 'on');
else
    set(handles.edit9, 'enable', 'off');
end

% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
if get(hObject, 'Value')
    set(handles.edit8, 'enable', 'on');
else
    set(handles.edit8, 'enable', 'off');
end


function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
input = get(hObject,'String'); %Obtiene input, que es el string que se ingresa
handles.MatPath = input;
guidata(hObject,handles); %Guarda el string en videoDirectory

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9
if get(hObject, 'Value')
    set(handles.checkbox1, 'enable', 'on');
    set(handles.checkbox2, 'enable', 'on');
    set(handles.checkbox3, 'enable', 'on');
    set(handles.checkbox7, 'enable', 'on');
    set(handles.text2, 'enable', 'on');
    set(handles.text4, 'enable', 'on');
    set(handles.edit5, 'enable', 'on');
else
    set(handles.checkbox1, 'enable', 'off');
    set(handles.checkbox2, 'enable', 'off');
    set(handles.checkbox3, 'enable', 'off');
    set(handles.checkbox7, 'enable', 'off');
    set(handles.text2, 'enable', 'off');
    set(handles.text4, 'enable', 'off');
    set(handles.edit5, 'enable', 'off');
end

% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
input = str2double(get(hObject,'string'));
if isnan(input)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
    handles.TotMarkers = input;
    guidata(hObject,handles); %Guarda el string en videoDirectory
end


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


