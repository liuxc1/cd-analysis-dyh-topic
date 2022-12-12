package ths.project.api.analysissanddustforecast.service;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvValidationException;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.service.base.BaseService;
import ths.project.common.util.ZipUtil;

import java.io.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

@Service
public class AnalysisSandDustForecastService extends BaseService {
    private final Logger logger = LoggerFactory.getLogger(AnalysisSandDustForecastService.class);
    private final String sqlPackage = "ths.project.api.analysissanddustforecast.mapper.AnalysisSandDustForecastMapper";
    private final String MODEL_FILE_LOCAL_PAT = (String) PropertyConfigure.getProperty("model_file_local_path");

    private final ExecutorService downloadThreadService = Executors.newFixedThreadPool(5);
    private final ExecutorService analysisThreadService = Executors.newFixedThreadPool(5);
    private List<Map<String, Object>> regionList = new ArrayList<>();

    /**
     * 查询需要解析的预报日期
     */
    public List<Map<String, Object>> getToResolvedModelTimeList() {

        return dao.list(null, sqlPackage + ".getToResolvedModelTimeList");
    }

    /**
     * 查询需要解析数据的行政区
     */
    public List<Map<String, Object>> getAnalysisRegionList() {
        if (regionList.isEmpty()) {
            regionList = dao.list(null, sqlPackage + ".getAnalysisRegionList");
        }
        return regionList;
    }

    /**
     * 批量查询入数据
     */
    public void insertDustHourTemp(List<Map<String, Object>> dataList) {

        dao.batchInsert(sqlPackage + ".insertDustHourTemp", dataList);
    }

    /**
     * 更正至正式表
     */
    public void insertDustHour(Map<String, Object> paramMap) {

        dao.delete(paramMap, sqlPackage + ".deleteDustHour");
        dao.insert(paramMap, sqlPackage + ".insertDustHour");
    }

    /**
     * 清空临时表
     */
    public void deleteDustHourTemp() {

        dao.delete(null, sqlPackage + ".deleteDustHourTemp");
    }

    /**
     * 解析数据入口
     */
    public void parsingStart(String modelTime) throws InterruptedException {
        //清空临时表所有数据
        this.deleteDustHourTemp();
        //清理文件夹目录
        this.emptyFolder();
        //开始解析
        List<Map<String, Object>> toResolvedModelTimeList = new ArrayList<>();
        if (StringUtils.isNotBlank(modelTime)) {
            Map<String, Object> map = new HashMap<>();
            map.put("MODEL_TIME", modelTime);
            toResolvedModelTimeList.add(map);
        } else {
            toResolvedModelTimeList = this.getToResolvedModelTimeList();
        }
        this.downloadFile(toResolvedModelTimeList);
    }

    /**
     * 清空目录下的所有文件
     */
    private void emptyFolder() {
        File folder = new File(MODEL_FILE_LOCAL_PAT);
        try {
            FileUtils.cleanDirectory(folder);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 下载预报模型文件
     */
    public void downloadFile(List<Map<String, Object>> modelTimeList) {
        for (Map<String, Object> map : modelTimeList) {

            String modelTime = MapUtils.getString(map, "MODEL_TIME");
            String fileName = "DUSTCAST_" + modelTime.replaceAll("-", "") + ".7z";
            String fileUrl = PropertyConfigure.getProperty("model_file_ip") + "/DUST/" + fileName;
            String toLocalFilePath = MODEL_FILE_LOCAL_PAT + File.separator + fileName;
            map.put("fileUrl", fileUrl);
            map.put("fileName", fileName);
            map.put("modelTime", modelTime);
            map.put("toLocalFilePath", MODEL_FILE_LOCAL_PAT);

            downloadThreadService.execute(() -> {
                boolean downLoad = this.downLoad(fileUrl, toLocalFilePath);
                map.put("fileOk", downLoad);
                logger.info("文件下载" + (downLoad ? "成功" : "失败") + "========>" + map);
                //解压/解析
                if (downLoad) {
                    //解压
                    long start = System.currentTimeMillis();
                    logger.info("文件解压开始========>" + map.get("MODEL_TIME") + "解压开始时间：" + LocalDateTime.now());
                    ZipUtil.un7z(toLocalFilePath);
                    logger.info("文件解压结束========>" + map.get("MODEL_TIME") + "解压结束时间：" + LocalDateTime.now() + ",一共耗时：" + (System.currentTimeMillis() - start)+"毫秒");
                    //解析
                    try {
                        this.analysis(map);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }

            });
        }
    }

    /**
     * 解析数据
     */
    private void analysis(Map<String, Object> map) throws InterruptedException {
        logger.info("文件开始解析=====>" + map.get("MODEL_TIME"));
        //解压后的目录
        String fileFolder = MapUtils.getString(map, "toLocalFilePath") + File.separator + "DUSTCAST_" + MapUtils.getString(map, "modelTime").replaceAll("-", "") + File.separator + "NCPLOTS";
        //找到所有csv文件
        List<File> csvFileList = getCsvFileList(fileFolder);
        CountDownLatch countDownLatch = new CountDownLatch(csvFileList.size());
        for (File file : csvFileList) {
            String regionName = this.getRegionName(file.getName());
            //没有找到名称文件直接跳过了
            if (StringUtils.isBlank(regionName)) {
                continue;
            }
            analysisThreadService.execute(() -> {
                try {
                    this.exeAnalysis(map, file);
                    countDownLatch.countDown();
                } catch (IOException | CsvValidationException e) {
                    e.printStackTrace();
                }
            });
        }
        countDownLatch.await();
        //插入正式表中
        this.insertDustHour(map);
        logger.info("文件解析入正式库完成=====>" + map.get("MODEL_TIME"));
    }

    private void exeAnalysis(Map<String, Object> map, File file) throws IOException, CsvValidationException {
        CSVReader reader = new CSVReader(new FileReader(file));
        String regionName = this.getRegionName(file.getName());
        String[] record;
        int begin = 0;
        List<Map<String, Object>> dataList = new ArrayList<>();
        while ((record = reader.readNext()) != null) {
            //排除标题行
            if (0 == begin) {
                begin++;
                continue;
            }
            String dataStr = StringUtils.join(record, ",");
            //按逗号拆解数据
            String[] dataArray = dataStr.split(",");
            //封装一行的数据
            Map<String, Object> dataLineMap = new HashMap<>();
            dataLineMap.put("MODEL_TIME", MapUtils.getString(map, "MODEL_TIME"));
            dataLineMap.put("RESULT_TIME", dataArray[1]);
            dataLineMap.put("POINT_NAME", regionName);
            dataLineMap.put("MODEL", "CDAQS-DUST");
            dataLineMap.put("PM10", new BigDecimal(StringUtils.trim(dataArray[2])).setScale(3, RoundingMode.HALF_DOWN).toString());
            dataLineMap.put("PM25", new BigDecimal(StringUtils.trim(dataArray[3])).setScale(3, RoundingMode.HALF_DOWN).toString());
            dataLineMap.put("TEMP", new BigDecimal(StringUtils.trim(dataArray[4])).setScale(3, RoundingMode.HALF_DOWN).toString());
            dataLineMap.put("PCPN", new BigDecimal(StringUtils.trim(dataArray[5])).setScale(3, RoundingMode.HALF_DOWN).toString());
            dataLineMap.put("WSPD", new BigDecimal(StringUtils.trim(dataArray[6])).setScale(3, RoundingMode.HALF_DOWN).toString());
            dataLineMap.put("WDIR", new BigDecimal(StringUtils.trim(dataArray[7])).setScale(3, RoundingMode.HALF_DOWN).toString());
            dataList.add(dataLineMap);
        }
        //插入数据
        this.insertDustHourTemp(dataList);
        reader.close();
    }

    /**
     * 获取文件下的所有csv文件
     */
    private List<File> getCsvFileList(String fileFolder) {
        File fileDir = new File(fileFolder);
        List<File> list = new ArrayList<>();
        if (fileDir.exists()) {
            String[] files = fileDir.list((dir, name) -> {
                if (name.endsWith("csv")) {
                    String regionName = this.getRegionName(name);
                    if (StringUtils.isNotBlank(regionName)) {
                        List<Map<String, Object>> tempList = this.getAnalysisRegionList().stream().filter((x) -> regionName.equals(MapUtils.getString(x, "REGION_NAME"))).collect(Collectors.toList());
                        return !tempList.isEmpty();
                    }
                }
                return false;
            });
            if (files != null && files.length > 0) {
                for (String file : files) {
                    list.add(new File(fileDir, file));
                }
            }
        }
        return list;
    }

    private boolean downLoad(String fileUrl, String toLocalFilePath) {

        BufferedOutputStream bos = null;
        BufferedInputStream out = null;
        try {
            URL url = new URL(fileUrl);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod(con.getRequestMethod());
            con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            con.setRequestProperty("User-Agent", "Mozilla/4.76");
            con.setRequestProperty("connection", "keep-alive");
            con.setRequestProperty("Authorization", (String) PropertyConfigure.getProperty("model_file_authorization"));
            con.setConnectTimeout(10000);//连接超时 单位毫秒
            con.setReadTimeout(100000);//读取超时 单位毫秒
            con.setDoOutput(true);
            //判断网络文件是否存在
            if (HttpURLConnection.HTTP_OK == con.getResponseCode()) {
                out = new BufferedInputStream(con.getInputStream());
                File file = new File(toLocalFilePath);
                boolean newFile = file.createNewFile();
                bos = new BufferedOutputStream(new FileOutputStream(file));
                int bytes;
                byte[] bufferOut = new byte[2048];
                while ((bytes = out.read(bufferOut)) != -1) {
                    bos.write(bufferOut, 0, bytes);
                }
                if (newFile && file.length() > 0) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
                if (bos != null) {
                    bos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    private String getRegionName(String name) {
        if (StringUtils.isNotBlank(name)) {
            String[] split = name.split("_");
            if (split.length > 0) {
                String s = split[2];
                return s.substring(0, s.indexOf("."));
            }
        }
        return null;
    }
}
