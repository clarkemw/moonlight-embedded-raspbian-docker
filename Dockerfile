# Dockerized version of the moonlight-embedded. (https://github.com/irtimmer/moonlight-embedded)
#
# Run syntax: 
#	docker build --tag moonlight-embeded .
#

FROM raspbian/stretch

RUN sudo apt-get update

# Install necessary packages for compiling
RUN sudo apt-get install -y git \
	libopus0 libexpat1 libasound2 \
	libudev1 libavahi-client3 \ 
	libevdev2 libenet7 \ 
	libssl-dev libopus-dev \
	libasound2-dev libudev-dev \
	libavahi-client-dev libcurl4-openssl-dev \
	libevdev-dev libexpat1-dev \
	libpulse-dev uuid-dev libenet-dev \
	cmake gcc g++ fakeroot debhelper

# Raspbian only
RUN sudo apt-get install -y libraspberrypi-dev

# Clone the project and build.
RUN git clone --recursive https://github.com/irtimmer/moonlight-embedded.git /opt/moonlight-embedded
RUN mkdir /opt/moonlight-embedded/build
WORKDIR /opt/moonlight-embedded/build
RUN cmake ..
RUN make
RUN sudo make install
RUN ldconfig

# Create directory for saved data
ENV HOME /home/moonlight-user

RUN mkdir -p $HOME

# $HOME will be exposed as a docker mount so the data is persistent
VOLUME $HOME

EXPOSE 80

ENTRYPOINT [ "/usr/local/bin/moonlight" ]
