package ths.project.dingding;

import com.alibaba.fastjson.JSONArray;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;

/**
 * @ClassName testMain11
 * @Description TODO
 * @Author ZT
 * @Date 2021/11/24 13:34
 * @Version 1.0
 **/
public class DingDingMain {

    static String getTokenUrl = "https://oapi.dingtalk.com/gettoken";
    static String appKey = "dingv61s5jtimm0ukcwu";
    static String appSecret = "Y3iADYwz70DGAO6sfuBLtjugEmtHiv963qS5nwI8EYk3SsgVHOqvnH4lXQ8cGSpq";
    static String getJsapiTicketUrl = "https://oapi.dingtalk.com/get_jsapi_ticket";
    static String agentId = "1376501201";
    static String corpId = "ding9504e0e12ed892d424f2f5cc6abecb85";




    public static String getAccessToken() {
        List<NameValuePair> kvList = new ArrayList<NameValuePair>();
        kvList.add(new BasicNameValuePair("appkey", appKey));
        kvList.add(new BasicNameValuePair("appsecret", appSecret));
        String resMsg = httpGet(getTokenUrl, kvList);
        String accessToken = JSONArray.parseObject(resMsg).get("access_token").toString();
        return accessToken;
    }

    public static String getJsapiTicket( ) {
        String access_token = getAccessToken();
        List<NameValuePair> kvList = new ArrayList<NameValuePair>();
        kvList.add(new BasicNameValuePair("access_token", access_token));
        String resMsg = httpGet(getJsapiTicketUrl, kvList);
        String jsapiTicket = JSONArray.parseObject(resMsg).get("ticket").toString();
        return jsapiTicket;
    }

    public static String httpGet(String urlPath, List<NameValuePair> params) {
        CloseableHttpClient httpClient = HttpClientBuilder.create().build();
        CloseableHttpResponse response = null;
        try {
            URI url = new URIBuilder().setPath(urlPath).setParameters(params).build();
            HttpGet httpGet = new HttpGet(url);
            response = httpClient.execute(httpGet);
            HttpEntity responseEntity = response.getEntity();
            System.out.println("响应状态为:" + response.getStatusLine());
            if (responseEntity != null) {
                System.out.println("响应内容长度为:" + responseEntity.getContentLength());
                String result = EntityUtils.toString(responseEntity, "UTF-8");
                System.out.println("响应内容为:" + result);
                return result;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                // 释放资源
                if (httpClient != null) {
                    httpClient.close();
                }
                if (response != null) {
                    response.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }


}
