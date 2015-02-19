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

% Last Modified by GUIDE v2.5 25-Oct-2014 17:46:01

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

%% CUERPO DE LA FUNCION

%cargo en el path las carpetas de interes
add_paths%por algún motivo cuando entra al GUI borra los paths donde se encuentran los programas
clc
disp('_____________________________________________________________')
disp('Monitor de Procesos')
disp('_____________________________________________________________')
disp(' ')

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

% %SE TIENE QUE GESTIONAR QUE PASA SI NO SE INGRESA path_XML O path_mat DE MANERA
% %ADECUADA LO QUE SIGUE ES UN PARCHE
% if get(handles.checkbox18, 'Value')%Si se tiene habilitada la casilla para ingresar el directorio xml
%     path_XML = handles.xmlPath ; %donde se quieren los archivos xml luego de la segmentacion
%     if get(handles.checkbox19, 'Value')%Si se tiene la activada la casilla para ingresar en el directorio .mat
%         path_mat = handles.MatPath; %donde se guardan las estructuras .mat luego de la segmentacion
%     end
% else if get(handles.checkbox19, 'Value')%Si se tiene la activada la casilla para ingresar en el directorio .mat
%         path_mat = handles.MatPath; %donde se guardan las estructuras .mat luego de la segmentacion
%         path_XML = path_mat;
%     end
% end

path_XML= handles.StructurePath ; %donde se quieren los archivos xml luego de la segmentacion
path_mat = handles.StructurePath ; %donde se guardan las estructuras .mat luego de la segmentacion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if get(handles.checkbox9, 'Value') %Si la segmentacion esta seleccionada 
    path_vid = handles.videoDirectory; 
    
    %%%%%NUNCA DICE QUE EXISTE handles.videoExtension, HAY QUE VER COMO
    %%%%%PREGUNTAR LA EXISTENCIA DE ESTE TIPO DE VARIABLES
    if exist('handles.videoExtension', 'var')%verifico si existe handles.videoExtension
        type_vid = handles.videoExtension; %el nombre de la extension siempre debe escribirse como '*.extension'                
    else
        type_vid = '*.dvd';%por defecto se lee *.dvd
    end    
    save_segmentation_mat = get(handles.checkbox7, 'Value'); % indica si se quiere guardar la estructura .mat al final de la segmentacion
    if get(handles.checkbox20, 'Value')
        saveSegmentedVideos = handles.saveSegmentedVideos;%get(handles.checkbox20, 'Value')  %% indica si se quiere guardar los videos generados en la segmentacion
    else 
        saveSegmentedVideos = nan;
    end
    %verifico que se tengan valores para las casillas habilitadas en la ventana de segmentación
    if get(handles.checkbox1,'Value') %si se tiene activada la casilla Static threshold leo el valor (ya se verifico que este valor está ingresado)
        seg_thr = handles.thresh;
    else
        seg_thr = nan;  %dejo un valor vacio
    end
    if get(handles.checkbox2,'Value') %verifico si se tiene activada la casilla de  Max area
        seg_areaMax = handles.areaMax;
    else
        seg_areaMax = nan;%dejo un valor vacio
    end
    if get(handles.checkbox3,'Value') %verifico si se tiene activada la casilla de  Min area
        seg_areaMin = handles.areaMin;
    else
        seg_areaMin = nan;%dejo un valor vacio
    end
end
%%%%%%%%%%%%%%5
%%%%%%%%%%%%%

if get(handles.checkbox10, 'Value') % Si la reconstruccion esta seleccionada
    save_reconstruction_mat = get(handles.checkbox12, 'Value'); % indica si se quiere guardar la estructura .mat al final de la reconstruccion
    reconsThr_on = get(handles.checkbox8, 'Value'); %indica si se encuentra habilitado el umbral en la reconstruccion
    if reconsThr_on %si el usuario no ingreso un umbral para reconstruccion
        reconsThr = handles.reconsThr; %valor del umbral en reconstruccion %POR DEFECTO DEBERIA SER 0.05
    else
        reconsThr = 0.05; %valor por defecto del umbral para reconstruccion
    end
    InitFrameSeg = handles.InitFrameSeg;
    EndFrameSeg = handles.EndFrameSeg;
    if get(handles.radiobutton3, 'Value')%si se tiene activada la casilla donde se indican las camaras que se utilizaran para la reconstruccion
        vec_cams = handles.vector_cameras;
    else
        vec_cams = -1;%se coloca un valor que indica que se va a reconstruir con todas las camaras
    end
end
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

if get(handles.checkbox11, 'Value') % Si el tracking esta seleccionado
    save_tracking_mat = get(handles.checkbox13, 'Value'); % indica si se quiere guardar la estructura .mat al final del tracking    
    InitFrameTrack = handles.InitFrameTrack;
    EndFrameTrack = handles.EndFrameTrack;
    globalThr_on = get(handles.checkbox23, 'Value'); %indica si se encuentra habilitado el umbral en la reconstruccion
    if globalThr_on 
        globalThr = handles.globalThr; %valor del umbral en reconstruccion %POR DEFECTO DEBERIA SER 0.05
    else
        globalThr = 0; %valor que indica que el umbral se encuentra apagado
    end
    localThr_on = get(handles.checkbox24, 'Value'); %indica si se encuentra habilitado el umbral en la reconstruccion    
end

    
switch processMethod    
    case 0 %SEGMENTACIÓN  RECONSTRUCCION Y TRACKING
        %segmentacion
        disp('_________________________________________')
        disp('Iniciando el proceso de segmentacion')
        disp('')
        cam_seg = main_segmentacion(names, path_vid, type_vid, path_XML, save_segmentation_mat, path_mat, saveSegmentedVideos, seg_thr, seg_areaMax, seg_areaMin); %ejecuto segmentacion
        %reconstruccion
        disp('_________________________________________')
        disp('Iniciando el proceso de reconstruccion')
        disp('')
        skeleton_rec = main_reconstruccion(cam_seg, n_markers, names, reconsThr_on, reconsThr, InitFrameSeg, EndFrameSeg, vec_cams, path_XML, save_reconstruction_mat, path_mat);                
        %tracking
        disp('_________________________________________')
        disp('Iniciando el proceso de tracking')
        disp('')
        [skeleton_track, X_out, datos] = main_tracking(skeleton_rec, InitFrameTrack, EndFrameTrack, save_tracking_mat, path_XML, path_mat, globalThr, localThr_on);
        assignin ('base','skeleton_track',skeleton_track)
        assignin ('base','cam_seg',cam_seg)
        assignin ('base','X_out',X_out)
        
    case 1 %SOLO SEGMENTACION
        disp('_________________________________________')
        disp('Iniciando el proceso de segmentacion')
        disp('')
        cam_seg = main_segmentacion(names, path_vid, type_vid, path_XML, save_segmentation_mat, path_mat, saveSegmentedVideos, seg_thr, seg_areaMax, seg_areaMin); %ejecuto segmentacion
        assignin ('base','cam_seg',cam_seg)
        
    case 2 %SOLO RECONSTRUCCION
        if ~exist('cam_seg', 'var') %si no existe en el workspace una estructura cam_seg  
            disp('--->Cargando una estructura cam, por favor espere.')
            disp('')
            load([path_mat, '/Segmentacion/cam.mat'])%cargo el archivo cam.mat que contiene la variable cam_seg            
        end
        %reconstruccion
        disp('_________________________________________')
        disp('Iniciando el proceso de reconstruccion')
        disp('')
        skeleton_rec = main_reconstruccion(cam_seg, n_markers, names, reconsThr_on, reconsThr, InitFrameSeg, EndFrameSeg, vec_cams, path_XML, save_reconstruction_mat, path_mat);        
        assignin ('base','skeleton_rec',skeleton_rec)
        assignin ('base','cam_seg',cam_seg)
        
    case 3  %SOLO TRACKING
        if ~exist('skeleton_rec', 'var') %si no existe en el workspace una estructura skeleton_rec    
            disp('-->Cargando una estructura skeleton, por favor espere.')
            disp('')
            load([path_mat, '/Reconstruccion/skeleton.mat'])%cargo el archivo skeleton.mat que contiene la variable skeleton_rec
        end
        %tracking
        disp('_________________________________________')
        disp('Iniciando el proceso de tracking')
        disp('')
        [skeleton_track, X_out, datos] = main_tracking(skeleton_rec, InitFrameTrack, EndFrameTrack, save_tracking_mat, path_XML, path_mat, globalThr, localThr_on);
        assignin ('base','skeleton_track',skeleton_track)
        assignin ('base','X_out',X_out)
        
    case 4 %SEGMENTACION Y RECONSTRUCCION
        %segmentacion
        disp('_________________________________________')
        disp('Iniciando el proceso de segmentacion')
        disp('')
        cam_seg = main_segmentacion(names, path_vid, type_vid, path_XML, save_segmentation_mat, path_mat, saveSegmentedVideos, seg_thr, seg_areaMax, seg_areaMin); %ejecuto segmentacion
        %reconstruccion
        disp('_________________________________________')
        disp('Iniciando el proceso de reconstruccion')
        disp('')
        skeleton_rec =main_reconstruccion(cam_seg, n_markers, names, reconsThr_on, reconsThr, InitFrameSeg, EndFrameSeg, vec_cams, path_XML, save_reconstruction_mat, path_mat);        
        %skeleton = main_reconstruccion(cam_segmentacion, n_markers, names, reconsThr_on, reconsThr, InitFrameSeg, EndFrameSeg, path_XML, save_reconstruction_mat, path_mat);
        assignin ('base','skeleton_rec',skeleton_rec)
        assignin ('base','cam_seg',cam_seg)
        
    case 5  %RECONSTRUCCION Y TRACKING
        if ~exist('cam_seg', 'var') %existe en el workspace una estructura cam_segmentacion 
            disp('--->Cargando una estructura cam, por favor espere.')
            disp('')
            load([path_mat, '/Segmentacion/cam.mat'])%cargo el archivo cam.mat que contiene la variable cam_seg
        end
        %reconstruccion
        disp('_________________________________________')
        disp('Iniciando el proceso de reconstruccion')
        disp('')
        skeleton_rec = main_reconstruccion(cam_seg, n_markers, names, reconsThr_on, reconsThr, InitFrameSeg, EndFrameSeg, vec_cams, path_XML, save_reconstruction_mat, path_mat);        
        %skeleton = main_reconstruccion(cam_segmentacion, n_markers, names, reconsThr_on, reconsThr, InitFrameSeg, EndFrameSeg, path_XML, save_reconstruction_mat, path_mat);
        %tracking
        disp('_________________________________________')
        disp('Iniciando el proceso de tracking')
        disp('')
        [skeleton_track, X_out, ~] = main_tracking(skeleton_rec, InitFrameTrack, EndFrameTrack, save_tracking_mat, path_XML, path_mat, globalThr, localThr_on);
        assignin ('base','skeleton_rec',skeleton_rec)
        assignin ('base','skeleton_track',skeleton_track)
        assignin ('base','cam_seg',cam_seg)
        assignin ('base','X_out',X_out)
end



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



% --- Executes on button press in checkbox50. Este checkbox es el del
% umbral Global en tracking
function checkbox23_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox8
if get(hObject, 'Value')
    set(handles.edit33, 'enable', 'on');
else
    set(handles.edit33, 'enable', 'off');
end


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit33_Callback(hObject, eventdata, handles)
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
  handles.globalThr = input;
  guidata(hObject,handles); %Guarda el string en videoDirectory
end

% --- Executes on button press in checkbox51. Este checkbox es el del
% umbral Global en tracking
function checkbox24_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7



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
    set(handles.checkbox20, 'enable', 'on');
    set(handles.pushbutton5, 'enable', 'on');
    if get(handles.checkbox1, 'Value')
       set(handles.edit2, 'enable', 'on'); 
    end
    if get(handles.checkbox2, 'Value')
       set(handles.edit3, 'enable', 'on'); 
    end
    if get(handles.checkbox3, 'Value')
       set(handles.edit4, 'enable', 'on'); 
    end    
    set(handles.edit19, 'enable', 'on');
    set(handles.edit21, 'enable', 'on');
    set(handles.text11, 'enable', 'on');
    set(handles.text13, 'enable', 'on');
    
else
    set(handles.checkbox1, 'enable', 'off');
    set(handles.checkbox2, 'enable', 'off');
    set(handles.checkbox3, 'enable', 'off');
    set(handles.checkbox7, 'enable', 'off');        
    set(handles.checkbox20, 'enable', 'off');        
    set(handles.pushbutton5, 'enable', 'off');        
    set(handles.edit19, 'enable', 'off');
    set(handles.edit21, 'enable', 'off');
    set(handles.edit2, 'enable', 'off');
    set(handles.edit3, 'enable', 'off');
    set(handles.edit4, 'enable', 'off');
    set(handles.text11, 'enable', 'off');    
    set(handles.text13, 'enable', 'off');    
end

% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10
if get(hObject, 'Value')
    set(handles.checkbox8, 'enable', 'on');    
    set(handles.checkbox12, 'enable', 'on');    
    set(handles.text6, 'enable', 'on');
    set(handles.text7, 'enable', 'on');
    set(handles.text20, 'enable', 'on');
    set(handles.text19, 'enable', 'on');
    set(handles.radiobutton2, 'enable', 'on');
    set(handles.radiobutton3, 'enable', 'on');
    if get(handles.checkbox8, 'Value')
        set(handles.edit9, 'enable', 'on');
    end
    if get(handles.radiobutton3, 'Value')
        set(handles.edit30, 'enable', 'on');
    end
    set(handles.edit11, 'enable', 'on');
    set(handles.edit12, 'enable', 'on');
else
    set(handles.checkbox8, 'enable', 'off'); 
    set(handles.checkbox12, 'enable', 'off'); 
    set(handles.radiobutton2, 'enable', 'off');
    set(handles.radiobutton3, 'enable', 'off');
    set(handles.text6, 'enable', 'off');
    set(handles.text7, 'enable', 'off');
    set(handles.text20, 'enable', 'off');
    set(handles.text19, 'enable', 'off');
    set(handles.edit9, 'enable', 'off');
    set(handles.edit11, 'enable', 'off');
    set(handles.edit12, 'enable', 'off');
    set(handles.edit30, 'enable', 'off');
end

% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11
if get(hObject, 'Value')    
    set(handles.checkbox13, 'enable', 'on');
    set(handles.checkbox23, 'enable', 'on');
    set(handles.checkbox24, 'enable', 'on');
    set(handles.text14, 'enable', 'on');
    set(handles.text15, 'enable', 'on');    
    set(handles.edit22, 'enable', 'on');
    set(handles.edit23, 'enable', 'on');   
    if get(handles.checkbox23, 'Value')
        set(handles.edit33, 'enable', 'on');
    end
else
    set(handles.checkbox13, 'enable', 'off');
    set(handles.checkbox23, 'enable', 'off');
    set(handles.checkbox24, 'enable', 'off');
    set(handles.text14, 'enable', 'off');
    set(handles.text15, 'enable', 'off');    
    set(handles.edit22, 'enable', 'off');
    set(handles.edit23, 'enable', 'off');
    set(handles.edit33, 'enable', 'off');
    
    
end


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



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double
input = str2double(get(hObject,'string'));
if isnan(input)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
    handles.InitFrameSeg = input;
    guidata(hObject,handles); %Guarda el string en handles.InitFrameSeg
end

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double
input = str2double(get(hObject,'string'));
if isnan(input)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
    handles.EndFrameSeg = input;
    guidata(hObject,handles); %Guarda el string en handles.EndFrameSeg
end

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double
input = get(hObject,'String'); %Obtiene input, que es el string que se ingresa
handles.StructurePath = input;
guidata(hObject,handles); %Guarda el string en videoDirectory

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double
input = get(hObject,'String'); %Obtiene input, que es el string que se ingresa
handles.MatPath = input;
guidata(hObject,handles); %Guarda el string en videoDirectory

% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double
input = get(hObject,'String'); %Obtiene input, que es el string que se ingresa
handles.videoDirectory = input;
guidata(hObject,handles); %Guarda el string en videoDirectory

% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12


% --- Executes during object creation, after setting all properties.
function checkbox7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function text12_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to text12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double
input = get(hObject,'String'); %Obtiene input, que es el string que se ingresa
handles.videoExtension = input;
guidata(hObject,handles); %Guarda el string en videoDirectory

% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
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


% --- Executes during object deletion, before destroying properties.
function edit9_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double
input = str2double(get(hObject,'string'));
if isnan(input)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
    handles.EndFrameTrack = input;
    guidata(hObject,handles); %Guarda el string en handles.EndFrameTrack
end

% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double
input = str2double(get(hObject,'string'));
if isnan(input)
  errordlg('You must enter a numeric value','Invalid Input','modal')
  uicontrol(hObject)
  return
else
    handles.InitFrameTrack = input;
    guidata(hObject,handles); %Guarda el string en handles.InitFrameTrack
end

% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.checkbox9,'Value'))
    segmentacion
end
if (get(handles.checkbox10,'Value'))
    reconstruccion
end
if (get(handles.checkbox11,'Value'))
    tracking
end



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir;
if ~(strcmp(folder_name,'0'));
    set(handles.edit16, 'string', folder_name);
    edit16_Callback(handles.edit16, eventdata, handles)
end
if (strcmp(get(handles.edit16, 'string'),'0'));
    set(handles.edit16, 'string', 'Structure Directory');
end




% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
if get(hObject, 'Value')
    set(handles.radiobutton3, 'Value', 0);
    set(handles.edit30, 'Enable', 'off');
else
    set(handles.radiobutton3, 'Value', 1);
    set(handles.edit30, 'Enable', 'on');
end

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
if get(hObject, 'Value')
    set(handles.radiobutton2, 'Value', 0);
    set(handles.edit30, 'Enable', 'on');
else
    set(handles.radiobutton2, 'Value', 1);
    set(handles.edit30, 'Enable', 'off');
end


function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double
input = get(hObject,'String'); %Obtiene input, que es el string que se ingresa
vec_cameras = input;
cameras = strread(vec_cameras,'%n','delimiter',';');
handles.vector_cameras = cameras;
guidata(hObject,handles); %Guarda el string en videoDirectory

% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir;
if ~(strcmp(folder_name,'0'));
    set(handles.edit19, 'string', folder_name);
    edit19_Callback(handles.edit19, eventdata, handles)
end
if (strcmp(get(handles.edit19, 'string'),'0'));
    set(handles.edit19, 'string', 'Videos Directory');
end


% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%SI ESTE CHECKBOX EST� ACTIVADO HAY QUE PASARLE EL ARGUMENTO s A LA
%SEGMENTACION
handles.saveSegmentedVideos = get(hObject, 'Value');
guidata(hObject,handles); %Guarda el string en videoDirectory
