# Install and setup some modules in AKS

## 事前準備

- [helm(ver3)](https://helm.sh/docs/intro/install/) をローカルPC環境にインストールする


## kured (KUbernetes REboot Daemon) のインストール

kuredの詳細については [Microsoft docs](https://docs.microsoft.com/ja-jp/azure/aks/node-updates-kured) 参照

```
make kured-setup
```

## secrets-store-csiのインストール

詳細については[Microsoft docs](https://docs.microsoft.com/ja-jp/azure/key-vault/general/key-vault-integrate-kubernetes) や [Azure Key Vault Provider for Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure) 参照

## ingress controllerのインストール

```
make ingress-setup
```
