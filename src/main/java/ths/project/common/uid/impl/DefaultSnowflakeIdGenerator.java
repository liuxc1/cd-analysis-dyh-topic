package ths.project.common.uid.impl;

import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import ths.project.common.uid.LastTimeHandle;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.uid.WorkerIdAssigner;
import ths.project.common.uid.config.SnowflakeIdConfig;

import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 唯一性ID生成器（雪花算法）
 * SnowFlake的结构如下(每部分用-分开):<br>
 * 标识位 - 时间戳差值 - 机器位 - 序列位 <br>
 * 标识位，由于long基本类型在Java中是带符号的，最高位是符号位，正数是0，负数是1，所以id一般是正数，最高位是0<br>
 * 时间截差值，即（当前时间截 - 开始时间截)/1000，默认31位，可以使用约35年（从开始时间计，且保证整数位数）<br>
 * 机器位，默认10位，可以部署在1024个节点，<br>
 * 序列位，默认22位，秒内的计数，22位的计数顺序号支持每个节点每秒(同一机器，同一时间截)产生4194304个ID序号<br>
 * 加起来刚好64位，为一个Long型。<br>
 * SnowFlake的优点是，整体上按照时间自增排序，并且整个分布式系统内不会产生ID碰撞(由数据中心ID和机器ID作区分)，并且效率较高，经测试，SnowFlake每秒能够产生26万ID左右。
 */
public class DefaultSnowflakeIdGenerator extends SnowflakeIdConfig implements SnowflakeIdGenerator, InitializingBean, DisposableBean {
    /**
     * 当前机器ID
     */
    protected long workerId;
    /**
     * WorkerId设计器
     */
    protected WorkerIdAssigner workerIdAssigner;
    /**
     * 上次时间处理器
     */
    private LastTimeHandle lastTimeHandle;
    /**
     * 具体id生成器
     */
    private NextIdCreater nextIdCreater;

    private ScheduledExecutorService scheduledExecutorService;

    @Override
    public void afterPropertiesSet() {
        super.initProperties();
        if (workerIdAssigner != null) {
            workerId = workerIdAssigner.getAssignedWorkerId();
            if (workerId > this.maxWorkerId) {
                throw new RuntimeException("workerId: " + workerId + " exceeds the max " + this.maxWorkerId);
            }
        }
        if (lastTimeHandle == null) {
            lastTimeHandle = new LastTimeHandle() {
                private long lastTime = System.currentTimeMillis() / 1000 - 1;

                @Override
                public long getLastTime() {
                    return lastTime;
                }

                @Override
                public void setLastTime(long lastTime) {
                    this.lastTime = lastTime;
                }

                @Override
                public boolean checkCurrentTime(long currentTime) {
                    return currentTime > lastTime;
                }
            };
        }

        long currentSecondInit = System.currentTimeMillis() / 1000;
        if (!lastTimeHandle.checkCurrentTime(currentSecondInit)) {
            throw new RuntimeException("currentSecond: " + currentSecondInit + " is less than the lastSecond: " + lastTimeHandle.getLastTime());
        }
        this.resolveNextIdCreater(currentSecondInit);

        scheduledExecutorService = new ScheduledThreadPoolExecutor(1, r -> {
            Thread thread = new Thread(r, DefaultSnowflakeIdGenerator.class.getName() + "." + Thread.class.getName());
            return thread;
        });
        scheduledExecutorService.scheduleAtFixedRate(() -> {
            long currentSecond1 = System.currentTimeMillis() / 1000;
            if (currentSecond1 > lastTimeHandle.getLastTime()) {
                this.resolveNextIdCreater(currentSecond1);
                lastTimeHandle.setLastTime(currentSecond1);
            }
        }, 1, 1, TimeUnit.SECONDS);

    }

    private void resolveNextIdCreater(long currentSecond) {
        this.nextIdCreater = new NextIdCreater(currentSecond - epochSeconds);
    }

    @Override
    public long getUniqueLongId() {
        long nextId = this.nextIdCreater.nextId();
        if (nextId <= 0) {
            //当前id生成器序列已满，等待新的ID生成器
            int index = 0;
            int maxIndex = 5;
            try {
                while (nextId <= 0 && index < maxIndex) {
                    Thread.sleep(500);
                    nextId = this.nextIdCreater.nextId();
                    index++;
                }
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            if (index == maxIndex) {
                throw new RuntimeException("id生成失败");
            }
        }
        return nextId;
    }

    @Override
    public String getUniqueId() {
        String nextId = this.getUniqueLongId() + "";
        return stringIdTemplate.substring(0, stringIdLength - nextId.length()) + nextId;
    }

    public long getWorkerId() {
        return workerId;
    }

    public void setWorkerId(long workerId) {
        this.workerId = workerId;
    }

    public WorkerIdAssigner getWorkerIdAssigner() {
        return workerIdAssigner;
    }

    public void setWorkerIdAssigner(WorkerIdAssigner workerIdAssigner) {
        this.workerIdAssigner = workerIdAssigner;
    }

    @Override
    public void destroy() {
        scheduledExecutorService.shutdown();
    }

    /**
     * id生成器（每秒都是一个新的）
     */
    private class NextIdCreater {
        /**
         * 本次时间戳差值（秒）
         */
        private final long secondsDiffer;
        /**
         * 序列号
         */
        private long sequence = 0L;

        public NextIdCreater(long secondsDiffer) {
            this.secondsDiffer = secondsDiffer;
        }

        /**
         * 获得下一个ID (该方法是线程安全的)
         *
         * @return SnowflakeId
         */
        private synchronized long nextId() {
            // 如果是同一时间生成的，则进行毫秒内序列
            sequence = (sequence + 1) & maxSequence;
            // 毫秒内序列溢出
            if (sequence == 0) {
                return 0;
            }
            // 移位并通过或运算拼到一起组成64位的ID
            return (secondsDiffer << timestampLeftShift) | (workerId << workerShift) | sequence;
        }
    }
}
