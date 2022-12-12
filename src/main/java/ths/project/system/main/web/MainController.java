/*
 * Copyright(C) 2000-2020 THS Technology Limited Company, http://www.ths.com.cn
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ths.project.system.main.web;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import ths.jdp.api.OuApi;
import ths.jdp.api.model.Login;
import ths.jdp.api.model.Menu;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.model.FormModel;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.base.BaseController;
import ths.jdp.util.PKUtil;
import ths.jdp.util.Tool;
import ths.project.common.aspect.log.annotation.LogOperation;
import ths.project.common.util.MD5Util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * 平台首页
 */
@Controller
public class MainController extends BaseController {

    @RequestMapping("/loginpage")
    @LogOperation(module = "系统管理", operation = "登陆页面")
    public String loginpage() {
        return "_main/login";
    }

    @RequestMapping("/login")
    @LogOperation(module = "系统管理", operation = "登陆")
    public Map<String, Object> login(@RequestBody Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) {
        String loginName = "";
        if (paramMap.get("loginName") != null) {
            loginName = String.valueOf(paramMap.get("loginName"));
        }
        String password = "";
        if (paramMap.get("password") != null) {
            password = String.valueOf(paramMap.get("password"));
        }
        Login login = getOuApi(request).login(loginName, password);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("status", login.getStatus());
        resultMap.put("message", login.getMessage());
        if ("1".equals(login.getStatus())) {
            //登录成功
            LoginCache.setLoginUser(request, response, login.getUser());
        }

        return resultMap;
    }

    @RequestMapping("/loginout")
    @LogOperation(module = "系统管理", operation = "退出")
    public String loginout(HttpServletRequest request, HttpServletResponse response) {
        LoginCache.removeLoginUser(request, response);
        request.getSession().invalidate();

        String unifiedLoginUrl = (String) PropertyConfigure.getProperty("UNIFIED_LOGIN_URL");
        String unifiedLoginFlag = (String) PropertyConfigure.getProperty("UNIFIED_LOGIN_FLAG");
        //登出跳转到统一平台登录界面
        if (StringUtils.isNotBlank(unifiedLoginFlag) && Boolean.valueOf(unifiedLoginFlag)) {

            return "redirect:" + unifiedLoginUrl;
        }

        String casContext = (String) PropertyConfigure.getProperty("jdp.cas.contextOut");
        if (casContext != null) {
            String thisContext = request.getScheme() + "://" + request.getHeader("Host") + request.getContextPath();
            return "redirect:" + casContext + "/logout?service=" + thisContext+"/";
        } else {
            return "redirect:" + request.getContextPath() + "/";
        }

    }

    @RequestMapping("/index")
    @LogOperation(module = "系统管理", operation = "首页")
    public String index(Model model, HttpServletRequest request, String tomenuid) {
        if ("THS.CD.WARN".equals(PropertyConfigure.getProperty("jdp.app.code")) && StringUtils.isEmpty(request.getParameter("appcode"))) {
            return "_main/index2";
        }

        String isAdmin = "";
        LoginUserModel loginUser = LoginCache.getLoginUser(request);
        if (loginUser.getLoginName().equals(PropertyConfigure.getProperty("superadmin"))) {
            isAdmin = "true";//是否为超级管理员
        }

        String menuid = request.getParameter("menuid");
        if (null == menuid) {
            menuid = (String) PropertyConfigure.getProperty("jdp.app.menuid");
        }

        Menu menu;
        if (StringUtils.isEmpty(menuid)) {
            //没有MENUID跳转应用，有的话跳转菜单
            if (StringUtils.isNotEmpty(tomenuid)) {
                menu = getOuApi(request).getMenuModel(isAdmin, tomenuid);
            } else {
                menu = getOuApi(request).getMenuModel(isAdmin);
            }
        } else {
            if (StringUtils.isNotEmpty(tomenuid)) {
                menu = getOuApi(request).getMenuModelByMenu(isAdmin, request.getParameter("menuid"), request.getParameter("topFloor"), tomenuid);
            } else {
                menu = getOuApi(request).getMenuModelByMenu(isAdmin, request.getParameter("menuid"), request.getParameter("topFloor"));
            }
        }
        //获取跳转菜单时需要携带的参数
        if (!Tool.isNull(tomenuid)) {
            List<String> toMenuParamList = new ArrayList<>();
            for (String param : request.getQueryString().split("&")) {
                if (!param.contains("tomenuid=")) {
                    toMenuParamList.add(param);
                }
            }
            if (toMenuParamList.size() > 0) {
                model.addAttribute("toMenuParams", StringUtils.join(toMenuParamList, "&"));
            }
        }

        model.addAttribute("topMenuHtml", menu.getTopMenuHtml());
        model.addAttribute("topFloor", menu.getTopFloor());
        model.addAttribute("leftMenuHtml", menu.getLeftMenuHtml());
        model.addAttribute("loginUser", loginUser);
        model.addAttribute("appTitle", menu.getTreeNode().getName());
        model.addAttribute("toMenuId", tomenuid);
        model.addAttribute("menuid", menuid);
        return "_main/index";
    }

    @RequestMapping("/leftmenu")
    @ResponseBody
    @LogOperation(module = "系统管理", operation = "查询菜单导航")
    public String leftmenu(HttpServletRequest request, String resid) {
        String isAdmin = "";
        LoginUserModel loginUser = LoginCache.getLoginUser(request);
        if (loginUser.getLoginName().equals(PropertyConfigure.getProperty("superadmin"))) {
            isAdmin = "true";
        }

        String menuid = request.getParameter("menuid");
        if (null == menuid) {
            menuid = (String) PropertyConfigure.getProperty("jdp.app.menuid");
        }

        Menu menu;
        if (StringUtils.isEmpty(menuid)) {
            //没有APPCODE跳转菜单，有的话跳转应用
            menu = getOuApi(request).getLeftMenuModel(resid, isAdmin);
        } else {
            menu = getOuApi(request).getLeftMenuModelByMenu(resid, isAdmin);
        }
        return menu.getLeftMenuHtml();
    }

    /**
     * 错误界面
     *
     * @param msg 错误消息
     * @return 页面模型
     */
    @RequestMapping("/error")
    @LogOperation(module = "系统管理", operation = "操作失败")
    public ModelAndView error(String msg) {
        ModelAndView mav = new ModelAndView("_common/error_500");
        try {
            String message = java.net.URLDecoder.decode(msg, "UTF-8");
            mav.addObject("message", message);
        } catch (UnsupportedEncodingException e) {
            log.error("", e);
        }
        return mav;
    }

    /**
     * 禁止操作提示
     *
     * @param path 路径
     * @return 结果
     */
    @RequestMapping("/notAllowOperation")
    @LogOperation(module = "系统管理", operation = "禁止操作")
    public Map<String, Object> notAllowOperation(String path) {
        Map<String, Object> map = new HashMap<>();
        map.put("noOp", new OuApi().getNotAllowOperation(path));
        return map;
    }

    /**
     * 修改用户密码界面
     *
     * @param loginName 登录名
     * @param service   服务名
     * @param request   请求
     * @return 结果页面
     */
    @RequestMapping("/jumpPasswordPage")
    @LogOperation(module = "系统管理", operation = "修改密码页面")
    public ModelAndView jumpPasswordPage(String loginName, String service, HttpServletRequest request) {
        if (!MD5Util.getMD5Code(LoginCache.getLoginUser().getLoginName()).equals(loginName)) {
            throw new RuntimeException("非法操作，修改用户应与当前登录用户保持一致！");
        }
        ModelAndView mav = new ModelAndView("ou/editPassword");
        OuApi ouApi = new OuApi();
        Map<String, Object> user = ouApi.getPasswordEditPageInfo(LoginCache.getLoginUser().getLoginName());
        mav.addObject("form", user);
        mav.addObject("service", service);
        String token = PKUtil.uuid();
        request.getSession().setAttribute("LAST_TOKEN", token);
        mav.addObject("LAST_TOKEN", token);
        return mav;
    }

    /**
     * 修改密码
     *
     * @param formModel 参数
     * @param request   请求
     * @return 结果
     */
    @RequestMapping("/modifyPassord")
    @ResponseBody
    @LogOperation(module = "系统管理", operation = "修改密码")
    public Map<String, Object> modifyPassord(FormModel formModel, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        if (!StringUtils.equals(formModel.getString("LAST_TOKEN"), String.valueOf(request.getSession().getAttribute("LAST_TOKEN")))) {
            request.getSession().removeAttribute("LAST_TOKEN");
            result.put("success", false);
            result.put("message", "非法操作");
            return result;
        }
        Map<String, Object> form = formModel.getForm();
        Map<String, Object> paramMap = new HashMap<>();
        for (Entry<String, Object> entry : form.entrySet()) {
            paramMap.put("form[" + entry.getKey() + "]", entry.getValue());
        }
        OuApi ouApi = new OuApi();
        result = ouApi.modifyPassword(paramMap);
        //删除session中临时的token
        request.getSession().removeAttribute("LAST_TOKEN");
        return result;
    }

    /**
     * 如果URL中有appcode参数，则从指定appcode构造菜单，否则从配置文件中配置的appcode取菜单
     *
     * @param request 请求
     * @return 实例
     */
    private OuApi getOuApi(HttpServletRequest request) {
        String appcode = request.getParameter("appcode");
        if (StringUtils.isEmpty(appcode)) {
            return new OuApi();
        }
        return new OuApi(appcode);
    }
}
