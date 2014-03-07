//OpenCV Headers
#include<cv.h>
#include<highgui.h>
//Input-Output
#include<stdio.h>
//Blob Library Headers
#include"cvblob.h"
//#include <cvblob.h>
#include<Windows.h>

#include"ColorFilter.h"
#include"detectarBlobs.h"

//NameSpaces
using namespace cv;
using namespace cvb;
using namespace std;
//using namespace cvb;

int mainViejo( int argc, char** argv ){
		
	if( argc != 2)
    {
     cout <<" Usage: display_image ImageToLoadAndDisplay" << endl;
     return -1;
    }

    Mat img;
		
    img = imread(argv[1], IMREAD_GRAYSCALE); // Read the file
	//img = imread(argv[1], IMREAD_COLOR); // Read the file

	if(! img.data ) // Check for invalid input
    {
        cout << "Could not open or find the image" << std::endl ;
        return -1;
    }
    
	
      IplImage imagen = img;
      
	  cvNamedWindow("imagen posta");      
      
	  cvNamedWindow("imagen filtrada");

	  IplImage *imagenfiltrada=cvCreateImage(cvSize(cvGetSize(&imagen).width,cvGetSize(&imagen).height),8,3);//Image in HSV color space

	  //imagenfiltrada = filterByColorHSV(&imagen,azulmin,azulmax);
	 
	  CvBlobs blobsimg;
	  //blobsimg = detectarBlobs(&imagen);
	  

	  cvShowImage("imagen posta", &imagen);
      //cvShowImage("imagen filtrada", imagenfiltrada);

	  //Mat imgf = imagenfiltrada;

	  //imwrite("conBlobs.jpg",imgf);

	  waitKey(0); //wait infinite time for a keypress

	  //destroyWindow("imagen posta"); //destroy the window with the name, "MyWindow"
	  //destroyWindow("imagen filtrada");
	  destroyAllWindows;

      return 0;

}