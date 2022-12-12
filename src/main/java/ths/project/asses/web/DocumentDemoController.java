package ths.project.asses.web;

import com.deepoove.poi.XWPFTemplate;
import com.deepoove.poi.util.PoitlIOUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.custom.util.res.Path;
import ths.jdp.eform.service.components.word.*;
import ths.project.common.util.ExcelUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class DocumentDemoController {

    private static String getFilePath(String fileName) throws UnsupportedEncodingException {
        String root = ExcelUtil.class.getResource("/").getPath();
        if (root.indexOf("target") >= 0) {
            root = root.substring(1, root.indexOf("target"));
            root = root.replaceAll("/", "\\\\");
            root = root + "src\\main\\webapp" + File.separator + "assets" + File.separator + "template" + File.separator + fileName;
        } else {
            root = root.substring(1, root.indexOf("WEB-INF"));
            root = root.replaceAll("/", "\\\\");
            root = root + "assets" + File.separator + "template" + File.separator + fileName;
        }

        return URLDecoder.decode(root, "GBK");
    }



    /**
     * 导出word文件，支持插入图片、转换为PDF、及上下标转换
     *
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/exportWord1")
    @ResponseBody
    public void exportWord1(HttpServletRequest request, HttpServletResponse response) throws Exception {

        //定义模板路径和名称
        String fileName = "环境违法行为调查报告";
        String templatePath = getFilePath("DCBG.doc");
        DocumentPage page = new DocumentPage();
        //定义Word模板参数替换的map
        Map<String, Object> paramDataMap = new HashMap<String, Object>();
        paramDataMap.put("DCID", "201700001");
        paramDataMap.put("ANYOU", "随地大小便");
        paramDataMap.put("UNITNAME", "张三");
        paramDataMap.put("UNITZIPCODE", "");
        paramDataMap.put("MAINID", "100000000000000000");
        paramDataMap.put("CORPORATECODE", "");
        paramDataMap.put("UNITADDRESS", "北京市海淀区");
        paramDataMap.put("CORPORATEMAN", "");
        paramDataMap.put("PARTYPHONE", "");
        paramDataMap.put("PROCESSDESC", "2017年1月1日，经调查发现，张三同志的大小便痕迹仍然清晰可见，有现场照片证明！经检测现场面积为5m2,PM2.5超标,以及SO2浓度过高。");
        paramDataMap.put("CASEMEMO", "因现场发现SO2过高，O2浓度较低，以不适合生存，罚款1000元");
        paramDataMap.put("RESEARCH", "张四");
        paramDataMap.put("RESEARCHTIME", "2017年1月1日");
        paramDataMap.put("CHECKCONTENT", "同意处罚");
        paramDataMap.put("CHECKMAN", "张大");
        paramDataMap.put("CHECKTIME", "2017年1月1日");
        page.setParamMap(paramDataMap);

        //封装文档体中需要插入的图片，集合中存放的是图片对象
        List<DocImage> imageList = new ArrayList<DocImage>();
        String imgPath = getFilePath("evidence.jpg");

        //图片对象构造方法有多个重载，本例中使用的构造方法有3个参数，分别为图片路径，长，宽
        DocImage img1 = new DocImage(imgPath, null, 100.0);
        imageList.add(img1);
//        page.getImages().put("img1", imageList);

        /*需要处理的上下标开始，参数封装的顺序，例如PM2.5和M2，因为两个指标有重合的地方，且上下标类型不同，因此要先封装PM2.5，再封装M2*/
        /*动态表格中的下标处理逻辑与此相同，只要是文档中涉及到的下标，都封装在DocumentPage对象中*/
        //下标一
        DocSuperAndSub docSub1 = new DocSuperAndSub();
        docSub1.setAllWord("PM2.5");
        docSub1.setBaseWord("PM");
        docSub1.setSubscript("2.5");
        page.getSuperAndSubs().add(docSub1);
        //下标2
        DocSuperAndSub docSub2 = new DocSuperAndSub();
        docSub2.setAllWord("CO2");
        docSub2.setBaseWord("CO");
        docSub2.setSubscript("2");
        page.getSuperAndSubs().add(docSub2);
        //下标3
        DocSuperAndSub docSub3 = new DocSuperAndSub();
        docSub3.setAllWord("O2");
        docSub3.setBaseWord("O");
        docSub3.setSubscript("2");
        page.getSuperAndSubs().add(docSub3);
        //上标1
        DocSuperAndSub docSuper1 = new DocSuperAndSub();
        docSuper1.setAllWord("m2");
        docSuper1.setBaseWord("m");
        docSuper1.setSuperscript("2");
        page.getSuperAndSubs().add(docSuper1);
        /*需要处理的上下标结束*/

        //生成的文档如果需要在浏览器中直接打开，则启用下面配置（目前仅支持生成pdf的情况）
        //page.setOnlineBrowse(true);

        RepDocTemplate doc = new RepDocTemplate();
        //如果需要将word转为pdf,将下面参数false改为true
        doc.exportWord(page, null, null, fileName, templatePath, false, request, response);
    }

    /**
     * 导出动态表格，支持标题折行
     *
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/exportWord2")
    @ResponseBody
    public void exportWord2(HttpServletRequest request, HttpServletResponse response) throws Exception {
        //定义模板路径和名称
        String fileName = "查封扣押清单";
        String templatePath = Path.CONF_PATH + File.separator + "eform" + File.separator + "word" + File.separator + "CFKYQD.doc";

        DocumentPage page = new DocumentPage();
        //定义Word模板参数替换的map
        Map<String, Object> paramDataMap = new HashMap<String, Object>();
        paramDataMap.put("UNITNAME", "XXX市环保局");
        paramDataMap.put("SIGN_NAME", "张大饼");
        paramDataMap.put("SIGN_DATE", "2017年9月26日");
        //表格标题行的参数也放进该map中
        paramDataMap.put("MODEL", "型号");
        page.setParamMap(paramDataMap);

        //定义Word模板动态表格替换的map
        Map<String, DocDynamicTable> paramDynamicTableMap = new HashMap<String, DocDynamicTable>();

        //构造动态表格,封装动态单表的数据
        DocDynamicTable dynamicTable = new DocDynamicTable();
        DocDynamicTable.InnerDocTable docTable = dynamicTable.getDocTable();

        //设置动态数据的开始行，参数为数组，值为数据行的首行序号（从1开始），如果标题行存在折行，则数组值为多个
        docTable.setDataRowStarts(new int[]{2, 4});

        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("CF_NAME", "锅炉");
        map1.put("CF_AMOUNT", 1);
        map1.put("CF_MODEL", "大锅炉");
        map1.put("CF_VENDER", "");
        map1.put("CF_PRODUCEDATE", "");
        map1.put("CF_ADDRESS", "北京市");
        map1.put("CF_DEP", "80%");
        docTable.addRow(map1);

        Map<String, Object> map2 = new HashMap<String, Object>();
        map2.put("CF_NAME", "机床");
        map2.put("CF_AMOUNT", 1);
        map2.put("CF_MODEL", "沈阳造");
        map2.put("CF_VENDER", "");
        map2.put("CF_PRODUCEDATE", "2010-8-8");
        map2.put("CF_ADDRESS", "北京市");
        map2.put("CF_DEP", "60%");
        docTable.addRow(map2);

        Map<String, Object> map3 = new HashMap<String, Object>();
        map3.put("CF_NAME", "煤球");
        map3.put("CF_AMOUNT", "一车");
        map3.put("CF_MODEL", "蜂窝煤");
        map3.put("CF_VENDER", "");
        map3.put("CF_PRODUCEDATE", "年前");
        map3.put("CF_ADDRESS", "北京市");
        map3.put("CF_DEP", "50%");
        docTable.addRow(map3);
        //把动态表格放到全局表格map中
        paramDynamicTableMap.put("CFKYLIST", dynamicTable);

        RepDocTemplate doc = new RepDocTemplate();
        doc.exportWord(page, paramDynamicTableMap, null, fileName, templatePath, false, request, response);

    }

    /**
     * 导出动态表格，支持合并行
     *
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/exportWord3")
    @ResponseBody
    public void exportWord3(HttpServletRequest request, HttpServletResponse response) throws Exception {

        //设置导出word的名称
        String fileName = "仪器设备（标准物质）配置表";
        //设置模板全路径
        String templatePath = Path.CONF_PATH + File.separator + "eform" + File.separator + "word" + File.separator + "YQSB.doc";

        //设置页面参数及页面属性
        DocumentPage page = new DocumentPage();
        Map<String, Object> paraMap = new HashMap<String, Object>();
        paraMap.put("address", "河南");
        page.setParamMap(paraMap);

        //定义Word模板动态表格替换的map
        Map<String, DocDynamicTable> paramDynamicTableMap = new HashMap<String, DocDynamicTable>();
        //构造动态表格,封装动态单表的数据
        DocDynamicTable dynamicTable = new DocDynamicTable();
        DocDynamicTable.InnerDocTable docTable = dynamicTable.getDocTable();

        //设置动态数据开始开始行
        docTable.setDataRowStarts(new int[]{3});

        //设置数据合并列，参数为数组，值为需要进行行合并的列号（从1开始）
        docTable.setMergeColumns(new int[]{1, 2, 4, 5});

        Map<String, Object> map1 = new HashMap<String, Object>();
        map1.put("id", "1");
        map1.put("category", "类别1");
        map1.put("name", "小米");
        map1.put("standard", "优良");
        docTable.addRow(map1);
        Map<String, Object> map2 = new HashMap<String, Object>();
        map2.put("id", "1");
        map2.put("category", "类别1");
        map2.put("name", "小米");
        map2.put("standard", "优良");
        docTable.addRow(map2);
        Map<String, Object> map3 = new HashMap<String, Object>();
        map3.put("id", "2");
        map3.put("category", "类别2");
        map3.put("name", "糯米");
        map3.put("standard", "优良");
        docTable.addRow(map3);
        Map<String, Object> map4 = new HashMap<String, Object>();
        map4.put("id", "2");
        map4.put("category", "类别2");
        map4.put("name", "糯米");
        map4.put("standard", "优良");
        docTable.addRow(map4);
        paramDynamicTableMap.put("YQSB", dynamicTable);

        RepDocTemplate doc = new RepDocTemplate();
        doc.exportWord(null, paramDynamicTableMap, null, fileName, templatePath, false, request, response);
    }

    /**
     * 导出循环动态表格
     *
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping("/exportWord4")
    @ResponseBody
    public void exportWord4(HttpServletRequest request, HttpServletResponse response) throws Exception {

        //设置导出word的名称
        String fileName = "仪器设备（标准物质）配置表";
        //设置父、子模版的全路径
        String parentPath = Path.CONF_PATH + File.separator + "eform" + File.separator + "word" + File.separator + "CIRCLE_PARENT.doc";
        String childPath = Path.CONF_PATH + File.separator + "eform" + File.separator + "word" + File.separator + "CIRCLE_CHILD.doc";

        //定义Word模板动态表格替换的map
        Map<String, DocDynamicTable> paramDynamicTableMap = new HashMap<String, DocDynamicTable>();
        //封装循环动态表的数据
        DocDynamicTable cycleTable = new DocDynamicTable();

        //生成第一个单表
        DocComplexTable complexTable1 = cycleTable.getMultiTable().newDocComplexTable();
        Map<String, Object> map4 = new HashMap<String, Object>();
        map4.put("address", "河南");
        complexTable1.setParamMap(map4);
        DocTable docTable1 = new DocTable();
        /*设置第一个单表开始*/
        //设置数据开始开始行
        docTable1.setDataRowStarts(new int[]{3});
        //设置数据合并列
        docTable1.setMergeColumns(new int[]{1, 2, 4, 5});
        Map<String, Object> map41 = new HashMap<String, Object>();
        map41.put("id", "1");
        map41.put("category", "类别1");
        map41.put("name", "小米");
        map41.put("standard", "优良");
        docTable1.addRow(map41);
        Map<String, Object> map42 = new HashMap<String, Object>();
        map42.put("id", "1");
        map42.put("category", "类别1");
        map42.put("name", "小米");
        map42.put("standard", "优良");
        docTable1.addRow(map42);
        Map<String, Object> map43 = new HashMap<String, Object>();
        map43.put("id", "2");
        map43.put("category", "类别2");
        map43.put("name", "糯米");
        map43.put("standard", "优良");
        docTable1.addRow(map43);
        Map<String, Object> map44 = new HashMap<String, Object>();
        map44.put("id", "2");
        map44.put("category", "类别2");
        map44.put("name", "糯米");
        map44.put("standard", "优良");
        docTable1.addRow(map43);
        complexTable1.getInnerTableMap().put("CKLIST", docTable1);
        /*设置第一个单表结束*/

        //生成第二个单表
        DocComplexTable complexTable2 = cycleTable.getMultiTable().newDocComplexTable();
        Map<String, Object> map5 = new HashMap<String, Object>();
        map5.put("address", "河北");
        complexTable2.setParamMap(map5);
        DocTable docTable2 = new DocTable();
        /*设置第二个单表开始*/
        //设置数据开始行
        docTable2.setDataRowStarts(new int[]{3});
        Map<String, Object> map51 = new HashMap<String, Object>();
        map51.put("id", "1");
        map51.put("category", "类别1");
        map51.put("name", "大米");
        map51.put("standard", "优良");
        docTable2.addRow(map51);
        Map<String, Object> map52 = new HashMap<String, Object>();
        map52.put("id", "2");
        map52.put("category", "类别2");
        map52.put("name", "小米");
        map52.put("standard", "优良");
        docTable2.addRow(map52);
        Map<String, Object> map53 = new HashMap<String, Object>();
        map53.put("id", "3");
        map53.put("category", "类别3");
        map53.put("name", "糯米");
        map53.put("standard", "优良");
        docTable2.addRow(map53);
        complexTable2.getInnerTableMap().put("CKLIST", docTable2);
        /*设置第二个单表开始*/

        //设置子模板全路径
        cycleTable.getMultiTable().setModelPath(childPath);
        //将动态多表放入全局表格map中
        paramDynamicTableMap.put("child", cycleTable);

        //父模板中循环表格所在位置的书签名称
        List<String> bookmarks = new ArrayList<String>();
        bookmarks.add("child");

        RepDocTemplate doc = new RepDocTemplate();
        doc.exportWord(null, paramDynamicTableMap, bookmarks, fileName, parentPath, false, request, response);
    }
}
