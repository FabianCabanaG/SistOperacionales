#!/usr/bin/env bash

docker network create --driver bridge ubuntu_network

docker pull ubuntu:22.04

docker run -dit --name m1 --hostname m1 --network ubuntu_network ubuntu:22.04 bash
docker run -dit --name m2 --hostname m2 --network ubuntu_network ubuntu:22.04 bash
docker run -dit --name m3 --hostname m3 --network ubuntu_network ubuntu:22.04 bash