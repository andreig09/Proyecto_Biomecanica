/*
 * File:   main.cpp
 * Author: mat
 *
 * Created on February 13, 2013, 8:26 PM
 */

#include <cstdlib>
#include <iostream>
#include "otsu.h"
#include <math.h>
#include <vector>
#include "funcionesAuxiliares.h"

using namespace std;

//Esta es la función principal que llama a las de el script otsu.cpp
// es similar al main_opencv.cpp de la librería kde/otsu/c_opencv
double callOtsuN(IplImage* img)
{
	int modes = 3;
	double* thr;
	double sep;
	int indSigma2BMax;

	IplImage *luminance = cvCreateImage(cvGetSize(img), IPL_DEPTH_8U, 1);

    cvCvtColor(img, luminance, CV_RGB2GRAY); //pasar la imagen a escala de grises

	IplImage* img_seg_cv=cvCreateImage(cvGetSize(img),img->depth,1);

	otsuN(luminance, img_seg_cv, modes, &thr, &sep); //Obtener 2 umbrales (en el caso de 3 niveles)
	
	double thresh;
		
	thresh = getMaxThresh(modes-1, thr); //obtener el umbral más grande

	//cvSaveImage("out.png",img_seg_cv); //esto guarda cada frame con los blobs detectados. Lo usaba para ver si coincidian con el xml

	cvReleaseImage(&img_seg_cv);
	
	cvReleaseImage(&luminance);
	delete[] thr;

	return thresh;
	
}

