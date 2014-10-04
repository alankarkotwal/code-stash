#!/bin/bash

# Execute this from the top level of the assignment folder.

direc=${PWD##*/}
echo $direc

if [ "$direc" != "assignment3" ]
then
	echo "Go to the assignment3 folder and execute the script."
	exit 0
else
	echo "Setting up..."
fi

mkdir -p 1/images/
mkdir -p 2/images/1 2/images/2
mkdir -p 3/images/
mkdir -p 4/images/

cd 1/images/
wget http://www.cse.iitb.ac.in/~suyash/cs663/Assignment3/boat.mat

cd ../../2/images/1
wget http://www.cl.cam.ac.uk/Research/DTG/attarchive/pub/data/att_faces.zip
unzip att_faces.zip

thresh=10

for i in $(seq 1 40)
do
	if [ "$i" -lt "$thresh" ]
	then
		mv s$i/ 0$i/
	else
		mv s$i/ $i/
	fi
done
rm att_faces.zip README

cd ../2
wget http://www.cse.iitb.ac.in/~ajitvr/CS663_Fall2014/HW3/CroppedYale_Subset.rar
unrar x CroppedYale_Subset.rar
mv CroppedYale_Subset/* ./
rm -rf CroppedYale_Subset CroppedYale_Subset.rar
cd ../../..

cp -r 2/images/1 3/images

cp -r 2/images/1 4/images

echo "All done!"
