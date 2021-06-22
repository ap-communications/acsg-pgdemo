.PHONY: local
local:
	docker build -t spa-client . --build-arg AI_INSTRUMENTATION_KEY=$(AI_INSTRUMENTATION_KEY)

acr:
	az acr build -t spa-client:{{.Run.ID}} -t spa-client:latest -r $(ACR_NAME) . --secret-build-arg AI_INSTRUMENTATION_KEY=$(AI_INSTRUMENTATION_KEY)
