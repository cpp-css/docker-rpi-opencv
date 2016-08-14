FROM jsurf/rpi-raspbian:latest

RUN ["cross-build-start"]

RUN apt-get update && \
    apt-get install -y \
    	wget \
	unzip \
	cmake \
	build-essential \
	clang \
	libtiff5-dev \
	python-dev \
	&& \
  apt-get clean

# defining compilers
ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++

RUN cd /tmp && \ 
    wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.1.0.zip && \
    unzip -q opencv.zip && \
    wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.1.0.zip && \
    unzip -q opencv_contrib.zip && \
    mkdir opencv-3.1.0/build && \
    cd opencv-3.1.0/build && \
    cmake \
        -D CMAKE_BUILD_TYPE=RELEASE \
	-D BUILD_opencv_python2=YES \
        -D WITH_OPENEXR=NO \ 
        -D BUILD_TESTS=NO \
	-D BUILD_PERF_TESTS=NO \
	.. && \
    make -j 4 VERBOSE=1 && \
    make && \
    make install 

RUN ["cross-build-end"]

CMD ["/bin/bash"]
