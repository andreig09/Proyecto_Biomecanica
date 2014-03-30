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

//Rangos de colores HSV
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
CvScalar naranjomin = cvScalar(10,122,200);
CvScalar naranjomax = cvScalar(22,256,256);

IplImage* imgTracking; //Imagen con el seguimiento
CvBlobs* blobsAnteriores = new CvBlobs;
CvBlob blobAnterior;

int lastX = -1;
int lastY = -1;

int main(int argc, char *argv[]){
	
	//Obtener video y separarlo en cuadros
	///////////////////////////////////////////////////////////////////////////////////////////////////
	CvCapture* capture =0;
	IplImage* frame=0;

	if ( argc != 3 ) {// argc should be 2 for correct execution
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

	CvScalar minimo;
	CvScalar maximo;
	
	switch (*argv[2])
	{
	case 'y': minimo = Amarillomin;
			  maximo = Amarillomax;
			  break;
	case 'r': minimo = Rojomin;
			  maximo = Rojomax;
			  break;
	case 'b': minimo = azulmin;
			  maximo = azulmax;
			  break;
	case 'o': minimo = naranjomin;
			  maximo = naranjomax;
			  break;
	case 'w': minimo = blancomin;
			  maximo = blancomax;
			  break;
	case 'g': minimo = verdemin;
			  maximo = verdemax;
			  break;
	default:  minimo = blancomin;
			  maximo = blancomax;
			  break;
	}
	
	//Declarar ventanas
    cvNamedWindow("Video");      
    
	cvNamedWindow("Seguimiento");

	//Tamaño del frame y frecuencia:  
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

    VideoWriter oVideoWriter2 ("Blobs.avi", CV_FOURCC('M','P','4','2'), fps, frameSize, true); //initialize the VideoWriter object
    if ( !oVideoWriter2.isOpened() ) //if not initialize the VideoWriter successfully, exit the program
    {
        cout << "ERROR: Failed to write the video" << endl;
        return -1;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
	//VALORES INICIALES:
	//Filtrar imagen
    IplImage* imgThresh = filterByColorHSV(frame,minimo,maximo);
    
    //Detectar blobs
	blobsDetectados* detblobs = new blobsDetectados;
	*detblobs = detectarBlobs(imgThresh);
    IplImage* imgblob = detblobs->imgBlobs;
    //inicializar blob anterior
	*blobsAnteriores = detblobs->blobs;
	for (CvBlobs::const_iterator it=(*blobsAnteriores).begin(); it!=(*blobsAnteriores).end(); ++it)
	{
		it->second->centroid.x = lastX;
		it->second->centroid.y = lastY;
	}
	//create a blank image and assigned to 'imgTracking' which has the same size of original video
    imgTracking=cvCreateImage(cvGetSize(imgThresh),IPL_DEPTH_8U, 3);
    cvZero(imgTracking); //covert the image, 'imgTracking' to black
	imgtrack seguir;
   
    //iterate through each frames of the video      
      while(true){
		  
		  CvBlobs* blobsAnteriores2 = new CvBlobs;
		  blobsAnteriores2 = blobsAnteriores;

           frame = cvQueryFrame(capture); 
		   
           if(!frame) break;
           frame=cvCloneImage(frame); 
            
           imgThresh = filterByColorHSV(frame,minimo,maximo); //Filtrar frame actual
		    

		   //seguir cada blob de la imagen anterior en la imagen actual
		   for (CvBlobs::const_iterator it=(*blobsAnteriores2).begin(); it!=(*blobsAnteriores2).end(); ++it)
			{
				blobAnterior = *(it->second);
				seguir = seguirBlob(frame,imgThresh,blobAnterior,imgTracking);
				imgblob = seguir.BlobsTrack;
				imgTracking = seguir.tracking;
			}
		   
		   *blobsAnteriores2 = seguir.BlobsAnteriores;
		   blobsAnteriores = blobsAnteriores2;
		   oVideoWriter.write(imgThresh); //writer the frame with blobs detected
		   oVideoWriter2.write(imgblob); //writer the frame with blobs and the tray
			 
		   //Mostrar videos
		   //cvShowImage("Seguimiento", imgblob); //blobs con trayectoria
		   //cvShowImage("filtro", imgThresh); //filtrada
		   cvShowImage("Video", frame); //original
           
           //Clean up used images
           //cvReleaseImage(&imgThresh);            
           cvReleaseImage(&frame);
		   cvReleaseImage(&imgblob);
		   cvReleaseImage(&imgThresh);
		   
		   delete blobsAnteriores2;
		   //delete detblobs;

           //Wait 10mS
           int c = cvWaitKey(10);
           //If 'ESC' is pressed, break the loop
           if((char)c==27 ) break;       
      }

	  waitKey(0); //wait infinite time for a keypress

	  destroyAllWindows;
	  cvReleaseCapture(&capture);
	  delete detblobs;
	  delete blobsAnteriores;
      return 0;

}