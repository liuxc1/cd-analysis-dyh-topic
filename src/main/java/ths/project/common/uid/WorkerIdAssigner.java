package ths.project.common.uid;

/**
 * WorkerId设计器，用于获取一个机器id
 */
public interface WorkerIdAssigner {

    /**
     * 获取一个机器ID
     *
     * @return assigned worker id
     */
    long getAssignedWorkerId();

}
