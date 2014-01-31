//OpenCV Headers
#include<cv.h>
#include<highgui.h>
//Input-Output
#include<stdio.h>
#include<Windows.h>

#include"ColorFilter.h"

//NameSpaces
using namespace cv;
using namespace std;

CvScalar Rojomin = cvScalar(170,160,60);
CvScalar Rojomax = cvScalar(180,256,256);
CvScalar Amarillomax = cvScalar(38,256,256);
CvScalar Amarillomin = cvScalar(22,0,0);
CvScalar azulmin = cvScalar(75,50,60);
CvScalar azulmax = cvScalar(130,256,256);
CvScalar verdemin = cvScalar(38,50,60);
CvScalar verdemax = cvScalar(75,256,256);
CvScalar blancomin = cvScalar(0,0,200);
CvScalar blancomax = cvScalar(180,10,256);

int main( int argc, char** argv ){
		
	if( argc != 2)
    {
     cout <<" Usage: display_image ImageToLoadAndDisplay" << endl;
     return -1;
    }

    Mat img;
		
    img = imread(argv[1], IMREAD_COLOR); // Read the file
	//img = imread("betta.jpg", IMREAD_COLOR); // Read the file

	if(! img.data ) // Check for invalid input
    {
        cout << "Could not open or find the image" << std::endl ;
        return -1;
    }
    
	
      IplImage imagen = img;
      
	  cvNamedWindow("imagen posta");      
      
	  cvNamedWindow("imagen filtrada");

	  IplImage *imagenfiltrada=cvCreateImage(cvSize(cvGetSize(&imagen).width,cvGetSize(&imagen).height),8,3);//Image in HSV color space

	  imagenfiltrada = filterByColorHSV(&imagen,azulmin,azulmax);

	  cvShowImage("imagen posta", &imagen);
      cvShowImage("imagen filtrada", imagenfiltrada);

	  waitKey(0); //wait infinite time for a keypress

	  destroyWindow("imagen posta"); //destroy the window with the name, "MyWindow"
	  destroyWindow("imagen filtrada");

      return 0;

}