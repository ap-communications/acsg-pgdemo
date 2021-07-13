IMAGE_NAME := db-setup
VER := 0.1.0

.PHONY: local
local:
	docker build -t $(IMAGE_NAME) .

.PHONY: acr
acr:
	az acr build -t $(IMAGE_NAME):{{.Run.ID}} -t $(IMAGE_NAME):latest -t $(IMAGE_NAME):$(VER) -r $(ACR_NAME) .
