FROM alpine:latest
ENV AGENT_VER=3.0.2
RUN apk --no-cache add curl
RUN curl -L "https://github.com/microsoft/ApplicationInsights-Java/releases/download/${AGENT_VER}/aplicationinsights-agent-${AGENT_VER}.jar" -o "applicationinsights-agent-${AGENT_VER}.jar"
CMD [cp, "applicationinsights-agent-${AGENT_VER}.jar", "/shared/java-agent/applicationinsights-agent.jar"]
