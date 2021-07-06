IMAGE_NAME := db-setup

.PHONY: local
local:
	docker build -t $(IMAGE_NAME) .

.PHONY: acr
acr:
	az acr build -t $(IMAGE_NAME):{{.Run.ID}} -t $(IMAGE_NAME):latest -r $(ACR_NAME) .
