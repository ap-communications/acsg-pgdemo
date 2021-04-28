package app.apcom.acgs.sample.pgdemo;

import javax.annotation.PreDestroy;

import org.springframework.boot.autoconfigure.data.redis.RedisProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.test.context.TestConfiguration;

import redis.embedded.RedisServer;

@TestConfiguration
@EnableConfigurationProperties(RedisProperties.class)
public class EmbebbedRedisConfiguration {
    private static RedisServer server = null;

    public EmbebbedRedisConfiguration(RedisProperties redisProperties) {
        start(redisProperties);
    }

    public static synchronized void start(RedisProperties redisProperties) {
        if (server == null) {
            server = new RedisServer(redisProperties.getPort());
            server.start();
        }
    }

    @PreDestroy
    public void preDestory() {
        stop();
    }

    public static synchronized void stop() {
        if (server != null) {
            server.stop();
            server = null;
        }
    }
    
}
