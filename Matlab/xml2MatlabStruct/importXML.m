function salida = importXML(archivo)
xml = xmlread(archivo);

children = xml.getChildNodes;

Detected_Markers = children.item(0);

frames = Detected_Markers.getChildNodes;

totalFrames = frames.getLength;

l=1;
for i=0:(totalFrames-1)
    if frames.item(i).getNodeName == 'Frame'
        salida(l)= parsearFrame(frames.item(i));
        l = l+1;
    end
end

function frameI = parsearFrame(Frame)
%Puede pasar que un frame no tenga marcadores
if (Frame.hasChildNodes) && (Frame.getLength > 1)
    k=1;
    markers = Frame.getChildNodes;

    totalMarkers = markers.getLength;

    for i = 0:(totalMarkers - 1)
        if markers.item(i).getNodeName == 'Marker'
            %Agregar nombre del marcador a frame.name
            frameI.name(k) = getMarkerName(markers.item(i));
            %Crear matriz de coordenadas
            frameI.X(:,k) = getMarkerPosition(markers.item(i));
            k = k+1;
        end
    end
else
    frameI.name = NULL;
    frameI.X = NULL;
end

function name = getMarkerName(Marker)
name = Marker.getAttribute('id');

function xyz = getMarkerPosition(Marker)
centroid =  Marker.getChildNodes.item(1);
coordenadas = centroid.getAttributes;
xyz = [str2num(coordenadas.item(0).getValue.toString); str2num(coordenadas.item(1).getValue.toString); 0];

