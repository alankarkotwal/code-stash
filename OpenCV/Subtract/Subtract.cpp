#include<opencv2/core/core.hpp>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>
#include<cstdlib>
#include<ctime>
#include<iostream>

int CLK_DIFF=CLOCKS_PER_SEC;

using namespace cv;
using namespace std;

int erosion_size=3;
int dilation_size=8;

int main()
{
        time_t t;

        t=clock();

	while(clock()-t<CLK_DIFF)
	{
	}

	VideoCapture cap(0);
	VideoCapture cap1;

	Mat present;
	Mat past;
	Mat diff;
	Mat temp;
	Mat diff_hsv;
	Mat thresh;
	namedWindow("present", WINDOW_NORMAL);
	namedWindow("past", WINDOW_NORMAL);
	namedWindow("diff", WINDOW_NORMAL);
	namedWindow("thresh", WINDOW_NORMAL);

	cap>>past;
//	imshow("past",past);
	imwrite("past.jpg",past);
	cap.release();

	t=clock();

	while(clock()-t<CLK_DIFF)
	{
	}

	cap1.open(0);
	cap1>>present;
//	cap1.release();
//	while(1)
//	{
		past=imread("past.jpg");
//		imshow("past",past);
		diff=past-present;
//		temp=present-past;
//		diff=diff+temp;
//		imshow("present",present);
//		imshow("diff",diff);
//		imwrite("present.jpg", present);
//		imwrite("diff.jpg", diff);
		cvtColor(diff, diff_hsv, CV_BGR2HSV);
		inRange(diff_hsv, Scalar(0,0,40), Scalar(255,255,255), thresh);
		Mat element=getStructuringElement(MORPH_RECT, Size(2*erosion_size+1, 2*erosion_size+1), Point(erosion_size, erosion_size));
		erode(thresh, thresh, element);
		element=getStructuringElement(MORPH_RECT, Size(2*dilation_size+1, 2*dilation_size+1), Point(dilation_size, dilation_size));
		dilate(thresh, thresh, element);
//		imshow("thresh",thresh);
//	}

	cap1.release();

	Moments thresh_moments;
	thresh_moments=moments(thresh);

//	int x_com=640-(thresh_moments.m10/thresh_moments.m00);
	int x_com=(thresh_moments.m10/thresh_moments.m00);

//	cout<<x_com;
//	waitKey(0.01);

	float ratio=x_com/thresh.cols;

	if(ratio<0.350)
	{
		cout<<"q";
	}
	else if(ratio>0.4 && ratio<0.6)
	{
		cout<<"f";
	}
	else if(ratio>0.6)
	{
		cout<<"w";
	}

	return 0;
}
