# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/aloo/Documents/Tech/OpenCV/Subtract

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/aloo/Documents/Tech/OpenCV/Subtract

# Include any dependencies generated for this target.
include CMakeFiles/Subtract.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/Subtract.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/Subtract.dir/flags.make

CMakeFiles/Subtract.dir/Subtract.cpp.o: CMakeFiles/Subtract.dir/flags.make
CMakeFiles/Subtract.dir/Subtract.cpp.o: Subtract.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/aloo/Documents/Tech/OpenCV/Subtract/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/Subtract.dir/Subtract.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/Subtract.dir/Subtract.cpp.o -c /home/aloo/Documents/Tech/OpenCV/Subtract/Subtract.cpp

CMakeFiles/Subtract.dir/Subtract.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/Subtract.dir/Subtract.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/aloo/Documents/Tech/OpenCV/Subtract/Subtract.cpp > CMakeFiles/Subtract.dir/Subtract.cpp.i

CMakeFiles/Subtract.dir/Subtract.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/Subtract.dir/Subtract.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/aloo/Documents/Tech/OpenCV/Subtract/Subtract.cpp -o CMakeFiles/Subtract.dir/Subtract.cpp.s

CMakeFiles/Subtract.dir/Subtract.cpp.o.requires:
.PHONY : CMakeFiles/Subtract.dir/Subtract.cpp.o.requires

CMakeFiles/Subtract.dir/Subtract.cpp.o.provides: CMakeFiles/Subtract.dir/Subtract.cpp.o.requires
	$(MAKE) -f CMakeFiles/Subtract.dir/build.make CMakeFiles/Subtract.dir/Subtract.cpp.o.provides.build
.PHONY : CMakeFiles/Subtract.dir/Subtract.cpp.o.provides

CMakeFiles/Subtract.dir/Subtract.cpp.o.provides.build: CMakeFiles/Subtract.dir/Subtract.cpp.o

# Object files for target Subtract
Subtract_OBJECTS = \
"CMakeFiles/Subtract.dir/Subtract.cpp.o"

# External object files for target Subtract
Subtract_EXTERNAL_OBJECTS =

Subtract: CMakeFiles/Subtract.dir/Subtract.cpp.o
Subtract: /opt/ros/hydro/lib/libopencv_calib3d.so
Subtract: /opt/ros/hydro/lib/libopencv_contrib.so
Subtract: /opt/ros/hydro/lib/libopencv_core.so
Subtract: /opt/ros/hydro/lib/libopencv_features2d.so
Subtract: /opt/ros/hydro/lib/libopencv_flann.so
Subtract: /opt/ros/hydro/lib/libopencv_gpu.so
Subtract: /opt/ros/hydro/lib/libopencv_highgui.so
Subtract: /opt/ros/hydro/lib/libopencv_imgproc.so
Subtract: /opt/ros/hydro/lib/libopencv_legacy.so
Subtract: /opt/ros/hydro/lib/libopencv_ml.so
Subtract: /opt/ros/hydro/lib/libopencv_nonfree.so
Subtract: /opt/ros/hydro/lib/libopencv_objdetect.so
Subtract: /opt/ros/hydro/lib/libopencv_photo.so
Subtract: /opt/ros/hydro/lib/libopencv_stitching.so
Subtract: /opt/ros/hydro/lib/libopencv_superres.so
Subtract: /opt/ros/hydro/lib/libopencv_ts.so
Subtract: /opt/ros/hydro/lib/libopencv_video.so
Subtract: /opt/ros/hydro/lib/libopencv_videostab.so
Subtract: CMakeFiles/Subtract.dir/build.make
Subtract: CMakeFiles/Subtract.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable Subtract"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/Subtract.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/Subtract.dir/build: Subtract
.PHONY : CMakeFiles/Subtract.dir/build

CMakeFiles/Subtract.dir/requires: CMakeFiles/Subtract.dir/Subtract.cpp.o.requires
.PHONY : CMakeFiles/Subtract.dir/requires

CMakeFiles/Subtract.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/Subtract.dir/cmake_clean.cmake
.PHONY : CMakeFiles/Subtract.dir/clean

CMakeFiles/Subtract.dir/depend:
	cd /home/aloo/Documents/Tech/OpenCV/Subtract && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/aloo/Documents/Tech/OpenCV/Subtract /home/aloo/Documents/Tech/OpenCV/Subtract /home/aloo/Documents/Tech/OpenCV/Subtract /home/aloo/Documents/Tech/OpenCV/Subtract /home/aloo/Documents/Tech/OpenCV/Subtract/CMakeFiles/Subtract.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/Subtract.dir/depend

