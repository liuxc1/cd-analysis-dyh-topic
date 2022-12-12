package ths.project.common.aspect.log.config;

import org.apache.commons.lang.StringUtils;

import ths.jdp.core.context.PropertyConfigure;

public class LogConfig {
	/** 日期时间模式 **/
	public static final String DATE_TIME_PATTERN = "yyyy-MM-dd HH:mm:ss:SSS";

	/** 需要动态替换参数的表达式前缀（当以该前缀为开头的需要动态替换参数，和ARGS_END_WITH连用） **/
	public static final String ARGS_STARTS_WITH = "${";

	/** 需要动态替换参数的表达式后缀（当以该后缀为结尾的需要动态替换参数，和ARGS_STARTS_WITH连用） **/
	public static final String ARGS_END_WITH = "}";

	/** 提交方Key **/
	public static final String REFERER = "Referer";

	/**
	 * 是否记录日志
	 */
	public static final boolean LOG_IS_RECORD;

	/**
	 * 是否允许使用Redis记录日志
	 */
	public static final boolean LOG_REDIS_IS_QUEUE;

	/**
	 * 日志队列
	 */
	public static final String LOG_REDIS_QUEUE;

	/**
	 * Redis日志消费者线程数（默认为3，日志写到db中比较慢，所以可以设置多个线程）<br>
	 * 由于系统公用threadPoolTaskExecutor线程池，所以此线程数建议不要超过的其最大容量的50%
	 */
	public static final int LOG_REDIS_CONSUMER_THREAD_NUM;

	/**
	 * redis日志消费间隔，默认0毫秒，单位：ms，0表示不等待。（多久消费一次）
	 */
	public static final int LOG_REDIS_CONSUMER_INTERVAL_TIME;

	/**
	 * redis队列遇到异常，等待间隔时间，默认1000毫秒，单位：ms
	 */
	public static final int LOG_REDIS_CONSUMER_EXCEPTION_INTERVAL_TIME;

	/**
	 * 是否允许java队列记录日志（如果允许，则java队列作为备选方案，在Redis连不上时候才会将日志写到此队列）
	 */
	public static final boolean LOG_JAVA_IS_QUEUE;

	/**
	 * java队列日志消费者线程数（默认为3，日志写到db中比较慢，所以可以设置多个线程）
	 */
	public static final int LOG_JAVA_CONSUMER_THREAD_NUM;

	/**
	 * java队列日志消费间隔，默认0毫秒，单位：ms，0表示不等待。（多久消费一次）
	 */
	public static final int LOG_JAVA_CONSUMER_INTERVAL_TIME;

	/**
	 * java队列遇到异常，等待间隔时间，默认1000毫秒，单位：ms
	 */
	public static final int LOG_JAVA_CONSUMER_EXCEPTION_INTERVAL_TIME;

	static {
		// 初始化参数
		LOG_IS_RECORD = Boolean.parseBoolean((String) PropertyConfigure.getProperty("log.is.record"));

		LOG_REDIS_IS_QUEUE = Boolean.parseBoolean((String) PropertyConfigure.getProperty("log.redis.is.queue"));

		String logRedisQueue = (String) PropertyConfigure.getProperty("log.redis.queue");
		LOG_REDIS_QUEUE = StringUtils.isNotBlank(logRedisQueue) ? logRedisQueue : "logQueue";

		int logRedisConsumerThreadNum = Integer
				.parseInt((String) PropertyConfigure.getProperty("log.redis.consumer.thread.num"));
		LOG_REDIS_CONSUMER_THREAD_NUM = logRedisConsumerThreadNum > 0 ? logRedisConsumerThreadNum : 3;

		int logRedisConsumerIntervalTime = Integer
				.parseInt((String) PropertyConfigure.getProperty("log.redis.consumer.interval.time"));
		LOG_REDIS_CONSUMER_INTERVAL_TIME = logRedisConsumerIntervalTime >= 0 ? logRedisConsumerIntervalTime : 0;

		int logRedisConsumerExceptionIntervalTime = Integer
				.parseInt((String) PropertyConfigure.getProperty("log.redis.consumer.exception.interval.time"));
		LOG_REDIS_CONSUMER_EXCEPTION_INTERVAL_TIME = logRedisConsumerExceptionIntervalTime >= 0
				? logRedisConsumerExceptionIntervalTime
				: 1000;

		LOG_JAVA_IS_QUEUE = Boolean.parseBoolean((String) PropertyConfigure.getProperty("log.java.is.queue"));

		int logJavaConsumerThreadNum = Integer
				.parseInt((String) PropertyConfigure.getProperty("log.java.consumer.thread.num"));
		LOG_JAVA_CONSUMER_THREAD_NUM = logJavaConsumerThreadNum > 0 ? logRedisConsumerThreadNum : 3;

		int logJavaConsumerIntervalTime = Integer
				.parseInt((String) PropertyConfigure.getProperty("log.java.consumer.interval.time"));
		LOG_JAVA_CONSUMER_INTERVAL_TIME = logJavaConsumerIntervalTime >= 0 ? logJavaConsumerIntervalTime : 0;

		int logJavaConsumerExceptionIntervalTime = Integer
				.parseInt((String) PropertyConfigure.getProperty("log.java.consumer.exception.interval.time"));
		LOG_JAVA_CONSUMER_EXCEPTION_INTERVAL_TIME = logJavaConsumerExceptionIntervalTime >= 0
				? logJavaConsumerExceptionIntervalTime
				: 1000;
	}
}
