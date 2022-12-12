package ths.project.common.uid.impl;


import ths.project.common.uid.WorkerIdAssigner;

import java.util.HashMap;
import java.util.Map;

public class HttpWorkerIdAssigner implements WorkerIdAssigner {

    private String url = null;
    private Map<String, String> paramMap = new HashMap<>();

    @Override
    public long getAssignedWorkerId() {
        //TODO
        return 0;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Map<String, String> getParamMap() {
        return paramMap;
    }

    public void setParamMap(Map<String, String> paramMap) {
        this.paramMap = paramMap;
    }
}
