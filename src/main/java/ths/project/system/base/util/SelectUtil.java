package ths.project.system.base.util;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.core.toolkit.support.SFunction;

public final class SelectUtil {

    @SafeVarargs
    public final <X extends BaseMapper<T>, T, R> T select(X mapper, SFunction<T, R>[] fields, Object[] params, SFunction<T, R>... whereFields) {
        LambdaQueryWrapper<T> queryWrapper = Wrappers.lambdaQuery();
        if (fields != null && fields.length > 0) {
            queryWrapper.select(fields);
        }
        for (SFunction<T, R> whereField : whereFields) {
            queryWrapper.eq(whereField, fields);
        }
        return mapper.selectOne(queryWrapper);
    }

    @SafeVarargs
    public final <X extends BaseMapper<T>, T, R> T select(X mapper, Object[] params, SFunction<T, R>... whereFields) {
        return select(mapper, null, params, whereFields);
    }
}
