VER := 0.1.3

.PHONY: local
local:
	docker build -t spa-client . --build-arg AI_INSTRUMENTATION_KEY=$(AI_INSTRUMENTATION_KEY)

.PHONY: acr
acr:
	az acr build -t spa-client:{{.Run.ID}} -t spa-client:latest -t spa-client:$(VER) -r $(ACR_NAME) . --secret-build-arg AI_INSTRUMENTATION_KEY=$(AI_INSTRUMENTATION_KEY)
