# Install and setup some modules in AKS

## 事前準備

- [helm(ver3)](https://helm.sh/docs/intro/install/) をローカルPC環境にインストールする

## ingress controllerのインストール

```
make ingress-setup
```

## kured (KUbernetes REboot Daemon) のインストール

kuredの詳細については [Microsoft docs](https://docs.microsoft.com/ja-jp/azure/aks/node-updates-kured) 参照

```
make kured-setup
```
