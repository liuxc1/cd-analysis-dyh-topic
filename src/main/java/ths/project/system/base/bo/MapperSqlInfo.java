package ths.project.system.base.bo;

import ths.project.common.util.DateUtil;

import java.util.Arrays;
import java.util.Date;
import java.util.regex.Matcher;

/**
 * mybatis的sql及参数信息
 *
 * @author lym
 */
public class MapperSqlInfo {

    String sql = null;
    Object[] params = null;

    public String getSql() {
        return sql;
    }

    public void setSql(String sql) {
        this.sql = sql;
    }

    public Object[] getParams() {
        return params;
    }

    public void setParams(Object[] params) {
        this.params = params;
    }

    public String getWrapperWhereSql() {
        String sql = this.sql;
        if (sql != null && params != null) {
            for (int i = 0; i < this.params.length; i++) {
                sql = sql.replaceFirst("\\?", "{" + i + "}");
            }
        }
        return sql;
    }

    public String getParseSql() {
        String sql = this.sql;
        if (sql != null && params != null) {
            for (Object param : this.params) {
                if (param instanceof Date) {
                    sql = sql.replaceFirst("\\?", "'" + DateUtil.formatDateTime((Date) param) + "'");
                } else {
                    sql = sql.replaceFirst("\\?", Matcher.quoteReplacement("'" + param + "'"));
                }
            }
        }
        return sql;
    }

    @Override
    public String toString() {
        return "MapperSqlInfo [sql=" + sql + ", params=" + Arrays.toString(params) + "]";
    }
}
