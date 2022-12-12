/*
 * Copyright(C) 2000-2011 THS Technology Limited Company, http://www.ths.com.cn
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ths.jdp.core.datasource;

import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

/**
 * @author jialin
 * @since 2016-7-13
 */
public class DynamicDataSource extends AbstractRoutingDataSource {

    private boolean debug = false;

    private Map<Object, Object> dynamicTargetDataSources;

    private Object dynamicDefaultTargetDataSource;

    /* (non-Javadoc)
     * @see org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource#determineCurrentLookupKey()
     */
    @Override
    protected Object determineCurrentLookupKey() {
        String datasource = DBContextHolder.getDataSource();

        if (debug) {
            if (StringUtils.isEmpty(datasource)) {
            	//System.out.println("---当前数据源：默认数据源---");
            } else {
                //System.out.println("---当前数据源：" + datasource + "---");
            }
        }

        return datasource;
    }

    @Override
    public void setTargetDataSources(Map<Object, Object> targetDataSources) {
        super.setTargetDataSources(targetDataSources);
        this.dynamicTargetDataSources = targetDataSources;
    }

    /**
     * Specify the default target DataSource, if any.
     * <p>The mapped value can either be a corresponding {@link javax.sql.DataSource}
     * instance or a data source name String (to be resolved via a
     * {@link #setDataSourceLookup DataSourceLookup}).
     * <p>This DataSource will be used as target if none of the keyed
     * {@link #setTargetDataSources targetDataSources} match the
     * {@link #determineCurrentLookupKey()} current lookup key.
     */
    public void setDefaultTargetDataSource(Object defaultTargetDataSource) {
        super.setDefaultTargetDataSource(defaultTargetDataSource);
        this.dynamicDefaultTargetDataSource = defaultTargetDataSource;
    }

    /**
     * @param debug the debug to set
     */
    public void setDebug(boolean debug) {
        this.debug = debug;
    }

    /**
     * @return the debug
     */
    public boolean isDebug() {
        return debug;
    }

    /**
     * @return the dynamicTargetDataSources
     */
    public Map<Object, Object> getDynamicTargetDataSources() {
        return dynamicTargetDataSources;
    }

    /**
     * @param dynamicTargetDataSources the dynamicTargetDataSources to set
     */
    public void setDynamicTargetDataSources(
            Map<Object, Object> dynamicTargetDataSources) {
        this.dynamicTargetDataSources = dynamicTargetDataSources;
    }

    /**
     * @return the dynamicDefaultTargetDataSource
     */
    public Object getDynamicDefaultTargetDataSource() {
        return dynamicDefaultTargetDataSource;
    }

    /**
     * @param dynamicDefaultTargetDataSource the dynamicDefaultTargetDataSource to set
     */
    public void setDynamicDefaultTargetDataSource(
            Object dynamicDefaultTargetDataSource) {
        this.dynamicDefaultTargetDataSource = dynamicDefaultTargetDataSource;
    }

}
