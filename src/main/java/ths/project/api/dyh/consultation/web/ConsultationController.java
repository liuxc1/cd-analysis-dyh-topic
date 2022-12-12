package ths.project.api.dyh.consultation.web;

import com.tencentcloudapi.wemeet.common.exception.WemeetSdkException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.web.base.BaseController;
import ths.project.common.data.DataResult;
import ths.project.common.exception.CtThsException;
import ths.project.common.util.MapUtil;
import ths.project.common.vo.ResponseVo;
import ths.project.api.dyh.consultation.service.ConsultationService;
import ths.project.system.message.service.SendMessageService;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;
import java.util.*;

/**
 * @ClassName ConsultationController
 * @Description 视频会商
 * @Author ZT
 * @Date 2021/9/29 10:12
 * @Version 1.0
 **/
@Controller
@RequestMapping("api/dyh/consultation")
public class ConsultationController extends BaseController {

    @Autowired
    private ConsultationService consultationService;


    /**
     * @return org.springframework.web.servlet.ModelAndView
     * @Author ZT
     * @Description 会商首页
     * @Date 15:43 2021/9/29
     * @Param []
     **/
    @RequestMapping("/index")
    public ModelAndView index() {
        ModelAndView result = new ModelAndView("/dyh/consultation/consultationIndex");
        return result;
    }

    /**
     * @return ths.project.common.vo.ResponseVo
     * @Author ZT
     * @Description 会商列表
     * @Date 15:58 2021/9/29
     * @Param [params, pageInfo]
     **/
    @RequestMapping("/listConsultationInfo")
    @ResponseBody
    public ResponseVo listConsultationInfo(Paging pageInfo,
                                           String CONSULT_STATUS, Integer pageSize, Integer pageNum, String START_TIME, String END_TIME, String state, String consultType, String keyWords) {
        ResponseVo vo = new ResponseVo();
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("CONSULT_STATUS", CONSULT_STATUS);
            params.put("START_TIME", START_TIME);
            params.put("END_TIME", END_TIME);
            params.put("state", state);
            params.put("consultType", consultType);
            params.put("keyWords", keyWords);
            pageInfo.setPageSize((pageSize == null || pageSize == 0) ? 10 : pageSize);
            pageInfo.setPageNum((pageNum == null || pageNum == 0) ? 1 : pageNum);
            Paging<Map<String, Object>> lists = consultationService.listConsultationInfo(params, pageInfo);
            vo.success(lists);
        } catch (Exception e) {
            e.printStackTrace();
            vo.failure();
        } finally {
            return vo;
        }
    }

    /**
     * @return org.springframework.web.servlet.ModelAndView
     * @Author ZT
     * @Description 新增/修改页面
     * @Date 16:35 2021/9/29
     * @Param [params]
     **/
    @RequestMapping("/editIndex")
    public ModelAndView editIndex(@RequestParam Map<String, Object> params) {
        ModelAndView result = new ModelAndView("/dyh/consultation/consultationEdit");
        params.put("PKID", MapUtil.getString(params, "PKID", UUID.randomUUID().toString()));
        result.addObject("form", params);
        return result;
    }

    /**
     * @return ths.project.common.vo.ResponseVo
     * @Author ZT
     * @Description 保存会商信息
     * @Date 10:34 2021/10/8
     * @Param [multipartFiles, params]
     **/
    @RequestMapping("/saveInfo")
    @ResponseBody
    public ResponseVo saveInfo(@RequestParam Map<String, Object> params) {
        ResponseVo responseVo = new ResponseVo();
        try {
            params.put("CREATE_TIME", new Date());
            consultationService.saveConsultationInfo(params);
            responseVo.success("保存成功！");
        } catch (WemeetSdkException |ParseException e) {
            e.printStackTrace();
            responseVo.failure("腾讯会议连接失败！");
        }catch (CtThsException e){
            e.printStackTrace();
            responseVo.failure("腾讯会议预约失败！");
        }catch (Exception e){
            e.printStackTrace();
            responseVo.failure("服务器繁忙，请稍后重试！");
        }
        return responseVo;
    }

    /**
     * @return ths.project.common.vo.ResponseVo
     * @Author ZT
     * @Description 查询基本信息
     * @Date 17:36 2021/10/8
     * @Param [params]
     **/
    @RequestMapping("/getBaseInfo")
    @ResponseBody
    public ResponseVo getBaseInfo(@RequestParam Map<String, Object> params) {
        ResponseVo responseVo = new ResponseVo();
        try {
            Map<String, Object> resultMap = consultationService.getBaseInfo(params);
            responseVo.success(resultMap);
        } catch (Exception e) {
            e.printStackTrace();
            responseVo.failure("服务器繁忙，请稍后重试！");
        }
        return responseVo;
    }

    /**
     * @return org.springframework.web.servlet.ModelAndView
     * @Author ZT
     * @Description 查看会商记录
     * @Date 9:19 2021/10/11
     * @Param [params]
     **/
    @RequestMapping("/showInfo")
    public ModelAndView showInfo(@RequestParam Map<String, Object> params) {
        ModelAndView result = new ModelAndView("/dyh/consultation/consultationShow");
        result.addObject("form", params);
        return result;
    }

    /**
     * @return ths.project.common.vo.ResponseVo
     * @Author ZT
     * @Description 查看部门列表
     * @Date 11:37 2021/10/11
     * @Param [params]
     **/
    @RequestMapping("/listDepts")
    @ResponseBody
    public ResponseVo listDepts(@RequestParam Map<String, Object> params) {
        ResponseVo responseVo = new ResponseVo();
        try {
            List<Map<String, Object>> resultMap = consultationService.listDepts(params);
            responseVo.success(resultMap);
        } catch (Exception e) {
            e.printStackTrace();
            responseVo.failure("服务器繁忙，请稍后重试！");
        }
        return responseVo;
    }


    /**
     * 开启快速视频会商
     * @param depts
     * @param deptNames
     * @return
     */
    @RequestMapping("/fastMeeting")
    @ResponseBody
    public DataResult fastMeeting(String depts,String deptNames) {
        Map<String,Object> result = null;
        try{
            result = consultationService.fastMeeting(depts,deptNames);
        }catch (ParseException e){
            e.printStackTrace();
            return DataResult.failure("生成会议失败，请核查该时间段是否存在预约会议！");
        }catch (WemeetSdkException e){
            e.printStackTrace();
            return DataResult.failure("腾讯会议连接失败！");
        }catch (Exception e){
            e.printStackTrace();
            return DataResult.failure("服务器繁忙，请稍后重试！");
        }
        return DataResult.success(result);
    }

    /**
     * 取消会议
     * @param id
     * @param meetingId
     * @return
     */
    @RequestMapping("/cancel")
    @ResponseBody
    public DataResult cancel(String id,String meetingId){
        Boolean result = null;
        try{
            result = consultationService.cancel(id,meetingId);
        }catch (WemeetSdkException |ParseException  e){
            e.printStackTrace();
            return DataResult.failure("腾讯会议连接失败！");
        }catch (Exception e){
            e.printStackTrace();
            return DataResult.failure("服务器繁忙，请稍后重试！");
        }
        return DataResult.success();
    }


    /**
     * 判断时间是否已经包含预约会议
     * @param params
     * @return
     */
    @RequestMapping("/cheakTime")
    @ResponseBody
    public DataResult cheakTime(@RequestParam Map<String,Object> params){
        return DataResult.success(consultationService.cheakTime(params));
    }
}
