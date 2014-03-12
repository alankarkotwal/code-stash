#include <sstream>
#include <cstring>
#include <cstdio>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace cv;
using namespace std;

int H_MIN = 0;
int H_MAX = 256;
int S_MIN = 0;
int S_MAX = 256;
int V_MIN = 0;
int V_MAX = 256;

const int FRAME_WIDTH = 640;
const int FRAME_HEIGHT = 480;

const int MAX_NUM_OBJECTS=50;

const int MIN_OBJECT_AREA = 20*20;
const int MAX_OBJECT_AREA = FRAME_HEIGHT*FRAME_WIDTH/1.5;

const string windowName = "Original Image";
const string windowName1 = "HSV Image";
const string windowName2 = "Thresholded Image";
const string windowName3 = "After Morphological Operations";
const string trackbarWindowName = "Trackbars";

void on_trackbar( int, void* )
{
}

string intToString(int number)
{
	std::stringstream ss;
	ss << number;
	return ss.str();
}


void createTrackbars()
{
	namedWindow(trackbarWindowName,0);

	char TrackbarName[50];

	sprintf( TrackbarName, "H_MIN", H_MIN);
	sprintf( TrackbarName, "H_MAX", H_MAX);
	sprintf( TrackbarName, "S_MIN", S_MIN);
	sprintf( TrackbarName, "S_MAX", S_MAX);
	sprintf( TrackbarName, "V_MIN", V_MIN);
	sprintf( TrackbarName, "V_MAX", V_MAX);

	createTrackbar( "H_MIN", trackbarWindowName, &H_MIN, H_MAX, on_trackbar );
	createTrackbar( "H_MAX", trackbarWindowName, &H_MAX, H_MAX, on_trackbar );
	createTrackbar( "S_MIN", trackbarWindowName, &S_MIN, S_MAX, on_trackbar );
	createTrackbar( "S_MAX", trackbarWindowName, &S_MAX, S_MAX, on_trackbar );
	createTrackbar( "V_MIN", trackbarWindowName, &V_MIN, V_MAX, on_trackbar );
	createTrackbar( "V_MAX", trackbarWindowName, &V_MAX, V_MAX, on_trackbar );
}

void drawObject(int x, int y,Mat &frame)
{
	circle(frame,Point(x,y),20,Scalar(0,255,0),2);
	if(y-25>0)
	{
		line(frame,Point(x,y),Point(x,y-25),Scalar(0,255,0),2);
	}
	else
	{
		line(frame,Point(x,y),Point(x,0),Scalar(0,255,0),2);
	}

	if(y+25<FRAME_HEIGHT)
	{
		line(frame,Point(x,y),Point(x,y+25),Scalar(0,255,0),2);
	}
	else
	{
		line(frame,Point(x,y),Point(x,FRAME_HEIGHT),Scalar(0,255,0),2);
	}

	if(x-25>0)
	{
		line(frame,Point(x,y),Point(x-25,y),Scalar(0,255,0),2);
	}
	else
	{
		line(frame,Point(x,y),Point(0,y),Scalar(0,255,0),2);
	}
	if(x+25<FRAME_WIDTH)
	{
		line(frame,Point(x,y),Point(x+25,y),Scalar(0,255,0),2);
	}
	else
	{
		line(frame,Point(x,y),Point(FRAME_WIDTH,y),Scalar(0,255,0),2);
	}

	putText(frame,intToString(x)+","+intToString(y),Point(x,y+30),1,1,Scalar(0,255,0),2);
}

void morphOps(Mat &thresh)
{
	Mat erodeElement = getStructuringElement( MORPH_RECT,Size(3,3));

	Mat dilateElement = getStructuringElement( MORPH_RECT,Size(3,3));

	erode(thresh,thresh,erodeElement);
	erode(thresh,thresh,erodeElement);


	dilate(thresh,thresh,dilateElement);
	dilate(thresh,thresh,dilateElement);
}

void trackFilteredObject(int &x, int &y, Mat threshold, Mat &cameraFeed){

	Mat temp;
	threshold.copyTo(temp);

	vector< vector<Point> > contours;
	vector<Vec4i> hierarchy;

	findContours(temp,contours,hierarchy,CV_RETR_CCOMP,CV_CHAIN_APPROX_SIMPLE );

	double refArea = 0;
	bool objectFound = false;
	if (hierarchy.size() > 0)
	{
		int numObjects = hierarchy.size();
		if(numObjects<MAX_NUM_OBJECTS)
		{
			for (int index = 0; index >= 0; index = hierarchy[index][0])
			{

				Moments moment = moments((cv::Mat)contours[index]);
				double area = moment.m00;
				if(area>MIN_OBJECT_AREA && area<MAX_OBJECT_AREA && area>refArea)
				{
					x = moment.m10/area;
					y = moment.m01/area;
					objectFound = true;
					refArea = area;
				}
				else
				{
					objectFound = false;
				}
			}

			if(objectFound ==true)
			{
				putText(cameraFeed,"Tracking Object",Point(0,50),2,1,Scalar(0,255,0),2);
				drawObject(x,y,cameraFeed);
			}
		}
		else
		{
			putText(cameraFeed,"TOO MUCH NOISE! ADJUST FILTER",Point(0,50),1,2,Scalar(0,0,255),2);
		}
	}
}

int main(int argc, char* argv[])
{
	//some boolean variables for different functionality within this
	//program
		bool trackObjects = false;
		bool useMorphOps = true;
	//Matrix to store each frame of the webcam feed
	Mat cameraFeed;
	//matrix storage for HSV image
	Mat HSV;
	//matrix storage for binary threshold image
	Mat threshold;
	//x and y values for the location of the object
	int x=0, y=0;
	//create slider bars for HSV filtering
	createTrackbars();
	//video capture object to acquire webcam feed
	VideoCapture capture;
	//open capture object at location zero (default location for webcam)
	capture.open(0);
	//set height and width of capture frame
	capture.set(CV_CAP_PROP_FRAME_WIDTH,FRAME_WIDTH);
	capture.set(CV_CAP_PROP_FRAME_HEIGHT,FRAME_HEIGHT);
	//start an infinite loop where webcam feed is copied to cameraFeed matrix
	//all of our operations will be performed within this loop
	while(1){
		//store image to matrix
		capture.read(cameraFeed);
		//convert frame from BGR to HSV colorspace
		cvtColor(cameraFeed,HSV,COLOR_BGR2HSV);
		//filter HSV image between values and store filtered image to
		//threshold matrix
		inRange(HSV,Scalar(H_MIN,S_MIN,V_MIN),Scalar(H_MAX,S_MAX,V_MAX),threshold);
		//perform morphological operations on thresholded image to eliminate noise
		//and emphasize the filtered object(s)
		if(useMorphOps)
		morphOps(threshold);
		//pass in thresholded frame to our object tracking function
		//this function will return the x and y coordinates of the
		//filtered object
		if(trackObjects)
			trackFilteredObject(x,y,threshold,cameraFeed);

		//show frames 
		imshow(windowName2,threshold);
		imshow(windowName,cameraFeed);
		imshow(windowName1,HSV);
		

		//delay 30ms so that screen can refresh.
		//image will not appear without this waitKey() command
		waitKey(30);
	}






	return 0;
}

