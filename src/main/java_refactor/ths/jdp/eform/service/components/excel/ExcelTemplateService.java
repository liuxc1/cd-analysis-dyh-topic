package ths.jdp.eform.service.components.excel;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.poi.ss.usermodel.DataValidation;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.context.SpringContextHelper;
import ths.jdp.core.datasource.DBContextHolder;
import ths.jdp.eform.service.EformService;
import ths.jdp.eform.service.components.excel.model.ImportCallbackProp;
import ths.jdp.eform.service.settings.dictionary.DictionaryUtils;
import ths.jdp.eform.web.common.EformCommonService;
import ths.jdp.util.SqlUtils;
import ths.jdp.util.Tool;

/**
 * @author
 * @Description: TODO
 * @date 2016-7-27 上午10:47:01
 */
@Service
public class ExcelTemplateService extends EformService {
    protected final Logger log = LoggerFactory.getLogger(this.getClass());
    @Autowired
    private EformCommonService eformCommonService;

    public static Workbook readWorkBook(String path) {
        try {
            return WorkbookFactory.create(new FileInputStream(new File(path)));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 处理Excel模板中的下拉选项
     *
     * @param workbook
     * @param sheetname
     * @param desigerid
     * @param startrow_int
     */
    public void handleExcelTemplate(Workbook workbook, String sheetname, String desigerid, int startrow_int) {
        Map<String, List<Map<String, String>>> sql_dictionarys_map = DictionaryUtils.getSqlDictionarys();
        Map<String, List<Map<String, String>>> dictionarys_map = DictionaryUtils.getDictionarys();
        //读取已经有的模板
        Sheet sheet = workbook.getSheet(sheetname);
        List<DataValidation> dataValidations = new ArrayList<DataValidation>();

        Map<String, Object> key_map = new HashMap<String, Object>();
        key_map.put("DESIGERID", desigerid);
        //在模板中添加下拉项目
        List<Map<String, Object>> excelfields = super.getListFromTable("JDP_EFORM_EXCELFIELDS", key_map,
                Arrays.asList("SHEETCOLNUM"));
        for (int i = 0; i < excelfields.size(); i++) {
            String outtransform = String.valueOf(excelfields.get(i).get("OUTTRANSFORM"));
            int sheetcolnum = Integer.parseInt(String.valueOf(excelfields.get(i).get("SHEETCOLNUM")));
            if (!Tool.isNull(outtransform)) {
                List<Map<String, String>> dictionarys = eformCommonService.getDictionarysByTreeId(outtransform,
                        dictionarys_map, sql_dictionarys_map, null);
                if (dictionarys != null && dictionarys.size() > 0) {
                    String[] dataGroup = new String[dictionarys.size()];
                    for (int d = 0; d < dictionarys.size(); d++) {
                        dataGroup[d] = dictionarys.get(d).get("dictionary_name");
                    }
                    dataValidations.add(ExcelTemplateUtils.setDropSelect(sheet, dataGroup, startrow_int, 1000,
                            sheetcolnum, sheetcolnum));
                }
            }
        }
        ExcelTemplateUtils.rewriteExcelTempAtEmp(workbook, sheet, dataValidations);
    }

    /**
     * 解析Excel文件，生成sql语句
     *
     * @throws IOException
     * @throws ClassNotFoundException
     */
    public ExcelProp parseExcelData(String filepath, String desigerid, Map<String, Object> variables) throws Exception {
        ExcelProp excelProp = new ExcelProp();
        excelProp.setChecked(true);
        Map<String, List<Map<String, String>>> sql_dictionarys_map = DictionaryUtils.getSqlDictionarys();
        Map<String, List<Map<String, String>>> dictionarys_map = DictionaryUtils.getDictionarys();
        Map<String, Map<String, String>> repeatMap = new HashMap<String, Map<String, String>>();//重复数据的map
        String dialet = DBContextHolder.getDialet();
        Workbook workbook;
        try {
            workbook = readWorkBook(filepath);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        //①验证解析文件是否成功
        if (workbook == null) {
            excelProp.setChecked(false);
            excelProp.setErrorMessage("文件[" + filepath + "],解析失败");
            return excelProp;
        }

        List<String> desigerid_list = new ArrayList<String>();
        if (!Tool.isNull(desigerid)) {
            desigerid_list = Arrays.asList(desigerid.split(","));
        }
        String desiger_sql = "'NA'";
        for (int i = 0; i < desigerid_list.size(); i++) {
            desiger_sql = desiger_sql + ",'" + StringEscapeUtils.escapeSql(desigerid_list.get(i)) + "'";
        }

        //②验证多个sheet是否在同一个Excel中、模板中要求的sheetname是否存在
        List<Map<String, Object>> data_list = super.getListFromSql(
                "select * from jdp_eform_excelsheets where desigerid in (" + desiger_sql + ")");
        //TODO:解决postGress返回小写字段的问题
        data_list = transListMapKey(data_list);
        Map<String, List<Map<String, Object>>> allFiledMap = new HashMap<String, List<Map<String, Object>>>();
        if (data_list == null || data_list.size() == 0) {
            excelProp.setChecked(false);
            excelProp.setErrorMessage("未查找到desigerid【" + desigerid + "】配置的sheet.");
            return excelProp;
        }
        String excelname = String.valueOf(data_list.get(0).get("EXCELNAME"));
        for (int i = 0; i < data_list.size(); i++) {
            //验证excelName是否一致
            if (!excelname.equalsIgnoreCase(String.valueOf(data_list.get(i).get("EXCELNAME")))) {
                excelProp.setChecked(false);
                excelProp.setErrorMessage(
                        "[" + excelname + "]和[" + String.valueOf(data_list.get(i).get("EXCELNAME")) + "]不是同一个Excel ");
                return excelProp;
            }
            //验证sheetName是否存在。
            String sheetname = String.valueOf(data_list.get(i).get("SHEETNAME"));
            Sheet sheet = workbook.getSheet(sheetname);
            if (sheet == null) {
                excelProp.setChecked(false);
                excelProp.setErrorMessage("SHEETNAME[" + sheetname + "]没有在Excel中 ");
                return excelProp;
            }
        }

        //解析excel，返回sql语句
        for (int i = 0; i < data_list.size(); i++) {
            String ths_desigerid = String.valueOf(data_list.get(i).get("DESIGERID"));
            excelname = String.valueOf(data_list.get(i).get("EXCELNAME"));
            String tabledatasource = String.valueOf(data_list.get(i).get("TABLEDATASOURCE"));
            String tablename = String.valueOf(data_list.get(i).get("TABLENAME"));
            String sheetname = String.valueOf(data_list.get(i).get("SHEETNAME"));
            Sheet sheet = workbook.getSheet(sheetname);
            List<Map<String, Object>> excelfields_list = super.getListFromSql(
                    "select * from JDP_EFORM_EXCELFIELDS where desigerid = '"
                            + StringEscapeUtils.escapeSql(ths_desigerid) + "' order by sheetcolnum");
            //TODO:解决postGress返回小写字段的问题
            excelfields_list = transListMapKey(excelfields_list);
            allFiledMap.put(ths_desigerid, excelfields_list);
            for (int j = 0; j < excelfields_list.size(); j++) {
                Map<String, Object> fields = excelfields_list.get(j);
                String intransform = String.valueOf(fields.get("INTRANSFORM"));
                //一个单元格可能存在多个验证条件，存在多个验证条件时，各个验证方式间会用“;”分割，因此验证时要先分割再验证
                String checkmethods = String.valueOf(fields.get("CHECKMETHOD"));
                if (!Tool.isNull(checkmethods) && checkmethods.split(";").length > 0) {
                    for (String checkmethod : checkmethods.split(";")) {
                        List<Map<String, String>> checkList = DictionaryUtils.getDictionarysByCode(checkmethod);
                        List<Map<String, String>> checkSqlList = DictionaryUtils.getSqlDictionarysByCode(checkmethod);
                        //验证重复导入使用
                        if (!Tool.isNull(checkmethod) && checkmethod.startsWith("NOREPEAT-")) {
                            if (repeatMap.get(checkmethod) == null) {
                                try {
                                    Map<String, String> haveData = new HashMap<String, String>();
                                    List<String> checkMethodList = Arrays
                                            .asList(checkmethod.replace("NOREPEAT-", "").split("-"));
                                    String selectfields = "1";
                                    for (int c = 0; c < checkMethodList.size(); c++) {
                                        selectfields = selectfields + "," + checkMethodList.get(c);
                                    }
                                    String currentDatasource = DBContextHolder.getDataSource();
                                    if (!Tool.isNull(tabledatasource)) {
                                        DBContextHolder.setDataSource(tabledatasource);
                                    }
                                    List<Map<String, Object>> listFromSql = new ArrayList<Map<String, Object>>();
                                    try {
                                        listFromSql = super.getListFromSql(
                                                "select " + selectfields + " from " + tablename);
                                    } catch (Exception e) {
                                        throw new RuntimeException(e);
                                    } finally {
                                        DBContextHolder.setDataSource(currentDatasource);
                                    }
                                    for (int l = 0; l < listFromSql.size(); l++) {
                                        String rowValue = "";
                                        for (int m = 0; m < checkMethodList.size(); m++) {
                                            rowValue = rowValue + "[" + listFromSql.get(l).get(checkMethodList.get(m))
                                                    + "]";
                                        }
                                        haveData.put(rowValue, rowValue);
                                    }
                                    repeatMap.put(checkmethod, haveData);
                                } catch (Exception e) {
                                    // TODO: handle exception
                                }
                            }
                        } else if ((checkList != null && checkList.size() > 0)
                                || (checkSqlList != null && checkSqlList.size() > 0)) {
                            String realintransform = checkmethod;
                            if (realintransform.startsWith("!")) {
                                realintransform = realintransform.substring(1);
                            }
                            List<Map<String, String>> dictionarys = eformCommonService.getDictionarysByTreeId(
                                    realintransform, dictionarys_map, sql_dictionarys_map, variables);
                            Map<String, String> dictionaryMap_CodeToName = new HashMap<String, String>();
                            Map<String, String> dictionaryMap_NameToCode = new HashMap<String, String>();
                            if (dictionarys != null && dictionarys.size() > 0) {
                                for (int d = 0; d < dictionarys.size(); d++) {
                                    dictionaryMap_CodeToName.put(dictionarys.get(d).get("dictionary_code"),
                                            dictionarys.get(d).get("dictionary_name"));
                                    dictionaryMap_NameToCode.put(dictionarys.get(d).get("dictionary_name"),
                                            dictionarys.get(d).get("dictionary_code"));
                                }
                            }
                            @SuppressWarnings("unchecked")
                            Map<String, Map<String, String>> dictionaryMap_CodeToName_check_map = (Map<String, Map<String, String>>) fields
                                    .get("dictionaryMap_CodeToName_check");
                            if (dictionaryMap_CodeToName_check_map == null) {
                                dictionaryMap_CodeToName_check_map = new HashMap<String, Map<String, String>>();
                                fields.put("dictionaryMap_CodeToName_check", dictionaryMap_CodeToName_check_map);
                            }
                            dictionaryMap_CodeToName_check_map.put(checkmethod, dictionaryMap_CodeToName);
                            @SuppressWarnings("unchecked")
                            Map<String, Map<String, String>> dictionaryMap_NameToCode_check_map = (Map<String, Map<String, String>>) fields
                                    .get("dictionaryMap_NameToCode_check");
                            if (dictionaryMap_NameToCode_check_map == null) {
                                dictionaryMap_NameToCode_check_map = new HashMap<String, Map<String, String>>();
                                fields.put("dictionaryMap_NameToCode_check", dictionaryMap_NameToCode_check_map);
                            }
                            dictionaryMap_NameToCode_check_map.put(checkmethod, dictionaryMap_NameToCode);
                        }
                    }
                }
                //开始：处理验证方式，如果是内容来自字典则取出字典中的值
                if (!Tool.isNull(intransform)) {
                    String realintransform = intransform;
                    if (realintransform.startsWith("!")) {
                        realintransform = realintransform.substring(1);
                    }
                    List<Map<String, String>> dictionarys = eformCommonService.getDictionarysByTreeId(realintransform,
                            dictionarys_map, sql_dictionarys_map, variables);
                    Map<String, String> dictionaryMap_CodeToName = new HashMap<String, String>();
                    Map<String, String> dictionaryMap_NameToCode = new HashMap<String, String>();
                    if (dictionarys != null && dictionarys.size() > 0) {
                        for (int d = 0; d < dictionarys.size(); d++) {
                            dictionaryMap_CodeToName.put(dictionarys.get(d).get("dictionary_code"),
                                    dictionarys.get(d).get("dictionary_name"));
                            dictionaryMap_NameToCode.put(dictionarys.get(d).get("dictionary_name"),
                                    dictionarys.get(d).get("dictionary_code"));
                        }
                    }
                    fields.put("dictionaryMap_CodeToName", dictionaryMap_CodeToName);
                    fields.put("dictionaryMap_NameToCode", dictionaryMap_NameToCode);
                }
                //结束：处理验证方式，如果是内容来自字典则取出字典中的值
            }

            ExcelProp this_excelProp = ExcelTemplateUtils.parseExcel(workbook, sheet, data_list.get(i),
                    excelfields_list, dialet, variables, repeatMap);
            if (!this_excelProp.isChecked()) {
                excelProp.setChecked(false);
            } else {
                String beforeRunSql = String.valueOf(data_list.get(i).get("BEFORERUNSQL"));
                if (!Tool.isNull(beforeRunSql)) {
                    //多条sql处理
                    String[] brsqls = SqlUtils.replaceSqlParam(beforeRunSql, variables).split(";");
                    for (String brsql : brsqls) {
                        if (!Tool.isNull(brsql)) {
                            excelProp.getSqlList().add(brsql);
                        }
                    }
                }
                if (this_excelProp.getSqlList() != null && this_excelProp.getSqlList().size() > 0) {
                    excelProp.getAllSqlMap().put(ths_desigerid, this_excelProp.getSqlList());
                }
                String afterRunSql = String.valueOf(data_list.get(i).get("AFTERRUNSQL"));
                if (!Tool.isNull(afterRunSql)) {
                    //多条sql处理
                    String[] arsqls = SqlUtils.replaceSqlParam(afterRunSql, variables).split(";");
                    for (String arsql : arsqls) {
                        if (!Tool.isNull(arsql)) {
                            excelProp.getSqlList().add(arsql);
                        }
                    }
                }

                excelProp.getAllDataMap().put(ths_desigerid, this_excelProp.getDataList());
            }
        }
        excelProp.setAllFiledMap(allFiledMap);
        excelProp.setSheetList(data_list);
        /****************** 解析EXCEL后处理逻辑 ************************/
        ImportCallbackProp callbackProp = new ImportCallbackProp();
        callbackProp.setExcelProp(excelProp);
        callbackProp.setVariables(variables);
        callbackProp.setWorkbook(workbook);
        //反射参数中配置的实现类，调用前置回调函数
        executeBeforeCallback(callbackProp);
        //前置函数中可以进行自定义的校验，所以校验结果会在前置函数中进行改变
        //如果校验通过，执行sql语句，并执行后置回调函数
        if (excelProp.isChecked()) {
            //执行sql
            this.excuteSql(excelProp);
            //反射参数中配置的实现类，调用后置回调函数
            executeAfterCallback(callbackProp);
        }
        if (!excelProp.isChecked()) {
            excelProp.setErrorMessage("下载错误文件");
            String errorTempFileName = String.valueOf(data_list.get(0).get("EXCELNAME"));
            //校验不通过的excel临时文件名称，防止并发时附件命名重复，覆盖别人文件，这里进行特殊处理
            if (!Tool.isNull(errorTempFileName)) {
                errorTempFileName = errorTempFileName.split("\\.")[0] + System.currentTimeMillis()
                        + Thread.currentThread().getId();
            } else {
                errorTempFileName = Tool.getUUID();
            }
            errorTempFileName = errorTempFileName + "_错误文件" + filepath.substring(filepath.lastIndexOf("."));
            excelProp.setErrorTempFileName(errorTempFileName);
            //校验不通过的excel存储路径
            String errorfilepath = PropertyConfigure.getProperty("jdp.eform.file.path").toString() + File.separator
                    + "temp";
            File dic = new File(errorfilepath);
            if (!dic.exists()) {
                dic.mkdirs();
            }
            FileOutputStream out = new FileOutputStream(errorfilepath + File.separator + errorTempFileName);
            workbook.write(out);
            out.close();
        }
        //清除缓存的数据，防止返回到页面造成页面崩溃
        excelProp.getAllDataMap().clear();
        excelProp.getAllFiledMap().clear();
        excelProp.getAllSqlMap().clear();
        excelProp.getDataList().clear();
        excelProp.getSheetList().clear();
        excelProp.getSqlList().clear();
        excelProp.getExecuteSqlResult().clear();
        return excelProp;
    }

    /**
     * 执行excel解析后的sql
     *
     * @param excelProp
     * @throws Exception
     */
    private void excuteSql(ExcelProp excelProp) throws Exception {
        if (excelProp.getAllSqlMap() != null && excelProp.getAllSqlMap().size() > 0) {
            for (Entry<String, List<String>> entry : excelProp.getAllSqlMap().entrySet()) {
                //数据库配置的datasource
                String desigerid = entry.getKey();
                List<Map<String, Object>> sheetList = excelProp.getSheetList();
                Map<String, Map<String, Object>> sheetMap = Tool.list2Map("DESIGERID", sheetList);
                String dataSource = String.valueOf(sheetMap.get(desigerid).get("TABLEDATASOURCE"));
                //当前运行环境的datasource
                String currentDatasource = DBContextHolder.getDataSource();
                if (Tool.isNull(dataSource)) {
                    dataSource = currentDatasource;
                }
                //切换数据源为配置的datasource
                DBContextHolder.setDataSource(dataSource);
                try {
                    //开启新事务
                    PlatformTransactionManager transactionManager = SpringContextHelper.getBean("transactionManager");
                    DefaultTransactionDefinition def = new DefaultTransactionDefinition();
                    def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
                    TransactionStatus status = transactionManager.getTransaction(def); // 获得事务状态
                    try {
                        log.info("************开始执行插入数据SQL" + entry.getValue().size() + "条*****************");
                        //执行excel数据导入数据库
                        super.batchSqlUpdate(entry.getValue());
                        //当sql执行成功时，设置sql执行标识位为true
                        excelProp.getExecuteSqlResult().put(desigerid, true);
                        transactionManager.commit(status);
                    } catch (Exception e) {
                        transactionManager.rollback(status);
                        //事务回滚
                        throw e;
                    }
                } catch (Exception e) {
                    log.error("解析的sql执行报错");
                    excelProp.getExecuteSqlResult().put(desigerid, false);
                    throw e;
                } finally {
                    DBContextHolder.setDataSource(currentDatasource);
                    if (excelProp.getExecuteSqlResult().get(desigerid) == null) {
                        excelProp.getExecuteSqlResult().put(desigerid, false);
                    }
                }
            }
        }
    }

    /**
     * 获取sheet页的字段配置项
     *
     * @param desigerid
     * @return
     */
    public List<Map<String, Object>> listExcelFields(String desigerid) {
        List<Map<String, Object>> list = super.getListFromSql("select * from JDP_EFORM_EXCELFIELDS where desigerid = '"
                + StringEscapeUtils.escapeSql(desigerid) + "' order by sheetcolnum");
        return transListMapKey(list);
    }

    /**
     * 执行前置回调方法
     *
     * @param callbackProp
     * @return
     */
    @SuppressWarnings("deprecation")
    private ImportCallbackProp executeBeforeCallback(ImportCallbackProp callbackProp) throws Exception {
        HashMap<String, Object> variables = (HashMap<String, Object>) callbackProp.getVariables();
        Workbook workbook = callbackProp.getWorkbook();
        String callbackClass = (String) variables.get("callbackClass");
        if (!Tool.isNull(callbackClass)) {
            WebApplicationContext wac = ContextLoader.getCurrentWebApplicationContext();
            Object bean = wac.getBean(callbackClass);
            //兼容老的回调函数
            if (bean instanceof ExcelCallbackInterface) {
                ExcelCallbackInterface callbackInterface = (ExcelCallbackInterface) bean;
                callbackInterface.beforeCallback((XSSFWorkbook) workbook, variables);
            } else if (bean instanceof ExcelImportCallbackInterface) {
                ExcelImportCallbackInterface callbackInterface = (ExcelImportCallbackInterface) bean;
                callbackInterface.beforeCallback(callbackProp);
            }
        }
        return callbackProp;
    }

    /**
     * 执行后置回调方法
     *
     * @param callbackProp
     * @return
     */
    @SuppressWarnings("deprecation")
    private ImportCallbackProp executeAfterCallback(ImportCallbackProp callbackProp) throws Exception {
        HashMap<String, Object> variables = (HashMap<String, Object>) callbackProp.getVariables();
        Workbook workbook = callbackProp.getWorkbook();
        String callbackClass = (String) variables.get("callbackClass");
        if (!Tool.isNull(callbackClass)) {
            WebApplicationContext wac = ContextLoader.getCurrentWebApplicationContext();
            Object bean = wac.getBean(callbackClass);
            //兼容老的回调函数
            if (bean instanceof ExcelCallbackInterface) {
                ExcelCallbackInterface callbackInterface = (ExcelCallbackInterface) bean;
                callbackInterface.afterCallback((XSSFWorkbook) workbook, variables);
            } else if (bean instanceof ExcelImportCallbackInterface) {
                ExcelImportCallbackInterface callbackInterface = (ExcelImportCallbackInterface) bean;
                callbackInterface.afterCallback(callbackProp);
            }
        }
        return callbackProp;
    }

    /**
     * 将返回值的map的key转为大写
     *
     * @param list
     * @return
     */
    private List<Map<String, Object>> transListMapKey(List<Map<String, Object>> list) {
        if (list == null) {
            return null;
        }
        List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> map : list) {
            returnList.add(Tool.transKey2Upper(map));
        }
        return returnList;
    }
}
