package ths.project.system.commdata.web;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.web.LoginCache;
import ths.project.common.aspect.log.annotation.LogOperation;
import ths.project.common.data.DataResult;
import ths.project.common.util.JsonUtil;
import ths.project.system.commdata.entity.UpdateEntity;
import ths.project.system.commdata.entity.UpdateField;
import ths.project.system.commdata.entity.UpdateLog;
import ths.project.system.commdata.service.UpdataLogManageService;
import ths.project.system.commdata.vo.UpdateEntityVo;

import javax.xml.crypto.Data;
import java.util.List;
import java.util.Map;

/**
 * 数据修改记录-控制层
 *
 * @author zl
 */
@Controller
@RequestMapping("/system/commdata/updataLogManage/")
public class UpdataLogManageController {

    @Autowired
    private UpdataLogManageService updataLogManageService;

    /**
     * 新增/编辑页面
     *
     * @param model
     * @param updateEntity
     * @return
     */
    @RequestMapping("edit")
    @LogOperation(module = "修改记录管理", operation = "新增页面")
    public String edit(Model model, UpdateEntity updateEntity) {
        model.addAttribute("form", updateEntity);
        return "/system/commdata/updataLogManage_entityEdit";
    }

    /**
     * 查询修改过的字段
     *
     * @param ascriptionId
     * @return
     */
    @RequestMapping("/queryUpdateFieldCount")
    @ResponseBody
    @LogOperation(module = "修改记录管理", operation = "查询修改记录")
    public DataResult queryUpdateFieldCount(String ascriptionId) {
        Map<String, Integer> map = updataLogManageService.queryUpdateFieldCount(ascriptionId);
        if (MapUtils.isNotEmpty(map)) {
            return DataResult.success(map);
        } else {
            return DataResult.failureNoData();
        }
    }

    /**
     * 查询数据修改记录列表
     *
     * @param updateLog
     * @return
     */
    @RequestMapping("/queryDataUpdateLogList")
    @ResponseBody
    @LogOperation(module = "修改记录管理", operation = "修改记录列表")
    public DataResult queryDataUpdateLogList(UpdateLog updateLog, Paging<UpdateLog> pageInfo) {
        pageInfo = updataLogManageService.queryDataUpdateLogList(updateLog, pageInfo);
        if (pageInfo != null && CollectionUtils.isNotEmpty(pageInfo.getList())) {
            return DataResult.success(pageInfo);
        } else {
            return DataResult.failure();
        }
    }

    /**
     * 查询dbo下的系统表
     *
     * @return
     */
    @RequestMapping("/queryAllTable")
    @ResponseBody
    @LogOperation(module = "修改记录管理", operation = "查询系统表信息")
    public DataResult queryAllTable() {
        List<Map<String, Object>> list = updataLogManageService.queryAllTable();
        if (CollectionUtils.isNotEmpty(list)) {
            return DataResult.success(list);
        } else {
            return DataResult.failure();
        }
    }

    /**
     * 查询表下面的所有表字段
     *
     * @param paramMap
     * @return
     */
    @RequestMapping("/queryAllField")
    @ResponseBody
    @LogOperation(module = "修改记录管理", operation = "查询系统表信息")
    public DataResult queryAllField(@RequestParam Map<String, Object> paramMap) {
        List<Map<String, Object>> list = updataLogManageService.queryAllField(paramMap);
        if (CollectionUtils.isNotEmpty(list)) {
            return DataResult.success(list);
        } else {
            return DataResult.failure();
        }
    }

    /**
     * 保存实体配置信息
     *
     * @param updateEntityVo
     * @return
     */
    @RequestMapping("/saveEntityAndFieldInfo")
    @ResponseBody
    @LogOperation(module = "修改记录管理", operation = "保存实体配置信息")
    public DataResult saveEntityAndFieldInfo(UpdateEntityVo updateEntityVo) {
        List<UpdateField> updateFieldList = JsonUtil.toList(updateEntityVo.getUpdateField(), UpdateField.class);
        String userName = LoginCache.getLoginUser().getLoginName();
        int i = updataLogManageService.saveEntityAndFieldInfo(updateEntityVo, updateFieldList, userName);
        if (i > 0) {
            return DataResult.success();
        } else {
            return DataResult.failure();
        }
    }
}
