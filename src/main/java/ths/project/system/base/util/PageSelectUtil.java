package ths.project.system.base.util;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.github.pagehelper.PageHelper;
import ths.jdp.core.dao.base.Paging;
import ths.project.common.util.BeanUtil;

import java.util.List;

public final class PageSelectUtil {
    /**
     * 分页查询
     *
     * @param mapper   数据层
     * @param pageInfo 分页参数
     * @param wrapper  查询条件
     * @return 分页查询结果
     */
    public static <M extends BaseMapper<T>, T> Paging<T> selectListPage(M mapper, Paging<T> pageInfo, Wrapper<T> wrapper) {
        return selectListPage(pageInfo, () -> mapper.selectList(wrapper));
    }

    /**
     * 分页查询
     *
     * @param pageInfo       分页参数
     * @param selectCallback 列表查询回调
     * @return 分页查询结果
     */
    public static <M, T, K> Paging<K> selectListPage(Paging<K> pageInfo, SelectCallback<K> selectCallback) {
        try {
            PageHelper.startPage(pageInfo.getPageNum(), pageInfo.getPageSize(), pageInfo.getOrderBy());
            List<K> list = selectCallback.callback();
            return new Paging<>(list, pageInfo.getNavigatePages());
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            PageHelper.clearPage();
        }
    }

    /**
     * 分页查询
     *
     * @param mapper   数据层对象
     * @param pageInfo 分页参数
     * @param fn       操作
     * @param a        操作参数1
     * @return 分页查询结果
     */
    public static <M, T, K, A> Paging<K> selectListPage1(M mapper, Paging<K> pageInfo
            , BeanUtil.BsFunction1<M, List<K>, A> fn, A a) {
        return selectListPage(pageInfo, () -> fn.apply(mapper, a));
    }

    /**
     * 分页查询
     *
     * @param mapper   数据层对象
     * @param pageInfo 分页参数
     * @param fn       操作
     * @param a        操作参数1
     * @param b        操作参数2
     * @return 分页查询结果
     */
    public static <M, T, K, A, B> Paging<K> selectListPage2(M mapper, Paging<K> pageInfo
            , BeanUtil.BsFunction2<M, List<K>, A, B> fn, A a, B b) {
        return selectListPage(pageInfo, () -> fn.apply(mapper, a, b));
    }

    /**
     * 分页查询
     *
     * @param mapper   数据层对象
     * @param pageInfo 分页参数
     * @param fn       操作
     * @param a        操作参数1
     * @param b        操作参数2
     * @param c        操作参数3
     * @return 分页查询结果
     */
    public static <M, T, K, A, B, C> Paging<K> selectListPage3(M mapper, Paging<K> pageInfo
            , BeanUtil.BsFunction3<M, List<K>, A, B, C> fn, A a, B b, C c) {
        return selectListPage(pageInfo, () -> fn.apply(mapper, a, b, c));
    }

    /**
     * 分页查询
     *
     * @param mapper   数据层对象
     * @param pageInfo 分页参数
     * @param fn       操作
     * @param a        操作参数1
     * @param b        操作参数2
     * @param c        操作参数3
     * @param d        操作参数4
     * @return 分页查询结果
     */
    public static <M, T, K, A, B, C, D> Paging<K> selectListPage4(M mapper, Paging<K> pageInfo
            , BeanUtil.BsFunction4<M, List<K>, A, B, C, D> fn, A a, B b, C c, D d) {
        return selectListPage(pageInfo, () -> fn.apply(mapper, a, b, c, d));
    }

    @FunctionalInterface
    public interface SelectCallback<K> {
        List<K> callback();
    }
}
