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

double callOtsuN(IplImage* img)
{
	//IplImage* img = cvLoadImage(full_fname);

	int modes = 3;
	double* thr;
	double sep;

	 IplImage *luminance = cvCreateImage(cvGetSize(img), IPL_DEPTH_8U, 1);
    cvCvtColor(img, luminance, CV_RGB2GRAY);

	IplImage* img_seg_cv=cvCreateImage(cvGetSize(img),img->depth,1);
	otsuN(luminance, img_seg_cv, modes, &thr, &sep);
	
	double thresh;
	thresh = getMaxThresh("thr.txt");

	return thresh;

	cvSaveImage("out.png",img_seg_cv);
	cvReleaseImage(&img_seg_cv);
	cvReleaseImage(&img);
	cvReleaseImage(&luminance);
	delete[] thr;
}

