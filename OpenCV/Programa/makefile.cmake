#Declaracion de variables
EXEC      = blobsTest
SRC_FILES = detectarBlobs.cpp colorFilter.cpp Source.cpp
#Directorio donde está el project
PROJECT_SOURCE_DIR = C:\Users\andrei\Documents\GitHub\Proyecto_Biomecanica\OpenCV\Programa

# Which compiler should be used
CXX = g++
CC = $(CXX)

# All source files have associated object files.
# This line sets `OFILES' to have the same value as `SRC_FILES' but
# with all the .cc's changed into .o's.
#O_FILES = $(SRC_FILES:%.cpp=%.o)

all: $(EXEC)

$(EXEC): $(SRC_FILES)
	$(CC) $(SRC_FILES) -o$(EXEC)


#cmake_minimum_required (VERSION 2.6)

#project (${EXEC})

#ESto me parece que se pone para crear las librerias, pero como estas ya están creadas me parece que no lo tenemos que poner
#add_library (OpenCV opencv_calib3d248d.lib)
#add_library (OpenCV opencv_contrib248d.lib)
#add_library (OpenCV opencv_core248d.lib)
#add_library (OpenCV opencv_features2d248.lib)
#add_library (OpenCV opencv_flann248d.lib)
#add_library (OpenCV opencv_gpu248d.lib)
#add_library (OpenCV opencv_highgui248d.lib)
#add_library (OpenCV opencv_imgproc248d.lib)
#add_library (OpenCV opencv_legacy248d.lib)
#add_library (OpenCV opencv_ml248d.lib)
#add_library (OpenCV opencv_nonfree248d.lib)
#add_library (OpenCV opencv_objdetect248d.lib)
#add_library (OpenCV opencv_ocl248d.lib)
#add_library (OpenCV opencv_photo248d.lib)
#add_library (OpenCV opencv_stitching248d.lib)
#add_library (OpenCV opencv_superres248d.lib)
#add_library (OpenCV opencv_ts248d.lib)
#add_library (OpenCV opencv_video248d.lib)
#add_library (OpenCV opencv_videostab248d.lib)

#include_directories ("${PROJECT_SOURCE_DIR}/OpenCV")
#add_subdirectory (OpenCV)

#add the executable
#add_executable (${EXEC} Source.cpp)

#target_link_libraries (${EXEC} OpenCV)