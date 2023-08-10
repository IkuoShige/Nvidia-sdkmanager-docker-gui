# Nvidia-sdkmanager-docker-gui

The English version of the README is available [here](https://github.com/IkuoShige/Nvidia-sdkmanager-docker-gui/blob/main/README_EN.md).

DockerでsdkmanagerをGUIで使うためのDockerfileとスクリプトファイルです。

## dockerの環境構築

### dockerのインストール・セットアップ
```
sudo apt install docker.io
sudo gpasswd -a $USER docker
sudo reboot
```

PC or dockerのデーモンを再起動すると  
sudoなしでdockerコマンドを使用できるようになります。

## コンテナを起動

### 1. イメージの作成

このリポジトリをクローンして、階層を移動
```
git clone https://github.com/IkuoShige/Nvidia-sdkmanager-docker-gui.git
cd Nvidia-sdkmanager-docker-gui/
```

ダウンロードするにはNvidiaのアカウントにログインする必要があるため、下記のNvidiaのリンクからログインして直接ダウンロードしてください。

https://developer.nvidia.com/sdk-manager

ダウンロードしたファイルからDockerイメージを生成
```
docker load -i ~/Downloads/sdkmanager-<version>-Ubuntu_<distribution>_docker.tar.gz
```

例） 
```
docker load -i ~/Downloads/sdkmanager-1.9.3.10904-Ubuntu_20.04_docker.tar.gz
```

Dockerイメージを元にコンテナをbuild
```
./build_docker_images.sh --ubuntu-version <distribution> --docker-version <sdkmanager-version>
```

例）
```
./build_docker_images.sh --ubuntu-version 20.04 --docker-version 1.9.3.10904
```

* 備考
  * --ubuntu-version で -v と同様にubuntuのディストリビューションを設定
  * --docker-version でダウンロードしたsdkmanagerのversionを設定

### 2. コンテナ起動
```
./launch_container.sh --ubuntu-version <distribution> --jetpack-home <path/to/jetpack_home>
```
例）
```
./launch_container.sh --ubuntu-version 20.04 --jetpack-home ./jetpack_home
```

* 備考
  * --ubuntu-version でubuntuのディストリビューションを設定可能
    * デフォルトでは`20.04`を指定
  * --jetpack-home でsdkmanagerによって作成されるnvidiaディレクトリの1つ上の階層を設定可能
    * デフォルトでは、`./jetpack`を指定

## sdkmanager (GUI) の実行

```
sdkmanager
```

## sdkmanager (CLI) の実行

Jetpack 5.1.1をJetson Xavier NXにインストールする場合
```
sdkmanager --cli install --logintype devzone --product Jetson --version 5.1.1 --targetos Linux --host --target JETSON_XAVIER_NX_TARGETS --flash all --additionalsdk 'DeepStream 6.2'
```
