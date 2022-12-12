package ths.project.common.util;

import java.io.File;
import java.io.IOException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.config.Registry;
import org.apache.http.config.RegistryBuilder;
import org.apache.http.conn.socket.ConnectionSocketFactory;
import org.apache.http.conn.socket.PlainConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.TrustSelfSignedStrategy;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.DefaultHttpRequestRetryHandler;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.ssl.SSLContextBuilder;
import org.apache.http.util.EntityUtils;

public class HttpClientUtil {
    // utf-8字符编码
    public static final String CHARSET_UTF_8 = "utf-8";

    // HTTP内容类型。
    public static final String CONTENT_TYPE_TEXT_HTML = "text/xml";

    // HTTP内容类型。相当于form表单的形式，提交数据
    public static final String CONTENT_TYPE_FORM_URL = "application/x-www-form-urlencoded";

    // HTTP内容类型。相当于form表单的形式，提交数据
    public static final String CONTENT_TYPE_JSON_URL = "application/json;charset=utf-8";


    // 连接管理器
    private static final PoolingHttpClientConnectionManager pool;

    // 请求配置
    private static RequestConfig requestConfig;

    static {

        try {
            //System.out.println("初始化HttpClientTest~~~开始");
            SSLContextBuilder builder = new SSLContextBuilder();
            builder.loadTrustMaterial(null, new TrustSelfSignedStrategy());
            SSLConnectionSocketFactory sslsf = new SSLConnectionSocketFactory(
                    builder.build());
            // 配置同时支持 HTTP 和 HTPPS
            Registry<ConnectionSocketFactory> socketFactoryRegistry = RegistryBuilder.<ConnectionSocketFactory>create().register(
                    "http", PlainConnectionSocketFactory.getSocketFactory()).register(
                    "https", sslsf).build();
            // 初始化连接管理器
            pool = new PoolingHttpClientConnectionManager(
                    socketFactoryRegistry);
            // 将最大连接数增加到200，实际项目最好从配置文件中读取这个值
            pool.setMaxTotal(200);
            // 设置最大路由
            pool.setDefaultMaxPerRoute(2);
            // 根据默认超时限制初始化requestConfig
            int socketTimeout = 10000;
            int connectTimeout = 10000;
            int connectionRequestTimeout = 10000;
            requestConfig = RequestConfig.custom().setConnectionRequestTimeout(
                    connectionRequestTimeout).setSocketTimeout(socketTimeout).setConnectTimeout(
                    connectTimeout).build();

            //System.out.println("初始化HttpClientTest~~~结束");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        // 设置请求超时时间
        requestConfig = RequestConfig.custom().setSocketTimeout(50000).setConnectTimeout(50000)
                .setConnectionRequestTimeout(50000).build();
    }

    public static CloseableHttpClient getHttpClient() {

        CloseableHttpClient httpClient = HttpClients.custom()
                // 设置连接池管理
                .setConnectionManager(pool)
                // 设置请求配置
                .setDefaultRequestConfig(requestConfig)
                // 设置重试次数
                .setRetryHandler(new DefaultHttpRequestRetryHandler(0, false))
                .build();

        return httpClient;
    }

    /**
     * 发送Post请求
     *
     * @param httpPost 请求内容
     * @return 响应结果
     */
    public static String sendHttp(HttpUriRequest httpPost) {
        // 创建默认的httpClient实例
        CloseableHttpClient httpClient = getHttpClient();
        // 响应内容
        String responseContent = null;
        try (CloseableHttpResponse response = httpClient.execute(httpPost)) {
            // 得到响应实例
            HttpEntity entity = response.getEntity();

            // 可以获得响应头
            // Header[] headers = response.getHeaders(HttpHeaders.CONTENT_TYPE);
            // for (Header header : headers) {
            // System.out.println(header.getName());
            // }

            // 得到响应类型
            // System.out.println(ContentType.getOrDefault(response.getEntity()).getMimeType());

            // 判断响应状态
            if (response.getStatusLine().getStatusCode() >= 300) {
                throw new IOException("HTTP Request is not success, Response code is " + response.getStatusLine().getStatusCode());
            }

            if (HttpStatus.SC_OK == response.getStatusLine().getStatusCode()) {
                responseContent = EntityUtils.toString(entity, CHARSET_UTF_8);
                EntityUtils.consume(entity);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return responseContent;
    }

    /**
     * 发送 post请求
     *
     * @param httpUrl 地址
     */
    public static String sendHttpPost(String httpUrl) {
        // 创建httpPost
        HttpPost httpPost = new HttpPost(httpUrl);
        return sendHttp(httpPost);
    }

    /**
     * 发送 get请求
     *
     * @param httpUrl
     */
    public static String sendHttpGet(String httpUrl) throws IOException {
        // 创建get请求
        HttpGet httpGet = new HttpGet(httpUrl);
        return sendHttp(httpGet);
    }

    /**
     * 发送 post请求
     *
     * @param httpUrl  地址
     * @param paramStr 参数(格式:key1=value1&key2=value2)
     */
    public static String sendHttpPost(String httpUrl, String paramStr) {
        HttpPost httpPost = new HttpPost(httpUrl);// 创建httpPost
        // 设置参数
        if (paramStr != null && paramStr.trim().length() > 0) {
            StringEntity stringEntity = new StringEntity(paramStr, "UTF-8");
            stringEntity.setContentType(CONTENT_TYPE_FORM_URL);
            httpPost.setEntity(stringEntity);
        }
        return sendHttp(httpPost);
    }

    /**
     * 发送 post请求
     *
     * @param params 参数
     */
    public static String sendHttpPost(String httpUrl, Map<String, String> params) {
        String paramStr = convertStringParamter(params);
        return sendHttpPost(httpUrl, paramStr);
    }


    /**
     * 发送 post请求 发送json数据
     *
     * @param httpUrl    地址
     * @param paramsJson 参数(格式 json)
     */
    public static String sendHttpPostJson(String httpUrl, String paramsJson) {
        // 创建httpPost
        HttpPost httpPost = new HttpPost(httpUrl);
        // 设置参数
        if (paramsJson != null && paramsJson.trim().length() > 0) {
            StringEntity stringEntity = new StringEntity(paramsJson, "UTF-8");
            stringEntity.setContentType(CONTENT_TYPE_JSON_URL);
            httpPost.setEntity(stringEntity);
        }
        return sendHttp(httpPost);
    }

    /**
     * 发送 post请求 发送xml数据
     *
     * @param httpUrl   地址
     * @param paramsXml 参数(格式 Xml)
     */
    public static String sendHttpPostXml(String httpUrl, String paramsXml) {
        HttpPost httpPost = new HttpPost(httpUrl);// 创建httpPost
        // 设置参数
        if (paramsXml != null && paramsXml.trim().length() > 0) {
            StringEntity stringEntity = new StringEntity(paramsXml, "UTF-8");
            stringEntity.setContentType(CONTENT_TYPE_TEXT_HTML);
            httpPost.setEntity(stringEntity);
        }
        return sendHttp(httpPost);
    }


    /**
     * 将map集合的键值对转化成：key1=value1&key2=value2 的形式
     *
     * @param parameterMap 需要转化的键值对集合
     * @return 字符串
     */
    public static String convertStringParamter(Map<String, String> parameterMap) {
        StringBuilder parameterBuffer = new StringBuilder();
        if (parameterMap != null) {
            Iterator<String> iterator = parameterMap.keySet().iterator();
            while (iterator.hasNext()) {
                String key = iterator.next();
                parameterBuffer.append(key).append("=")
                        .append(parameterMap.get(key) != null ? parameterMap.get(key) : "");
                if (iterator.hasNext()) {
                    parameterBuffer.append("&");
                }
            }
        }
        return parameterBuffer.toString();
    }
}

