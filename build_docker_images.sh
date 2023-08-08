#!/bin/bash

# Usage
# 使用方法
# ./build_docker_images.sh --ubuntu-version 20.04 --docker-version 1.9.3.10904
# ex)./build_docker_images.sh --ubuntu-version <distribution> --docker-version <sdkmanager-version>

# ヘルプメッセージを表示する関数
# Function to display help messages
function show_help {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help               Show this help message and exit"
    echo "  --ubuntu18               Use Ubuntu 18.04 as the base image"
    echo "  --docker-version         Set the sdkmanager docker version. Pick up <sdkmanager-docker-version> in the sdkmanager-<sdkmanager-docker-version>-ubuntu_<distr>_docker.tar.gz"
    echo "  --uid                    Set the UID for the user in the container"
    echo "  --gid                    Set the GID for the user in the container"
}

# デフォルトのオプション
# Default options
DISTR="20.04"
USER_UID=$(id -u)
USER_GID=$(id -g)
SDK_MANAGER_VERSION=""
SDK_MANAGER_DOCKER_VERSION=""
DEB_FILE=""

# コマンドライン引数を解析
# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        --ubuntu-distr)
            DISTR="$2"
            shift
            ;;
        --uid)
            USER_UID="$2"
            shift 2
            ;;
        --gid)
            USER_GID="$2"
            shift 2
            ;;
        --docker-version)
            SDK_MANAGER_DOCKER_VERSION="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# ビルド実行
# Execute the build process
echo "Building Docker image with base image: ${DISTR}, SDK Manager version: ${SDK_MANAGER_VERSION}"
docker build \
    --build-arg SDK_MANAGER_VERSION=${SDK_MANAGER_VERSION} \
    --build-arg SDK_MANAGER_DOCKER_VERSION=${SDK_MANAGER_DOCKER_VERSION} \
    --build-arg UID=${USER_UID} \
    --build-arg GID=${USER_GID} \
    --build-arg DISTR=${DISTR} \
    -t sdkmanager_gui_${DISTR} \
    -f Dockerfile \
    .


echo "Done."
