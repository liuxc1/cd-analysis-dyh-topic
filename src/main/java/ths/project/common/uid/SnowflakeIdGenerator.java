package ths.project.common.uid;

/**
 * 唯一性ID生成器（雪花算法）
 * 一般SnowFlake的结构如下(每部分用-分开，具体实现不一定遵循此规则):<br>
 * 标识位 - 时间戳差值 - 机器位 - 序列位 <br>
 * 加起来刚好64位，为一个Long型。<br>
 */
public interface SnowflakeIdGenerator extends UniqueIdGenerator {

    /**
     * 获取一个唯一性ID
     *
     * @return id
     */
    long getUniqueLongId();
}
