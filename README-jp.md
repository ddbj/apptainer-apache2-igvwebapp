# apptainer-apache2-igvwebapp
igv-webappとapache2を実行するapptainer instanceを起動するためのファイル一式です。
apptainer imageはapptainer buildコマンドでローカルで ubuntu-20.04-apache-2.4-igvwebapp-1.13.def から生成するか、遺伝研スパコンで実行する場合はスパコン上のファイルをコピーして使用します。

## imageのbuild

    $ sudo apptainer build ubuntu-20.04-apache-2.4-igv-webapp-1.13.sif ubuntu-20.04-apache-2.4-webapp-1.13.def


## 初期設定
### httpd.conf

    ServerRoot "/usr/local/apache2"
    
    Listen 38080
    User user1
    Group group1

user1を自分のアカウント名、group1を自分のグループ名、38080をapache2が使用するポート番号に修正します。
netstatコマンドで38080が未使用なら変更不要です。

### package.json

    {
      "name": "igv-webapp",
      "version": "1.13.11",
      "description": "igv web app",
      "keywords": [],
      "author": "Douglass Turner and Jim Robinson",
      "license": "MIT",
      "scripts": {
        "start": "npx http-server -p 38081 dist",
        "build": "node scripts/updateVersion.js && node scripts/clean.js && rollup -c && node scripts/copyArtifacts.js"

38081をigv-webappが使用するポート番号に修正します。
netstatコマンドで38081が未使用なら変更不要です。

## apptainer instanceの起動

    $ bash start_container.sh

遺伝研スパコン上の場合、初回実行時に /lustre7/software/experimental/igv-webapp/ubuntu-20.04-apache-2.4-igv-webapp-1.13.sif からイメージファイルがコピーされます。遺伝研スパコン上でない場合は実行前にイメージファイルをビルドしておいてください。
また、cgi-bin, htdocs, logsディレクトリが作成されます。
遺伝研スパコン上で実行した場合は htdocs ディレクトリにサンプルのbamファイルとインデックスファイルもコピーされます。
htdocs ディレクトリに、igv-webappで表示したいbamファイルとインデックスファイルを配置してください。

## igv-webappへのアクセス

ウェブブラウザで http://<ホストのIPアドレス>:<package.jsonに設定したポート番号> にアクセスしてください。
トラックの追加は、TracksメニューからURLを選び、

* http://<ホストのIDアドレス>:<httpd.confに設定したポート番号>/<htdocsに配置したbamファイル>
* http://<ホストのIDアドレス>:<httpd.confに設定したポート番号>/<htdocsに配置したインデックスファイル>

を開いてください。
