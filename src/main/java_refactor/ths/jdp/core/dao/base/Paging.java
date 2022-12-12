package ths.jdp.core.dao.base;

import java.util.List;


/**
 * @author 王明力
 * @Description: TODO
 * @date 2016-8-2 上午10:24:57
 */
public class Paging<T> extends com.github.pagehelper.PageInfo<T> {

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    /**
     * 兼容旧版代码，但为实现旧版功能
     */
    private String orderBy;

    public Paging() {
        super();
    }

    public Paging(int pageNum, int pageSize) {
        super();
        super.setPageNum(pageNum);
        super.setPageSize(pageSize);
    }

    public Paging(List<T> list) {
        super(list, 8);
    }

    public Paging(List<T> list, int navigatePages) {
        super(list, navigatePages);
    }

    @Override
    public int getPageNum() {
        if (super.getPageNum() <= 0)
            super.setPageNum(1);
        return super.getPageNum();
    }

    @Override
    public int getPageSize() {
        if (super.getPageSize() <= 0)
            super.setPageSize(10);
        return super.getPageSize();
    }

    @Override
    public int getNavigatePages() {
        if (super.getNavigatePages() <= 0)
            super.setNavigatePages(8);
        return super.getNavigatePages();
    }

    /**
     * @return 当前页第一条
     */
    public int getFirst() {
        return ((super.getPageNum() - 1) * super.getPageSize()) + 1;
    }

    public String getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }
}
