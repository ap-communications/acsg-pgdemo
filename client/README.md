# サンプルアプリケーションクライアント

## Server URLの取得

```
$ kubectl get svc -n ingress-basic
```
コマンドでpgdemo-basicのexternal IPを取得する （ここでは 192.168.1.10 とする)

## Compile

1. `npm install`
1. `npm run compile`

# Test

`$ node dist/index.js -n 5 -u http://192.168.1.10/basic/tasks`
でダウンロード開始

オプション説明
-n 5  ダウンロードを5つ同時並行で実行 5の部分は変更可能(min 1/max 10)
-u http://.... ダウンロード実行URL サーバー側は/basic/tasks というパスで定義されている
