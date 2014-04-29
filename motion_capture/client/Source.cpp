//OpenCV Headers
#include<cv.h>
#include<highgui.h>
//Input-Output
#include<stdio.h>
//Blob Library Headers
#include"cvblob.h"
//#include <cvblob.h>
//#include<Windows.h>
#include"ColorFilter.h"
//#include"detectarBlobs.h"

//NameSpaces
using namespace cv;
using namespace cvb;
using namespace std;

CvScalar naranjomin = cvScalar(10,122,200);
CvScalar naranjomax = cvScalar(22,256,256);

int main(int argc, char *argv[]){
	
	//Obtener video y separarlo en cuadros
	///////////////////////////////////////////////////////////////////////////////////////////////////
	CvCapture* capture =0;
	IplImage* frame=0;

	if ( argc != 2 ) {// argc should be 2 for correct execution
    // We print argv[0] assuming it is the program name
    cout<<"Cantidad de argumentos incorrecta";
	}else {

	//capture = cvCaptureFromAVI("pelotitas.mp4"); //Camina_pelado.dvd, Camina_pelado_BW.dvd macaco.avi
	capture = cvCaptureFromAVI(argv[1]);

    if(!capture){
         printf("Capture failure\n");
         return -1;
    }
      
	frame = cvQueryFrame(capture);           
    if(!frame) return -1;
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////

	//Declarar ventanas
    cvNamedWindow("Video");      
    
	//Tama�o del frame y frecuencia:  
    double dWidth = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_WIDTH); //get the width of frames of the video
    double dHeight = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_HEIGHT); //get the height of frames of the video
    int fps = cvGetCaptureProperty(capture, CV_CAP_PROP_FPS);
	cout << "Frame Size = " << dWidth << "x" << dHeight << endl;
    cout << "FPS = " << fps << endl;
	Size frameSize(static_cast<int>(dWidth), static_cast<int>(dHeight));

	//salidas de video
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    VideoWriter oVideoWriter ("filtro.avi", CV_FOURCC('M','P','4','2'), fps, frameSize, false); //initialize the VideoWriter object 
    //CV_FOURCC('P','I','M','1')
    if ( !oVideoWriter.isOpened() ) //if not initialize the VideoWriter successfully, exit the program
    {
        cout << "ERROR: Failed to write the video" << endl;
        return -1;
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
	//VALORES INICIALES:
	//Filtrar imagen
    IplImage* imgThresh = filterByColorHSV(frame,naranjomin,naranjomax);
    
    //iterate through each frames of the video      
      while(true){

           frame = cvQueryFrame(capture); 
		   
           if(!frame) break;
           frame=cvCloneImage(frame); 
            
           imgThresh = filterByColorHSV(frame,naranjomin,naranjomax); //Filtrar frame actual
		   		   	   
		   oVideoWriter.write(imgThresh); //writer the frame with blobs detected
		   			 
		   //Mostrar videos
		   
		   cvShowImage("Video", frame); //original
           
           //Clean up used images
           cvReleaseImage(&frame);
		   cvReleaseImage(&imgThresh);

           //Wait 10mS
           int c = cvWaitKey(10);
           //If 'ESC' is pressed, break the loop
           if((char)c==27 ) break;       
      }

	  waitKey(0); //wait infinite time for a keypress

	  destroyAllWindows;
	  cvReleaseCapture(&capture);
      return 0;

}
