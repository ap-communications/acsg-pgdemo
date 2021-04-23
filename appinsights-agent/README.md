# Application Insights Dockerイメージ作成

公開されている `applicationinsights-agent` のjarファイルを取得し、Dockerイメージを生成する。

手順は以下の通りです。

前提

1. *export ACR_NAME=\<acr name\>*
1.  Makefileの1行目の `AGENT_VER` に取得したいエージェントのバージョンを指定する。最新のバージョンは [Microsoftのドキュメント](https://docs.microsoft.com/ja-jp/azure/azure-monitor/app/java-in-process-agent) で確認する。

```
# download agent jar file and build docker image
make build

# add some tags to docker image
make tag

# push tagged image to azure container registory
make push
```