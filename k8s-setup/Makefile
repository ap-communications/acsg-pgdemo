INGRESS_NAMESPACE := ingress-basic
KURED_NAMESPACE := kured
INGRESS_IP_NAME := pgdemo-ingress-ip

.PHONY: id-setup
id-setup:
	@$(eval TENANT_ID=$(shell az account show --query tenantId -o tsv))
	@$(eval MANAGED_ID=$(shell az aks show -g $(RESOURCE_GROUP) -n ${CLUSTER_NAME} --query identityProfile.kubeletidentity.clientId -o tsv))

.PHONY: ingress-ip
ingress-ip:
	@$(eval INGRESS_IP=$(shell az network public-ip show --name $(INGRESS_IP_NAME) -g $(RESOURCE_GROUP) --query ipAddress -o tsv))

.PHONY: kured-setup
kured-setup:
	kubectl apply -f kured-namespace.yaml
	helm repo add kured https://weaveworks.github.io/kured
	helm repo update
	helm upgrade kured kured/kured --install --namespace $(KURED_NAMESPACE) -f kured-values.yaml	

.PHONY: secrets-store-setup
secrets-store-setup:
	helm repo add csi-secrets-store-provider-azure https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts
	helm upgrade secrets-store csi-secrets-store-provider-azure/csi-secrets-store-provider-azure --install --namespace kube-system -f azure-csi-secrets-store.yaml

.PHONE: secret-csi-setup
secret-csi-setup: id-setup
	kubectl apply -f ingress-namespace.yaml
	yq e '.spec.parameters.tenantId = "$(TENANT_ID)"' default-secret-provider.yaml \
	| yq e '.spec.parameters.userAssignedIdentityID = "$(MANAGED_ID)"' - \
	| kubectl apply --namespace default -f -
	yq e '.spec.parameters.tenantId = "$(TENANT_ID)"' ingress-secret-provider.yaml \
	| yq e '.spec.parameters.userAssignedIdentityID = "$(MANAGED_ID)"' - \
	| kubectl apply --namespace $(INGRESS_NAMESPACE) -f -

.PHONY: ingress-setup
ingress-setup: ingress-ip
	kubectl apply -f ingress-namespace.yaml
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update
	yq e '.controller.service.loadBalancerIP = "$(INGRESS_IP)"' ingress-values.yaml \
	| yq e '.controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-resource-group" = "$(RESOURCE_GROUP)"' - \
	| helm upgrade nginx-ingress ingress-nginx/ingress-nginx  --install --namespace $(INGRESS_NAMESPACE) -f -
