package ths.project.common.factory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.ThreadFactory;

public class CustomThreadFactory implements ThreadFactory {

    private final String threadName;
    private final boolean daemon;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    public CustomThreadFactory(String threadName, boolean daemon) {
        this.threadName = threadName;
        this.daemon = daemon;
    }

    @Override
    public Thread newThread(Runnable r) {
        CustomThread thread = new CustomThread(r, threadName);
        thread.setDaemon(daemon);
        return thread;
    }

    private class CustomThread extends Thread {

        public CustomThread(Runnable r, String threadName) {
            super(r, threadName);
        }

        @Override
        public void run() {
            try {
                super.run();
            } catch (Exception e) {
                logger.error("", e);
            }
        }

    }
}