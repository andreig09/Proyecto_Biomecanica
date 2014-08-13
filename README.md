Proyecto_Biomecanica
====================

Motion capture project. 

====================

Blender
-------------------------
Blender\
obtener_datos.py -->Función phyton que permite extraer información de las cámaras en Blender. Se debe correr desde Blender.
tree_Blender.txt --> archivo que indica la estructura de archivos relativos a Blender guardada en el drive de google.


Funciones por bloques:
-------------------------
Segmentación:

segmentacion/CMakeLists.txt<
segmentacion/client/Source.cpp
segmentacion/client/CMakeLists.txt
segmentacion/include/ColorFilter.h
segmentacion/include/detectarBlobs.h
segmentacion/include/funcionesAuxiliares.h
segmentacion/include/getThreshold.h
segmentacion/include/otsu.h
segmentacion/lib/CMakeLists.txt
segmentacion/lib/ColorFilter.cpp
segmentacion/lib/detectarBlobs.cpp
segmentacion/lib/funcionesAuxiliares.cpp
segmentacion/lib/getThreshold.cpp
segmentacion/lib/otsu.cpp

-------------------------
Triangulación estéreo:

Matlab/xml2MtalabStruct/importXML.m

Matlab\multiples_vistas\geom_epipolar\
cam2cam.m --------->Función que devuelve en el frame "n_frame" ordenados de mejor a peor, los correspondientes "n_points" mejores 
			  puntos xd's de la cámara cam_d, para los xi de entrada pertenecientes a la cámara cam_i, .
dlt.m ------------->Función necesaria para reconstruccion3D.m
esfera2cam.m ------>Función que devuelve la matriz de la cónica resultado de proyectar una esfera sobre una cámara,
				útil para mapear entornos 3D sobre cámaras.
euclid2homog.m ---->Función que lleva coordenadas euclideas a coordenadas homogeneas normalizadas.
F_from_P.m --------> Función que devuelve la matriz fundamental entre dos cámaras a partir de sus corresponientes matrices de proyección.
get_info.m --------> Función que permite recuperar información de las estructuras skeleton y cam.
homog2euclid.m ---->Función que lleva coordenadas homogeneas a coordenadas euclideas.
homog_norm.m ------> Función que normaliza un vector de coordenadas homogeneas.
InfoCamBlender.m --> Script con información de las cámaras en el entorno Blender, generado automaticamente por .... y utilizado por main para 
					generar la estructura de datos
load3D.m ---------->Función utilizada por main.m
loadbvh.m --------->Función utilizada por main.m
main.m ------------> Función que genera la estructura de datos a partir de archivos .bvh e InfoCamBlender.m
MatrixProjection.m ----->Construye las matrices de parámetros intrínsecos y extrínsecos a partir de los datos en Blender devuelve la matriz de proyección.
obtain_coord_retina.m -->Función que lleva puntos 3D a puntos 2D en coordenadas pixel sobre una retina
plot_frames.m ----------> Función que permite plotear un cierto numero de frames de secuencias contenidas en estructura cam(i) o skeleton
plotear.m -------------->función obsoleta, pasa a ser remplazada por plot_frames.m.
quaternion.m ----------->clase de matlab para trabajar con quaterniones.
reconstruccion3D.m ----->Función que efectúa la reconstrucción de un punto 3D a partir de puntos en dos cámaras
recta_epipolar.m ------->Función que devuelve rectas epipolares en cámara derecha asociados a puntos de cámara izquierda.
rotacion.m ------------->Función que devuelve una matriz de rotacion que lleva del sistema del mundo a un sistema solidario a una camara.
set_info.m ------------->Función que setea información de estructuras skeleton o cam(i).
validation3D ----------->Función útil para validar reconstrucciones 3D en un frame.
 



-------------------------
Bloques de corrección:

-------------------------
Chequeo de visibilidad y oclusión:

-------------------------
Tracking:

-------------------------
Performance:

Matlab/Performance/Global/performance3D2D.m

=====================