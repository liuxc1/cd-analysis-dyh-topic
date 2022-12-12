package ths.project.common.util;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;

public class ReponseUtil {

    public static void downFile(HttpServletResponse response, File file, String fileName) {
        if (!file.exists()) {
            return;
        }
        byte[] buffer = new byte[4096];
        try (FileInputStream is = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            response.setContentType("application/force-download");// 设置强制下载不打开
            String encodedfileName = new String(fileName.getBytes("GBK"), "iso8859-1");
            response.addHeader("Content-Disposition", "attachment;fileName=" + encodedfileName);// 设置文件名

            int i;
            while ((i = is.read(buffer)) != -1) {
                os.write(buffer, 0, i);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
