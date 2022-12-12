package ths.project.common.uid.config;

/**
 * 雪花算法全局配置类
 */
public class SnowflakeIdConfig {

    /**
     * 首部位数（固定为1，表示正负）
     */
    protected final int signBits = 1;
    /**
     * 时间戳差值位数（决定使用年限，默认31位，约69年）
     */
    protected int timeBits = 31;
    /**
     * 机器标识位数(决定此分布式环境中的同类型应用最大数量，默认1024台)
     */
    protected int workerBits = 10;
    /**
     * 序列位数(秒内的计数，决定每台应用每秒能够生成的ID数量，默认4194304个)
     */
    protected int sequenceBits = 22;

    /**
     * 起始时间戳，默认2011-10-31 02:40:00
     */
    protected long epochSeconds = 1320000000L;

    /**
     * stringId前缀，用于获取字符串ID时补充头部
     */
    protected String stringIdPrefix = "";
    /**
     * stringId的长度(默认同去掉连接符的UUID的长度，32位。注意：不能小于（字符串ID前缀的长度+19（无符号long转字符串后，最大长度19））)
     */
    protected int stringIdLength = 32;

    /**
     * 支持的最大机器id(移位算法,默认((2^机器标识位数)-1))
     */
    protected long maxWorkerId;

    /**
     * 机器ID在序列位左边
     */
    protected long workerShift;

    /**
     * 时间截差值在机器位左边
     */
    protected long timestampLeftShift;

    /**
     * 最大的序列数（通过位移算法算出，默认默认((2^序列位数)-1)）
     */
    protected long maxSequence;

    /**
     * 字符串ID模板（以0填充）
     */
    protected String stringIdTemplate;

    /**
     * 初始化一些扩展字段
     */
    public void initProperties() {
        maxWorkerId = ~(-1L << workerBits);
        workerShift = sequenceBits;
        timestampLeftShift = sequenceBits + workerBits;
        maxSequence = ~(-1L << sequenceBits);
        if (stringIdPrefix != null) {
            long longIdLength = stringIdLength - stringIdPrefix.length();
            if (longIdLength < 19) {
                throw new RuntimeException("字符串ID的长度减去字符串ID前缀的长度后，其长度不能小于19");
            }
            stringIdTemplate = stringIdPrefix + String.format("%0" + longIdLength + "d", 0);
        }
        long curSecond = System.currentTimeMillis() / 1000;
        if (curSecond < epochSeconds) {
            throw new RuntimeException("起始时间戳不能大于当前时刻的时间戳");
        }
    }

    public int getTimeBits() {
        return timeBits;
    }

    public void setTimeBits(int timeBits) {
        this.timeBits = timeBits;
    }

    public int getWorkerBits() {
        return workerBits;
    }

    public void setWorkerBits(int workerBits) {
        this.workerBits = workerBits;
    }

    public int getSequenceBits() {
        return sequenceBits;
    }

    public void setSequenceBits(int sequenceBits) {
        this.sequenceBits = sequenceBits;
    }

    public long getEpochSeconds() {
        return epochSeconds;
    }

    public void setEpochSeconds(long epochSeconds) {
        this.epochSeconds = epochSeconds;
    }

    public String getStringIdPrefix() {
        return stringIdPrefix;
    }

    public void setStringIdPrefix(String stringIdPrefix) {
        this.stringIdPrefix = stringIdPrefix;
    }

    public int getStringIdLength() {
        return stringIdLength;
    }

    public void setStringIdLength(int stringIdLength) {
        this.stringIdLength = stringIdLength;
    }
}
