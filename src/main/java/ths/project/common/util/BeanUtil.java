package ths.project.common.util;

import org.apache.commons.lang.StringUtils;

import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.Serializable;
import java.lang.invoke.SerializedLambda;
import java.lang.ref.SoftReference;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 实体类操作工具
 */
public class BeanUtil {

    /**
     * 获取实体类对象内容为空的属性名称
     *
     * @param t       实体类对象
     * @param getters 属性的get方法引用
     * @param <T>     实体类型
     * @param <R>     属性类型
     * @return 内容为空的属性名称集合
     */
    @SafeVarargs
    public static <T, R> List<String> getEmptyFields(T t, GetterFunction<T, R>... getters) {
        List<String> nullFieldList = new ArrayList<>();
        for (GetterFunction<T, R> getter : getters) {
            R obj = getter.apply(t);
            if (obj == null) {
                nullFieldList.add(getFieldName(getter));
            } else if (obj instanceof String && obj.toString().trim().length() == 0) {
                nullFieldList.add(getFieldName(getter));
            }
        }
        return nullFieldList;
    }

    /**
     * 获取实体类的指定属性的属性名称
     *
     * @param getters 属性的get方法引用
     * @param <T>     实体类型
     * @param <R>     属性类型
     * @return 属性名称数组
     */
    @SafeVarargs
    public static <T, R> String[] getFieldNames(GetterFunction<T, R>... getters) {
        String[] fieldNames = new String[getters.length];
        for (int i = 0; i < getters.length; i++) {
            fieldNames[i] = getFieldName(getters[i]);
        }
        return fieldNames;
    }

    /**
     * 获取实体类的指定属性的属性名称
     *
     * @param fn  属性的get方法引用
     * @param <T> 实体类型
     * @param <R> 属性类型
     * @return 属性名称
     */
    public static <T, R> String getFieldName(GetterFunction<T, R> fn) {
        String fieldName = fn.getLambadaInfo().getFieldName();
        if (fieldName.length() == 0) {
            throw new RuntimeException("非getter方法");
        }
        return fieldName;
    }

    /**
     * 获取实体类的指定属性的属性名称
     *
     * @param fn  属性的get方法引用
     * @param <T> 实体类型
     * @param <R> 属性类型
     * @return 属性名称
     */
    public static <T, R> String getFieldNameWithUpper(GetterFunction<T, R> fn) {
        return MapUtil.upperScoreName(getFieldName(fn));
    }

    /**
     * 复制源对象的指定属性到目标对象
     *
     * @param from 源对象
     * @param to   目标对象
     * @param fns  指定属性的get方法引用
     * @param <T>  源对象和目标对象的共同父类型
     * @param <T1> 目标对象类型
     * @param <T2> 源对象类型
     * @param <R>  属性类型
     * @return 目标对象
     */
    @SafeVarargs
    public static <T, T1 extends T, T2 extends T, R> T1 copyProperties(T1 to, T2 from, GetterFunction<T, R>... fns) {
        try {
            for (GetterFunction<T, R> fn : fns) {
                R r = fn.apply(from);
                Method methodSet = fn.getLambadaInfo().getSetter();
                methodSet.invoke(to, r);
            }
            return to;
        } catch (IllegalAccessException | InvocationTargetException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 把源list的元素匹配并添加到目标list的匹配元素的对应属性中
     *
     * @param toList    目标类型list
     * @param fromList  源类型list
     * @param getFnTo   目标类型对应匹配属性的get方法引用，用于匹配
     * @param getFnFrom 源类型对应匹配属性的get方法引用，用于匹配
     * @param setfnTo   目标类型的对应源类型（或源父类型）属性的set方法引用，用于设置匹配的源类型元素
     * @param <T1>      目标类型
     * @param <T2>      源类型
     * @param <T3>      源类型或其父类
     * @param <R>       匹配属性的类型
     * @param <C1>      目标类型list的类型
     * @param <C2>      源类型list的类型
     * @return 目标类型list
     */
    public static <T1, T2 extends T3, T3, R, Q, C1 extends Collection<T1>, C2 extends Collection<T2>> C1 matchSet(C1 toList
            , C2 fromList, GetterFunction<T1, R> getFnTo, GetterFunction<T3, R> getFnFrom, SetterFunction<T1, T3> setfnTo) {
        fromList.parallelStream().forEach(t2 -> {
            R r = getFnFrom.apply(t2);
            if (r != null) {
                toList.parallelStream().forEach(t1 -> {
                    if (r.equals(getFnTo.apply(t1))) {
                        setfnTo.apply(t1, t2);
                    }
                });
            }
        });
        return toList;
    }

    /**
     * 把源list的元素匹配并添加到目标list的匹配元素的对应属性中(目标的匹配属性的值是唯一的)
     *
     * @param toList    目标类型list
     * @param fromList  源类型list
     * @param getFnTo   目标类型对应匹配属性的get方法引用，用于匹配
     * @param getFnFrom 源类型对应匹配属性的get方法引用，用于匹配
     * @param setfnTo   目标类型的对应源类型（或源父类型）属性的set方法引用，用于设置匹配的源类型元素
     * @param <T1>      目标类型
     * @param <T2>      源类型
     * @param <T3>      源类型或其父类
     * @param <R>       匹配属性的类型
     * @param <C1>      目标类型list的类型
     * @param <C2>      源类型list的类型
     * @return 目标类型list
     */
    public static <T1, T2 extends T3, T3, R, Q, C1 extends Collection<T1>, C2 extends Collection<T2>> C1 matchSetMain(C1 toList
            , C2 fromList, GetterFunction<T1, R> getFnTo, GetterFunction<T3, R> getFnFrom, SetterFunction<T1, T3> setfnTo) {
        Map<R, T1> indexMap = toCacheMap(toList, getFnTo);
        for (T2 t2 : fromList) {
            R r = getFnFrom.apply(t2);
            T1 t1 = indexMap.get(r);
            if (t1 != null) {
                setfnTo.apply(t1, t2);
            }
        }
        return toList;
    }

    /**
     * 把源list的元素匹配并添加到目标list的匹配元素的对应属性中(目标的匹配属性的值是唯一的)（setter带返回值的）
     *
     * @param toList    目标类型list
     * @param fromList  源类型list
     * @param getFnTo   目标类型对应匹配属性的get方法引用，用于匹配
     * @param getFnFrom 源类型对应匹配属性的get方法引用，用于匹配
     * @param setFnTo   目标类型的对应源类型（或源父类型）属性的set方法引用，用于设置匹配的源类型元素
     * @param <T1>      目标类型
     * @param <T2>      源类型
     * @param <T3>      源类型或其父类
     * @param <R>       匹配属性的类型
     * @param <Q>       set方法引用的返回类型
     * @param <C1>      目标类型list的类型
     * @param <C2>      源类型list的类型
     * @return 目标类型list
     */
    public static <T1, T2 extends T3, T3, R, Q, C1 extends Collection<T1>, C2 extends Collection<T2>> C1 matchSetMain(C1 toList
            , C2 fromList, GetterFunction<T1, R> getFnTo, GetterFunction<T3, R> getFnFrom, SetterFunctionQ<T1, T3, Q> setFnTo) {
        Map<R, T1> indexMap = toCacheMap(toList, getFnTo);
        for (T2 t2 : fromList) {
            R r = getFnFrom.apply(t2);
            T1 t1 = indexMap.get(r);
            if (t1 != null) {
                setFnTo.apply(t1, t2);
            }
        }
        return toList;
    }

    /**
     * 把源list的元素匹配并添加到目标list的匹配元素的对应list属性中(目标的匹配属性的值是唯一的)
     *
     * @param toList      目标类型list
     * @param fromList    源类型list
     * @param getFnTo     目标类型对应匹配属性的get方法引用，用于匹配
     * @param getFnFrom   源类型对应匹配属性的get方法引用，用于匹配
     * @param getfnToList 目标类型对应源类型（或源父类型）的list属性的get方法引用，用于获取对应类型的list并加入匹配的源类型元素
     * @param <T1>        目标类型
     * @param <T2>        源类型
     * @param <T3>        源类型或其父类
     * @param <R>         匹配属性的类型
     * @param <C1>        目标类型list的类型
     * @param <C2>        源类型list的类型
     * @param <X>         目标类型对应源类型（或源父类型）的list属性的类型
     * @return 目标类型list
     */
    public static <T1, T2 extends T3, T3, R, C1 extends Collection<T1>
            , C2 extends Collection<T2>, X extends Collection<T3>> C1 matchSetCollectionMain(C1 toList, C2 fromList
            , GetterFunction<T1, R> getFnTo, GetterFunction<T3, R> getFnFrom, GetterFunction<T1, X> getfnToList) {
        Map<R, T1> indexMap = toCacheMap(toList, getFnTo);
        for (T2 t2 : fromList) {
            R r = getFnFrom.apply(t2);
            T1 t1 = indexMap.get(r);
            if (t1 != null) {
                X x = getfnToList.apply(t1);
                x.add(t2);
            }
        }
        return toList;
    }

    /**
     * 集合转缓存Map
     *
     * @param vList 集合
     * @param getFn 集合元素的父类的属性的getter方法引用
     * @param <K>   属性类型
     * @param <V>   集合元素类型
     * @param <X>   集合元素的父类
     * @param <Y>   集合类型
     * @return 缓存Map
     */
    public static <K, V extends X, X, Y extends Collection<V>> Map<K, V> toCacheMap(Y vList, GetterFunction<X, K> getFn) {
        int initialCapacity = (int) (vList.size() / 0.75) + 1;
        Map<K, V> cacheMap = new HashMap<>(Math.max(initialCapacity, 16));
        for (V v : vList) {
            K k = getFn.apply(v);
            cacheMap.put(k, v);
        }
        return cacheMap;
    }

    /**
     * 获取某对象集合中的某个属性的集合
     *
     * @param fromList 源对象集合
     * @param getFn    某属性的getter方法引用
     * @param <C>      集合类型定义
     * @param <T>      对象定义
     * @param <R>      属性定义
     * @return 属性集合
     */
    public static <C extends Collection<T>, T, R> List<R> getAttributes(C fromList, GetterFunction<T, R> getFn) {
        List<R> rList = new ArrayList<>(fromList.size());
        for (T t : fromList) {
            rList.add(getFn.apply(t));
        }
        return rList;
    }

    /**
     * 获取某对象集合中的某个属性的集合
     *
     * @param fromList 源对象集合
     * @param getFn    某属性的getter方法引用
     * @param <C>      集合类型定义
     * @param <T>      对象定义
     * @param <R>      属性定义
     * @return 属性集合
     */
    public static <C extends Collection<T>, T, R> List<R> getAttributesNoEmpty(C fromList, GetterFunction<T, R> getFn) {
        List<R> rList = new ArrayList<>(fromList.size());
        for (T t : fromList) {
            R r = getFn.apply(t);
            if (r != null && StringUtils.isNotBlank(r.toString())) {
                rList.add(r);
            }
        }
        return rList;
    }

    /**
     * 对象转Map
     *
     * @param map 目标map
     * @param t   对象
     * @param <T> 对象类型
     * @return map
     */
    public static <T> Map<String, Object> toMap(Map<String, Object> map, T t) {
        try {
            java.beans.BeanInfo beanInfo = Introspector.getBeanInfo(t.getClass());
            PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
            for (PropertyDescriptor property : propertyDescriptors) {
                String key = property.getName();
                if (!"class".equals(key)) {
                    Method readMethod = property.getReadMethod();
                    if (readMethod != null) {
                        Object value = readMethod.invoke(t);
                        if (value != null || map.get(key) == null) {
                            map.put(key, value);
                        }
                    }
                }
            }
            return map;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 对象转Map（key为大写加下划线）
     *
     * @param map 目标map
     * @param t   对象
     * @param <T> 对象类型
     * @return map
     */
    public static <T> Map<String, Object> toMapWithUpperName(Map<String, Object> map, T t) {
        try {
            java.beans.BeanInfo beanInfo = Introspector.getBeanInfo(t.getClass());
            PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
            for (PropertyDescriptor property : propertyDescriptors) {
                // 获得驼峰转大写加下划线后的属性名
                String key = MapUtil.upperScoreName(property.getName());
                Method readMethod = property.getReadMethod();
                if (readMethod != null) {
                    map.put(key, readMethod.invoke(t));
                }
            }
            return map;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 对象转Map
     *
     * @param map 目标map
     * @param t   对象
     * @param <T> 对象类型
     * @return map
     */
    @SafeVarargs
    public static <T, R> Map<String, Object> toMap(Map<String, Object> map, T t, GetterFunction<T, R>... fns) {
        for (GetterFunction<T, R> fn : fns) {
            map.put(fn.getLambadaInfo().getFieldName(), fn.apply(t));
        }
        return map;
    }

    /**
     * getter方法的函数式接口
     */
    @FunctionalInterface
    public interface GetterFunction<T, R> extends SerialFunction {
        R apply(T t);
    }

    /**
     * setter方法的函数式接口
     */
    @FunctionalInterface
    public interface SetterFunction<T, R> extends SerialFunction {
        void apply(T t, R r);
    }

    /**
     * setter方法的函数式接口(带返回值的)
     */
    @FunctionalInterface
    public interface SetterFunctionQ<T, R, Q> extends SerialFunction {
        Q apply(T t, R r);
    }

    /**
     * 方法的函数式接口
     */
    public interface BsFunction extends SerialFunction {
    }

    /**
     * 方法的函数式接口(不含参数的)
     */
    @FunctionalInterface
    public interface BsFunction0<T, R> extends BsFunction {
        R apply(T t);
    }

    /**
     * 方法的函数式接口(含1个参数的)
     */
    @FunctionalInterface
    public interface BsFunction1<T, R, A> extends BsFunction {
        R apply(T t, A a);
    }

    /**
     * 方法的函数式接口(含2个参数的)
     */
    @FunctionalInterface
    public interface BsFunction2<T, R, A, B> extends BsFunction {
        R apply(T t, A a, B b);
    }

    /**
     * 方法的函数式接口(含3个参数的)
     */
    @FunctionalInterface
    public interface BsFunction3<T, R, A, B, C> extends BsFunction {
        R apply(T t, A a, B b, C c);
    }

    /**
     * 方法的函数式接口(含4个参数的)
     */
    @FunctionalInterface
    public interface BsFunction4<T, R, A, B, C, D> extends BsFunction {
        R apply(T t, A a, B b, C c, D d);
    }

    // 信息缓存
    private static final Map<Class<?>, BeanInfo> BEAN_INFO_CACHE = new HashMap<>();
    private static SoftReference<Map<Class<? extends SerialFunction>, LambadaInfo>> LAMBADA_INFO_CACHE = new SoftReference<>(new HashMap<>());

    private static Map<Class<? extends SerialFunction>, LambadaInfo> getLambdaInfoCache() {
        Map<Class<? extends SerialFunction>, LambadaInfo> map = LAMBADA_INFO_CACHE.get();
        if (map == null) {
            synchronized (BeanUtil.class) {
                map = LAMBADA_INFO_CACHE.get();
                if (map == null) {
                    map = new HashMap<>();
                    LAMBADA_INFO_CACHE = new SoftReference<>(map);
                    map = LAMBADA_INFO_CACHE.get();
                }
            }
        }
        return map;
    }

    /**
     * 可序列化的函数式接口模板（非函数式接口）
     */
    private interface SerialFunction extends Serializable {

        /**
         * 这个方法返回的SerializedLambda是重点
         *
         * @return SerializedLambda
         */
        default LambadaInfo getLambadaInfo() {
            try {
                Class<? extends SerialFunction> clz = this.getClass();
                Map<Class<? extends SerialFunction>, LambadaInfo> lambdaInfoCache = getLambdaInfoCache();
                LambadaInfo lambadaInfo = lambdaInfoCache.get(clz);
                if (lambadaInfo == null) {
                    //noinspection SynchronizationOnLocalVariableOrMethodParameter
                    synchronized (clz) {
                        lambadaInfo = lambdaInfoCache.get(clz);
                        if (lambadaInfo == null) {
                            //通过函数式接口实例的writeReplace方法获取对应的SerializedLambda实例
                            Method write = this.getClass().getDeclaredMethod("writeReplace");
                            write.setAccessible(true);
                            SerializedLambda serializedLambda = (SerializedLambda) write.invoke(this);
                            Class<?> impClass = Class.forName(serializedLambda.getImplClass().replace("/", "."));
                            lambadaInfo = new LambadaInfo(impClass, serializedLambda.getImplMethodName());
                            lambdaInfoCache.put(clz, lambadaInfo);
                        }
                    }
                }
                return lambadaInfo;
            } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException | ClassNotFoundException e) {
                throw new RuntimeException(e);
            }
        }
    }

    public static class BeanInfo {
        /**
         * 所属类定义
         */
        private Class<?> implClass;
        /**
         * getter方法缓存
         */
        private final Map<String, Method> getterMap = new HashMap<>();
        /**
         * getter方法缓存
         */
        private final Map<String, Method> setterMap = new HashMap<>();

        public Class<?> getImplClass() {
            return implClass;
        }

        public void setImplClass(Class<?> implClass) {
            this.implClass = implClass;
        }

        public Map<String, Method> getGetterMap() {
            return getterMap;
        }

        public Map<String, Method> getSetterMap() {
            return setterMap;
        }
    }

    /**
     * 方法引用描述对象
     */
    public static class LambadaInfo {
        /**
         * 所属类定义
         */
        private final Class<?> implClass;
        /**
         * 具体引用方法名
         */
        private final String implMethodName;
        /**
         * 属性名（用于getter或setter方法引用的缓存）
         */
        private String fieldName;
        /**
         * 对应getter方法
         */
        private Method getter;
        /**
         * 对应setter方法
         */
        private Method setter;

        public LambadaInfo(Class<?> implClass, String implMethodName) {
            this.implClass = implClass;
            this.implMethodName = implMethodName;
        }

        public Class<?> getImplClass() {
            return implClass;
        }

        public String getImplMethodName() {
            return implMethodName;
        }

        /**
         * 获取属性名（getter或setter方法引用）
         *
         * @return 属性名, 不会为null，不存在为空字符串
         */
        public String getFieldName() {
            if (fieldName == null) {
                synchronized (this) {
                    if (fieldName == null) {
                        if (implMethodName.startsWith("get") || implMethodName.startsWith("set")) {
                            String fileName = implMethodName.substring(3);
                            this.fieldName = fileName.substring(0, 1).toLowerCase() + fileName.substring(1);
                        } else {
                            this.fieldName = "";
                        }
                    }
                }
            }
            return fieldName;
        }

        private BeanInfo getImplBeanInfo() {
            Class<?> implClass = this.getImplClass();
            BeanInfo beanInfo = BEAN_INFO_CACHE.get(implClass);
            if (beanInfo == null) {
                synchronized (this) {
                    beanInfo = BEAN_INFO_CACHE.get(implClass);
                    if (beanInfo == null) {
                        try {
                            beanInfo = new BeanInfo();
                            java.beans.BeanInfo beanInfo1 = Introspector.getBeanInfo(implClass);
                            PropertyDescriptor[] propertyDescriptors = beanInfo1.getPropertyDescriptors();
                            beanInfo.setImplClass(implClass);
                            for (PropertyDescriptor propertyDescriptor : propertyDescriptors) {
                                String fieldName = propertyDescriptor.getName();
                                Method readMethod = propertyDescriptor.getReadMethod();
                                if (readMethod != null) {
                                    beanInfo.getGetterMap().put(fieldName, readMethod);
                                }
                                Method writeMethod = propertyDescriptor.getWriteMethod();
                                if (writeMethod != null) {
                                    beanInfo.getSetterMap().put(fieldName, writeMethod);
                                }
                            }

                            BEAN_INFO_CACHE.put(implClass, beanInfo);
                        } catch (IntrospectionException e) {
                            throw new RuntimeException(e);
                        }
                    }
                }
            }
            return beanInfo;
        }

        public Method getGetter() {
            if (this.getter == null) {
                BeanInfo beanInfo = this.getImplBeanInfo();
                this.getter = beanInfo.getGetterMap().get(this.getFieldName());
            }
            return this.getter;
        }

        public Method getSetter() {
            if (this.setter == null) {
                BeanInfo beanInfo = this.getImplBeanInfo();
                this.setter = beanInfo.getSetterMap().get(this.getFieldName());
            }
            return this.setter;
        }
    }

}

