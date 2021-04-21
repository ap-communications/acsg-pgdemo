AGENT_VER := 3.0.3
.PHONY: build
build:
	curl -L https://github.com/microsoft/ApplicationInsights-Java/releases/download/$(AGENT_VER)/applicationinsights-agent-$(AGENT_VER).jar -o applicationinsights-agent.jar
	docker build -t applicationinsights-agent .

.PHONY: tag
tag:
	docker tag applicationinsights-agent:latest applicationinsights-agent:${AGENT_VER}
	docker tag applicationinsights-agent:latest \
    	${ACR_NAME}.azurecr.io/applicationinsights-agent:latest
	docker tag applicationinsights-agent:latest \
    	${ACR_NAME}.azurecr.io/applicationinsights-agent:${AGENT_VER}

.PHONY: push
push:
	docker push ${ACR_NAME}.azurecr.io/applicationinsights-agent:latest
	docker push ${ACR_NAME}.azurecr.io/applicationinsights-agent:${AGENT_VER}
