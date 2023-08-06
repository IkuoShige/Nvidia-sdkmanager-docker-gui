#!/bin/bash

# usage
# 使用方法
#./download_sdkmanager_docker.sh -v ubuntu1804
#./download_sdkmanager_docker.sh -v ubuntu<distr>

# Default Ubuntu version
# デフォルトのUbuntuバージョン
DEFAULT_UBUNTU_VERSION="ubuntu2004"

# If an Ubuntu version is specified as an option, get it; otherwise, use the default
# オプションで指定されたUbuntuバージョンがあれば取得、なければデフォルトを使用
while getopts ":v:" opt; do
  case $opt in
    v) UBUNTU_VERSION="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Use the default if the Ubuntu version is empty
# Ubuntuバージョンが空の場合はデフォルトを使用
if [ -z "$UBUNTU_VERSION" ]; then
  UBUNTU_VERSION="$DEFAULT_UBUNTU_VERSION"
fi

# Download the HTML file
# HTMLファイルをダウンロード
wget "https://developer.download.nvidia.com/sdkmanager/redirects/sdkmanager-docker-image-$UBUNTU_VERSION.html"

# Specify the HTML file
# HTMLファイルを指定
html_file="sdkmanager-docker-image-$UBUNTU_VERSION.html"

# Extract the URL from the <meta> tag in the HTML file
# HTMLファイルから<meta>タグの内容を抽出してURLを取得
url=$(grep -oP "(?<=content=\"0;URL=')[^\']+" "$html_file")

# Extract the file name from the URL
# URLからファイル名を抽出
file_name=$(basename "$url")

# Download the file from the URL using HTTPS scheme
# URLからファイルをダウンロード（HTTPSスキームを指定）
wget "$url" -O "$file_name"

# Remove the unnecessary HTML file
# 不要なファイルを削除
rm "$html_file"

