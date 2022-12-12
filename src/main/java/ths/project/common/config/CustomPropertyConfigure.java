package ths.project.common.config;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.EncodedResource;
import org.springframework.core.io.support.PropertiesLoaderUtils;

import java.util.Properties;

/**
 * 自定义spring变量配置类
 *
 * @author lym
 */
public class CustomPropertyConfigure extends ths.jdp.core.context.PropertyConfigure {

    /**
     * 资源文件编码
     */
    private String fileEncoding = null;

    /**
     * 资源文件路径数组
     */
    private String[] locationPaths = null;

    @Override
    protected void processProperties(ConfigurableListableBeanFactory beanFactory, Properties props) throws BeansException {

        String webContextPath = CustomWebConfigure.getContextPath();
        String realPath = CustomWebConfigure.getRealPath();
        props.put("web.context.path", webContextPath);
        props.put("web.context.real_path", realPath);
       
        if (locationPaths != null) {
            DefaultResourceLoader resourceLoader = new DefaultResourceLoader(this.getClass().getClassLoader());
            for (String locationPath : locationPaths) {
                try {
                    locationPath = locationPath.replaceAll("\\$\\{web.context.path}", webContextPath);
                    Resource resource = resourceLoader.getResource(locationPath);
                    if (resource != null && resource.exists()) {
                        System.out.println("加载全局配置文件:  " + resource.getURI().toString());
                        PropertiesLoaderUtils.fillProperties(props, new EncodedResource(resource, this.fileEncoding));
                    } else {
                        System.out.println("配置文件不存在:  " + locationPath);
                    }
                } catch (Exception e) {
                    throw new RuntimeException("配置文件加载出错！", e);
                }
            }
        }

        for (Object keyO : props.keySet()) {
            String key = (String) keyO;
            String value = props.getProperty(key);
            if (value != null) {
                if (value.contains("${web.context.real_path}")) {
                    props.setProperty(key, value.replace("${web.context.real_path}", realPath));
                }
                if (value.contains("${web.context.path}")) {
                    props.setProperty(key, value.replace("${web.context.path}", webContextPath));
                }
            }
        }

        super.processProperties(beanFactory, props);
    }

    /**
     * Set the encoding to use for parsing properties files.
     * <p>
     * Default is none, using the {@code java.util.Properties} default encoding.
     * <p>
     * Only applies to classic properties files, not to XML files.
     *
     * @see org.springframework.util.PropertiesPersister#load
     */
    @Override
    public void setFileEncoding(String encoding) {
        this.fileEncoding = encoding;
        super.setFileEncoding(encoding);
    }

    /**
     * Set locations of properties file paths to be loaded.
     * <p>
     * Can point to classic properties files or to XML files that follow JDK 1.5's properties XML format.
     * <p>
     * Note: Properties defined in later files will override properties defined earlier files, in case of overlapping keys. Hence, make sure that the most specific files are the last ones in the given list of locations.
     */
    public void setLocationPaths(String[] locationPaths) {
        this.locationPaths = locationPaths;
    }
}
