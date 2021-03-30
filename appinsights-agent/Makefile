AGENT_VER := 3.0.2
.PHONY: build
build:
	curl -L https://github.com/microsoft/ApplicationInsights-Java/releases/download/$(AGENT_VER)/applicationinsights-agent-$(AGENT_VER).jar -o applicationinsights-agent.jar
	docker build -t applicationinsights-agent .