# Database初期化

## Initialize

postgreSQL database作成直後、初期化を実行する必要があります。

以下のコマンドを実行し、初期化を実行します。

```
$ cd ${TOP}/db-setup/init-daatabase
$ make acr
$ cd ${TOP}/deploy/db-setup
$ kubectl apply -f job.yaml
```

この処理は最初に１度だけ実行します。以降は不要です。

## Table 作成 & マイグレーション

database初期化後、必要なテーブルを作成します。テーブルの作成と以降の修正（マイグレーション）は
flywayを用いて実行します。

```
$ cd ${TOP}/db-setup/flyway
$ make acr
$ cd ${TOP}/deploy/db-migrate
$ kubectl delete -f job.yaml --ignore-not-found true
$ kubectl apply -f job.yaml
```
