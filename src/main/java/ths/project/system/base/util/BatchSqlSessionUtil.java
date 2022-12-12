package ths.project.system.base.util;

import com.baomidou.mybatisplus.core.enums.SqlMethod;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.toolkit.CollectionUtils;
import com.baomidou.mybatisplus.core.toolkit.Constants;
import com.baomidou.mybatisplus.core.toolkit.GlobalConfigUtils;
import com.baomidou.mybatisplus.extension.toolkit.SqlHelper;
import com.p6spy.engine.common.P6LogQuery;
import com.p6spy.engine.logging.Category;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.mapping.ParameterMode;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.type.TypeHandlerRegistry;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import ths.project.common.util.BeanUtil;
import ths.project.system.base.bo.MapperSqlInfo;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class BatchSqlSessionUtil {

    private static final int BATCH_SIZE = 100;

    private static final Map<ClassLoader, Logger> SQL_LOGGERS = new HashMap<>();

    private static Logger getSqlLogger() {
        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        Logger logger = SQL_LOGGERS.get(classLoader);
        if (logger == null) {
            //noinspection SynchronizationOnLocalVariableOrMethodParameter
            synchronized (classLoader) {
                logger = SQL_LOGGERS.get(classLoader);
                if (logger == null) {
                    try {
                        //获取当前classLoader所加载的LoggerFactory类，防止同一应用不同项目间的干扰
                        Class<?> clz = classLoader.loadClass(LoggerFactory.class.getName());
                        Method method = clz.getMethod("getLogger", String.class);
                        logger = (Logger) method.invoke(null, "p6spy");
                    } catch (ClassNotFoundException | NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
                        logger = LoggerFactory.getLogger("p6spy");
                        logger.error("", e);
                    }
                    SQL_LOGGERS.put(classLoader, logger);
                }
            }
        }
        return logger;
    }

    /**
     * 获取SQL statementId
     *
     * @param clz       实体类
     * @param sqlMethod MybatisPlus支持的SQL方法
     * @return mapper 注入的 SQL StatementId
     */
    private static String getSqlStatementId(Class<?> clz, SqlMethod sqlMethod) {
        return SqlHelper.table(clz).getSqlStatement(sqlMethod.getMethod());
    }

    /**
     * 获取mapper接口对应的实体类定义
     *
     * @param mapperClass mapper接口的实现对象
     * @param <M>         mapper接口类限定
     * @param <T>         实体类限定
     * @return 实体类定义
     */
    @SuppressWarnings("unchecked")
    private static <M extends BaseMapper<T>, T> Class<T> getEntityClass(Class<M> mapperClass) {
        Type[] types = mapperClass.getGenericInterfaces();
        for (Type type : types) {
            if (type instanceof ParameterizedType) {
                ParameterizedType parameterizedType = (ParameterizedType) type;
                Type rawType = parameterizedType.getRawType();
                if (rawType instanceof Class && BaseMapper.class.isAssignableFrom((Class<?>) rawType)) {
                    return (Class<T>) parameterizedType.getActualTypeArguments()[0];
                }
            }
        }
        throw new RuntimeException("无法获取mapper接口对应实体类的的具体class定义");
    }

    /**
     * 获取mapper接口对应的实体类定义
     *
     * @param mapper mapper接口的实现对象
     * @param <M>    mapper接口类限定
     * @param <T>    实体类限定
     * @return 实体类定义
     */
    private static <M extends BaseMapper<T>, T> Class<T> getEntityClass(M mapper) {
        return getEntityClass(getMapperClass(mapper));
    }

    /**
     * 获取mapper接口实现的具体接口类定义
     *
     * @param mapper mapper接口的实现对象
     * @param <M>    mapper接口类限定
     * @param <T>    实体类限定
     * @return 具体接口类定义
     */
    @SuppressWarnings({"unchecked"})
    private static <M extends BaseMapper<T>, T> Class<M> getMapperClass(M mapper) {
        Type[] types = mapper.getClass().getInterfaces();
        for (Type type : types) {
            if (type instanceof Class) {
                Class<?> clz = (Class<?>) type;
                if (BaseMapper.class.isAssignableFrom(clz)) {
                    return (Class<M>) clz;
                }
            }
        }
        throw new RuntimeException("无法获取mapper接口的具体class定义");
    }

    /**
     * <p>
     * 插入（批量）
     * </p>
     *
     * @param entityList 实体对象列表
     * @return int 有效操作记录数量
     */
    public static <M extends BaseMapper<T>, T, C extends Collection<T>> int insertBatch(M baseMapper, C entityList) {
        return insertBatch(baseMapper, entityList, BATCH_SIZE);
    }

    /**
     * <p>
     * 插入（批量）
     * </p>
     *
     * @param entityList 实体对象列表
     * @return int 有效操作记录数量
     */
    public static <M extends BaseMapper<T>, T, C extends Collection<T>> int insertBatch(M baseMapper, C entityList, int batchSize) {
        if (CollectionUtils.isEmpty(entityList)) {
            return 0;
        }
        Class<T> clz = getEntityClass(baseMapper);
        String sqlStatement = getSqlStatementId(clz, SqlMethod.INSERT_ONE);
        SqlSessionFactory sqlSessionFactory = SqlHelper.sqlSessionFactory(clz);
        return executeBatch(sqlSessionFactory, sqlStatement, entityList, StatementType.INSERT, batchSize);
    }

    /**
     * <p>
     * 更新（批量）
     * </p>
     *
     * @param entityList 实体对象列表
     * @return int 有效操作记录数量
     */
    public static <M extends BaseMapper<T>, T> int updateBatch(M baseMapper, Collection<? extends T> entityList) {
        return updateBatch(baseMapper, entityList, BATCH_SIZE);
    }

    /**
     * <p>
     * 更新（批量）
     * </p>
     *
     * @param entityList 实体对象列表
     * @return int 有效操作记录数量
     */
    public static <M extends BaseMapper<T>, T> int updateBatch(M baseMapper, Collection<? extends T> entityList, int batchSize) {
        if (CollectionUtils.isEmpty(entityList)) {
            return 0;
        }
        Class<T> clz = getEntityClass(baseMapper);
        SqlSessionFactory sqlSessionFactory = SqlHelper.sqlSessionFactory(clz);
        String sqlStatement = getSqlStatementId(clz, SqlMethod.UPDATE_BY_ID);

        List<Map<String, T>> paramList = new ArrayList<>(entityList.size());
        for (T entity : entityList) {
            Map<String, T> paramMap = new HashMap<>();
            paramMap.put(Constants.ENTITY, entity);
            paramList.add(paramMap);
        }
        return executeBatch(sqlSessionFactory, sqlStatement, paramList, StatementType.UPDATE, batchSize);
    }

    /**
     * <p>
     * 插入（批量）
     * </p>
     *
     * @param baseMapper 数据层对象
     * @param fn         操作
     * @param paramList  参数集合
     * @return int 有效操作记录数量
     */
    public static <M extends BaseMapper<T>, T, K, Q> int insertBatch(M baseMapper, BeanUtil.BsFunction1<M, Q, K> fn, List<K> paramList) {
        return insertBatch(baseMapper, fn, paramList, BATCH_SIZE);
    }

    /**
     * <p>
     * 插入（批量）
     * </p>
     *
     * @param baseMapper 数据层对象
     * @param fn         操作
     * @param paramList  参数集合
     * @return int 有效操作记录数量
     */
    public static <M extends BaseMapper<T>, T, K, Q> int insertBatch(M baseMapper, BeanUtil.BsFunction1<M, Q, K> fn, List<K> paramList, int batchSize) {
        Class<M> mapperClass = getMapperClass(baseMapper);
        Class<T> entityClass = getEntityClass(baseMapper);
        SqlSessionFactory sqlSessionFactory = SqlHelper.sqlSessionFactory(entityClass);
        return executeBatch(sqlSessionFactory, mapperClass.getName() + "." + fn.getLambadaInfo().getImplMethodName(), paramList, StatementType.INSERT, batchSize);
    }

    /**
     * <p>
     * 更新（批量）
     * </p>
     *
     * @param baseMapper 数据层对象
     * @param fn         操作
     * @param paramList  参数集合
     * @return int 有效操作记录数量
     */
    public static <M extends BaseMapper<T>, T, K, Q> int updateBatch(M baseMapper, BeanUtil.BsFunction1<M, Q, K> fn, List<K> paramList) {
        return updateBatch(baseMapper, fn, paramList, BATCH_SIZE);
    }

    /**
     * <p>
     * 更新（批量）
     * </p>
     *
     * @param baseMapper 数据层对象
     * @param fn         操作
     * @param paramList  参数集合
     * @return int 有效操作记录数量
     */
    public static <M extends BaseMapper<T>, T, K, Q> int updateBatch(M baseMapper, BeanUtil.BsFunction1<M, Q, K> fn, List<K> paramList, int batchSize) {
        Class<M> mapperClass = getMapperClass(baseMapper);
        Class<T> entityClass = getEntityClass(baseMapper);
        SqlSessionFactory sqlSessionFactory = SqlHelper.sqlSessionFactory(entityClass);
        return executeBatch(sqlSessionFactory, mapperClass.getName() + "." + fn.getLambadaInfo().getImplMethodName(), paramList, StatementType.UPDATE, batchSize);
    }

    /**
     * <p>
     * 执行（批量）
     * </p>
     *
     * @param sqlSessionFactory 会话工厂
     * @param statementId       会话ID
     * @param paramList         参数集合
     * @param statementType     操作类型
     * @return int 有效操作记录数量
     */
    private static <M extends BaseMapper<T>, T, K, C extends Collection<K>> int executeBatch(SqlSessionFactory sqlSessionFactory, String statementId, C paramList, StatementType statementType, int batchSize) {
        if (CollectionUtils.isEmpty(paramList)) {
            return 0;
        }

        try (SqlSession batchSqlSession = sqlSessionFactory.openSession(ExecutorType.BATCH)) {
            long startTime = System.currentTimeMillis();
            int total = 0;
            int i = -1;
            for (K k : paramList) {
                i++;
                if (statementType == StatementType.UPDATE) {
                    batchSqlSession.update(statementId, k);
                    total++;
                } else if (statementType == StatementType.INSERT) {
                    batchSqlSession.insert(statementId, k);
                    total++;
                } else {
                    batchSqlSession.delete(statementId, k);
                    total++;
                }
                if (i >= 1 && i % batchSize == 0) {
                    batchSqlSession.flushStatements();
                }
            }
            batchSqlSession.flushStatements();

            Logger logger = getSqlLogger();
            if (logger.isInfoEnabled()) {
                MapperSqlInfo mapperSqlInfo = getSql(sqlSessionFactory.getConfiguration(), statementId, paramList.iterator().next());
                P6LogQuery.logElapsed(-1, startTime, System.currentTimeMillis(), Category.STATEMENT, mapperSqlInfo.getSql(), mapperSqlInfo.getParseSql());
            }
            return total;
        }
    }

    /**
     * 获取mapper中某个statement的sql
     *
     * @param mapperClz 数据层Class
     * @param clz       实体类Calss
     * @param fn        操作方法
     * @param parameter 参数
     * @return sql解析结果
     */
    @SafeVarargs
    public static <M extends BaseMapper<T>, T, X, Q> MapperSqlInfo getSql(Class<M> mapperClz, Class<T> clz, BeanUtil.BsFunction0<M, Q> fn, X... parameter) {
        return getSql0(mapperClz, clz, fn, parameter);
    }

    /**
     * 获取mapper中某个statement的sql
     *
     * @param mapperClz 数据层Class
     * @param clz       实体类Calss
     * @param fn        操作方法
     * @param parameter 参数
     * @return sql解析结果
     */
    @SafeVarargs
    public static <M extends BaseMapper<T>, T, X, Q, A> MapperSqlInfo getSql(Class<M> mapperClz, Class<T> clz, BeanUtil.BsFunction1<M, Q, A> fn, X... parameter) {
        return getSql0(mapperClz, clz, fn, parameter);
    }

    /**
     * 获取mapper中某个statement的sql
     *
     * @param mapperClz 数据层Class
     * @param clz       实体类Calss
     * @param fn        操作方法
     * @param parameter 参数
     * @return sql解析结果
     */
    @SafeVarargs
    public static <M extends BaseMapper<T>, T, X, Q, A, B> MapperSqlInfo getSql(Class<M> mapperClz, Class<T> clz, BeanUtil.BsFunction2<M, Q, A, B> fn, X... parameter) {
        return getSql0(mapperClz, clz, fn, parameter);
    }

    /**
     * 获取mapper中某个statement的sql
     *
     * @param mapperClz 数据层Class
     * @param clz       实体类Calss
     * @param fn        操作方法
     * @param parameter 参数
     * @return sql解析结果
     */
    @SafeVarargs
    public static <M extends BaseMapper<T>, T, X, Q, A, B, C> MapperSqlInfo getSql(Class<M> mapperClz, Class<T> clz, BeanUtil.BsFunction3<M, Q, A, B, C> fn, X... parameter) {
        return getSql0(mapperClz, clz, fn, parameter);
    }

    /**
     * 获取mapper中某个statement的sql
     *
     * @param mapperClz 数据层Class
     * @param clz       实体类Calss
     * @param fn        操作方法
     * @param parameter 参数
     * @return sql解析结果
     */
    @SafeVarargs
    public static <M extends BaseMapper<T>, T, X, Q, A, B, C, D> MapperSqlInfo getSql(Class<M> mapperClz, Class<T> clz, BeanUtil.BsFunction4<M, Q, A, B, C, D> fn, X... parameter) {
        return getSql0(mapperClz, clz, fn, parameter);
    }

    /**
     * 获取mapper中某个statement的sql
     *
     * @param mapperClz 数据层Class
     * @param clz       实体类Calss
     * @param fn        操作
     * @param parameter 参数
     * @return sql解析结果
     */
    @SafeVarargs
    private static <M extends BaseMapper<T>, T, X> MapperSqlInfo getSql0(Class<M> mapperClz, Class<T> clz, BeanUtil.BsFunction fn, X... parameter) {
        String statementId = mapperClz.getName() + "." + fn.getLambadaInfo().getImplMethodName();
        Configuration configuration = GlobalConfigUtils.currentSessionFactory(clz).getConfiguration();
        return getSql(configuration, statementId, parameter);
    }


    /**
     * 获取mapper中某个statement的sql
     *
     * @param configuration mybatis配置信息
     * @param statementId   mybatis命名空间及操作
     * @param parameter     参数
     * @return sql解析结果
     */
    private static <T, X> MapperSqlInfo getSql(Configuration configuration, String statementId, X parameter) {
        BoundSql boundSql = configuration.getMappedStatement(statementId).getBoundSql(parameter);
        MapperSqlInfo mapperSqlInfo = new MapperSqlInfo();
        mapperSqlInfo.setSql(boundSql.getSql());
        List<ParameterMapping> parameterMappings = boundSql.getParameterMappings();
        if (parameterMappings != null) {
            List<Object> parameterList = new ArrayList<>(parameterMappings.size());
            if (parameter != null) {
                TypeHandlerRegistry typeHandlerRegistry = configuration.getTypeHandlerRegistry();
                for (ParameterMapping parameterMapping : parameterMappings) {
                    if (parameterMapping.getMode() != ParameterMode.OUT) {
                        Object value;
                        String propertyName = parameterMapping.getProperty();
                        if (boundSql.hasAdditionalParameter(propertyName)) {
                            value = boundSql.getAdditionalParameter(propertyName);
                        } else if (typeHandlerRegistry.hasTypeHandler(parameter.getClass())) {
                            value = parameter;
                        } else {
                            MetaObject metaObject = configuration.newMetaObject(parameter);
                            value = metaObject.getValue(propertyName);
                        }

                        if (value == null) {
                            value = "";
                        }
                        parameterList.add(value);
                    }
                }
            }
            mapperSqlInfo.setParams(parameterList.toArray());
        }
        return mapperSqlInfo;
    }

    public enum StatementType {
        /**
         * 更新
         */
        UPDATE,
        /**
         * 插入
         */
        INSERT,
        /**
         * 删除
         */
        DELETE
    }
}
