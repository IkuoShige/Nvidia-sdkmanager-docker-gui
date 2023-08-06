# Nvidia-sdkmanager-docker-gui

DockerでsdkmanagerをGUIで使うためのDockerfileとスクリプトファイルです。

## dockerの環境構築

### 1. dockerのインストール・セットアップ
```
sudo apt install docker.io
sudo gpasswd -a $USER docker
sudo reboot
```

PC or Dockerのデーモンを再起動すると  
sudoなしでdockerコマンドを使用できるようになります。

## コンテナを起動

### 1. イメージの作成


```
git clone https://github.com/IkuoShige/Nvidia-sdkmanager-docker-gui.git
cd Nvidia-sdkmanager-docker-gui/
./download_sdkmanager_docker.sh -v ubuntu2004
./build_docker_images.sh --ubuntu-version 20.04 --docker-version 1.9.3.10904
```

* 備考
  * -v でダウンロードするsdkmanagerのDockerのubuntuのディストリビューションを設定
  * --ubuntu-version で -v と同様にubuntuのディストリビューションを設定
  * --docker-version でダウンロードしたsdkmanagerのversionを設定

### 2. GUIを使用するためにXサーバへのアクセス許可
```
xhost +local:docker
```

### 3. コンテナ起動
```
./launch_container.sh --ubuntu-version 20.04 --jetpack-home ./jetpack_home
```

* 備考
  * --ubuntu-version でubuntuのディストリビューションを設定可能
    * デフォルトでは20.04を指定
  * --jetpack-home でsdkmanagerによって作成されるnvidiaディレクトリの1つ上の階層を設定可能
    * デフォルトでは、カレントディレクトリを指定

## sdkmanager (GUI) の起動

```
sdkmanager
```

## sdkmanager (CLI) の起動

Jetpack 5.1.1をJetson Xavier NXにインストールする場合
```
sdkmanager --cli install --logintype devzone --product Jetson --version 5.1.1 --targetos Linux --host --target JETSON_XAVIER_NX_TARGETS --flash all --additionalsdk 'DeepStream 6.2'
```
