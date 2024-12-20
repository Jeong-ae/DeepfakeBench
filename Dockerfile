# Copyright@SCLBD
# This Dockerfile aims to build the base image for Deepfakbench.
FROM pytorch/pytorch:1.12.0-cuda11.3-cudnn8-devel

ENV TZ Asia/Seoul
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="Deepfake"

# Install dependencies outside of the base image
RUN DEBIAN_FRONTEND=noninteractive apt update && \
	apt install -y --no-install-recommends automake \
    build-essential  \
    ca-certificates  \
    libfreetype6-dev  \
    libtool  \
    pkg-config  \
    python-dev  \
    python-distutils-extra \
    python3.7-dev  \
    python3-pip \
    cmake \
	&& \
    rm -rf /var/lib/apt/lists/* \
    && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 0  \
    && \
    python3.7 -m pip install pip --upgrade 

RUN apt-get update && apt-get -y install \
    libgl1 tzdata git wget ssh vim

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN echo "root:password" | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes #prohibit-password/' /etc/ssh/sshd_config

WORKDIR /workspace
ADD . .

# Install Python dependencies
RUN pip install --no-cache-dir certifi setuptools \
    && pip install --no-cache-dir \
    dlib==19.24.0 \
    imageio==2.9.0 \
    imgaug==0.4.0 \
    scipy==1.7.3 \
    seaborn==0.11.2 \
    pyyaml==6.0 \
    imutils==0.5.4 \
    opencv-python==4.6.0.66 \
    scikit-image==0.19.2 \
    scikit-learn==1.0.2 \
    efficientnet-pytorch==0.7.1 \
    timm==0.6.12 \
    segmentation-models-pytorch==0.3.2 \
    torchtoolbox==0.1.8.2 \
    tensorboard==2.10.1 \
    setuptools==59.5.0 \
    loralib \
    pytorchvideo \
    einops \
    transformers \
    filterpy \
    simplejson \
    kornia \
    albumentations \
    git+https://github.com/openai/CLIP.git

ENV MODEL_NAME=deepfakebench

# Expose port
EXPOSE 6000
