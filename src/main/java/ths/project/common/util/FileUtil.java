package ths.project.common.util;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

public class FileUtil {

    /**
     * 创建一个空白的文件（已存在则跳过）
     *
     * @param file 文件
     */
    public static void createDir(File file) {
        if (!file.exists()) {
            boolean b = file.mkdirs();
            if (!b) {
                throw new RuntimeException("文件夹创建失败！" + file.getAbsolutePath());
            }
        }

    }

    /**
     * 创建一个空白的文件（已存在则跳过）
     *
     * @param file 文件
     */
    public static void createEmptyFile(File file) {
        if (!file.exists()) {
            File parentFile = file.getParentFile();
            if (!parentFile.exists()) {
                boolean b = parentFile.mkdirs();
                if (!b) {
                    throw new RuntimeException("文件夹创建失败！" + parentFile.getAbsolutePath());
                }
            }
            try {
                boolean b = file.createNewFile();
                if (!b) {
                    throw new RuntimeException("文件创建失败！" + file.getAbsolutePath());
                }
            } catch (Exception e) {
                throw new RuntimeException("文件创建失败！" + file.getAbsolutePath(), e);
            }
        }
    }
    /**
     * 获取模板路径
     * @param fileName 文件名含后缀
     * @return
     * @throws UnsupportedEncodingException
     */
    public static String getTemplateFilePath (String fileName) throws UnsupportedEncodingException {
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
}
