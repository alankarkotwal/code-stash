#include<opencv2/core/core.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>
#include<iostream>

using namespace cv;

int main()
{
	VideoCapture cap(0);
	
	Mat frame, thresh, frame_hsv;
	
	Moments thresh_moments;
	float y_com, x_com, ratio;
	
	while(1)
	{
		cap>>frame;
		
		cvtColor(frame, frame_hsv, CV_BGR2HSV);

		inRange(frame, Scalar(0,50,80), Scalar(50,255,255), thresh);
		
		imshow("Original", frame);
		imshow("HSV", frame_hsv);
		imshow("Thresholded", thresh);
		
		thresh_moments=moments(thresh);
		
		if(thresh_moments.m00/255>5000)
		{
			x_com=thresh_moments.m10/thresh_moments.m00;
		
			ratio=x_com/frame.cols;
			
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
		}
		else
		{
			cout<<"l"<<endl;
			// system("gpio write 0 1");
			// system("gpio write 1 0");
		}
		
		if(waitKey(500)>0) break;
	}
	
	return 0;
}
