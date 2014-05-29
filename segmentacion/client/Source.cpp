//OpenCV Headers
#include<cv.h>
#include<highgui.h>
//Input-Output
#include<stdio.h>
#include"ColorFilter.h"
#include"getThreshold.h"
#include"detectarBlobs.h"

//NameSpaces
using namespace cv;
//using namespace cvb;
using namespace std;

int main(int argc, char *argv[]){
	
	//Obtener video y separarlo en cuadros
	///////////////////////////////////////////////////////////////////////////////////////////////////
	CvCapture* capture =0;
	IplImage* frame=0;
	int frameNum = 0;

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
    
	//Tamaño del frame y frecuencia:  
    double dWidth = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_WIDTH); //get the width of frames of the video
    double dHeight = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_HEIGHT); //get the height of frames of the video
    int fps = cvGetCaptureProperty(capture, CV_CAP_PROP_FPS);
	//cout << "Frame Size = " << dWidth << "x" << dHeight << endl;
    //cout << "FPS = " << fps << endl;
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

	//Determinar umbral
	double thresh;
	thresh = callOtsuN(frame);
	
	cout << "max threshold: " << thresh << "\n" ;

	double thresh2;
	thresh2 = thresh*255;

	//Filtrar imagen
    IplImage* imgThresh = filterOtsu(frame,thresh2);

	//Detectar blobs
	//////////////////////////////////////////////////////////
	//blobsDetectados detblobs = blobsDetectados();
	//blobsDetectados* detblobs = new blobsDetectados();
	//*detblobs = detectarBlobs(imgThresh);
	//delete[] detblobs;
	blobsDetectados detblobs;
	detblobs = detectarBlobs(imgThresh);
	//////////////////////////////////////////////////////////

	startXML();
	XMLAddFrame(frameNum,detblobs.blobs);

    //iterate through each frames of the video      
      while(true){
	
           frame = cvQueryFrame(capture); 
		   frameNum++;

		   string cuadro = itoa(frameNum);
		   char* char_type = (char*) cuadro.c_str();
		   char* nombreI = strcat(char_type,".png" );
		   
           if(!frame) break;
           frame=cvCloneImage(frame); 

		   thresh = callOtsuN(frame);
		   //cout << "max threshold: " << thresh << "\n" ;
		   thresh2 = thresh*255;
           imgThresh = filterOtsu(frame,thresh2); //Filtrar frame actual

		   //blobsDetectados *detblobs = new blobsDetectados[];
		   //*detblobs = detectarBlobs(imgThresh);
		   //delete[] detblobs;
		   detblobs = detectarBlobs(imgThresh);

		   //cvSaveImage(nombreI,detblobs.imgBlobs);
		   XMLAddFrame(frameNum,detblobs.blobs);

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

	  endXML();

	  waitKey(0); //wait infinite time for a keypress

	  destroyAllWindows;
	  cvReleaseCapture(&capture);
      return 0;

}
