///*
// * Copyright(C) 2000-2011 THS Technology Limited Company, http://www.ths.com.cn
// *
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//package ths.project.dyh.equipment.web;
//
//import org.apache.commons.lang.StringUtils;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.ResponseBody;
//import org.springframework.web.servlet.ModelAndView;
//import ths.jdp.core.dao.base.Paging;
//import ths.jdp.core.model.FormModel;
//import ths.jdp.core.web.base.BaseController;
//import ths.project.common.data.DataResult;
//import ths.project.common.util.DateUtil;
//import ths.project.common.util.JsonUtil;
//import ths.project.common.util.ParamUtils;
//import ths.project.dyh.dataquery.service.AirMonitorService;
//import ths.project.system.file.service.CommFileService;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import java.io.*;
//import java.net.HttpURLConnection;
//import java.net.URL;
//import java.util.List;
//import java.util.Map;
//
///**
// * @author ZT
// * @since 2018-8-15
// */
//暂废弃
//@Controller
//@RequestMapping({"/dyh/equiment"})
//public class EquipmentController extends BaseController {
//
//    public String FILE_PATH = CommFileService.FILE_ROOT_PATH;
//
//    /**
//     * 从网络Url中下载文件
//     * @param fileName
//     * @throws IOException
//     */
//    @ResponseBody
//    @RequestMapping("/downLoadByUrl")
//    public  DataResult downLoadByUrl(String fileUrl, String ID, String suffix, String fileName) throws IOException {
//        //String urlStr="/api/web/getFileById/215608";
//        //http://172.25.80.134:9018/getFileById/215608
//        String urlStr=fileUrl+ID;
//        //String fileName="test.pdf";
//        String savePath=FILE_PATH;
//        URL url = new URL(urlStr);
//        HttpURLConnection conn = (HttpURLConnection)url.openConnection();
//        //设置超时间为3秒
//        conn.setConnectTimeout(5*1000);
//        //防止屏蔽程序抓取而返回403错误
//        conn.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 5.0; Windows NT; DigExt)");
//        //得到输入流
//        InputStream inputStream = conn.getInputStream();
//        //获取自己数组
//        byte[] getData = readInputStream(inputStream);
//        //文件保存位置
//        File saveDir = new File(savePath);
//        if(!saveDir.exists()){
//            saveDir.mkdir();
//        }
//        File file = new File(saveDir+File.separator+fileName);
//        FileOutputStream fos = new FileOutputStream(file);
//        fos.write(getData);
//        if(fos!=null){
//            fos.close();
//        }
//        if(inputStream!=null){
//            inputStream.close();
//        }
//        System.out.println("info:"+url+" download success");
//        System.out.println(saveDir+File.separator+fileName);
//        String saveUrl=(saveDir+File.separator+fileName).toString();
//       return DataResult.success("saverUrl:"+saveUrl+suffix);
//
//    }
//
//    /**
//     * 从输入流中获取字节数组
//     * @param inputStream
//     * @return
//     * @throws IOException
//     */
//    public static  byte[] readInputStream(InputStream inputStream) throws IOException {
//        byte[] buffer = new byte[1024];
//        int len = 0;
//        ByteArrayOutputStream bos = new ByteArrayOutputStream();
//        while((len = inputStream.read(buffer)) != -1) {
//            bos.write(buffer, 0, len);
//        }
//        bos.close();
//        return bos.toByteArray();
//    }
//
//
//}
