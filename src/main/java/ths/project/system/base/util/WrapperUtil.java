package ths.project.system.base.util;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.support.SFunction;

/**
 * mybatis-plus的wrapper相关操作的工具类
 */
public final class WrapperUtil {

    /**
     * 将某些值为null的字段，更新时设为null（mybatis-plus默认不更新值为null的字段）
     *
     * @param t             要更新的实体数据
     * @param updateWrapper 更新条件组装器
     * @param fns           需要判断并设为null的字段的方法引用
     * @param <T>           实体类型
     * @param <R>           字段类型
     */
    @SafeVarargs
    public static <T, R> LambdaUpdateWrapper<T> setUpdateNull(T t, LambdaUpdateWrapper<T> updateWrapper, SFunction<T, R>... fns) {
        for (SFunction<T, R> fn : fns) {
            if (fn.apply(t) == null) {
                updateWrapper.set(fn, null);
            }
        }
        return updateWrapper;
    }

    /**
     * 获取lambda字段数组
     *
     * @param fns lambda字段数组
     * @param <T> 实体类型
     * @param <R> 字段类型
     * @return lambda字段数组
     */
    @SafeVarargs
    public static <T, R> SFunction<T, R>[] getFns(SFunction<T, R>... fns) {
        return fns;
    }
}
