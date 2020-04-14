FROM ubuntu:16.04

MAINTAINER robotics_qi<robotics_qi@sjtu.edu.cn>

RUN	apt-get -y update && apt-get install -y \
	libboost-all-dev \
	cmake git \
	libgoogle-glog-dev \
	libeigen3-dev \
	libsuitesparse-dev \
	libgl1-mesa-dev \
	libglew-dev \
	libxkbcommon-x11-dev \
  rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN cd /opt \
      && git clone https://github.com/raulmur/ORB_SLAM2.git ORB_SLAM2 \
      && cd ORB_SLAM2 && chmod +x build.sh && sh build.sh

RUN	apt-get update -y && apt-get install -y \
	openssh-server xfce4 xfce4-goodies x11vnc sudo bash xvfb && \
	useradd -ms /bin/bash ubuntu && echo 'ubuntu:ubuntu' | chpasswd && \
	echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && apt-get clean && \
	rm -rf /var/lib/apt/lists/*

COPY 	x11vnc /etc/init.d/
COPY 	xvfb /etc/init.d/
COPY 	entry.sh /

RUN 	sudo chmod +x /entry.sh /etc/init.d/*

EXPOSE 	5900

ENTRYPOINT [ "/entry.sh" ]

