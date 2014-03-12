#include<opencv2/core/core.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>
#include<stdio.h>
#include<stdlib.h>
#include<iostream>

using namespace cv;
using namespace std;

int main(int, char**)
{
	VideoCapture cap(1); // open the default camera
	if(!cap.isOpened())  // check if we succeeded
	return -1;

	Mat frame;
	Mat thresh;
	
	Moments thresh_mom;

	float y_com, x_com;

	// system("gpio mode 0 out"); // Left
	// system("gpio mode 1 out"); // Right

	while(1)
	{
		cap >> frame; // get a new frame from camera
	
		inRange(frame, Scalar(0,100,100), Scalar(50,255,255), thresh); 
		imshow("blah", thresh);
		waitKey(1);
			
		thresh_mom=moments(thresh);
	
		x_com=thresh_mom.m10/thresh_mom.m00;
		
		float ratio=x_com/frame.cols;
		
		cout<<"lol"<<endl;
		
		if(ratio<0.4)
		{
			cout<<"l"<<endl;
			// system("gpio write 0 1");
			// system("gpio write 1 0");
		}
		else if(ratio>0.6)
		{
			cout<<"r"<<endl;
			// system("gpio write 0 0");
			// system("gpio write 1 1");
		}
		else if(ratio>0.4 && ratio<0.6)
		{
			cout<<"f"<<endl;
			// system("gpio write 0 1");
			// system("gpio write 1 1");
		}
		else
		{
			cout<<"s"<<endl;
			// system("gpio write 0 0");
			// system("gpio write 1 0");
		}
	}
	
	//cap.release();
	
	return 0;
}

