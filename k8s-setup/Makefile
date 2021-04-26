.PHONY: helm-setup
ingress-setup:
	kubectl apply -f ingress-namespace.yaml
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update
	helm upgrade nginx-ingress ingress-nginx/ingress-nginx  --install --namespace ingress-basic -f ingress-values.yaml

.PHONY: kured-setup
kured-setup:
	kubectl apply -f kured-namespace.yaml
	helm repo add kured https://weaveworks.github.io/kured
	helm repo update
	helm upgrade kured kured/kured --install --namespace kured -f kured-values.yaml	
