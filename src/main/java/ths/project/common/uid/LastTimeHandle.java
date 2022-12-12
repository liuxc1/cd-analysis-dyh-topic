package ths.project.common.uid;

/**
 * 上次时间处理器（主要用于下次重启后的时间校验）
 */
public interface LastTimeHandle {
    /**
     * 获取上次时间
     *
     * @return 上次时间
     */
    long getLastTime();

    /**
     * 缓存上次时间
     *
     * @param lastTime 上次时间
     */
    void setLastTime(long lastTime);

    boolean checkCurrentTime(long currentTime);
}
