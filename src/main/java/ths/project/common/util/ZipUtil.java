package ths.project.common.util;

import org.apache.commons.compress.archivers.sevenz.SevenZArchiveEntry;
import org.apache.commons.compress.archivers.sevenz.SevenZFile;
import org.apache.commons.io.FileUtils;

import java.io.*;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

public class ZipUtil {
    /**
     * 文件读取缓冲区大小
     */
    private static final int CACHE_SIZE = 4096;

    /**
     * 把zip文件解压到指定的文件夹
     */
    public static void unzip(File sourceFile, File destPath) throws IOException {
        if (destPath.exists() && destPath.listFiles() == null) {
            throw new RuntimeException("目标文件夹不为空！");
        }
        try {
            unzip(sourceFile, destPath, StandardCharsets.UTF_8);
        } catch (Exception e) {
            FileUtils.deleteDirectory(destPath);
            unzip(sourceFile, destPath, Charset.forName("GBK"));
        }
    }

    /**
     * 把zip文件解压到指定的文件夹
     */
    public static void unzip(File sourceFile, File destPath, Charset charset) throws IOException {
        if (sourceFile.exists()) {
            FileUtil.createDir(destPath);

            ZipFile zip = new ZipFile(sourceFile, ZipFile.OPEN_READ, charset);
            Enumeration<? extends ZipEntry> enumeration = zip.entries();
            while (enumeration.hasMoreElements()) {
                ZipEntry entry = enumeration.nextElement();
                String zipEntryName = entry.getName();

                File file = new File(destPath, zipEntryName);
                //处理压缩文件包含文件夹的情况
                if (entry.isDirectory()) {
                    FileUtil.createDir(file);
                    continue;
                }
                FileUtil.createEmptyFile(file);
                try (InputStream in = zip.getInputStream(entry); OutputStream out = new FileOutputStream(file);) {
                    byte[] buff = new byte[CACHE_SIZE];
                    int len;
                    while ((len = in.read(buff)) > 0) {
                        out.write(buff, 0, len);
                    }
                }
            }
        }
    }

    /**
     * 压缩文件
     *
     * @param sourceFolder 压缩文件夹
     * @param zipFilePath  压缩文件输出路径
     */
    public static void zip(String sourceFolder, String zipFilePath) throws Exception {
        ZipUtil.zip(new File(sourceFolder), new File(zipFilePath));
    }

    /**
     * 压缩文件
     *
     * @param sourceFile 被压缩的文件
     * @param zipFile    压缩文件输出路径
     */
    public static void zip(File sourceFile, File zipFile) throws IOException {
        String basePath;
        if (sourceFile.isDirectory()) {
            basePath = sourceFile.getPath();
        } else {
            basePath = sourceFile.getParent();
        }
        // 此处为了兼顾windows系统，压缩编码使用了GBK
        try (ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(zipFile), Charset.forName("GBK"))) {
            zip(sourceFile, basePath, zos);
            zos.closeEntry();
        }
    }


    /**
     * 递归压缩文件
     */
    private static void zip(File srcFile, String basePath, ZipOutputStream zos) throws IOException {
        File[] files = srcFile.isDirectory() ? srcFile.listFiles() : new File[]{srcFile};
        if (files == null || files.length == 0) {
            return;
        }

        byte[] cache = new byte[CACHE_SIZE];
        for (File file : files) {
            if (file.isDirectory()) {
                String pathName = file.getPath().substring(basePath.length() + 1) + "/";
                zos.putNextEntry(new ZipEntry(pathName));
                zip(file, basePath, zos);
            } else {
                String pathName = file.getPath().substring(basePath.length() + 1);
                ZipEntry zipEntry = new ZipEntry(pathName);
                zipEntry.setSize(file.length());
                zipEntry.setTime(file.lastModified());
                zos.putNextEntry(zipEntry);
                try (InputStream is = new FileInputStream(file)) {
                    int nRead;
                    while ((nRead = is.read(cache)) != -1) {
                        zos.write(cache, 0, nRead);
                    }
                }
            }
        }
    }

    /**
     * 递归取到当前目录所有文件
     */
    public static List<String> getFiles(String dir) {
        List<String> lstFiles = new ArrayList<>();
        File file = new File(dir);
        File[] files = file.listFiles();
        if (files != null) {
            for (File f : files) {
                if (f.isDirectory()) {
                    lstFiles.add(f.getAbsolutePath());
                    lstFiles.addAll(getFiles(f.getAbsolutePath()));
                } else {
                    String str = f.getAbsolutePath();
                    lstFiles.add(str);
                }
            }
        }
        return lstFiles;
    }


    /**
     * 7z解压缩
     * @param z7zFilePath    7z文件的全路径
     */
    public static void un7z(String z7zFilePath){

        String un7zFilePath = "";		//压缩之后的绝对路径
        SevenZFile zIn = null;
        try {
            File file = new File(z7zFilePath);
            un7zFilePath = file.getAbsolutePath().substring(0, file.getAbsolutePath().lastIndexOf(".7z"));
            zIn = new SevenZFile(file);
            SevenZArchiveEntry entry = null;
            File newFile = null;
            while ((entry = zIn.getNextEntry()) != null){
                //不是文件夹就进行解压
                if(!entry.isDirectory()){
                    newFile = new File(un7zFilePath, entry.getName());
                    if(!newFile.exists()){
                        new File(newFile.getParent()).mkdirs();   //创建此文件的上层目录
                    }
                    OutputStream out = new FileOutputStream(newFile);
                    BufferedOutputStream bos = new BufferedOutputStream(out);
                    int len = -1;
                    byte[] buf = new byte[CACHE_SIZE];
                    while ((len = zIn.read(buf)) != -1){
                        bos.write(buf, 0, len);
                    }
                    bos.flush();
                    bos.close();
                    out.close();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            try {
                if (zIn != null)
                    zIn.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {

//        /org.tukaani.xz.LZMA2OutputStream
        un7z("D:\\xxx\\DUSTCAST_20221206.7z");
    }
    /**
     * 获取压缩包中的全部文件
     * @param path	文件夹路径
     * @childName   每一个文件的每一层的路径==D==区分层数
     * @return  压缩包中所有的文件
     */
    private static Map<String, String> getFileNameList(String path, String childName) {
        Map<String, String> files = new HashMap<>();
        File file = new File(path); // 需要获取的文件的路径
        String[] fileNameLists = file.list(); // 存储文件名的String数组
        File[] filePathLists = file.listFiles(); // 存储文件路径的String数组
        for (int i = 0; i < filePathLists.length; i++) {
            if (filePathLists[i].isFile()) {
                files.put(fileNameLists[i] + "==D==" + childName, path + File.separator + filePathLists[i].getName());
            } else {
                files.putAll(getFileNameList(path + File.separator + filePathLists[i].getName(), childName + "&" + filePathLists[i].getName()));
            }
        }
        return files;
    }

}
