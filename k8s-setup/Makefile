.PHONY: helm-setup
ingress-setup:
	kubectl apply -f ingress-namespace.yaml
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update
	helm upgrade nginx-ingress ingress-nginx/ingress-nginx  --install --dry-run --namespace ingress-basic -f ingress-values.yaml
