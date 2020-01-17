#!/bin/bash
IMAGE_ARRAY_ALL=( "alpine:3.8" "alpine:3.7" "alpine:3.8" "alpine:3.5" "alpine:3.4" "alpine:3.3" "alpine:3.2"
"alpine:3.1" "alpine:3.6" "nginx:1.15.6-alpine" "nginx:1.14-alpine" "nginx:1.15.5-alpine" "nginx:1.15.4"
"nginx:1.15.3-alpine" "nginx:1.13.12-alpine" "ubuntu:xenial" "ubuntu:trusty" "ubuntu:devel" "ubuntu:disco"
"ubuntu:19.04" "ubuntu:18.10" "ubuntu:18.04" "node:6.15-slim" "node:10-alpine" "node:lts-jessie-slim"
"node:stretch-slim" "node:11.3.0" "golang:1.10.5" "golang:1.11" "golang:1.10-alpine3.7" "golang:1.10-alpine"
"golang:alpine" "golang:1.11.1" "golang:1.11.0-stretch" "golang:1.10.4-alpine" "golang:1.10.5-alpine3.8"
"consul:1.4.0" "consul:1.2.4" "consul:1.1.1" "consul:0.9.4" "consul:0.7.3" "php:5.6-jessie" "php:7.0-stretch"
"php:7.3" "php:7.0-alpine3.7" "httpd:2.4.37-alpine" "httpd:2.4" "httpd:2.4.34" "centos:6.6" "centos:6.7" "centos:6.10"
"centos:6.6" "centos:7.1.1503" "centos:6" "centos:7" "centos:6.9" "centos:centos7.4.1708" "debian:9.6" "debian:9.2"
"debian:jessie-20181112" "debian:wheezy-20181011" "debian:9.5" "debian:wheezy-20180831" "debian:8" "debian:7"
"debian:9-slim" "debian:stretch-20180831" "debian:jessie-20180831" )
NUMBER_OF_NAMESPACES="${1:-20}"
DEPLOYMENTS_PER_NAMESPACE="${2:-3}"
PODS_PER_DEPLOYMENT="${3:-3}"

createNameSpaces(){
    for a in $(seq 1 $NUMBER_OF_NAMESPACES);do
        echo "creating namespace aquans${a}: out of $NUMBER_OF_NAMESPACES"
        kubectl create namespace yakovns${a}
    done
}

runDeployments(){
for i in $(seq 1 $NUMBER_OF_NAMESPACES);do
    echo "running $DEPLOYMENTS_PER_NAMESPACE deployments on on namespace: aquans$i"
    for b in $(seq 1 $DEPLOYMENTS_PER_NAMESPACE);do
        lImage=${IMAGE_ARRAY_ALL[RANDOM%${#IMAGE_ARRAY_ALL[@]}]}
        lImageMod=$(echo $lImage | sed -e 's/\//-/g' -e 's/:/-/g')
        echo "running $PODS_PER_DEPLOYMENT $lImage pods on $lImageMod-$b deployment on NS aquans$i"
         kubectl -n yakovns$i run $lImageMod-$b --image=$lImage --replicas=$PODS_PER_DEPLOYMENT --command sleep 9999999999
    done
done
}

usage(){
echo -e " Usage: \n $(basename $0) <number of namespaces> <deployments per namespace> <pods per deployment>"
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ];
then
	usage
else
createNameSpaces
runDeployments
fi