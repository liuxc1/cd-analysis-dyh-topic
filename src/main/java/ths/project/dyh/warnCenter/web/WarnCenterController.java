package ths.project.dyh.warnCenter.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import ths.jdp.core.web.base.BaseController;
import ths.project.common.vo.ResponseVo;
import ths.project.dyh.warnCenter.service.WarnCenterService;

import java.util.List;
import java.util.Map;

/**
 * @ClassName WarnCenterController
 * @Description TODO
 * @Author ZT
 * @Date 2021/10/12 11:05
 * @Version 1.0
 **/
@Controller
public class WarnCenterController extends BaseController {

    @Autowired
    private WarnCenterService warnCenterService;

    /**
     * @Author ZT
     * @Description 主页面
     * @Date 11:12 2021/10/12
     * @Param []
     * @return org.springframework.web.servlet.ModelAndView
     **/
    @RequestMapping("/dyh/warnCenter/index")
    public ModelAndView index(){
        ModelAndView result = new ModelAndView("/dyh/warnCenter/warnCenterIndex");
        return result;
    }

    /**
     * @Author ZT
     * @Description 查询列表数据
     * @Date 11:17 2021/10/12
     * @Param [params]
     * @return ths.project.common.vo.ResponseVo
     **/
    @RequestMapping("/dyh/warnCenter/listTable")
    @ResponseBody
    public ResponseVo listTable(@RequestParam Map<String ,Object> params){
        ResponseVo responseVo = new ResponseVo();
        try {
            List<Map<String ,Object>> list = warnCenterService.listTable(params);
            responseVo.success(list);
        }catch (Exception e){
            e.printStackTrace();
            responseVo.failure("系统繁忙，请稍后再试");
        }
        return responseVo;
    }
}
