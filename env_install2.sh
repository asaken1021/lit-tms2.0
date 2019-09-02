#!/bin/bash
echo "TMS 2.0用の環境構築(2)、及び起動準備を開始します。"
cd
docker image pull litwebs/lit-school-sinatra
docker run -v ~/TMS2.0/:/home/lit_users/workspace --name tms2.0 -p 8080:4567 -it litwebs/lit-school-sinatra
echo "TMS 2.0用のDockerコンテナの作成が完了しました。補足資料の起動手順をご確認の上、起動作業をお願い致します。"
docker attach tms2.0
