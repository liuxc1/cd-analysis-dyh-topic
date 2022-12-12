package ths.project.system.user.web;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.web.LoginCache;
import ths.project.common.aspect.log.annotation.LogOperation;
import ths.project.common.data.DataResult;
import ths.project.system.user.service.DeptService;

import java.util.Map;

/**
 * 责任单位弹框树形结构接口
 *
 * @author L
 */
@Controller
@RequestMapping("/system/dept")
public class DeptController {

    @Autowired
    private DeptService deptService;

    @RequestMapping("/index")
    @LogOperation(module = "部门管理",operation="首页")
    public String index() {
        return "/system/dept/deptTreeDemo";
    }

    /**
     * 获取部门信息
     * 按类型选择
     *
     * @param paramMap 请求参数
     * @return 部门信息集合
     */
    @ResponseBody
    @RequestMapping("/queryDeptList")
    @LogOperation(module = "部门管理",operation="按类型查询部门信息")
    public DataResult queryDeptList(@RequestParam Map<String, Object> paramMap) {
        if (StringUtils.isBlank(MapUtils.getString(paramMap, "TYPES"))) {
            return DataResult.failure("必填参数内容缺失！");
        }
        paramMap.put("REGION_CODE", StringUtils.isBlank(LoginCache.getLoginUser().getRegionCode())?PropertyConfigure.getProperty("regioncode"):LoginCache.getLoginUser().getRegionCode());
        return DataResult.success(deptService.queryDeptList(paramMap));
    }

    /**
     * 获取部门信息
     * 按类型选择
     * 无登录角色权限
     *
     * @param paramMap 请求参数
     * @return 部门信息集合
     */
    @ResponseBody
    @RequestMapping("/queryDeptNotRoleList")
    @LogOperation(module = "部门管理",operation="查询部门信息")
    public DataResult queryDeptNotRoleList(@RequestParam Map<String, Object> paramMap) {
        if (StringUtils.isBlank(MapUtils.getString(paramMap, "TYPES"))) {
            return DataResult.failure("必填参数内容缺失！");
        }
        if (StringUtils.isBlank(MapUtils.getString(paramMap, "REGION_CODE"))) {
            paramMap.put("REGION_CODE", PropertyConfigure.getProperty("regioncode"));
        }
        return DataResult.success(deptService.queryDeptList(paramMap));
    }

    /**
     * 查询部门信息，统一返回
     *
     * @param paramMap 请求参数
     * @return 部门信息集合
     */
    @ResponseBody
    @RequestMapping("/queryDeptAllList")
    @LogOperation(module = "部门管理",operation="查询部门信息列表")
    public DataResult queryDeptAllList(@RequestParam Map<String, Object> paramMap) {
        if (StringUtils.isBlank(MapUtils.getString(paramMap, "TYPES"))) {
            return DataResult.failure("必填参数内容缺失！");
        }
        paramMap.put("REGION_CODE", LoginCache.getLoginUser().getRegionCode());
        return DataResult.success(deptService.queryDeptAllList(paramMap));
    }
}
