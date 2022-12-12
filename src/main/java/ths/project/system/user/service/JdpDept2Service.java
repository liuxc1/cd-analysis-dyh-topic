package ths.project.system.user.service;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import ths.jdp.api.OuApi;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.model.LoginUserModel;
import ths.project.common.util.JsonUtil;
import ths.project.common.util.MapUtil;
import ths.project.system.user.entity.DeptInfo;

import java.lang.ref.SoftReference;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class JdpDept2Service {
    private static final String API_DEPT_ALL = "/ouapi/api/dept";
    private static final String API_DEPT_BY_ID = "/ouapi/api/dept/";

    String ctx = String.valueOf(PropertyConfigure.getProperty("jdp.ou.api.context"));
    private final OuApi ouApi = new OuApi();

    private void resolveDeptInfo(DeptInfo deptInfo, Map<String, DeptInfo> deptInfoMap) {
        String deptPath = deptInfo.getDeptPath();
        if (StringUtils.isNotBlank(deptPath)) {
            String[] deptPaths = deptPath.split(",");
            StringBuilder sb = new StringBuilder();
            for (String pathId : deptPaths) {
                sb.append("/");
                DeptInfo deptInfoParent = deptInfoMap.get(pathId);
                if (deptInfoParent != null) {
                    sb.append(deptInfoParent.getDeptName());
                } else {
                    sb.append("--");
                }
            }
            deptInfo.setDeptPathName(sb.toString());
        }
    }

    @Cacheable("JDP.CACHE.ONE_HOUR")
    public DeptInfo getDeptInfo(String deptId) {
        String result = ouApi.get(ctx + API_DEPT_BY_ID + deptId, new HashMap<>());
        Map<String, Object> map = JsonUtil.toMap(result);
        DeptInfo deptInfo = MapUtil.toBeanByUpperName(map, new DeptInfo());
        deptInfo.setDeptType(deptInfo.getExt1());
        return deptInfo;
    }

    public List<DeptInfo> getDeptInfoList(List<String> deptIdList) {
        List<DeptInfo> deptInfoList = new ArrayList<>(deptIdList.size());
        for (String deptId : deptIdList) {
            deptInfoList.add(this.getDeptInfo(deptId));
        }
        return deptInfoList;
    }

    /**
     * 获取部门类型
     * @Deprecated 请使用getDeptInfo(dept).getDeptType()
     * @param deptId 部门ID
     * @return 部门类型
     */
    @Deprecated
    @Cacheable("JDP.CACHE.ONE_HOUR")
    public String getDeptType(String deptId) {
        return getDeptInfo(deptId).getDeptType();
    }

    public List<LoginUserModel> getDeptUserList(String deptId) {
        String url = ctx + "/ouapi/api/dept/" + deptId + "/user";
        String result = ouApi.get(url, new HashMap<>());
        List<LoginUserModel> userList = new ArrayList<>();
        if (result != null && result.startsWith("[")) {
            List<Map<String, Object>> list = JsonUtil.toList(result);
            for (Map<String, Object> map : list) {
                userList.add(MapUtil.toBeanByUpperName(map, new LoginUserModel()));
            }
        }
        return userList;
    }

    @Cacheable("JDP.CACHE.ONE_HOUR")
    public List<DeptInfo> getCheckGroupList(String deptId) {
        DeptInfo deptInfo = null;
        List<DeptInfo> subDeptList = getSubDeptList(deptId);
        for (DeptInfo info : subDeptList) {
            if ("CHECK_GROUP".equals(info.getExt1())) {
                deptInfo = info;
                break;
            }
        }
        if (deptInfo != null) {
            return getSubDeptList(deptId);
        }
        return new ArrayList<>();
    }

    public List<DeptInfo> getSubDeptList(String deptId) {
        String url = ctx + "/ouapi/api/dept/" + deptId + "/dept";
        String result = ouApi.get(url, new HashMap<>());
        List<Map<String, Object>> list = JsonUtil.toList(result);
        List<DeptInfo> deptInfoList = new ArrayList<>(list.size());
        for (Map<String, Object> map : list) {
            DeptInfo deptInfo = MapUtil.toBeanByUpperName(map, new DeptInfo());
            deptInfoList.add(deptInfo);
        }
        return deptInfoList;
    }
}
