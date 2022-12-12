package ths.project.common.util;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import sun.misc.BASE64Decoder;
import ths.project.common.entity.Image;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Excel工具类
 * @author liangdl
 */
@SuppressWarnings("restriction")
public class ExcelUtil {

    /**
     * 导出最简单的Excel（2003版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param titles 标题数组。格式：["key: value", "key1: value1"]
     * @param dataList 数据集合。格式：[{"key: data", "key1: data1"}, "key: data", "key1: data1"]
     * @param cellWidths 列宽（可选），从0开始。格式：["0: 15", "1: 15"]
     */
    public static void exportSimpleExcel03 (HttpServletResponse response, String fileName, String[] titles, List<Map<String, Object>> dataList, String ... cellWidths) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new HSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportSimpleExcel(wb, null, titles, null, null, dataList, null, cellWidths);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出最简单的Excel（2007及以上版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param titles 标题数组。格式：["key: value", "key1: value1"]
     * @param dataList 数据集合。格式：[{"key: data", "key1: data1"}, "key: data", "key1: data1"]
     * @param cellWidths 列宽（可选），从0开始。格式：["0: 15", "1: 15"]
     */
    public static void exportSimpleExcel07 (HttpServletResponse response, String fileName, String[] titles, List<Map<String, Object>> dataList, String ... cellWidths) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new XSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportSimpleExcel(wb, null, titles, null, null, dataList, null, cellWidths);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出最简单的Excel（2003版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param sheetName 页签名称
     * @param titles 标题数组。格式：["key: value", "key1: value1"]
     * @param dataList 数据集合。格式：[{"key: data", "key1: data1"}, "key: data", "key1: data1"]
     * @param cellWidths 列宽（可选），从0开始。格式：["0: 15", "1: 15"]
     */
    public static void exportSimpleExcel03 (HttpServletResponse response, String fileName, String sheetName, String[] titles, List<Map<String, Object>> dataList, String ... cellWidths) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new HSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportSimpleExcel(wb, sheetName, titles, null, null, dataList, null, cellWidths);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出最简单的Excel（2007及以上版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param sheetName 页签名称
     * @param titles 标题数组。格式：["key: value", "key1: value1"]
     * @param dataList 数据集合。格式：[{"key: data", "key1: data1"}, "key: data", "key1: data1"]
     * @param cellWidths 列宽（可选），从0开始。格式：["0: 15", "1: 15"]
     */
    public static void exportSimpleExcel07 (HttpServletResponse response, String fileName, String sheetName, String[] titles, List<Map<String, Object>> dataList, String ... cellWidths) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new XSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportSimpleExcel(wb, sheetName, titles, null, null, dataList, null, cellWidths);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出最简单的Excel（2003版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param sheetName 页签名称
     * @param titles 标题数组。格式：["key: value", "key1: value1"]
     * @param dataList 数据集合。格式：[{"key: data", "key1: data1"}, "key: data", "key1: data1"]
     * @param imageList 图片集合
     * @param cellWidths 列宽（可选），从0开始。格式：["0: 15", "1: 15"]
     */
    public static void exportSimpleExcel03 (HttpServletResponse response, String fileName, String sheetName, String[] titles, Integer titleRow, Integer titleCell, List<Map<String, Object>> dataList, List<Image> imageList, String ... cellWidths) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new HSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportSimpleExcel(wb, sheetName, titles, titleRow, titleCell, dataList, imageList, cellWidths);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出最简单的Excel（2007及以上版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param sheetName 页签名称
     * @param titles 标题数组。格式：["key: value", "key1: value1"]
     * @param dataList 数据集合。格式：[{"key: data", "key1: data1"}, "key: data", "key1: data1"]
     * @param imageList 图片集合
     * @param cellWidths 列宽（可选），从0开始。格式：["0: 15", "1: 15"]
     */
    public static void exportSimpleExcel07 (HttpServletResponse response, String fileName, String sheetName, String[] titles, Integer titleRow, Integer titleCell, List<Map<String, Object>> dataList, List<Image> imageList, String ... cellWidths) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new XSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportSimpleExcel(wb, sheetName, titles, titleRow, titleCell, dataList, imageList, cellWidths);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出最简单的Excel
     * @param wb 工作空间
     * @param sheetName 页签名称
     * @param titles 标题数组。格式：["key: value", "key1: value1"]
     * @param dataList 数据集合。格式：[{"key: data", "key1: data1"}, "key: data", "key1: data1"]
     * @param cellWidths 列宽（可选），从0开始。格式：["0: 15", "1: 15"]
     */
    private static void exportSimpleExcel (Workbook wb, String sheetName, String[] titles, Integer startRow, Integer startCell, List<Map<String, Object>> dataList, List<Image> imageList, String ... cellWidths) {
        // 判断数据是否为空，如果为空，则抛出异常
        if (dataList == null || dataList.size() == 0) {
            throw new RuntimeException("数据不能为空，请确认！");
        }
        startRow = (startRow == null || startRow < 0) ? 0 : startRow;
        startCell = (startCell == null || startCell < 0) ? 0 : startCell;

        // 定义参数
        // 样式（画笔）
        CellStyle cellStyle = getStyle(wb);
        // 标题信息
        Map<String, String[]> titleMap = getSimpleTitleInfo(titles);
        // value（名称）
        String[] values = titleMap.get("values");
        // 页签名称
        sheetName = (sheetName != null && !"".equals(sheetName)) ? sheetName : "Sheet 1";

        // 第一步：页签
        Sheet sheet = wb.createSheet(sheetName);
        // 第二步：创建标题行
        Row titleRow = sheet.createRow(startRow);
        // 设置行高
        titleRow.setHeightInPoints(20);
        // 第三步：给标题行创建单元格，并添加数据
        for (int i = 0, length = values.length; i < length; i++) {
            Cell titleCell = titleRow.createCell(startCell + i);
            titleCell.setCellValue(values[i]);
            // 设置样式
            titleCell.setCellStyle(cellStyle);
        }

        // 第四步：添加数据
        addData(sheet, cellStyle, titleMap, startRow, startCell, dataList);
        // 第五步：设置列宽
        setCellWidth(sheet, cellWidths);

        if (imageList != null && imageList.size() > 0) {
            // 画图的顶级管理器，一个sheet只能获取一个（一定要注意这点）
            Drawing drawing = sheet.createDrawingPatriarch();
            for (Image image : imageList) {
                // 如果图片为该页签下的图，则画图
                if (image != null && image.getSheetIndex() == 0) {
                    // 画图
                    drawing(wb, drawing, image);
                }
            }
        }
    }

    /**
     * 导出多个Sheet页签的Excel（2003版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param titleList 标题数组。格式：[["key: value", "key1: value1"]]
     * @param dataList 数据集合。格式：[[{"key: data", "key1: data1"}, "key: data", "key1: data1"]]
     */
    public static void exportMultiSheetExcel03 (HttpServletResponse response, String fileName, List<String[]> titleList, List<List<Map<String, Object>>> dataList) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new HSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportMultiSheetExcel(wb, null, titleList, dataList, null);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出多个Sheet页签的Excel（2007及以上版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param titleList 标题数组。格式：[["key: value", "key1: value1"]]
     * @param dataList 数据集合。格式：[[{"key: data", "key1: data1"}, "key: data", "key1: data1"]]
     */
    public static void exportMultiSheetExcel07 (HttpServletResponse response, String fileName, List<String[]> titleList, List<List<Map<String, Object>>> dataList) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new XSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportMultiSheetExcel(wb, null, titleList, dataList, null);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出多个Sheet页签的Excel（2003版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param sheetNames 页面名称数组
     * @param titleList 标题数组。格式：[["key: value", "key1: value1"]]
     * @param dataList 数据集合。格式：[[{"key: data", "key1: data1"}, "key: data", "key1: data1"]]
     */
    public static void exportMultiSheetExcel03 (HttpServletResponse response, String fileName, String[] sheetNames, List<String[]> titleList, List<List<Map<String, Object>>> dataList) {
        // 第一步： 创建工作工作空间，对应一个Excel文件
        Workbook wb = new HSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportMultiSheetExcel(wb, sheetNames, titleList, dataList, null);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出多个Sheet页签的Excel（2007及以上版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param sheetNames 页面名称数组
     * @param titleList 标题数组。格式：[["key: value", "key1: value1"]]
     * @param dataList 数据集合。格式：[[{"key: data", "key1: data1"}, "key: data", "key1: data1"]]
     */
    public static void exportMultiSheetExcel07 (HttpServletResponse response, String fileName, String[] sheetNames, List<String[]> titleList, List<List<Map<String, Object>>> dataList) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new XSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportMultiSheetExcel(wb, sheetNames, titleList, dataList, null);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出多个Sheet页签的Excel（2003版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param sheetNames 页面名称数组
     * @param titleList 标题数组。格式：[["key: value", "key1: value1"]]
     * @param dataList 数据集合。格式：[[{"key: data", "key1: data1"}, "key: data", "key1: data1"]]
     * @param cellWidthList 列宽，从0开始。格式：[["0: 15", "1: 15"]]
     */
    public static void exportMultiSheetExcel03 (HttpServletResponse response, String fileName, String[] sheetNames, List<String[]> titleList, List<List<Map<String, Object>>> dataList, List<String[]> cellWidthList) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new HSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportMultiSheetExcel(wb, sheetNames, titleList, dataList, cellWidthList);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出多个Sheet页签的Excel（2007及以上版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param sheetNames 页面名称数组
     * @param titleList 标题数组。格式：[["key: value", "key1: value1"]]
     * @param dataList 数据集合。格式：[[{"key: data", "key1: data1"}, "key: data", "key1: data1"]]
     * @param cellWidthList 列宽，从0开始。格式：[["0: 15", "1: 15"]]
     */
    public static void exportMultiSheetExcel07 (HttpServletResponse response, String fileName, String[] sheetNames, List<String[]> titleList, List<List<Map<String, Object>>> dataList, List<String[]> cellWidthList) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new XSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportMultiSheetExcel(wb, sheetNames, titleList, dataList, cellWidthList);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出多个Sheet页签的Excel（2003版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param titleList 标题数组。格式：[["key: value", "key1: value1"]]
     * @param dataList 数据集合。格式：[[{"key: data", "key1: data1"}, "key: data", "key1: data1"]]
     * @param cellWidthList 列宽，从0开始。格式：[["0: 15", "1: 15"]]
     */
    public static void exportMultiSheetExcel03 (HttpServletResponse response, String fileName, List<String[]> titleList, List<List<Map<String, Object>>> dataList, List<String[]> cellWidthList) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new HSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportMultiSheetExcel(wb, null, titleList, dataList, cellWidthList);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出多个Sheet页签的Excel（2007及以上版本）
     * @param response 响应对象
     * @param fileName 文件名称
     * @param titleList 标题数组。格式：[["key: value", "key1: value1"]]
     * @param dataList 数据集合。格式：[[{"key: data", "key1: data1"}, "key: data", "key1: data1"]]
     * @param cellWidthList 列宽，从0开始。格式：[["0: 15", "1: 15"]]
     */
    public static void exportMultiSheetExcel07 (HttpServletResponse response, String fileName, List<String[]> titleList, List<List<Map<String, Object>>> dataList, List<String[]> cellWidthList) {
        // 第一步：创建工作工作空间，对应一个Excel文件
        Workbook wb = new XSSFWorkbook();
        // 第二步：向工作工作空间中写入内容
        exportMultiSheetExcel(wb, null, titleList, dataList, cellWidthList);
        // 第三步：将文件输出到客户端浏览器
        outExcelToClient(response, wb, fileName);
    }

    /**
     * 导出多个Sheet页签的Excel
     * @param wb 工作空间
     * @param sheetNames 页面名称数组
     * @param titleList 标题数组。格式：[["key: value", "key1: value1"]]
     * @param dataList 数据集合。格式：[[{"key: data", "key1: data1"}, "key: data", "key1: data1"]]
     * @param cellWidthList 列宽，从0开始。格式：[["0: 15", "1: 15"]]
     */
    private static void exportMultiSheetExcel(Workbook wb, String[] sheetNames, List<String[]> titleList, List<List<Map<String, Object>>> dataList, List<String[]> cellWidthList) {
        // 判断数据是否为空，如果为空，则抛出异常
        if (dataList == null || dataList.size() == 0) {
            throw new RuntimeException("数据不能为空，请确认！");
        } else {
            // 循环判断数据是否为空
            for (List<Map<String, Object>> list : dataList) {
                if (list == null || list.size() == 0) {
                    throw new RuntimeException("数据不能为空，请确认！");
                }
            }
        }

        // 样式（画笔）
        CellStyle cellStyle = getStyle(wb);
        for (int i = 0, size = titleList.size(); i < size; i++) {
            // 页签名称
            String sheetName = null;
            // 如果页面名称为空，则使用默认的页签名称
            if (sheetNames != null && sheetNames.length > 0 && sheetNames[i] != null && !"".equals(sheetNames[i])) {
                sheetName = sheetNames[i];
            } else {
                sheetName = "Sheet " + (i + 1);
            }
            // 标题信息
            Map<String, String[]> titleMap = getSimpleTitleInfo(titleList.get(i));
            // value（名称）
            String[] values = titleMap.get("values");

            // 第一步：创建页签
            Sheet sheet = wb.createSheet(sheetName);
            // 第二步：创建标题行
            Row titleRow = sheet.createRow(0);
            // 设置行高
            titleRow.setHeightInPoints(20);
            // 第三步：创建标题单元格，并给单元格赋值
            for (int j = 0, length = values.length; j < length; j++) {
                // 列（单元格）
                Cell titleCell = titleRow.createCell(j);
                titleCell.setCellValue(values[j]);
                // 设置样式
                titleCell.setCellStyle(cellStyle);
            }

            // 第四步：添加数据体
            addData(sheet, cellStyle, titleMap, 0, 0, dataList.get(i));

            // 第五步：设置列宽
            if (cellWidthList != null && cellWidthList.size() > 0) {
                setCellWidth(sheet, cellWidthList.get(i));
            }
        }
    }

    /**
     * 根据模版导出Excel(2003版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportExcelByTemp03 (HttpServletResponse response, String tempFileName, String outFileName, List<LinkedHashMap<String, Object>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new HSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            exportExcelByTemp(wb, null, null, null, dataList, images);
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出Excel(2007及以上版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportExcelByTemp07 (HttpServletResponse response, String tempFileName, String outFileName, List<LinkedHashMap<String, Object>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new XSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            exportExcelByTemp(wb, null, null, null, dataList, images);
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出Excel(2003版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param startRow 开始行，从0开始
     * @param startCell 开始列，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportExcelByTemp03 (HttpServletResponse response, String tempFileName, String outFileName, Integer startRow, Integer startCell, List<LinkedHashMap<String, Object>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new HSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            exportExcelByTemp(wb, null, startRow, startCell, dataList, images);
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出Excel(2007及以上版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param startRow 开始行，从0开始
     * @param startCell 开始列，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportExcelByTemp07 (HttpServletResponse response, String tempFileName, String outFileName, Integer startRow, Integer startCell, List<LinkedHashMap<String, Object>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new XSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            exportExcelByTemp(wb, null, startRow, startCell, dataList, images);
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出Excel(2007及以上版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param startRow 开始行，从0开始
     * @param startCell 开始列，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void customExportExcel (HttpServletResponse response, String tempFileName, String outFileName, Integer startRow, Integer startCell, Map<String, Object> params, List<LinkedHashMap<String, Object>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new XSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            customExportExcelByTemp(wb, null, startRow, startCell,params,dataList, images);
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }



    /**
     * 根据模版导出Excel(2003版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param sheetIndex Sheet页签索引，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportExcelByTemp03 (HttpServletResponse response, String tempFileName, String outFileName, Integer sheetIndex, List<LinkedHashMap<String, Object>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new HSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            exportExcelByTemp(wb, sheetIndex, null, null, dataList, images);
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出Excel(2007及以上版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param sheetIndex Sheet页签索引，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportExcelByTemp07 (HttpServletResponse response, String tempFileName, String outFileName, Integer sheetIndex, List<LinkedHashMap<String, Object>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new XSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            exportExcelByTemp(wb, sheetIndex, null, null, dataList, images);
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出Excel(2003版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param sheetIndex Sheet页签索引，从0开始
     * @param startRow 开始行，从0开始
     * @param startCell 开始列，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportExcelByTemp03 (HttpServletResponse response, String tempFileName, String outFileName, Integer sheetIndex, Integer startRow, Integer startCell, List<LinkedHashMap<String, Object>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new HSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            exportExcelByTemp(wb, sheetIndex, startRow, startCell, dataList, images);
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出Excel(2007及以上版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param sheetIndex Sheet页签索引，从0开始
     * @param startRow 开始行，从0开始
     * @param startCell 开始列，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportExcelByTemp07 (HttpServletResponse response, String tempFileName, String outFileName, Integer sheetIndex, Integer startRow, Integer startCell, List<LinkedHashMap<String, Object>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new XSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            exportExcelByTemp(wb, sheetIndex, startRow, startCell, dataList, images);
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出多个Sheet页签的Excel(2003版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportMultiSheetExcelByTemp03 (HttpServletResponse response, String tempFileName, String outFileName, List<List<LinkedHashMap<String, Object>>> dataList, Image... images) {
        if (dataList == null || dataList.size() == 0) {
            throw new RuntimeException("数据不能为空，请确认！");
        }

        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new HSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            for (int i = 0, size = dataList.size(); i < size; i++) {
                exportExcelByTemp(wb, i, null, null, dataList.get(i), images);
            }
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出多个Sheet页签的Excel(2007及以上版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportMultiSheetExcelByTemp07 (HttpServletResponse response, String tempFileName, String outFileName, List<List<LinkedHashMap<String, Object>>> dataList, Image... images) {
        if (dataList == null || dataList.size() == 0) {
            throw new RuntimeException("数据不能为空，请确认！");
        }

        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new XSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            for (int i = 0, size = dataList.size(); i < size; i++) {
                exportExcelByTemp(wb, i, null, null, dataList.get(i), images);
            }
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出多个Sheet页签的Excel(2003版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param startRows 开始行数组，每个Sheet 页签一个，从0开始
     * @param startCells 开始列集合，每个Sheet 页签一个，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportMultiSheetExcelByTemp03 (HttpServletResponse response, String tempFileName, String outFileName, Integer[] startRows, Integer[] startCells, List<List<LinkedHashMap<String, Object>>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new HSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            for (int i = 0, size = startRows.length; i < size; i++) {
                List<LinkedHashMap<String, Object>> list = (dataList != null && dataList.size() > 0) ? dataList.get(i) : null;
                exportExcelByTemp(wb, i, startRows[i], startCells[i], list, images);
            }
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出多个Sheet页签的Excel(2007及以上版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param startRows 开始行数组，每个Sheet 页签一个，从0开始
     * @param startCells 开始列集合，每个Sheet 页签一个，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportMultiSheetExcelByTemp07 (HttpServletResponse response, String tempFileName, String outFileName, Integer[] startRows, Integer[] startCells, List<List<LinkedHashMap<String, Object>>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new XSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            for (int i = 0, size = startRows.length; i < size; i++) {
                List<LinkedHashMap<String, Object>> list = (dataList != null && dataList.size() > 0) ? dataList.get(i) : null;
                exportExcelByTemp(wb, i, startRows[i], startCells[i], list, images);
            }
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出多个Sheet页签的Excel(2003版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param sheetIndexs Sheet页签索引数组，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportMultiSheetExcelByTemp03 (HttpServletResponse response, String tempFileName, String outFileName, Integer[] sheetIndexs, List<List<LinkedHashMap<String, Object>>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new HSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            for (int i = 0, size = sheetIndexs.length; i < size; i++) {
                List<LinkedHashMap<String, Object>> list = (dataList != null && dataList.size() > 0) ? dataList.get(i) : null;
                exportExcelByTemp(wb, sheetIndexs[i], null, null, list, images);
            }
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出多个Sheet页签的Excel(2007及以上版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param sheetIndexs Sheet页签索引数组，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportMultiSheetExcelByTemp07 (HttpServletResponse response, String tempFileName, String outFileName, Integer[] sheetIndexs, List<List<LinkedHashMap<String, Object>>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new XSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            for (int i = 0, size = sheetIndexs.length; i < size; i++) {
                List<LinkedHashMap<String, Object>> list = (dataList != null && dataList.size() > 0) ? dataList.get(i) : null;
                exportExcelByTemp(wb, sheetIndexs[i], null, null, list, images);
            }
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出多个Sheet页签的Excel(2003版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param sheetIndexs Sheet页签索引数组，从0开始
     * @param startRows 开始行数组，每个Sheet 页签一个，从0开始
     * @param startCells 开始列集合，每个Sheet 页签一个，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportMultiSheetExcelByTemp03 (HttpServletResponse response, String tempFileName, String outFileName, Integer[] sheetIndexs, Integer[] startRows, Integer[] startCells, List<List<LinkedHashMap<String, Object>>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new HSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            for (int i = 0, size = sheetIndexs.length; i < size; i++) {
                List<LinkedHashMap<String, Object>> list = (dataList != null && dataList.size() > 0) ? dataList.get(i) : null;
                exportExcelByTemp(wb, sheetIndexs[i], startRows[i], startCells[i], list, images);
            }
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出多个Sheet页签的Excel(2007及以上版本)
     * @param response 响应对象
     * @param tempFileName 模版文件名
     * @param outFileName 输出文件名
     * @param sheetIndexs Sheet页签索引数组，从0开始
     * @param startRows 开始行数组，每个Sheet 页签一个，从0开始
     * @param startCells 开始列集合，每个Sheet 页签一个，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static void exportMultiSheetExcelByTemp07 (HttpServletResponse response, String tempFileName, String outFileName, Integer[] sheetIndexs, Integer[] startRows, Integer[] startCells, List<List<LinkedHashMap<String, Object>>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new XSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            for (int i = 0, size = sheetIndexs.length; i < size; i++) {
                List<LinkedHashMap<String, Object>> list = (dataList != null && dataList.size() > 0) ? dataList.get(i) : null;
                exportExcelByTemp(wb, sheetIndexs[i], startRows[i], startCells[i], list, images);
            }
            // 第三步：将文件输出到客户端浏览器
            outExcelToClient(response, wb, outFileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 根据模版导出Excel
     * @param wb 工作空间，对应Excel文件
     * @param sheetIndex Sheet页签索引，从0开始
     * @param startRow 开始行，从0开始
     * @param startCell 开始列，从0开始
     * @param dataList 数据集合，不能为空
     */
    private static void exportExcelByTemp(Workbook wb, Integer sheetIndex, Integer startRow, Integer startCell, List<LinkedHashMap<String, Object>> dataList, Image... images) {
        // Sheet页签，从0开始
        sheetIndex = (sheetIndex != null && sheetIndex > 0) ? sheetIndex : 0;

        // 第一步：获取Sheet页签
        Sheet sheet = wb.getSheetAt(sheetIndex);
        // 如果页签不存在，则创建页签
        sheet = sheet != null ? sheet : wb.createSheet();
        if (dataList != null && dataList.size() > 0) {
            // 开始行
            startRow = (startRow != null && startRow > 0) ? startRow : 0;
            // 开始列
            startCell = (startCell != null && startCell > 0) ? startCell : 0;
            // 样式（画笔）
            CellStyle cellStyle = getStyle(wb);



            for (int i = 0, size = dataList.size(); i < size; i++) {
                // 第二步：获取行

                Row row = sheet.getRow(startRow + i);
                if(row == null){
                    row = sheet.createRow(startRow + i);
                }
                // 设置行高
                row.setHeightInPoints(20);

                LinkedHashMap<String, Object> dataMap = dataList.get(0);
                int j = 0;
                for (Map.Entry<String, Object> entry : dataMap.entrySet()) {
                    // 第三步： 获取单元格
                    Cell cell = row.createCell(startCell + j);
                    // Cell cell = row.getCell(startRow + j);
                    // 设置单元格类型为字符串
                    cell.setCellType(CellType.STRING);
                    cell.setCellValue(String.valueOf(entry.getValue()));
                    cell.setCellStyle(cellStyle);
                    j++;
                    entry = null;
                }

                dataList.remove(0);
            }
        }

        if (images != null && images.length > 0) {
            // 画图的顶级管理器，一个sheet只能获取一个（一定要注意这点）
            Drawing drawing = sheet.createDrawingPatriarch();
            for (Image image : images) {
                // 如果图片为该页签下的图，则画图
                if (image != null && image.getSheetIndex() == sheetIndex) {
                    // 画图
                    drawing(wb, drawing, image);
                }
            }
        }
    }

    /**
     * 自定义模版导出Excel（主要针对于同比环比分析导出）
     * @param wb 工作空间，对应Excel文件
     * @param sheetIndex Sheet页签索引，从0开始
     * @param startRow 开始行，从0开始
     * @param startCell 开始列，从0开始
     * @param params 传入参数
     * @param dataList 数据集合，不能为空
     */
    private static void customExportExcelByTemp(Workbook wb, Integer sheetIndex, Integer startRow, Integer startCell, Map<String, Object> params,List<LinkedHashMap<String, Object>> dataList, Image... images) {
        // Sheet页签，从0开始
        sheetIndex = (sheetIndex != null && sheetIndex > 0) ? sheetIndex : 0;
        // 第一步：获取Sheet页签
        Sheet sheet = wb.getSheetAt(sheetIndex);
        // 如果页签不存在，则创建页签
        sheet = sheet != null ? sheet : wb.createSheet();
        // 开始行
        startRow = (startRow != null && startRow > 0) ? startRow : 0;
        // 开始列
        startCell = (startCell != null && startCell > 0) ? startCell : 0;
        // 样式（画笔）
        CellStyle cellStyle = getStyle(wb);

        // 设置标题名称
        String countyNum = ParamUtils.getString(params, "countyNum");
        String unit = ParamUtils.getString(params, "unit");
        /**获取第一行**/
        Row oneRow = sheet.getRow(0);
        Cell oneCell = oneRow.getCell(1);
        oneCell.setCellType(CellType.STRING);
        Row twoRow = sheet.getRow(1);
        Cell cell2 = twoRow.getCell(1);
        cell2.setCellType(CellType.STRING);
        if ("allCounty".equals(countyNum)) {
            oneCell.setCellValue(ParamUtils.getString(params, "formatType"));
            Cell cell3 = twoRow.getCell(2);
            Cell cell4 = twoRow.getCell(3);
            Cell cell5 = twoRow.getCell(4);
            String[] dateArr = ParamUtils.getString(params, "chooseDate").split("-");
            cell2.setCellValue((Integer.parseInt(dateArr[0]) - 1)+"年"+dateArr[1]+"月" + unit);
            cell3.setCellType(CellType.STRING);
            cell3.setCellValue(dateArr[0]+"年"+dateArr[1]+"月" + unit);
            cell4.setCellType(CellType.STRING);
            cell4.setCellValue(dateArr[0]+"年"+dateArr[1]+"月同比变化率（%）");

            if ("TB".equals(ParamUtils.getString(params, "compareType"))) {
                Cell cell6 = twoRow.getCell(5);
                Cell cell7 = twoRow.getCell(6);
                cell5.setCellType(CellType.STRING);
                cell5.setCellValue((Integer.parseInt(dateArr[0]) - 1)+"年01月~"+dateArr[1]+"月" + unit);
                cell6.setCellType(CellType.STRING);
                cell6.setCellValue(dateArr[0]+"年01~"+dateArr[1]+"月" + unit);
                cell7.setCellType(CellType.STRING);
                cell7.setCellValue(dateArr[0]+"年01~"+dateArr[1]+"月同比变化率（%）");
            }else if ("HB".equals(ParamUtils.getString(params, "compareType"))) {
                cell5.setCellType(CellType.STRING);
                cell5.setCellValue(dateArr[0]+"年"+dateArr[1]+"月环比变化率（%）");
            }
        }else {
            oneCell.setCellValue(ParamUtils.getString(params, "regionName"));
            cell2.setCellValue(ParamUtils.getString(params, "pollutantType")+"浓度" + unit);
        }

        if (dataList != null && dataList.size() > 0) {
            for (int i = 0, size = dataList.size(); i < size; i++) {
                Row row = sheet.createRow(startRow + i);
                // 设置行高
                row.setHeightInPoints(20);

                LinkedHashMap<String, Object> dataMap = dataList.get(0);
                int j = 0;
                for (Map.Entry<String, Object> entry : dataMap.entrySet()) {
                    // 第三步： 获取单元格
                    Cell cell = row.createCell(startCell + j);
                    // 设置单元格类型为字符串
                    cell.setCellType(CellType.STRING);
                    cell.setCellValue(String.valueOf(entry.getValue()));
                    cell.setCellStyle(cellStyle);
                    j++;
                    entry = null;
                }

                dataList.remove(0);
            }
        }

        if (images != null && images.length > 0) {
            // 画图的顶级管理器，一个sheet只能获取一个（一定要注意这点）
            Drawing drawing = sheet.createDrawingPatriarch();
            for (Image image : images) {
                // 如果图片为该页签下的图，则画图
                if (image != null && image.getSheetIndex() == sheetIndex) {
                    // 画图
                    drawing(wb, drawing, image);
                }
            }
        }
    }

    /**
     * 画图
     * @param wb 工作空间，对应一个Excel文档
     * @param image 图片信息
     */
    private static void drawing (Workbook wb, Drawing drawing, Image image) {
        InputStream is = null;
        ByteArrayOutputStream os = null;
        try {
            //Base64解码
            String base64 = image.getBase64().indexOf(",") >= 0 ? image.getBase64().split(",")[1] : image.getBase64();
            byte[] buffer = new BASE64Decoder().decodeBuffer(base64);
            is = new ByteArrayInputStream(buffer);
            // 将图片写入流中
            os = new ByteArrayOutputStream();
            BufferedImage bufferImg = ImageIO.read(is);
            // 利用Patriarch将图片写入Excel
            ImageIO.write(bufferImg, "PNG", os);

            // anchor主要用于设置图片的属性
            ClientAnchor anchor = null;
            if (wb instanceof HSSFWorkbook) {
                // Excel 03版本
                anchor = new HSSFClientAnchor(0, 0, 0, 0, (short) image.getStartCell(), (short) image.getStartRow(), (short) (image.getWidth() + image.getStartCell()), (short) (image.getHeight() + image.getStartRow()));
            } else if (wb instanceof XSSFWorkbook) {
                // Excel 07版本及以上
                anchor = new XSSFClientAnchor(0, 0, 0, 0, (short) image.getStartCell(), (short) image.getStartRow(), (short) (image.getWidth() + image.getStartCell()), (short) (image.getHeight() + image.getStartRow()));
            } else {
                throw new RuntimeException("工作空间(Workbook) 类型不匹配");
            }
            // 画图
            drawing.createPicture(anchor, wb.addPicture(os.toByteArray(), Workbook.PICTURE_TYPE_PNG));
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (os != null) {
                try {
                    os.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 获取简单标题信息
     * @param titles
     * @return
     */
    private static Map<String, String[]> getSimpleTitleInfo (String[] titles) {
        if (titles == null || titles.length == 0) {
            throw new RuntimeException("标题不能为空，请确认！");
        }

        int size = titles.length; // 标题长度
        String[] keys = new String[size], // key（编码）
                values = new String[size]; // value（名称）

        for (int i = 0; i < size; i++) {
            String title = titles[i]; // 单个标题

            if (title.indexOf(":") <= 0 || title.endsWith(":")) {
                throw new RuntimeException("标题数组中请使用key:value键值对方式，且不能用“:”开头和结尾，请确认！\n例如:\n\tCITY_NAME: 城市名称");
            } else {
                String[] temp = title.split(":"); // 根据规则截取标题
                keys[i]   = temp[0].trim();
                values[i] = temp[1].trim();
            }
        }

        // 封装结果
        Map<String, String[]> resultMap = new HashMap<String, String[]>();
        resultMap.put("keys", keys);
        resultMap.put("values", values);

        return resultMap;
    }

    /**
     * 设置列宽
     * @param sheet 页签对象
     * @param cellWidths 列宽说明
     */
    private static void setCellWidth(Sheet sheet, String[] cellWidths) {
        // 设置列宽
        if (cellWidths != null && cellWidths.length > 0) {
            for (int i = 0, cellSize = cellWidths.length; i < cellSize; i++) {
                String width = cellWidths[i];
                if (width == null || "".equals(width.trim())
                        || width.trim().endsWith(":") || width.trim().indexOf(":") <= 0) {
                    continue;
                }
                String[] temp = cellWidths[i].split(":");
                int cellIndex = Integer.parseInt(temp[0].trim()); // 列索引
                int cellWidth = Integer.parseInt(temp[1].trim()); // 列宽

                // 设置列宽
                sheet.setColumnWidth(cellIndex, (short)(cellWidth * 264));
            }
        }
    }

    /**
     * 添加数据
     * @param sheet 页签
     * @param cellStyle 列样式
     * @param titleMap 标题集合
     * @param dataList 数据集合
     */
    private static void addData(Sheet sheet, CellStyle cellStyle, Map<String, String[]> titleMap, int startRow, int startCell, List<Map<String, Object>> dataList) {
        String[] keys = titleMap.get("keys"), // key（编码）
                values = titleMap.get("values"); // value（名称）
        // 长度
        int length = values.length,
                size = dataList.size();
        for (int i = 0; i < size; i++) {
            // 数据集合
            Map<String, Object> dataMap = dataList.get(0);
            // 行
            Row row = sheet.createRow(i + 1 + startRow);
            // 设置行高
            row.setHeightInPoints(20);
            for (int j = 0; j < length; j++) {
                // 列（单元格）
                Cell cell = row.createCell(j + startCell);
                // 值
                String value = dataMap.get(keys[j]) != null ? String.valueOf(dataMap.get(keys[j])) : "";
                cell.setCellValue(value);
                // 设置样式
                cell.setCellStyle(cellStyle);
            }

            dataMap = null;
            dataList.remove(0);
        }
    }

    /**
     * 获取样式
     * @param wb 工作空间
     * @return
     */
    private static CellStyle getStyle(Workbook wb) {
        // 设置字体;
        Font font = wb.createFont();
        // 设置字体大小;
        font.setFontHeightInPoints((short) 12);
        // 设置字体名字;
        font.setFontName("Courier New");
        // font.setItalic(true); // 斜体
        // font.setStrikeout(true); // 删除线
        // 设置样式;
        CellStyle style = wb.createCellStyle();
        // 设置底边框;
        style.setBorderBottom(BorderStyle.THIN);
        // 设置底边框颜色;
        style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
        // 设置左边框;
        style.setBorderLeft(BorderStyle.THIN);
        // 设置左边框颜色;
        style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
        // 设置右边框;
        style.setBorderRight(BorderStyle.THIN);
        // 设置右边框颜色;
        style.setRightBorderColor(IndexedColors.BLACK.getIndex());
        // 设置顶边框;
        style.setBorderTop(BorderStyle.THIN);
        // 设置顶边框颜色;
        style.setTopBorderColor(IndexedColors.BLACK.getIndex());
        // 在样式用应用设置的字体;
        style.setFont(font);
        // 设置自动换行;
        style.setWrapText(false);
        // 设置水平对齐的样式为居中对齐;
        style.setAlignment(HorizontalAlignment.CENTER);
        // 设置垂直对齐的样式为居中对齐;
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        return style;
    }

    /**
     * 输入Excel文件到客户端
     * @param response 响应对象
     * @param wb 工作空间，对应一个Excel文件
     * @param fileName Excel文件名
     */
    private static void outExcelToClient (HttpServletResponse response, Workbook wb, String fileName) {
        OutputStream out = null;
        try {
            response.addHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
            response.setContentType("application/vnd.ms-excel; charset=UTF-8");
            out = response.getOutputStream();
            wb.write(out);
            out.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private static String getFilePath (String fileName) throws UnsupportedEncodingException {
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

    public static XSSFWorkbook createXSSFWorkbook2(String templateFilePath, int sheetIndex, int startRow, int startCell, String[] keys, List<Map<String, Object>> dataList, Image... images) throws IOException {
        XSSFWorkbook wb = null;
        InputStream is = null;
        try {
            is = new FileInputStream(templateFilePath);
            // 创建工作空间
            wb = new XSSFWorkbook(is);

            // 获取Sheet页签
            Sheet sheet = wb.getSheetAt(sheetIndex);
            // 获取数据行每列样式
            CellStyle[] cellStyles = new CellStyle[keys.length];
            short rowHeight = 20;
            if (keys != null) {
                Row row = sheet.getRow(startRow);
                rowHeight = row.getHeight();
                for (int i = 0; i < keys.length; i++) {
                    Cell cell = row.getCell(i);
                    if (cell == null) {
                        cell = row.createCell(i);
                        cellStyles[i] = cell.getCellStyle();
                        cell.setCellValue("");
                    }
                }
            }

            if (dataList != null && dataList.size() > 0) {
                for (int i = 0, size = dataList.size(); i < size; i++) {
                    Map<String, Object> map = dataList.get(i);
                    // 获取行
                    Row row = sheet.getRow(startRow + i);
                    if (row == null) {
                        row = sheet.createRow(startRow + i);
                    }
                    // 设置行高
                    row.setHeight(rowHeight);
                    for (int j = 0; j < keys.length; j++) {
                        Cell cell = row.getCell(j);
                        if (cell == null) {
                            cell = row.createCell(j);
                        }

                        cell.setCellStyle(cellStyles[j]);
                        cell.setCellType(CellType.STRING);
                        cell.setCellValue((map.get(keys[j]) == null || "".equals(String.valueOf(map.get(keys[j])))) ? "--" : map.get(keys[j]).toString());
                    }
                }
            }

            if (images != null && images.length > 0) {
                // 画图的顶级管理器，一个sheet只能获取一个（一定要注意这点）
                Drawing drawing = sheet.createDrawingPatriarch();
                for (Image image : images) {
                    // 如果图片为该页签下的图，则画图
                    if (image != null && image.getSheetIndex() == sheetIndex) {
                        // 画图
                        drawing(wb, drawing, image);
                    }
                }
            }

        } catch (IOException e) {
            wb = null;
            throw e;
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return wb;
    }

    /**
     * 根据模版存储Excel(2007及以上版本)
     * @param tempFileName 模版文件名
     * @param sheetIndex Sheet页签索引，从0开始
     * @param startRow 开始行，从0开始
     * @param startCell 开始列，从0开始
     * @param dataList 数据集合，不能为空
     * @param images 图片集合（可选）
     */
    public static MultipartFile getMultipartFileByTemp07 (String tempFileName,String fileName, Integer sheetIndex, Integer startRow, Integer startCell, List<LinkedHashMap<String, Object>> dataList, Image... images) {
        Workbook wb = null;
        InputStream is = null;
        MultipartFile multipartFile = null;
        try {
            is = new FileInputStream(getFilePath(tempFileName));
            // 第一步：创建工作空间，对应Excel文件
            wb = new XSSFWorkbook(is);
            // 第二步：向工作工作空间中写入内容
            exportExcelByTemp(wb, sheetIndex, startRow, startCell, dataList, images);
            // 第三步：workBook转换为
            multipartFile = workbookToCommonsMultipartFile(wb,fileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return multipartFile;
    }

    /**
     * Workbook 转 MultipartFile(CommonsMultipartFile)
     *
     * @param workbook excel文档
     * @param fileName 文件名
     * @return
     */
    public static MultipartFile workbookToCommonsMultipartFile(Workbook workbook, String fileName) {
        //Workbook转FileItem
        FileItemFactory factory = new DiskFileItemFactory(16, null);
        FileItem fileItem = factory.createItem("textField", "text/plain", true, fileName);
        try {
            OutputStream os = fileItem.getOutputStream();
            workbook.write(os);
            os.close();
            //FileItem转MultipartFile
            MultipartFile multipartFile = new CommonsMultipartFile(fileItem);
            return multipartFile;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
