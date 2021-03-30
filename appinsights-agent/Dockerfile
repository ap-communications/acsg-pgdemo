FROM alpine:latest
ARG AGENT_VER=3.0.2
RUN apk --no-cache add curl
RUN curl -L "https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.0.2/aplicationinsights-agent-3.0.jar" -o "applicationinsights-agent.jar"
CMD [ "cp", "applicationinsights-agent.jar", "/shared/java-agent/applicationinsights-agent.jar" ]