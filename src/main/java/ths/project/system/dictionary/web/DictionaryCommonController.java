package ths.project.system.dictionary.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import ths.project.common.aspect.log.annotation.LogOperation;
import ths.project.common.data.DataResult;
import ths.project.system.dictionary.entity.Dictionary;
import ths.project.system.dictionary.entity.DictionaryTree;
import ths.project.system.dictionary.service.DictionaryCommonService;

import java.util.List;

/**
 * 字典查询公共接口
 *
 * @author L
 */
@RestController
@RequestMapping("/dictionary/dictionaryCommon")
public class DictionaryCommonController {

    @Autowired
    private DictionaryCommonService dictionaryCommonService;

    /**
     * 根据字典编码查询条目
     */
    @RequestMapping("/listByTreeCode")
    @ResponseBody
    @LogOperation(module = "字典管理", operation = "查询字典编码列表")
    public DataResult listByTreeCode(@RequestParam(name = "treeCode") String treeCode) {
        List<Dictionary> list = this.dictionaryCommonService.listByTreeCode(treeCode);
        if (list != null && list.size() > 0) {
            return DataResult.success(list);
        } else {
            return DataResult.failureNoData();
        }
    }

    /**
     * 根据字典编码查询条目
     */
    @RequestMapping("/treeListByCode")
    @ResponseBody
    @LogOperation(module = "字典管理", operation = "查询字典编码列表")
    public DataResult treeListByCode(String treeCode) {
        List<Dictionary> list = this.dictionaryCommonService.listByTreeCode(treeCode);
        if (list != null && list.size() > 0) {
            return DataResult.success(list);
        } else {
            return DataResult.failureNoData();
        }
    }

    /**
     * 根据字典编码,查询所有下级字典
     */
    @ResponseBody
    @RequestMapping("/childDictionaryTreeListByTreeCode")
    @LogOperation(module = "字典管理", operation = "查询所有下级字典")
    public DataResult childDictionaryTreeListByTreeCode(String treeCode) {
        List<DictionaryTree> list = this.dictionaryCommonService.childDictionaryTreeListByTreeCode(treeCode);
        if (list != null && list.size() > 0) {
            return DataResult.success(list);
        } else {
            return DataResult.failureNoData();
        }
    }
}
