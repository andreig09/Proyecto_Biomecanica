//OpenCV Headers
#include<cv.h>
#include<highgui.h>
//Input-Output
#include<stdio.h>
#include<stdlib.h>
#include"ColorFilter.h"
#include"getThreshold.h"
#include"detectarBlobs.h"


//NameSpaces
using namespace cv;
//using namespace cvb;
using namespace std;

CvCapture* capture =0;
IplImage* frame=0;
int frameNum = 0;
double thresh;
double thresh2;


int main(int argc, char *argv[]){
	
	//Obtener video y separarlo en cuadros
	///////////////////////////////////////////////////////////////////////////////////////////////////
	if ( (argc < 2) || (argc > 9) ) {// argc should be 2 for correct execution
    // We print argv[0] assuming it is the program name
    cout<<"Cantidad de argumentos incorrecta";
	}else {

	//capture = cvCaptureFromAVI("cam2-321.avi"); //Camina_pelado.dvd, Camina_pelado_BW.dvd macaco.avi
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
    //double dWidth = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_WIDTH); //get the width of frames of the video
    //double dHeight = cvGetCaptureProperty(capture,CV_CAP_PROP_FRAME_HEIGHT); //get the height of frames of the video
    //int fps = cvGetCaptureProperty(capture, CV_CAP_PROP_FPS);
	//cout << "Frame Size = " << dWidth << "x" << dHeight << endl;
    //cout << "FPS = " << fps << endl;
	//Size frameSize(static_cast<int>(dWidth), static_cast<int>(dHeight));

	//salidas de video
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //VideoWriter oVideoWriter ("filtro.avi", CV_FOURCC('M','P','4','2'), fps, frameSize, false); //initialize the VideoWriter object 
    //CV_FOURCC('P','I','M','1')
    //if ( !oVideoWriter.isOpened() ) //if not initialize the VideoWriter successfully, exit the program
    //{
    //   cout << "ERROR: Failed to write the video" << endl;
    //   return -1;
    //}

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
	//VALORES INICIALES:
	double Amax = FindA(argc,argv);
	if (Amax != -1){
	cout<<"area maxima"<<"="<<Amax<<"\n";
	}
	double Amin = Finda(argc,argv);
	if (Amin != -1){
	cout<<"area minima"<<"="<<Amin<<"\n";
	}
	double thr = FindT(argc,argv);
	
	//Determinar umbral
	if (thr == -1)
	{
		thresh = callOtsuN(frame);
		thresh2 = thresh*255;
	}else 
	{
		thresh2 = thr;
		cout<<"Umbral constante para todos los frames"<<"="<<thresh2<<"\n";
	}
	
	
	//Filtrar imagen
    IplImage* imgThresh = filterOtsu(frame,thresh2);

	//Detectar blobs
	//////////////////////////////////////////////////////////
	blobsDetectados detblobs;
	detblobs = detectarBlobs(imgThresh, Amax, Amin);
	//////////////////////////////////////////////////////////
	//argv[1] = "cam2-321.avi";
	const char *name = XMLname(argv[1]);
	//cout<<"Afuera de la funcion: "<<name<<"\n";
	startXML(name);
	XMLAddFrame(frameNum,detblobs.blobs,name);

	//delete[] detblobsI;

	//iterate through each frames of the video      
      while(true){
		   //blobsDetectados* detblobs = new blobsDetectados();
		   frame = cvQueryFrame(capture); 
		   frameNum++;

		   if(!frame) break;
           frame=cvCloneImage(frame); 

		   //Detectar Umbral para frame actual
		   if (thr == -1)
			{
				thresh = callOtsuN(frame);
				thresh2 = thresh*255;
				//cout<<"Umbral en el frame"<<frameNum<<"="<<thresh2<<"\n";
			}
		   //cout << "max threshold: " << thresh << "\n" ;

           imgThresh = filterOtsu(frame,thresh2); //Filtrar frame actual

		   //oVideoWriter.write(imgThresh); //writer the frame with blobs detected
		   	   
		   detblobs = detectarBlobs(imgThresh, Amax, Amin); //Detectar markers fitlrados

		   XMLAddFrame(frameNum,detblobs.blobs,name); //Agregar los blobs de este frame en el xml
		   			 
		   //Mostrar video original		   
		   cvShowImage("Video", frame);
           
           //Clean up used images
		   //delete[] detblobs;
           cvReleaseImage(&frame);
		   cvReleaseImage(&imgThresh);

           //Wait 10mS
           int c = cvWaitKey(10);
           //If 'ESC' is pressed, break the loop
           if((char)c==27 ) break;       
      }

	  endXML(name); //Cerrar xml

	  //waitKey(0); //wait infinite time for a keypress

	  destroyAllWindows;
	  cvReleaseCapture(&capture);
      return 0;

}
