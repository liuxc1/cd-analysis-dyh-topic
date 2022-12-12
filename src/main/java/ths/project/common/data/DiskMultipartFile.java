package ths.project.common.data;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class DiskMultipartFile implements MultipartFile {

    private final String name;
    private final String fileName;
    private final File file;

    public DiskMultipartFile(String name, File file) {
        this.name = name;
        this.fileName = file.getName();
        this.file = file;
    }

    public DiskMultipartFile(String name, String fileName, File file) {
        this.name = name;
        this.fileName = fileName;
        this.file = file;
    }

    @Override
    public String getName() {
        return this.name;
    }

    @Override
    public String getOriginalFilename() {
        return this.fileName;
    }

    @Override
    public String getContentType() {
        return null;
    }

    @Override
    public boolean isEmpty() {
        return file == null || file.length() == 0;
    }

    @Override
    public long getSize() {
        return this.file.length();
    }

    @Override
    public byte[] getBytes() throws IOException {
        return null;
    }

    @Override
    public InputStream getInputStream() throws IOException {
        return new FileInputStream(this.file);
    }

    @Override
    public void transferTo(File dest) throws IOException, IllegalStateException {
        FileCopyUtils.copy(file, dest);
    }
}