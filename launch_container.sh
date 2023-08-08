#!/bin/bash

# Usage
# 使用方法
# ./launch_container.sh --ubuntu-version <distribution> --jetpack-home path/to/jetpack_home
# ex)./launch_container.sh --ubuntu-version 20.04 --jetpack-home ./jetpack_home


XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Default JETPACK_HOME path
# デフォルトのJETPACK_HOMEパス
DEFAULT_JETPACK_HOME=$(realpath ./jetpack_home)
JETPACK_HOME=$DEFAULT_JETPACK_HOME

# Default distribution
# デフォルトのディストリビューション
DISTR="20.04"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --ubuntu-version)
            # If the --ubuntu-version option is given, set the next argument as DISTR
            # --ubuntu-version オプションが指定された場合、次の引数をDISTRに設定
            DISTR="$2"
            shift 2
            ;;
        --jetpack-home)
            # If the --jetpack-home option is given, set the next argument as JETPACK_HOME
            # --jetpack-home オプションが指定された場合、次の引数をJETPACK_HOMEに設定
            JETPACK_HOME=$(realpath $2)
            shift 2
            ;;
        *)
            exit 1
            ;;
    esac
done

docker run --privileged --rm -it \
           --volume=$XSOCK:$XSOCK:rw \
           --volume=$XAUTH:$XAUTH:rw \
           --volume="$JETPACK_HOME/nvidia":/home/nvidia/nvidia:rw \
           --volume="$JETPACK_HOME/Downloads":/home/nvidia/Downloads:rw \
           -v /dev/bus/usb:/dev/bus/usb/ \
           --shm-size=1gb \
           --env="XAUTHORITY=${XAUTH}" \
           --env="DISPLAY=${DISPLAY}" \
           --env=TERM=xterm-256color \
           --env=QT_X11_NO_MITSHM=1 \
           --net=host \
           -u "nvidia"  \
           sdkmanager_gui_${DISTR}:latest

