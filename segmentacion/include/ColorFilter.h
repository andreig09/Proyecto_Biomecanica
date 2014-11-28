//OpenCV Headers
#include<cv.h>
#include<highgui.h>
//Input-Output
#include<stdio.h>
//Blob Library Headers
#include"cvblob.h"
//#include <cvblob.h>
//#include<Windows.h>  Solo funca en windows
//NameSpaces
using namespace cv;
using namespace cvb;
using namespace std;

IplImage* filterOtsu(IplImage *img, int thresh,  VideoWriter oVideoWriter, bool guardar);