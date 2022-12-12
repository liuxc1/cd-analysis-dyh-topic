package ths.project.common.watch;

import org.apache.commons.lang.StringUtils;
import org.apache.ibatis.builder.xml.XMLMapperBuilder;
import org.apache.ibatis.executor.ErrorContext;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.util.ObjectUtils;

import java.io.IOException;
import java.lang.reflect.Field;
import java.util.*;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;

/**
 * Mybatis Mapper文件动态加载
 */
public class MybatisMapperWatch implements InitializingBean {

    private final Logger logger = LoggerFactory.getLogger(MybatisMapperWatch.class);

    private final Map<String, String> mappers = new HashMap<>();

    private final PathMatchingResourcePatternResolver pathMatchingResourcePatternResolver = new PathMatchingResourcePatternResolver();

    private final List<Resource> reloadList = new ArrayList<>();

    private Resource[] resources;

    private SqlSessionFactory sqlSessionFactory;

    private String[] mapperLocations;

    private int sleepSeconds = 30;

    private int delaySeconds = 0;

    private ScheduledExecutorService scheduledExecutorService;

    @Override
    public void afterPropertiesSet() throws Exception {
        if (!ObjectUtils.isEmpty(mapperLocations)) {
            findAllClassPathResources();
            for (Resource resource : resources) {
                mappers.put(resource.getURI().toString(), getMd(resource));
            }

            scheduledExecutorService = new ScheduledThreadPoolExecutor(1, new ThreadFactory() {
                @Override
                public Thread newThread(Runnable r) {
                    Thread thread = new Thread(r, this.getClass().getName() + "." + Thread.class.getName());
                    return thread;
                }
            });
            scheduledExecutorService.scheduleAtFixedRate(() -> {
                try {
                    if (isChanged()) {
                        reloadXML();
                    }
                } catch (Exception e) {
                    logger.error("", e);
                }
            }, delaySeconds, sleepSeconds, TimeUnit.SECONDS);
        } else {
            logger.error("<========== 属性: mapperlocations 未指定或没有发现匹配的资源... ==========>");
        }
    }

    /**
     * 重新解析XML加载配置
     */
    @SuppressWarnings("unchecked")
    private void reloadXML() throws Exception {
        Configuration configuration = sqlSessionFactory.getConfiguration();

        String[] fieldNames = {"mappedStatements", "caches", "resultMaps", "parameterMaps", "keyGenerators", "sqlFragments"};
        Field[] fields = new Field[fieldNames.length];
        for (int i = 0; i < fieldNames.length; i++) {
            Field field = getFiled(configuration.getClass(), fieldNames[i]);
            field.setAccessible(true);
            fields[i] = field;
        }

        for (Resource resource : reloadList) {
            String filePath = resource.getFile().getAbsolutePath();

            for (Field field : fields) {
                Map<String, Object> strictMap = new StrictMap<>(StringUtils.capitalize(field.getName()) + "collection");
                strictMap.putAll((Map<String, Object>) field.get(configuration));
                field.set(configuration, strictMap);
            }

            Field field = getFiled(configuration.getClass(), "loadedResources");
            field.setAccessible(true);
            Set<String> set = (HashSet<String>) field.get(configuration);
            set.remove(filePath);

            try {
                new XMLMapperBuilder(resource.getInputStream(), configuration, filePath, configuration.getSqlFragments()).parse();
            } finally {
                ErrorContext.instance().reset();
            }

            logger.info("<========== 加载 {" + resource.getFilename() + "} 完成... ==========>");
        }
        reloadList.clear();
    }

    private Field getFiled(Class<?> clz, String fieldName) {
        try {
            return clz.getDeclaredField(fieldName);
        } catch (NoSuchFieldException e) {
            if (!Object.class.equals(clz)) {
                return getFiled(clz.getSuperclass(), fieldName);
            }
        }
        throw new RuntimeException("未查到该字段");
    }

    /**
     * 检查是否改变,新增/修改
     */
    private boolean isChanged() throws IOException {
        boolean flag = false;
        findAllClassPathResources();
        for (Resource resource : resources) {
            String key = resource.getURI().toString();
            String value = getMd(resource);
            if (mappers.get(key) == null || !value.equals(mappers.get(key))) {
                mappers.put(key, value);
                reloadList.add(resource);
                flag = true;
            }
        }
        return flag;
    }

    /**
     * 动态扫描classpath
     */
    public void findAllClassPathResources() throws IOException {
        for (String path : mapperLocations) {
            resources = pathMatchingResourcePatternResolver.getResources(path);
        }
    }

    /**
     * 生成文件标识
     */
    private String getMd(Resource resource) throws IOException {
        return resource.contentLength() + "-" + resource.lastModified();
    }

    public void setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
        this.sqlSessionFactory = sqlSessionFactory;
    }

    public void setMapperLocations(String[] mapperLocations) {
        this.mapperLocations = mapperLocations;
    }

    public void setSleepSeconds(int sleepSeconds) {
        this.sleepSeconds = sleepSeconds;
    }

    public void setDelaySeconds(int delaySeconds) {
        this.delaySeconds = delaySeconds;
    }

    /**
     * 重写 org.apache.ibatis.session.Configuration.StrictMap 类,修改 put方法,允许反复 put更新。
     */
    public static class StrictMap<V> extends HashMap<String, V> {

        private static final long serialVersionUID = 7071099691573645874L;

        private final String name;

        public StrictMap(String name, int initialCapacity, float loadFactor) {
            super(initialCapacity, loadFactor);
            this.name = name;
        }

        public StrictMap(String name, int initialCapacity) {
            super(initialCapacity);
            this.name = name;
        }

        public StrictMap(String name) {
            super();
            this.name = name;
        }

        public StrictMap(String name, Map<String, ? extends V> m) {
            super(m);
            this.name = name;
        }

        @Override
        @SuppressWarnings("unchecked")
        public V put(String key, V value) {
            String separativeSign = ".";
            if (key.contains(separativeSign)) {
                final String shortKey = getShortName(key);
                if (super.get(shortKey) == null) {
                    super.put(shortKey, value);
                } else {
                    super.put(shortKey, (V) new Ambiguity(shortKey));
                }
            }
            return super.put(key, value);
        }

        @Override
        public V get(Object key) {
            V value = super.get(key);
            if (value == null) {
                throw new IllegalArgumentException(name + " does not contain value for " + key);
            }
            if (value instanceof Ambiguity) {
                throw new IllegalArgumentException(((Ambiguity) value).getSubject() + " is ambiguous in " + name + " (try using the full name including the namespace, or rename one of the entries)");
            }
            return value;
        }

        private String getShortName(String key) {
            final String[] keyparts = key.split("\\.");
            return keyparts[keyparts.length - 1];
        }

        protected static class Ambiguity {

            private final String subject;

            public Ambiguity(String subject) {
                this.subject = subject;
            }

            public String getSubject() {
                return subject;
            }
        }
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        try {
            scheduledExecutorService.shutdown();
        } catch (Exception ignored) {
        }
    }
}