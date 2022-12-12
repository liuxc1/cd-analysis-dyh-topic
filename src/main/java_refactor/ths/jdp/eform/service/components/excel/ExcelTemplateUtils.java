package ths.jdp.eform.service.components.excel;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFComment;
import org.apache.poi.xssf.usermodel.XSSFDataValidation;
import org.apache.poi.xssf.usermodel.XSSFDrawing;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.springframework.web.context.ContextLoader;
import ths.jdp.custom.util.Tool;
import ths.jdp.eform.service.components.excel.model.DataSheet;
import ths.jdp.eform.service.components.excel.model.TemplateSheet;
import ths.jdp.util.SqlUtils;
import ths.project.common.uid.SnowflakeIdGenerator;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ExcelTemplateUtils {

    private static SnowflakeIdGenerator SNOWFLAKE_ID_GENERATOR;

    static {
        SNOWFLAKE_ID_GENERATOR = ContextLoader.getCurrentWebApplicationContext().getBean(SnowflakeIdGenerator.class);
    }

    /**
     * 根据路径读取excel文件
     *
     * @param path
     * @return
     */
    public static Workbook readWorkBook(String path) {
        Workbook wb;
        try {
            wb = WorkbookFactory.create(new FileInputStream(path));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return wb;
    }

    /**
     * 生成Excel中的下拉框
     *
     * @param sheet
     * @param pos      下拉数组
     * @param firstRow 开始行
     * @param lastRow  结束行
     * @param firstCol 开始列
     * @param lastCol  结束列
     * @return
     */
    public static DataValidation setDropSelect(Sheet sheet, String[] pos, int firstRow, int lastRow, int firstCol,
                                               int lastCol) {
        DataValidationHelper helper = sheet.getDataValidationHelper();
        // CellRangeAddressList(firstRow, lastRow, firstCol, lastCol)设置行列范围
        CellRangeAddressList addressList = new CellRangeAddressList(firstRow, lastRow, firstCol, lastCol);
        // 设置下拉框数据
        DataValidationConstraint constraint = helper.createExplicitListConstraint(pos);
        DataValidation dataValidation = helper.createValidation(constraint, addressList);
        // 处理Excel兼容性问题
        if (dataValidation instanceof XSSFDataValidation) {
            dataValidation.setSuppressDropDownArrow(true);
            dataValidation.setShowErrorBox(true);
        } else {
            dataValidation.setSuppressDropDownArrow(false);
        }
        return dataValidation;
    }

    public static String rewriteExcelTempAtEmp(Workbook workbook, Sheet sheet, List<DataValidation> dataValidations) {
        String newPath = "";
        if (workbook != null && sheet != null) {
            if (dataValidations != null && dataValidations.size() > 0) {
                for (DataValidation dataValidation : dataValidations) {
                    sheet.addValidationData(dataValidation);
                }
            }
        }
        return newPath;
    }

    /**
     * 根据路径创建Excel
     *
     * @param workbook
     * @param path
     * @author lance 2014年8月13日 下午4:06:10
     */
    public static void createExcel(Workbook workbook, String path) {
        try (FileOutputStream fileOut = new FileOutputStream(path)) {
            workbook.write(fileOut);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * <pre>
     * 定义错误样式
     * </pre>
     *
     * @param wb
     * @return
     * @author liyy, 2017-3-6 下午2:38:01
     */
    public static CellStyle getErrorStyle(Workbook wb) {
        CellStyle errorstyle = wb.createCellStyle();
        errorstyle.setFillPattern(FillPatternType.FINE_DOTS);
        errorstyle.setFillForegroundColor(IndexedColors.RED.getIndex());
        errorstyle.setFillBackgroundColor(IndexedColors.RED.getIndex());
        errorstyle.setBorderBottom(BorderStyle.THIN); //下边框
        errorstyle.setBorderLeft(BorderStyle.THIN);//左边框
        errorstyle.setBorderTop(BorderStyle.THIN);//上边框
        errorstyle.setBorderRight(BorderStyle.THIN);//右边框
        errorstyle.setLocked(false);
        return errorstyle;
    }

    /**
     * <pre>
     * 恢复原有格式
     * </pre>
     *
     * @param wb
     * @return
     * @author liyy, 2017-3-8 上午10:20:55
     */
    private static CellStyle getSuccessStyle(Workbook wb) {
        CellStyle errorstyle = wb.createCellStyle();
        errorstyle.setFillPattern(FillPatternType.FINE_DOTS);
        errorstyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        errorstyle.setFillBackgroundColor(IndexedColors.WHITE.getIndex());
        errorstyle.setBorderBottom(BorderStyle.THIN); //下边框
        errorstyle.setBorderLeft(BorderStyle.THIN);//左边框
        errorstyle.setBorderTop(BorderStyle.THIN);//上边框
        errorstyle.setBorderRight(BorderStyle.THIN);//右边框
        errorstyle.setLocked(false);
        return errorstyle;
    }

    /**
     * <pre>
     * 恢复excel样式
     * </pre>
     *
     * @param workbook
     * @param sheetIndexArr
     * @return
     * @author liyy, 2017-3-8 上午9:44:22
     */
    private static Sheet recoverExcelStyle(Workbook wb, Sheet sheet) {
        Integer rowNum = sheet.getLastRowNum() + 1; //获取行
        for (int i = 1; i < rowNum; i++) {
            Row row = sheet.getRow(i);
            if (row == null) {
                break;
            }
            Integer cellNum = (int) row.getLastCellNum(); //获取列
            for (int j = 0; j < cellNum; j++) {
                Cell cell = row.getCell(j);
                if (cell != null) {
                    //删除批注
                    cell.removeCellComment();
                    //删除背景
                    short color = cell.getCellStyle().getFillBackgroundColor();
                    if (color == 10) {
                        short format = cell.getCellStyle().getDataFormat();
                        cell.setCellStyle(getSuccessStyle(wb));
                        cell.getCellStyle().setDataFormat(format);
                    }
                }
            }
        }
        return sheet;
    }

    /**
     * <pre>
     * Poi读取excel中Cell里的值
     * </pre>
     *
     * @param cell
     * @return
     * @author liyy, 2016-3-23 下午2:22:56
     */
    public static String getCellValue(Cell cell, String fieldtype) {
        String value = "";
        if (cell != null) {
            CellType tag = cell.getCellType();
            if (tag == CellType.NUMERIC) {
                if (cell.getCellStyle().getDataFormat() == 58 || cell.getCellStyle().getDataFormat() == 57) {// 处理自<STRONG>定义</STRONG><STRONG>日期</STRONG>格式：m月d日(通过判断单元格的格式id解决，id的值是58)
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    double values = cell.getNumericCellValue();
                    Date date = org.apache.poi.ss.usermodel.DateUtil.getJavaDate(values);
                    value = sdf.format(date);

                } else if (!Tool.isNull(fieldtype) && fieldtype.startsWith("DATE")) {
                    SimpleDateFormat sdf = new SimpleDateFormat(fieldtype.replace("DATE:", ""));
                    value = sdf.format(cell.getDateCellValue()).toString();
                } else if (DateUtil.isCellDateFormatted(cell)) {
                    // 如果是date类型则，获取该cell的date值
                    //					value = HSSFDateUtil
                    //							.getJavaDate(cell.getNumericCellValue()).toString();
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    value = sdf.format(cell.getDateCellValue()).toString();
                } else {// 纯数字
                    DecimalFormat df = new DecimalFormat("#.#########");
                    value = df.format(cell.getNumericCellValue());
                }
            } else if (tag == CellType.STRING) {
                value = cell.getRichStringCellValue().toString();
            } else if (tag == CellType.FORMULA) {
                /*
                 * try { value = String.valueOf(cell.getRichStringCellValue()); if (value.equals("NaN")) {// 如果获取的数据值为非法值,则转换为获取字符串 value = cell.getRichStringCellValue().toString(); } } catch (Exception e) { cell.setCellType(Cell.CELL_TYPE_STRING); value = String.valueOf(cell.getRichStringCellValue()); }
                 */
                cell.setCellType(CellType.STRING);
                value = String.valueOf(cell.getRichStringCellValue());
            } else if (tag == CellType.BOOLEAN) {
                value = " " + cell.getBooleanCellValue();
            } else if (tag == CellType.BLANK) {
                value = "";
            } else if (tag == CellType.ERROR) {
                value = "";
            } else {
                value = cell.getRichStringCellValue().toString();
                if (DateUtil.isCellDateFormatted(cell)) {//单元格为日期型
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    value = sdf.format(value).toString();
                }
            }
        }
        if (value != null) {
            //去除特殊字符
            value = value.replaceAll(String.valueOf((char) 8203), " ");
            value = value.replaceAll(String.valueOf((char) 160), " ");
            value = value.trim();
        }
        return value;
    }

    /**
     * 校验内容是否符合要求，不对单元格进行处理
     *
     * @param cell
     * @param content
     * @param dictionaryMap_CodeToName
     * @param checkString
     * @param checkmethoddescr
     * @param haveData
     * @return
     */
    private static String checkCell(Cell cell, String content, Map<String, String> dictionaryMap_CodeToName,
                                    String checkString, String checkmethoddescr, Map<String, String> haveData) {
        if (dictionaryMap_CodeToName != null && dictionaryMap_CodeToName.size() > 0) {
            if (checkString.startsWith("!")) {
                if (dictionaryMap_CodeToName.get(content) != null) {
                    return checkmethoddescr;
                }
            } else {
                if (dictionaryMap_CodeToName.get(content) == null) {
                    return checkmethoddescr;
                }
            }
        } else if (!Tool.isNull(checkString)) {
            if (content == null) {
                content = "";
            }
            if (!content.matches(checkString)) {
                return checkmethoddescr;
                //添加错误
                //sb.append("错误提示：【"+excelColIndexToStr(cellIndex+1)+(rowIndex+1)+"】,"+resultList.get(1)+"<br>");
            }
        }
        return "";
    }

    /**
     * 检测内容是否符合要求
     *
     * @param cell
     * @param content
     * @param drawing
     * @param checkList
     * @param checkString
     * @param checkmethoddescr
     * @param errorStyle
     * @return
     */
    public static boolean checkCell(Cell cell, String content, Drawing drawing,
                                    Map<String, String> dictionaryMap_CodeToName, String checkString, String checkmethoddescr,
                                    CellStyle errorStyle, Map<String, String> haveData) {
        /*
         * int cellIndex=cell.getColumnIndex(); int rowIndex=row.getRowNum();
         */
        if (dictionaryMap_CodeToName != null && dictionaryMap_CodeToName.size() > 0) {
            if (checkString.startsWith("!")) {
                if (dictionaryMap_CodeToName.get(content) != null) {
                    //标红错误数据
                    short format = cell.getCellStyle().getDataFormat();
                    cell.setCellStyle(errorStyle);
                    cell.getCellStyle().setDataFormat(format);
                    //添加标注
                    Comment comment = null;
                    if (drawing instanceof XSSFDrawing) {
                        comment = drawing
                                .createCellComment(new XSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
                        comment.setString(new XSSFRichTextString(checkmethoddescr));
                    } else {
                        comment = drawing
                                .createCellComment(new HSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
                        comment.setString(new HSSFRichTextString(checkmethoddescr));
                    }
                    cell.setCellComment(comment);
                    return false;
                }
            } else {
                if (dictionaryMap_CodeToName.get(content) == null) {
                    //标红错误数据
                    short format = cell.getCellStyle().getDataFormat();
                    cell.setCellStyle(errorStyle);
                    cell.getCellStyle().setDataFormat(format);
                    //添加标注
                    Comment comment = null;
                    if (drawing instanceof XSSFDrawing) {
                        comment = drawing
                                .createCellComment(new XSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
                        comment.setString(new XSSFRichTextString(checkmethoddescr));
                    } else {
                        comment = drawing
                                .createCellComment(new HSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
                        comment.setString(new HSSFRichTextString(checkmethoddescr));
                    }
                    cell.setCellComment(comment);
                    return false;
                }
            }
        } else if (!Tool.isNull(checkString)) {
            if (content == null) {
                content = "";
            }
            if (!content.matches(checkString)) {
                //标红错误数据
                short format = cell.getCellStyle().getDataFormat();
                cell.setCellStyle(errorStyle);
                cell.getCellStyle().setDataFormat(format);
                //添加标注
                Comment comment = null;
                if (drawing instanceof XSSFDrawing) {
                    comment = drawing.createCellComment(new XSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
                    comment.setString(new XSSFRichTextString(checkmethoddescr));
                } else {
                    comment = drawing.createCellComment(new HSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
                    comment.setString(new HSSFRichTextString(checkmethoddescr));
                }
                cell.setCellComment(comment);
                return false;
                //添加错误
                //sb.append("错误提示：【"+excelColIndexToStr(cellIndex+1)+(rowIndex+1)+"】,"+resultList.get(1)+"<br>");
            }
        }
        return true;
    }

    /**
     * 校验是否重复，只返回校验结果，结果为提示信息，不对单元格进行处理
     *
     * @param cell
     * @param content
     * @param checkmethoddescr
     * @param haveData
     * @return
     */
    private static String checkCellRepeat(Cell cell, String content, String checkmethoddescr,
                                          Map<String, String> haveData) {
        if (Tool.isNull(content) || Tool.isNull(getCellValue(cell, ""))) {
            return "数据不能为空！";
        }
        if (haveData != null && haveData.size() > 0) {
            if (!Tool.isNull(haveData.get(content))) {
                return content + checkmethoddescr;
            }
        }
        return "";
    }

    /**
     * 校验是否重复，校验结果为true/false,并且对单元格进行处理
     *
     * @param cell
     * @param content
     * @param drawing
     * @param checkmethoddescr
     * @param errorStyle
     * @param haveData
     * @return
     */
    public static boolean checkCellRepeat(Cell cell, String content, Drawing drawing, String checkmethoddescr,
                                          CellStyle errorStyle, Map<String, String> haveData) {
        if (Tool.isNull(content) || Tool.isNull(getCellValue(cell, ""))) {
            //标红错误数据
            short format = cell.getCellStyle().getDataFormat();
            cell.setCellStyle(errorStyle);
            cell.getCellStyle().setDataFormat(format);
            //添加标注
            Comment comment = drawing.createCellComment(new XSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
            if (comment instanceof XSSFComment) {
                comment.setString(new XSSFRichTextString("数据不能为空！"));
            } else {
                comment.setString(new HSSFRichTextString("数据不能为空！"));
            }
            cell.setCellComment(comment);
            return false;
        }
        if (haveData != null && haveData.size() > 0) {
            if (!Tool.isNull(haveData.get(content))) {
                short format = cell.getCellStyle().getDataFormat();
                //标红错误数据
                cell.setCellStyle(errorStyle);
                cell.getCellStyle().setDataFormat(format);
                //添加标注
                Comment comment = drawing
                        .createCellComment(new XSSFClientAnchor(0, 0, 0, 0, (short) 4, 2, (short) 6, 5));
                if (comment instanceof XSSFComment) {
                    comment.setString(new XSSFRichTextString(content + checkmethoddescr));
                } else {
                    comment.setString(new HSSFRichTextString(content + checkmethoddescr));
                }
                cell.setCellComment(comment);
                return false;
            }
        }
        return true;
    }

    /**
     * <pre>
     * excel列号数字转字母
     * </pre>
     *
     * @param columnIndex
     * @return
     * @author liyy, 2017-3-6 下午6:04:04
     */
    public static String excelColIndexToStr(int columnIndex) {
        if (columnIndex <= 0) {
            return null;
        }
        String columnStr = "";
        columnIndex--;
        do {
            if (columnStr.length() > 0) {
                columnIndex--;
            }
            columnStr = ((char) (columnIndex % 26 + (int) 'A')) + columnStr;
            columnIndex = (int) ((columnIndex - columnIndex % 26) / 26);
        } while (columnIndex > 0);
        return columnStr;
    }

    /**
     * 为错误单元格设置样式及批注
     *
     * @param cell
     * @param commentStr
     */
    public static void setErrorStyleAndComment(Sheet sheet, Cell cell, String commentStr) {
        Drawing drawing = sheet.createDrawingPatriarch();
        short format = cell.getCellStyle().getDataFormat();
        //标红错误数据
        cell.setCellStyle(getErrorStyle(sheet.getWorkbook()));
        cell.getCellStyle().setDataFormat(format);
        Comment comment = null;
        //添加标注
        if (sheet instanceof XSSFSheet) {
            comment = drawing.createCellComment(new XSSFClientAnchor(0, 0, 0, 0, cell.getColumnIndex(), cell.getRowIndex(), cell.getColumnIndex()+2, cell.getRowIndex()+2));
            comment.setString(new XSSFRichTextString(commentStr));
        } else {
            comment = drawing.createCellComment(new HSSFClientAnchor(0, 0, 0, 0, (short) cell.getColumnIndex(), cell.getRowIndex(), (short) cell.getColumnIndex(), cell.getRowIndex()));
            comment.setString(new HSSFRichTextString(commentStr));
        }
        cell.setCellComment(comment);
    }

    /**
     * 获取当前单元格的批注信息
     *
     * @param cell
     * @return
     */
    public static String getCommentStr(Cell cell) {
        String msg = "";
        Comment cellComment = cell.getCellComment();
        if (cellComment != null) {
            RichTextString richTextString = cellComment.getString();
            if (richTextString != null) {
                msg = richTextString.getString();
            }
        }
        return msg;
    }

    /**
     * 判断row是否为空
     *
     * @param row
     * @param excelfields
     * @return
     */
    public static boolean checkRowEmpty(Row row, List<Map<String, Object>> excelfields) {
        if (row == null) {
            return false;
        }
        boolean flag = true;
        // 过滤无效数据
        StringBuffer rowContent = new StringBuffer();
        for (int k = 0; k < excelfields.size(); k++) {
            Cell cell = row.getCell(k);
            if (cell != null) {
                if (cell.getCellType().FORMULA != cell.getCellType()) {
                    Map<String, Object> excelfield = excelfields.get(k);
                    String fieldtype = String.valueOf(excelfield.get("FIELDTYPE"));// 数据格式，
                    // 获取单元格值
                    String content = getCellValue(cell, fieldtype);
                    rowContent.append(content);
                }
            }
        }
        // 如果有效数据拼接起来都是空,则直接跳转到下一行的解析,知道结束
        if (StringUtils.isBlank(rowContent.toString())) {
            flag = false;
        }
        return flag;
    }

    /**
     * 解析指定excel中对应的sheet
     *
     * @param workbook
     * @param sheet
     * @param excelsheet
     * @param excelfields
     * @return
     */
    @SuppressWarnings({"unchecked", "unused"})
    public static ExcelProp parseExcel(Workbook workbook, Sheet sheet, Map<String, Object> excelsheet,
                                       List<Map<String, Object>> excelfields, String dialet, Map<String, Object> variables,
                                       Map<String, Map<String, String>> repeatMap) {
        ExcelProp excelProp = new ExcelProp();
        excelProp.setChecked(true);
        List<String> sqlList = new ArrayList<String>();
        List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
        try {
            CellStyle errorStyle = getErrorStyle(workbook);
            //定义接收错误信息变量
            StringBuffer sb = new StringBuffer();

            int startrow_int = 0;
            String startrow = String.valueOf(excelsheet.get("STARTROW"));
            if (Tool.isInt(startrow)) {
                startrow_int = Integer.parseInt(startrow);
            }
            String tablename = String.valueOf(excelsheet.get("TABLENAME"));

            boolean isCreateSql = "N".equals(excelsheet.get("IS_CREATE_SQL")) ? false : true;

            //校验导入的excel是否合法
            List<Map<String, String>> rowList = new ArrayList<Map<String, String>>();//封装sheet中的row
            //遍历sheet单元格，去掉红色背景及标注
            sheet = recoverExcelStyle(workbook, sheet);
            Drawing drawing = sheet.createDrawingPatriarch();
            Integer rowNum = sheet.getLastRowNum() + 1; //获取行

            Integer cellNum = (int) sheet.getRow(0).getLastCellNum(); //获取列数
            sb.append("--------" + Tool.getCurrentDetailTime() + " sheet标签页【" + sheet.getSheetName() + "】中数据开始验证<br>");
            // 定义一个tab标签,方便下面直接跳转使用
            for (int i = startrow_int; i < rowNum; i++) {
                Row row = sheet.getRow(i);
                if (row == null) {
                    continue;
                }
                // 过滤无效数据
                StringBuffer rowContent = new StringBuffer();
                for (int k = 0; k < excelfields.size(); k++) {
                    Cell cell = row.getCell(k);
                    if (cell != null) {
                        if (cell.getCellType().FORMULA != cell.getCellType()) {
                            Map<String, Object> excelfield = excelfields.get(k);
                            String fieldtype = String.valueOf(excelfield.get("FIELDTYPE"));// 数据格式，
                            // 获取单元格值
                            String content = getCellValue(cell, fieldtype);
                            rowContent.append(content);
                        }
                    }
                }

                Map<String, Object> dataMap = new HashMap<String, Object>();
                Map<String, Object> dateFormat_map = new HashMap<String, Object>();
                // 如果有效数据拼接起来都是空,则直接跳转到下一行的解析,知道结束
                if (StringUtils.isBlank(rowContent.toString())) {
                    continue;
                }
                // 具体处理数据,转SQL的逻辑
                for (int j = 0; j < excelfields.size(); j++) {
                    Map<String, Object> excelfield = excelfields.get(j);
                    String checkmethods = String.valueOf(excelfield.get("CHECKMETHOD"));//验证方法
                    String intransform = String.valueOf(excelfield.get("INTRANSFORM"));//验证字典,入库转换字典
                    //入库转换字典
                    Map<String, String> dictionaryMap_CodeToName = new HashMap<String, String>();
                    Map<String, String> dictionaryMap_NameToCode = new HashMap<String, String>();
                    if (excelfield.get("dictionaryMap_NameToCode") != null) {
                        dictionaryMap_NameToCode = (Map<String, String>) excelfield.get("dictionaryMap_NameToCode");
                        dictionaryMap_CodeToName = (Map<String, String>) excelfield.get("dictionaryMap_CodeToName");
                    }

                    String checkmethoddescr = String.valueOf(excelfield.get("CHECKMETHODDESCR"));//验证错误后的描述

                    String fieldtype = String.valueOf(excelfield.get("FIELDTYPE"));//数据格式，主要用来处理日期类型

                    String fieldcode = String.valueOf(excelfield.get("FIELDCODE"));//验证错误后的描述
                    String fielddefaultvalue = String.valueOf(excelfield.get("FIELDDEFAULTVALUE"));//默认值
                    String fieldcheckvalue = String.valueOf(excelfield.get("FIELDCHECKVALUE"));//验证值，根据多个字段的值来验证
                    int sheetcolnum = Integer.parseInt(String.valueOf(excelfield.get("SHEETCOLNUM")));
                    String content = null;
                    if (sheetcolnum >= 0) { //非隐藏列
                        Cell cell = row.getCell(sheetcolnum);
                        if (cell == null) {
                            cell = row.createCell(sheetcolnum);
                        }
                        //获取列号
                        int cellIndex = cell.getColumnIndex();
                        //获取单元格值
                        Cell mergeCell = getMergeCell(sheet, cell);
                        if (mergeCell != null) {
                            content = getCellValue(mergeCell, fieldtype);
                        } else {
                            content = getCellValue(cell, fieldtype);
                        }
                        //checkmethoddescr不存在
                        if (Tool.isNull(checkmethoddescr)) {
                            checkmethoddescr = "";
                        }
                        if (!Tool.isNull(intransform) && !intransform.startsWith("!")) {
                            content = dictionaryMap_NameToCode.get(content);
                        }
                        if (Tool.isNull(content) && !Tool.isNull(fielddefaultvalue)) {
                            if ("uuid".equalsIgnoreCase(fielddefaultvalue)) {
                                content = Tool.getUUID();
                            } else if ("snakeflow_id".equalsIgnoreCase(fielddefaultvalue)) {
                                content = SNOWFLAKE_ID_GENERATOR.getUniqueId();
                            }
                        }
                        StringBuilder checkValue = new StringBuilder(content);
                        //记录所有该单元格的校验结果
                        List<String> checkResultList = new ArrayList<String>();
                        //因为同一个单元格可能存在多个校验条件，因此要进行多次校验
                        if (!Tool.isNull(checkmethods) && checkmethods.split(";").length > 0) {
                            String[] checkmethoddescrs = checkmethoddescr.split(";");
                            for (int b = 0; b < checkmethods.split(";").length; b++) {
                                String checkmethod = checkmethods.split(";")[b];
                                //_check为 checkMethod设置的数据校验字典
                                Map<String, String> dictionaryMap_CodeToName_check = new HashMap<String, String>();
                                Map<String, String> dictionaryMap_NameToCode_check = new HashMap<String, String>();
                                if (excelfield.get("dictionaryMap_NameToCode_check") != null
                                        && ((Map<String, Map<String, String>>) excelfield.get("dictionaryMap_NameToCode_check")).get(checkmethod) != null) {
                                    dictionaryMap_NameToCode_check = ((Map<String, Map<String, String>>) excelfield
                                            .get("dictionaryMap_NameToCode_check")).get(checkmethod);
                                    dictionaryMap_CodeToName_check = ((Map<String, Map<String, String>>) excelfield
                                            .get("dictionaryMap_CodeToName_check")).get(checkmethod);
                                }
                                //校验数据是否重复
                                if (!Tool.isNull(checkmethod) && checkmethod.startsWith("NOREPEAT-")) {
                                    checkValue = new StringBuilder();
                                    String[] checkMethodList = checkmethod.replace("NOREPEAT-", "").split("-");
                                    Map<String, String> haveData = repeatMap.computeIfAbsent(checkmethod, k -> new HashMap<String, String>());
                                    for (String s : checkMethodList) {
                                        if (fieldcode.equalsIgnoreCase(s)) {
                                            checkValue.append("[").append(content).append("]");
                                        } else {
                                            checkValue.append("[").append(dataMap.get(s)).append("]");
                                        }
                                    }
                                    String checkResult = "";
                                    if (!Tool.isNull(checkResult = checkCellRepeat(cell, checkValue.toString(),
                                            checkmethoddescrs[b], haveData))) {
                                        checkResultList.add(checkResult);
                                        excelProp.setChecked(false);
                                    }
                                    haveData.put(checkValue.toString(), checkValue.toString());
                                } else {
                                    //校验单元格数据是否符合要求
                                    String checkResult = "";
                                    if (!Tool.isNull(checkResult = checkCell(cell, checkValue.toString(),
                                            dictionaryMap_CodeToName_check, checkmethod, checkmethoddescrs[b], null))) {
                                        checkResultList.add(checkResult);
                                        excelProp.setChecked(false);
                                    }
                                }
                            }
                        }
                        //如果字段需要转为日期格式，则要对日期内容进行格式化校验
                        if (!Tool.isNull(fieldtype) && StringUtils.startsWith(fieldtype, "DATE:")
                                && !Tool.isNull(fieldtype.replace("DATE:", ""))) {
                            String dateType = fieldtype.replace("DATE:", "");
                            try {
                                new SimpleDateFormat(dateType).parse(content);
                            } catch (Exception e) {
                                excelProp.setChecked(false);
                                checkResultList.add("日期类型不符合格式要求，应为" + dateType);
                            }
                        }
                        //为单元格设置错误信息
                        if (checkResultList.size() > 0) {
                            StringBuilder checkResultBuffer = new StringBuilder();
                            for (int m = 1; m <= checkResultList.size(); m++) {
                                if (checkResultList.size() > 1) {
                                    checkResultBuffer.append(m).append(" ").append(checkResultList.get(m - 1))
                                            .append("\r\n");
                                } else {
                                    checkResultBuffer.append(checkResultList.get(m - 1)).append("\r\n");
                                }
                            }
                            setErrorStyleAndComment(sheet, cell, checkResultBuffer.toString());
                        }
                    } else { //隐藏列
                        if (!Tool.isNull(fielddefaultvalue)) {
                            if (!fielddefaultvalue.startsWith("{")) {
                                if ("uuid".equalsIgnoreCase(fielddefaultvalue)) {
                                    content = Tool.getUUID();
                                } else if ("snakeflow_id".equalsIgnoreCase(fielddefaultvalue)) {
                                    content = SNOWFLAKE_ID_GENERATOR.getUniqueId();
                                } else {
                                    content = fielddefaultvalue;
                                }
                            } else {
                                Pattern placesParam = Pattern.compile("\\{.*\\}");
                                Matcher matcherParam = placesParam.matcher(fielddefaultvalue);
                                if (matcherParam.find()) {
                                    String key = matcherParam.group();
                                    key = key.substring(1, key.length() - 1);
                                    if (variables.containsKey(key)) {
                                        fielddefaultvalue = fielddefaultvalue.replace(matcherParam.group(),
                                                variables.get(key).toString());
                                    } else {
                                        fielddefaultvalue = fielddefaultvalue.replace(matcherParam.group(), "");
                                    }
                                }
                                content = fielddefaultvalue;
                            }
                        } else { //隐藏列不设默认值，不进行保存
                            continue;
                        }
                    }

                    dataMap.put(fieldcode, content);
                    dateFormat_map.put(fieldcode, fieldtype);
                }

                if (isCreateSql) {
                    sqlList.add(SqlUtils.getInsertSql(tablename, dataMap, dateFormat_map, dialet));
                }
                dataList.add(dataMap);
            }
            excelProp.setSqlList(sqlList);
            excelProp.setDataList(dataList);
            sb.append("--------").append(Tool.getCurrentDetailTime()).append(" sheet标签页【").append(sheet.getSheetName()).append("】中数据结束验证<br>");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return excelProp;
    }

    /**
     * 导出excel(没有模板)
     */
    public static void exportExecl(HttpServletResponse response, String fileName, List<DataSheet> sheets) {

        ExcelUtil.exportExcel(response, fileName, sheets);
    }

    /**
     * 返回一个填充过数据的workbook对象
     */
    public static Workbook writeExcel(Workbook wb, List<DataSheet> sheets) {

        return ExcelUtil.writeExcel(wb, sheets);
    }

    /**
     * 导出excel(基于模板)
     */
    public static void exportExeclByTemplate(HttpServletResponse response, String filePath, String fileName,
                                             List<TemplateSheet> sheets, List<String> deleteSheets) throws Exception {

        ExcelUtil.exportExcelByTemplate(response, filePath, fileName, sheets, deleteSheets);
    }

    /**
     * 返回一个填充过数据的workbook对象
     */
    public static Workbook writeExcelByTemplate(String filePath, List<TemplateSheet> sheets,
                                                List<String> deleteSheets) {

        return ExcelUtil.writeExcelByTemplate(filePath, sheets, deleteSheets);
    }

    /**
     * 获取合并单元格
     *
     * @param sheet sheet对象
     * @param cell  当前单元格
     */
    public static Cell getMergeCell(Sheet sheet, Cell cell) {
        Cell mergeCell = null;
        int sheetMergeCount = sheet.getNumMergedRegions();
        for (int i = 0; i < sheetMergeCount; i++) {
            CellRangeAddress range = sheet.getMergedRegion(i);
            if (range.isInRange(cell.getRowIndex(), cell.getColumnIndex())) {
                mergeCell = sheet.getRow(range.getFirstRow()).getCell(range.getFirstColumn());
                break;
            }
        }
        return mergeCell;
    }

    /**
     * 导出excel
     */
    public static void export(String fileName, String filePath, HttpServletResponse response) {
        try {
            Workbook workbook = WorkbookFactory.create(new FileInputStream(filePath));
            export(fileName, org.springframework.util.StringUtils.getFilenameExtension(filePath), workbook, response);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 导出
     */
    public static void export(String fileName, String suffix, Workbook wb, HttpServletResponse response) {
        ExcelUtil.export(fileName, suffix, wb, response);
    }
}
