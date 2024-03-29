# Dockerized version of the moonlight-embedded. (https://github.com/moonlight-stream/moonlight-embedded)
#
# Run syntax: 
#	docker build --tag moonlight-embedded .
#

FROM lpenz/raspbian-bullseye-armhf

RUN apt-get update

# Install necessary packages for compiling
RUN apt-get install -y git \
	libopus0 libexpat1 libasound2 \
	libudev1 libavahi-client3 \ 
	libevdev2  \ 
	libssl-dev libopus-dev \
	libasound2-dev libudev-dev \
	libavahi-client-dev libcurl4-openssl-dev \
	libevdev-dev libexpat1-dev \
	libpulse-dev uuid-dev \
	cmake gcc g++ build-essential

# Raspbian only
RUN apt-get install -y libraspberrypi-dev

# Clone the project and build.
RUN git clone --depth 1 --branch v2.6.2 https://github.com/moonlight-stream/moonlight-embedded.git /opt/moonlight-embedded \
&& cd /opt/moonlight-embedded && git submodule update --init --recursive
RUN mkdir /opt/moonlight-embedded/build
WORKDIR /opt/moonlight-embedded/build
RUN cmake ..
RUN make
RUN make install
RUN ldconfig

# Create directory for saved data
ENV HOME /home/moonlight-user

RUN mkdir -p $HOME

# $HOME will be exposed as a docker mount so the data is persistent
VOLUME $HOME

EXPOSE 80

ENTRYPOINT [ "/usr/local/bin/moonlight" ]
