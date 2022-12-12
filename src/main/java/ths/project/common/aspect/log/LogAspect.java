package ths.project.common.aspect.log;

import java.lang.reflect.Method;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.TimeUnit;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.core.annotation.AnnotatedElementUtils;
import org.springframework.data.redis.RedisConnectionFailureException;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import com.alibaba.druid.support.http.WebStatFilter;
import com.alibaba.druid.support.http.WebStatFilter.StatHttpServletResponseWrapper;
import org.springframework.web.context.support.WebApplicationContextUtils;
import ths.jdp.core.consts.PubConstants;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.RequestHelper;
import ths.project.common.aspect.log.annotation.LogModule;
import ths.project.common.aspect.log.annotation.LogOperation;
import ths.project.common.aspect.log.config.LogConfig;
import ths.project.common.util.JsonUtil;
import ths.project.system.log.entity.Log;
import ths.project.system.log.service.CmdLogService;

/**
 * AOP-日志切面<br>
 * 注意Aspect默认是单例模式
 *
 * @author zl
 */
@Component
@Aspect
public class LogAspect {
    /**
     * slf4j日志对象
     **/
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * 是否初始化
     **/
    private volatile boolean isInit = false;


    /**
     * 消息中转站队列，加入中转站的主要原因是提高响应速度。<br>
     * 由于ConcurrentLinkedQueue是无界队列，所有在使用的时候，千万要小心内存溢出。<br>
     * 由于Aspect默认是单例模式，所以消息中转站队列可以直接定义成成员变量。
     */
    public static Queue<Log> queue;

    private RedisTemplate<String, Object> redisTemplate;

    @Resource
    private ThreadPoolTaskExecutor threadPoolTaskExecutor;

    @Autowired
    private CmdLogService cmdLogSerivce;

    /**
     * 初始化
     */
    @SuppressWarnings("unchecked")
    public void init() {
        // 是否允许记录日志
        if (LogConfig.LOG_IS_RECORD) {
            logger.info("【日志】：初始化异步线程处理系统日志信息！");
            // 允许Redis记录日志
            if (LogConfig.LOG_REDIS_IS_QUEUE) {
                // 允许使用Redis记录日志
                redisTemplate = (RedisTemplate<String, Object>) WebApplicationContextUtils.getWebApplicationContext(
                        ContextLoader.getCurrentWebApplicationContext().getServletContext()).getBean("redisTemplate");
                // 消费日志
                logRedisConsumer(LogConfig.LOG_REDIS_CONSUMER_THREAD_NUM);
            }
            // 这里千万要注意线程池的核心线程数要大于所有活动线程数。线程池的核心线程在等待的时候，等待的线程也不执行。
            if (LogConfig.LOG_JAVA_IS_QUEUE) {
                queue = new ConcurrentLinkedQueue<>();
                // 允许使用Java队列日志
                // 消费日志
                logQueueConsumer(LogConfig.LOG_JAVA_CONSUMER_THREAD_NUM);
            }
        }
    }

    /**
     * 日志Around环绕通知
     *
     * @param joinPoint
     * @return
     * @throws Throwable
     */
    @Around("(@annotation(ths.project.common.aspect.log.annotation.LogOperation)) || (@annotation(org.springframework.web.bind.annotation.RequestMapping) && !@annotation(org.springframework.web.bind.annotation.ResponseBody) )")
    public Object logAround(ProceedingJoinPoint joinPoint) throws Throwable {
        Instant startInstant = Instant.now(Clock.systemDefaultZone());
        Object result = null;
        Exception exception = null;
        try {
            result = joinPoint.proceed();
        } catch (Exception e) {
            exception = e;
        }

        try {
            if (isRecordLog(joinPoint)) {
                // 第一次访问时候初始化，并且保证只初始化一次
                if (isInit == false) {
                    synchronized (this) {
                        if (isInit == false) {
                            init();
                            isInit = true;
                        }
                    }
                }
                Instant endInstant = Instant.now(Clock.systemDefaultZone());
                recordLog(joinPoint, result, exception, startInstant, endInstant);
            }
        } catch (Exception e) {
            logger.error("异常堆栈信息：", e);
        }

        if (exception != null) {
            throw exception;
        }

        // 不记录日志
        return result;
    }

    /**
     * 记录日志
     *
     * @param joinPoint    切点对象，包含了调用对象信息和请求参数信息。
     * @param result       请求执行结果
     * @param exception    异常信息
     * @param startInstant 开始时间，由Java8提供。
     * @param endInstant   结束时间，由Java8提供。
     */
    private void recordLog(ProceedingJoinPoint joinPoint, Object result, Exception exception, Instant startInstant,
                           Instant endInstant) {
        Log log = new Log();
        // 设置参数。 借助Java的引用传递，可以在后续依次给对象参数赋值，保证了是同一个对象
        setLogArgs(log, joinPoint, result, exception, startInstant, endInstant);
        // 推送到临时队列
        offerLogToQueue(log);
    }

    /**
     * 将元素加入到消息中转站队列
     *
     * @param log
     */
    private void offerLogToQueue(Log log) {
        try {
            if (LogConfig.LOG_REDIS_IS_QUEUE && redisTemplate != null) {
                redisTemplate.opsForList().rightPush(LogConfig.LOG_REDIS_QUEUE, log);
            } else if (LogConfig.LOG_JAVA_IS_QUEUE) {
                queue.offer(log);
            } else {
                // 如果Redis和java队列都不生效，则记录到日志文件中
                logger.info(JsonUtil.toJson(log));
            }
        } catch (RedisConnectionFailureException e1) {
            logger.error("异常堆栈信息：", e1);
            // 如果发生Redis连接失败异常，降级处理
            if (LogConfig.LOG_JAVA_IS_QUEUE) {
                queue.offer(log);
            } else {
                // 如果Redis和java队列都不生效，则记录到日志文件中
                logger.info(JsonUtil.toJson(log));
            }
        } catch (Exception e) {
            logger.error("异常堆栈信息：", e);
        }
    }

    /**
     * 消费Redis日志
     *
     * @param threadNum 线程数
     */
    private void logRedisConsumer(int threadNum) {
        for (int i = 0; i < threadNum; i++) {
            threadPoolTaskExecutor.execute(() -> {
                // 牺牲空间换性能
                List<Log> list = new ArrayList<Log>(100);
                while (true) {
                    try {
                        list.clear();

                        // 从redis的list中取
                        Log log = (Log) redisTemplate.opsForList().leftPop(LogConfig.LOG_REDIS_QUEUE, 3,
                                TimeUnit.SECONDS);
                        while (log != null) {
                            log = resolveLog(log);

                            list.add(log);
                            int size = list.size();
                            // 如果日志记录大于等于50，则不再获取
                            if (size >= 50) {
                                break;
                            }

                            log = (Log) redisTemplate.opsForList().leftPop(LogConfig.LOG_REDIS_QUEUE, 3,
                                    TimeUnit.SECONDS);
                        }

                        if (list.size() > 0) {
                            cmdLogSerivce.saveLog(list);
                        }
                        if (LogConfig.LOG_REDIS_CONSUMER_INTERVAL_TIME > 0) {
                            Thread.sleep(LogConfig.LOG_REDIS_CONSUMER_INTERVAL_TIME);
                        }
                    } catch (Exception e1) {
                        logger.error("异常堆栈信息：", e1);
                        for (Log xLog : list) {
                            logger.error(JsonUtil.toJson(xLog));
                        }
                        try {
                            // 遇到异常等待重试
                            Thread.sleep(LogConfig.LOG_REDIS_CONSUMER_EXCEPTION_INTERVAL_TIME);
                        } catch (InterruptedException e) {
                            logger.error("", e);
                        }
                    }
                }
            });
        }
    }

    /**
     * 消费Java日志
     *
     * @param threadNum 线程数
     */
    private void logQueueConsumer(int threadNum) {
        for (int i = 0; i < threadNum; i++) {
            threadPoolTaskExecutor.execute(() -> {
                // 牺牲空间换性能
                List<Log> list = new ArrayList<Log>(100);
                while (true) {
                    try {
                        list.clear();

                        // 移除并返问队列头部的元素    如果队列为空，则返回null
                        Log log = queue.poll();
                        while (log != null) {
                            log = resolveLog(log);

                            list.add(log);
                            int size = list.size();
                            // 如果日志记录大于等于50，则不再获取
                            if (size >= 50) {
                                break;
                            }

                            log = queue.poll();
                        }

                        if (list.size() > 0) {
                            cmdLogSerivce.saveLog(list);
                        }
                        // 默认不等待
                        if (LogConfig.LOG_JAVA_CONSUMER_INTERVAL_TIME > 0) {
                            Thread.sleep(LogConfig.LOG_JAVA_CONSUMER_INTERVAL_TIME);
                        }
                    } catch (Exception e1) {
                        logger.error("异常堆栈信息：", e1);
                        for (Log xLog : list) {
                            logger.error(JsonUtil.toJson(xLog));
                        }
                        try {
                            // 遇到异常等待重试
                            Thread.sleep(LogConfig.LOG_JAVA_CONSUMER_EXCEPTION_INTERVAL_TIME);
                        } catch (InterruptedException e) {
                            logger.error("", e);
                        }
                    }
                }
            });
        }
    }

    /**
     * 重新组装log,处理长度
     *
     * @param log
     * @return
     */
    private Log resolveLog(Log log) {
        if (log.getReferer() != null && log.getReferer().length() > 150) {
            byte[] bytes = log.getReferer().getBytes();
            if (bytes.length > 500) {
                log.setReferer(new String(ArrayUtils.subarray(bytes, 0, 500)));
            }
        }
        if (log.getUrl() != null && log.getUrl().length() > 150) {
            byte[] bytes = log.getUrl().getBytes();
            if (bytes.length > 500) {
                log.setUrl(new String(ArrayUtils.subarray(bytes, 0, 500)));
            }
        }
        if (log.getHeader() != null && log.getHeader().length() > 1000) {
            byte[] bytes = log.getHeader().getBytes();
            if (bytes.length > 3000) {
                log.setHeader(new String(ArrayUtils.subarray(bytes, 0, 3000)));
            }
        }
        if (log.getArgs() != null && log.getArgs().length() > 1000) {
            byte[] bytes = log.getArgs().getBytes();
            if (bytes.length > 3000) {
                log.setArgs(new String(ArrayUtils.subarray(bytes, 0, 3000)));
            }
        }
        if (log.getResult() != null && log.getResult().length() > 1000) {
            byte[] bytes = log.getResult().getBytes();
            if (bytes.length > 3000) {
                log.setResult(new String(ArrayUtils.subarray(bytes, 0, 3000)));
            }
        }
        if (log.getException() != null && log.getException().length() > 1000) {
            byte[] bytes = log.getException().getBytes();
            if (bytes.length > 3000) {
                log.setException(new String(ArrayUtils.subarray(bytes, 0, 3000)));
            }
        }
        return log;
    }

    /**
     * 设置日志参数
     *
     * @param log
     * @param joinPoint    切点对象，包含了调用对象信息和请求参数信息。
     * @param result       请求执行结果
     * @param exception    异常信息
     * @param startInstant 开始时间，由Java8提供。
     * @param endInstant   结束时间，由Java8提供。
     */
    private void setLogArgs(Log log, ProceedingJoinPoint joinPoint, Object result, Exception exception,
                            Instant startInstant, Instant endInstant) {
        // 为了便于理解，目前的设计是，将能同时获取的参数分组管理（认知上分组，实际不分组）。详情参考Log类属性注释。
        // 设置日志基本参数
        setLogBasicArgs(log, joinPoint);
        // 设置时间参数
        setLogTimeArgs(log, startInstant, endInstant);
        // 设置日志请求参数
        setLogRequestArgs(log, joinPoint);
        // 设置日志类参数
        setLogClazzArgs(log, joinPoint);
        // 设置日志响应参数
        setLogResponseArgs(log, joinPoint, result);
        // 设置异常参数
        setLogExceptionArgs(log, exception);
    }

    /**
     * 设置日志异常参数
     *
     * @param log
     * @param e   异常信息
     */
    private void setLogExceptionArgs(Log log, Throwable e) {
        // 给Log对象赋值
        if (e != null) {
            log.setException(e.toString());
        }
    }

    /**
     * 设置日志响应参数
     *
     * @param log
     * @param joinPoint 切点对象，包含了调用对象信息和请求参数信息。
     * @param result    请求执行结果
     */
    private void setLogResponseArgs(Log log, ProceedingJoinPoint joinPoint, Object result) {
        Method method = ((MethodSignature) joinPoint.getSignature()).getMethod();
        LogOperation logOperationAnnotation = AnnotatedElementUtils.getMergedAnnotation(method, LogOperation.class);
        // 给Log对象赋值
        if (result != null && logOperationAnnotation != null && logOperationAnnotation.isLogResult()) {
            String r = null;
            if (result instanceof String) {
                r = (String) result;
            } else {
                r = JsonUtil.toJson(result);
            }
            log.setResult(r);
        }

        log.setStatus(getResponseStatus());
    }

    /**
     * 获取Http响应状态码
     *
     * @return Http响应状态码
     */
    private int getResponseStatus() {
        HttpServletResponse response = RequestHelper.getResponse();
        StatHttpServletResponseWrapper statHttpServletResponseWrapper = new WebStatFilter.StatHttpServletResponseWrapper(
                response);
        int status = statHttpServletResponseWrapper.getStatus();
        return status;
    }

    /**
     * 设置日志类参数
     *
     * @param log
     * @param joinPoint 切点对象，包含了调用对象信息和请求参数信息。
     */
    private void setLogClazzArgs(Log log, ProceedingJoinPoint joinPoint) {
        String qualiedName = joinPoint.getTarget().getClass().getName();
        String method = joinPoint.getSignature().getName();

        // 给Log对象赋值
        log.setQualiedName(qualiedName);
        log.setMethod(method);
    }

    /**
     * 设置日志请求参数
     *
     * @param log
     * @param joinPoint 切点对象，包含了调用对象信息和请求参数信息。
     */
    private void setLogRequestArgs(Log log, ProceedingJoinPoint joinPoint) {
        Method method = ((MethodSignature) joinPoint.getSignature()).getMethod();
        LogOperation logOperationAnnotation = AnnotatedElementUtils.getMergedAnnotation(method, LogOperation.class);
        HttpServletRequest request = RequestHelper.getRequest();
        // 用户真实IP
        // String ip = getRemoteAddr(request);
        String ip = RequestHelper.getRequestClientIp();
        // 请求来源，可能为空（比如：直接在浏览器中输入接口url就为空）
        String referer = request.getHeader(LogConfig.REFERER);
        // 完整url
        String url = request.getRequestURL().toString();

        log.setSystem(request.getServletContext().getContextPath());
        // 请求参数
        String args = null;
        if (logOperationAnnotation != null && logOperationAnnotation.isLogParam()) {
            Map<String, String[]> parameterMap = request.getParameterMap();
            if (parameterMap.isEmpty() == false) {
                args = JsonUtil.toJson(parameterMap);
            }
        }

        // 给Log对象赋值
        log.setIp(ip);
        log.setReferer(referer);
        log.setUrl(url);
        // log.setHeader(header);
        log.setArgs(args);
    }

    /**
     * 设置日志时间参数
     *
     * @param log
     * @param startInstant 开始时间，由Java8提供。
     * @param endInstant   结束时间，由Java8提供。
     */
    private void setLogTimeArgs(Log log, Instant startInstant, Instant endInstant) {
        long start = startInstant.toEpochMilli();
        long end = endInstant.toEpochMilli();
        // 格式：yyyy-MM-dd HH:mm:ss:SSS
        String dateTime = LocalDateTime.ofInstant(startInstant, ZoneId.systemDefault())
                .format(DateTimeFormatter.ofPattern(LogConfig.DATE_TIME_PATTERN));

        // 给Log对象赋值
        log.setDateTime(dateTime);
        log.setDuration((int) (end - start));
    }

    /**
     * 设置日志基础参数
     *
     * @param log
     * @param joinPoint 切点对象，包含了调用对象信息和请求参数信息。
     */
    private void setLogBasicArgs(Log log, ProceedingJoinPoint joinPoint) {
        Method method = ((MethodSignature) joinPoint.getSignature()).getMethod();
        Class<? extends Object> clazz = joinPoint.getTarget().getClass();

        boolean isLogOperation = AnnotatedElementUtils.isAnnotated(method, LogOperation.class);
        boolean isLogModule = AnnotatedElementUtils.isAnnotated(clazz, LogModule.class);

        String system = null;
        String module = null;
        String operation = null;
        String userName = null;
        String remark = null;

        // 第一优先级
        if (isLogOperation) {
            LogOperation logOperationAnnotation = AnnotatedElementUtils.getMergedAnnotation(method, LogOperation.class);
            // 获取注解上的属性和属性值。
            system = logOperationAnnotation.system();
            module = logOperationAnnotation.module();
            operation = logOperationAnnotation.operation();
            userName = logOperationAnnotation.userName();
            remark = logOperationAnnotation.remark();
        }

        // 第二优先级
        // 如果@LogOperation注解中的system或module为空，则取类上@LogModule注解中的值替换。
        // 换句话说是：最大范围补全参数。
        if (isLogModule && (!isLogOperation || StringUtils.isBlank(system) || StringUtils.isBlank(module))) {
            LogModule logModuleAnnotation = AnnotatedElementUtils.getMergedAnnotation(clazz, LogModule.class);
            // 当第一优先级当前值为空，才取第二优先级的字段
            if (StringUtils.isBlank(system)) {
                system = logModuleAnnotation.system();
            }
            if (StringUtils.isBlank(module)) {
                module = logModuleAnnotation.module();
            }
        }

        // 使用默认类名
        if (StringUtils.isBlank(module)) {
            module = clazz.getName();
        }
        // 使用默认方法名
        if (StringUtils.isBlank(operation)) {
            operation = method.getName();
        }

        // 验证是否需要替换参数，如果需要替换，则返回替换后的值
        // 如果原始值是null，则返回的同样是null。
        // 原因是：当值为空，则不进入verifyReplaceArgs()中的判断，而是原样返回。
        system = verifyReplaceArgs(system);
        module = verifyReplaceArgs(module);
        operation = verifyReplaceArgs(operation);
        userName = verifyReplaceArgs(userName);
        remark = verifyReplaceArgs(remark);

        // userName需要特殊处理，因为userName可能会从Session中获取。
        //if (StringUtils.isBlank(userName)) {
        userName = getUserNameBySession();
        //}

        // 给Log对象赋值
        log.setSystem(system);
        log.setModule(module);
        log.setOperation(operation);
        log.setUserName(userName);
        log.setRemark(remark);
    }

    /**
     * 根据Session获取登录用户名
     *
     * @return 登录用户名
     */
    private String getUserNameBySession() {
        LoginUserModel loginUserModel = (LoginUserModel) RequestHelper.getSession()
                .getAttribute(PubConstants.LOGIN_SESSION_USERINFO);
        return loginUserModel != null ? loginUserModel.getUserName() : null;
    }

    /**
     * 验证是否需要替换参数，如果需要替换，则返回替换后的值
     *
     * @param args 参数
     * @return 替换后的参数
     */
    private String verifyReplaceArgs(String args) {
        if (isReplaceArgs(args)) {
            // 从request中获取对应的attribute
            String temp = args
                    .substring(LogConfig.ARGS_STARTS_WITH.length(), args.length() - LogConfig.ARGS_END_WITH.length())
                    .trim();
            Object attribute = RequestContextHolder.getRequestAttributes().getAttribute(temp,
                    RequestAttributes.SCOPE_REQUEST);
            if (attribute != null) {
                args = attribute.toString();
            }
            // 这里附加从配置文件中获取参数的逻辑，这样不用每个注解都需要在LogHelper中赋值。
            if (StringUtils.isBlank(args)) {
                args = (String) PropertyConfigure.getProperty(temp);
            }
        }
        return StringUtils.isNotBlank(args) ? args : null;
    }

    /**
     * 验证是否需要动态替换参数。<br>
     * 以"${"开头和"}"结尾的参数需要使用动态参数替换，如：${system}。<br>
     *
     * @param args 参数key
     * @return 是否需要动态替换参数。true：需要，false：不需要
     */
    private boolean isReplaceArgs(String args) {
        return StringUtils.isNotBlank(args) && args.startsWith(LogConfig.ARGS_STARTS_WITH)
                && args.endsWith(LogConfig.ARGS_END_WITH);
    }

    /**
     * 判断是否记录日志。<br>
     * 判断条件分为第一优先级和第二优先级，如下：<br>
     * 1. 只要方法中包含@LogOperation注解或类上包含@LogModule注解，则记录日志。<br>
     * 2. 当第一优先级不成立时，判断请求调用方法是否为数据接口，若不是数据接口，则记录日志，若不是数据接口，则不记录日志。
     *
     * @param joinPoint 切点对象，包含了调用对象信息和请求参数信息。
     * @return 是否记录日志。true：记录日志，false：不记录日志。
     */
    private Boolean isRecordLog(ProceedingJoinPoint joinPoint) {
        if (!LogConfig.LOG_IS_RECORD) {
            return false;
        }

        Method method = ((MethodSignature) joinPoint.getSignature()).getMethod();
        Class<? extends Object> clazz = joinPoint.getTarget().getClass();

        // 第一优先级
        boolean isLogOperation = AnnotatedElementUtils.isAnnotated(method, LogOperation.class);
        if (isLogOperation) {
            return true;
        }
        // 第二优先级
        boolean isRestController = AnnotatedElementUtils.isAnnotated(clazz, RestController.class);
        // 当类上加了@RestController注解后，说明该方法是属于数据接口，数据接口目前先不记录日志
        if (!isRestController) {
            return true;
        }

        return false;
    }
}
