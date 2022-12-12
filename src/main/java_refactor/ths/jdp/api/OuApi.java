package ths.jdp.api;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.arronlong.httpclientutil.HttpClientUtil;
import com.arronlong.httpclientutil.common.HttpConfig;
import com.arronlong.httpclientutil.exception.HttpProcessException;

import org.springframework.cache.Cache;
import ths.jdp.api.model.Login;
import ths.jdp.api.model.Menu;
import ths.jdp.api.model.OuApiConstans;
import ths.jdp.api.tool.MenuUtils;
import ths.jdp.core.cache.JdpCache;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.model.TreeNode;
import ths.jdp.core.web.LoginCache;
import ths.jdp.util.JsonUtil;

/**
 * 平台组织用户相关API
 *
 * @author jialin
 * @since 2016-7-27
 */
public class OuApi {
    protected final Logger log = LoggerFactory.getLogger(this.getClass());
    private String ctx = "";//PropertyConfigure.getProperty("jdp.ou.api.context").toString();
    private String appcode = "";//PropertyConfigure.getProperty("jdp.app.code").toString();
    private String roleids = "";
    private final String menuid = "";

    private Cache cachex = null;

    public OuApi() {
        this.ctx = String.valueOf(PropertyConfigure.getProperty("jdp.ou.api.context"));
        if (null != PropertyConfigure.getProperty("jdp.app.code")) {
            this.appcode = String.valueOf(PropertyConfigure.getProperty("jdp.app.code"));
        }
        //有些接口不需要用户登录，所以无法获取roleid
        //this.roleids=LoginCache.getLoginUser().getRoleId();
    }

    public OuApi(String appcode) {
        this.ctx = PropertyConfigure.getProperty("jdp.ou.api.context").toString();
        this.appcode = appcode;
    }

    public OuApi(String ctx, String appcode) {
        this.ctx = ctx;
        this.appcode = appcode;
    }

    public OuApi(String ctx, String appcode, String roleids) {
        this.ctx = ctx;
        this.appcode = appcode;
        this.roleids = roleids;
    }

    private Cache getCache() {
        if (this.cachex == null) {
            this.cachex = JdpCache.getCache(null);
        }
        return this.cachex;
    }

    //根据菜单信息获取左侧菜单导航
    public Menu getLeftMenuModelByMenu(String menuid, String admin) {
//			String url=ctx+getP("jdp.ou.api.getLeftMenuModel");
        if (StringUtils.isEmpty(roleids)) {
            roleids = LoginCache.getLoginUser().getRoleId();
        }
        String url = ctx + OuApiConstans.API_ALLOWMENU;
        String cacheKey = this.getClass().getName() + "getLeftMenuModelByMenu" + url + "," + roleids + "," + menuid + admin;

        Menu menu = getCache().get(cacheKey, Menu.class);
        if (menu != null) {
            return menu;
        }

        TreeNode treeNode = new OuCache().getMenuTreeNodeByMenu(url, roleids, menuid, admin, appcode);
        String leftMenuHtml = new MenuUtils().createLeftMenuHTML(treeNode.getChildren());
        menu = new Menu();
        menu.setLeftMenuHtml(leftMenuHtml);
        getCache().put(cacheKey, menu);

        return menu;
    }

    //根据菜单信息获取菜单导航
    public Menu getMenuModelByMenu(String admin, String menuid, String topFloor) {

        if (null == menuid || StringUtils.isEmpty(menuid)) {//没有传MENUID默认MENUID
            menuid = PropertyConfigure.getProperty("jdp.app.menuid").toString();
        }
        if (StringUtils.isEmpty(roleids)) {
            roleids = LoginCache.getLoginUser().getRoleId();
        }
        String url = ctx + OuApiConstans.API_ALLOWMENU;
        String cacheKey = this.getClass().getName() + "getMenuModelByMenu" + url + "," + roleids + "," + menuid + topFloor + admin;

        Menu menu = getCache().get(cacheKey, Menu.class);
        if (menu != null) {
            return menu;
        }

        TreeNode treeNode = new OuCache().getMenuTreeNodeByMenu(url, roleids, menuid, admin, appcode);
        menu = new Menu();
        menu.setTreeNode(treeNode);
        if (null == topFloor || StringUtils.isEmpty(topFloor)) {
            topFloor = treeNode.getTopFloor();
        }
        if (null == topFloor || StringUtils.isEmpty(topFloor)) {
            topFloor = "1";
        }
        menu.setTopFloor(topFloor);
        String topMenuHtml = "";
        String leftMenuHtml = "";

        if (topFloor.equals("1")) {
            treeNode.getOption().put("IS_SHOW_FIRSTMENU", "TRUE");
            treeNode.getOption().put("IS_SHOW_DROPDOWNMENU", null);
            topMenuHtml = new MenuUtils().createTopMenuHTML(treeNode);
            menu.setTopMenuHtml(topMenuHtml);
        } else if (topFloor.equals("0")) {
            treeNode.getOption().put("IS_SHOW_FIRSTMENU", null);
            treeNode.getOption().put("IS_SHOW_DROPDOWNMENU", null);
            leftMenuHtml = new MenuUtils().createLeftMenuHTML(treeNode.getChildren());
            menu.setLeftMenuHtml(leftMenuHtml);
        } else {
            treeNode.getOption().put("IS_SHOW_FIRSTMENU", "TRUE");
            treeNode.getOption().put("IS_SHOW_DROPDOWNMENU", "TRUE");
            topMenuHtml = new MenuUtils().createTopMenuHTML(treeNode);
            menu.setTopMenuHtml(topMenuHtml);
        }
        getCache().put(cacheKey, menu);
        return menu;
    }

    public Menu getMenuModelByMenu(String admin, String menuid, String topFloor, String tomenuid) {

        if (null == menuid || StringUtils.isEmpty(menuid)) {//没有传MENUID默认MENUID
            menuid = PropertyConfigure.getProperty("jdp.app.menuid").toString();
        }
        if (StringUtils.isEmpty(roleids)) {
            roleids = LoginCache.getLoginUser().getRoleId();
        }
        String url = ctx + OuApiConstans.API_ALLOWMENU;
        String cacheKey = this.getClass().getName() + "getMenuModelByMenu" + url + "," + roleids + "," + menuid + topFloor + admin + tomenuid;

        Menu menu = getCache().get(cacheKey, Menu.class);
        if (menu != null) {
            return menu;
        }
        TreeNode treeNode = new OuCache().getMenuTreeNodeByMenu(url, roleids, menuid, admin, tomenuid);
        menu = new Menu();
        menu.setTreeNode(treeNode);
        if (null == topFloor || StringUtils.isEmpty(topFloor)) {
            topFloor = treeNode.getTopFloor();
        }
        if (null == topFloor || StringUtils.isEmpty(topFloor)) {
            topFloor = "1";
        }
        menu.setTopFloor(topFloor);
        String topMenuHtml = "";
        String leftMenuHtml = "";

        if (topFloor.equals("1")) {
            treeNode.getOption().put("IS_SHOW_FIRSTMENU", "TRUE");
            treeNode.getOption().put("IS_SHOW_DROPDOWNMENU", null);
            topMenuHtml = new MenuUtils().createTopMenuHTML(treeNode, tomenuid);
            for (TreeNode node : treeNode.getChildren()) {
                Map<String, Object> option = node.getOption();
                if (option.get("active") != null && "true".equals(option.get("active").toString())) {
                    leftMenuHtml = new MenuUtils().createLeftMenuHTML(node.getChildren(), tomenuid);
                    break;
                }
            }
            menu.setTopMenuHtml(topMenuHtml);
            menu.setLeftMenuHtml(leftMenuHtml);
        } else if (topFloor.equals("0")) {
            treeNode.getOption().put("IS_SHOW_FIRSTMENU", null);
            treeNode.getOption().put("IS_SHOW_DROPDOWNMENU", null);
            leftMenuHtml = new MenuUtils().createLeftMenuHTML(treeNode.getChildren(), tomenuid);
            menu.setLeftMenuHtml(leftMenuHtml);
        } else {
            treeNode.getOption().put("IS_SHOW_FIRSTMENU", "TRUE");
            treeNode.getOption().put("IS_SHOW_DROPDOWNMENU", "TRUE");
            topMenuHtml = new MenuUtils().createTopMenuHTML(treeNode, tomenuid);
            for (TreeNode node1 : treeNode.getChildren()) {
                Map<String, Object> option1 = node1.getOption();
                if (option1.get("active") != null && "true".equals(option1.get("active").toString())) {
                    for (TreeNode node2 : node1.getChildren()) {
                        Map<String, Object> option2 = node2.getOption();
                        if (option2.get("active") != null && "true".equals(option2.get("active").toString())) {
                            leftMenuHtml = new MenuUtils().createLeftMenuHTML(node2.getChildren(), tomenuid);
                            break;
                        }
                    }
                    break;
                }
            }
            menu.setTopMenuHtml(topMenuHtml);
            menu.setLeftMenuHtml(leftMenuHtml);
        }
        getCache().put(cacheKey, menu);
        return menu;
    }

    //获取导航菜单（根据菜单编码）
    private TreeNode getTopTreeNodeByMe(String menuid, String roleids, String admin) {
        String url = ctx + OuApiConstans.API_ALLOWMENU;
        TreeNode treeNode = new OuCache().getMenuTreeNodeByMenu(url, roleids,
                menuid, admin, appcode);
        return treeNode;
    }

    //根据应用信息获取左侧菜单导航
    public Menu getLeftMenuModel(String resid, String admin) {
        if (StringUtils.isEmpty(roleids)) {
            roleids = LoginCache.getLoginUser().getRoleId();
        }

        String url = ctx + OuApiConstans.API_GETLEFTMENUMODEL;
        String cacheKey = this.getClass().getName() + "getLeftMenuModel" + url + "," + roleids + "," + appcode + resid + admin;

        Menu menu = getCache().get(cacheKey, Menu.class);
        if (menu != null) {
            return menu;
        }
        Map<String, String> resMap = new HashMap();
        TreeNode node = new OuCache().getMenuTreeNode(url, roleids, appcode, admin);
        List<TreeNode> list = new MenuUtils().getTreeMenu(node.getChildren(), resid);
        String leftMenuHtml = new MenuUtils().createLeftMenuHTML(list);
        menu = new Menu();
        menu.setLeftMenuHtml(leftMenuHtml);
        // menu.setResMap(resMap);

        getCache().put(cacheKey, menu);

        return menu;
    }

    //根据应用信息获取菜单导航
    public Menu getMenuModel(String admin) {
//		String url=ctx+getP("jdp.ou.api.getMenuModel");
        String url = ctx + OuApiConstans.API_GETMENUMODEL;
        if (StringUtils.isEmpty(roleids)) {
            roleids = LoginCache.getLoginUser().getRoleId();
        }
        String cacheKey = this.getClass().getName() + "getMenuModel" + url + "," + roleids + "," + appcode + admin;

        Menu menu = getCache().get(cacheKey, Menu.class);
        if (menu != null) {
            return menu;
        }
        Map<String, String> resMap = new HashMap();
        TreeNode treeNode = new OuCache().getMenuTreeNode(url, roleids, appcode, admin);

        menu = new Menu();
        menu.setTreeNode(treeNode);
        //  menu.setResMap(resMap);
        String topFloor = treeNode.getTopFloor();
        menu.setTopFloor(topFloor);
        String topMenuHtml = "";
        String leftMenuHtml = "";

        if (topFloor.equals("1")) {
            topMenuHtml = new MenuUtils().createTopMenuHTML(treeNode);
            menu.setTopMenuHtml(topMenuHtml);
        } else if (topFloor.equals("0")) {
            leftMenuHtml = new MenuUtils().createLeftMenuHTML(treeNode.getChildren());
            menu.setLeftMenuHtml(leftMenuHtml);
        } else {
            topMenuHtml = new MenuUtils().createTopMenuHTML(treeNode);
            menu.setTopMenuHtml(topMenuHtml);
        }

        getCache().put(cacheKey, menu);

        return menu;
    }

    public Menu getMenuModel(String admin, String tomenuid) {
//		String url=ctx+getP("jdp.ou.api.getMenuModel");
        String url = ctx + OuApiConstans.API_GETMENUMODEL;
        if (StringUtils.isEmpty(roleids)) {
            roleids = LoginCache.getLoginUser().getRoleId();
        }
        String cacheKey = this.getClass().getName() + "getMenuModel" + url + "," + roleids + "," + appcode + admin + tomenuid;

        Menu menu = getCache().get(cacheKey, Menu.class);
        if (menu != null) {
            return menu;
        }
        Map<String, String> resMap = new HashMap();
        TreeNode treeNode = new OuCache().getMenuTreeNode(url, roleids, appcode, admin, tomenuid);

        menu = new Menu();
        menu.setTreeNode(treeNode);
        //menu.setResMap(resMap);
        String topFloor = treeNode.getTopFloor();
        menu.setTopFloor(topFloor);
        String topMenuHtml = "";
        String leftMenuHtml = "";

        if (topFloor.equals("1")) {
            topMenuHtml = new MenuUtils().createTopMenuHTML(treeNode, tomenuid);
            for (TreeNode node : treeNode.getChildren()) {
                Map<String, Object> option = node.getOption();
                if (option.get("active") != null && "true".equals(option.get("active").toString())) {
                    if (node.getChildren() != null && node.getChildren().size() > 0) {
                        leftMenuHtml = new MenuUtils().createLeftMenuHTML(node.getChildren(), tomenuid);
                        break;
                    }
                }
            }
            menu.setTopMenuHtml(topMenuHtml);
            menu.setLeftMenuHtml(leftMenuHtml);
        } else if (topFloor.equals("0")) {
            leftMenuHtml = new MenuUtils().createLeftMenuHTML(treeNode.getChildren(), tomenuid);
            menu.setLeftMenuHtml(leftMenuHtml);
        } else {
            topMenuHtml = new MenuUtils().createTopMenuHTML(treeNode, tomenuid);
            for (TreeNode node1 : treeNode.getChildren()) {
                Map<String, Object> option1 = node1.getOption();
                if (option1.get("active") != null && "true".equals(option1.get("active").toString())) {
                    if (node1.getChildren() != null && node1.getChildren().size() > 0) {
                        for (TreeNode node2 : node1.getChildren()) {
                            Map<String, Object> option2 = node2.getOption();
                            if (option2.get("active") != null && "true".equals(option2.get("active").toString())) {
                                leftMenuHtml = new MenuUtils().createLeftMenuHTML(node2.getChildren(), tomenuid);
                                break;
                            }
                        }
                    }
                    break;
                }
            }
            menu.setTopMenuHtml(topMenuHtml);
            menu.setLeftMenuHtml(leftMenuHtml);
        }

        getCache().put(cacheKey, menu);

        return menu;
    }

    //登录
    public Login login(String username, String password) {
//		String url=ctx+getP("jdp.ou.api.login");
        String url = ctx + OuApiConstans.API_LOGIN;
        Map<String, Object> map = new HashMap<>();
        map.put("loginName", username);
        map.put("password", password);
        String result = null;
        Login login;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            config.json(JsonUtil.toJson(map));
            result = HttpClientUtil.post(config);

            login = JsonUtil.toObject(result, Login.class);

            if ("1".equals(login.getStatus()) && login.getUser() != null) {
                resolveUserRole(login.getUser());
                resolveUserDept(login.getUser());
            }
        } catch (Exception e) {
            log.debug("返回结果：" + result);
            throw new RuntimeException(e);
        }

        return login;
    }

    //判断是否有某个url的访问权限
    public boolean validatePermission(String permissionCode) {
        if (StringUtils.isEmpty(roleids)) {
            roleids = LoginCache.getLoginUser().getRoleId();
        }
        String cacheKey = this.getClass().getName() + "validatePermission" + permissionCode + "," + roleids + "," + appcode;

        Boolean result = getCache().get(cacheKey, Boolean.class);
        if (result != null) {
            return result;
        }
//		String urlAll=ctx+getP("jdp.ou.api.validatePermission.urlAll");
        String urlAll = ctx + OuApiConstans.API_VALIDATEPERMISSION_URLALL;
//		String urlAllow=ctx+getP("jdp.ou.api.validatePermission.urlAllow");
        String urlAllow = ctx + OuApiConstans.API_VALIDATEPERMISSION_URLALLLOW;
        Map<String, Object> allRec = new OuCache().getAllResAndOperation(urlAll, appcode);

        if (!allRec.containsKey(permissionCode)) {
            return true;
        }

        Map<String, Object> permissionRec = new OuCache().getAllowResource(urlAllow, roleids, appcode);
        result = permissionRec.containsKey(permissionCode);
        getCache().put(cacheKey, result);
        return result;
    }


    //获取页面上不能显示的操作按钮
    public String getNotAllowOperation(String permissionCode) {
//		String url=ctx+getP("jdp.ou.api.getNotAllowOperation");
        String url = ctx + OuApiConstans.API_GETNOTALLOWOPERATION;
        if (LoginCache.getLoginUser() == null) return "";
        if (StringUtils.isEmpty(roleids)) {
            roleids = LoginCache.getLoginUser().getRoleId();
        }
        return new OuCache().getNotAllowOperation(url, permissionCode, roleids, appcode);
    }


    //登录获取用户信息
    public LoginUserModel selUserByName(String username) {
        String url = ctx + OuApiConstans.API_SELUSERBYNAME;
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("loginName", username);

        LoginUserModel userModel;
        String result = null;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            config.json(JsonUtil.toJson(map));
            result = HttpClientUtil.post(config);

            Login login = JsonUtil.toObject(result, Login.class);
            userModel = login.getUser();

            if (userModel != null) {
                resolveUserRole(userModel);
                resolveUserDept(userModel);
            }

        } catch (Exception e) {
            log.debug("返回结果：" + result);
            throw new RuntimeException(e);
        }

        return userModel;
    }

    /**
     * 处理用户部门code可能为空的问题
     *
     * @param loginUser 用户信息
     */
    private void resolveUserDept(LoginUserModel loginUser) {
        Map<String, Object> dept = getDeptByLoginName(loginUser.getLoginName());
        loginUser.setDeptCode((String) dept.get("DEPT_CODE"));
    }

    /**
     * 处理用户角色id和角色code可能为空的问题
     *
     * @param userModel 用户信息
     */
    private void resolveUserRole(LoginUserModel userModel) {
        List<Map<String, Object>> roles = getRolesByUserId(userModel.getUserId());
        String[] roleCodes = new String[roles.size()];
        for (int i = 0; i < roles.size(); i++) {
            roleCodes[i] = (String) roles.get(i).get("ROLE_CODE");
        }
        userModel.setRoleCode(StringUtils.join(roleCodes, ","));
    }

    public List<Map> getRoleByAppcode() {
        String url = ctx + OuApiConstans.API_GETROLEBYAPPCODE;
        return new OuCache().getRoleByAppcode(url, appcode);
    }

    /**
     * 根据登录名获取用户详细信息
     *
     * @param loginNames 逗号分隔
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getUsersByLoginNames(String loginNames) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETUSERSBYLOGINNAMES + "?loginNames=" + loginNames;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 获取所有用户信息
     *
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getAllUsers() {
        Map<String, List<Map<String, Object>>> result = new HashMap<String, List<Map<String, Object>>>();
        String url = ctx + OuApiConstans.API_GETALLUSERS;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (HttpProcessException e) {
            throw new RuntimeException(e);
        }
        return result.get("mapList");
    }


    /**
     * 根据部门code查询部门详细信息
     *
     * @param deptCodes 逗号分隔
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getDeptsByDeptCodes(String deptCodes) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETDEPTSBYDEPTCODES + "?deptCodes=" + deptCodes;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据角色code查询角色详细信息
     *
     * @param roleCodes 逗号分隔
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getRolesByRoleCodes(String roleCodes) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETROLESBYROLECODES + "?roleCodes=" + roleCodes;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据岗位code查询岗位详细信息
     *
     * @param posiCodes 逗号分隔
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getPosisByPosiCodes(String posiCodes) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETPOSISBYPOSICODES + "?posiCodes=" + posiCodes;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据群组code查询群组详细信息
     *
     * @param groupCodes 逗号分隔
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getGroupsByGroupCodes(String groupCodes) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETGROUPSBYGROUPCODES + "?groupCodes=" + groupCodes;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据登录名获取用户详细信息
     *
     * @param loginName
     * @return
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> getUserByLoginName(String loginName) {
        Map<String, Object> result = new HashMap<String, Object>();
        String url = ctx + OuApiConstans.API_USER_GETBYLOGINNAME.replace("{loginName}", loginName);
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据USER_ID获取用户详细信息
     *
     * @param
     * @return
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> getUserByUserId(String userId) {
        Map<String, Object> result = new HashMap<String, Object>();
        String url = ctx + OuApiConstans.API_USER_GETBYUSERID + userId;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据部门code查询用户详细信息
     *
     * @param deptCodes
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getUsersByDeptCodes(String deptCodes) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETUSERSBYDEPTCODES + "?deptCodes=" + deptCodes;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据角色code查询用户详细信息
     *
     * @param
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getUsersByRoleCodes(String roleCodes) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETUSERSBYROLECODES + "?roleCodes=" + roleCodes;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据岗位code查询用户详细信息
     *
     * @param
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getUsersByPosiCodes(String posiCodes) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETUSERSBYPOSICODES + "?posiCodes=" + posiCodes;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据群组code查询用户详细信息
     *
     * @param
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getUsersByGroupCodes(String groupCodes) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETUSERSBYGROUPCODES + "?groupCodes=" + groupCodes;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据登录帐号查询部门信息，仅包含主部门
     *
     * @param loginName
     * @return
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> getDeptByLoginName(String loginName) {
        Map<String, Object> result = new HashMap<String, Object>();
        String url = ctx + OuApiConstans.API_QUERY_GETDEPTBYLOGINNAME + "?loginName=" + loginName;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据登录帐号查询部门信息,包含主部门和兼职部门
     *
     * @param loginName
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getAllDeptByLoginName(String loginName) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETALLDEPTBYLOGINNAME + "?loginName=" + loginName;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据父节点部门code查询用户详细信息（包含子部门用户）
     *
     * @param
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getDeptsByUserId(String userId) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_USER_GETDEPTSBYUSERID.replace("{userId}", userId);
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据父节点部门code查询用户详细信息（包含子部门用户）
     *
     * @param deptCode
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getUsersByParentDept(String deptCode) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETUSERSBYPARENTDEPT + "?deptCode=" + deptCode;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据行政区域代码过滤用户
     *
     * @param regionCode
     * @param loginName  以逗号分隔
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getFilterUsersByRegionCode(String regionCode, String loginName) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_REGION_GETFILTERUSERSBYREGIONCODE;
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("regionCode", regionCode);
        paramMap.put("loginName", loginName);
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.post(config.map(paramMap));
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * regionCode获取用户
     *
     * @param
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getUsersByRegionCode(String regionCode) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_REGION_GETUSERSBYREGIONCODE.replace("{regionCode}", regionCode);
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据登录名获取所有所属群组信息
     *
     * @param
     * @return
     */
    public List<Map<String, Object>> getGroupsByLoginName(String loginName) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_GETGROUPSBYLOGINNAME + "?loginName=" + loginName;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 根据父节点部门code查询用户详细信息（包含子部门用户）
     *
     * @param
     * @return
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getRolesByUserId(String userId) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        String url = ctx + OuApiConstans.API_QUERY_ROLESBYUSERID.replace("{userId}", userId);
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 获取密码修改页的信息
     *
     * @param loginName
     * @return
     */
    public Map<String, Object> getPasswordEditPageInfo(String loginName) {
        Map<String, Object> result = new HashMap<String, Object>();
        String url = ctx + OuApiConstans.API_PASSWORDEDITPAGE + "?loginName=" + loginName;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config);
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    /**
     * 修改密码
     *
     * @param paramMap 参数说明: LOGIN_NAME:用户登录名,PASSWORD:旧密码,NEW_PASSWORD:新密码
     * @return
     */
    public Map<String, Object> modifyPassword(Map<String, Object> paramMap) {
        Map<String, Object> result = new HashMap<String, Object>();
        String url = ctx + OuApiConstans.API_MODIFYPASSWORD;
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.post(config.map(paramMap));
            if (!StringUtils.isEmpty(resultJson)) {
                result = JsonUtil.toObject(resultJson, result.getClass());
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return result;
    }

    public <T> T get(String url, Map<String, Object> paramMap, Class<T> classType) {
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config.map(paramMap));
            if (!StringUtils.isEmpty(resultJson)) {
                return JsonUtil.toObject(resultJson, classType);
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return null;
    }

    public <T> T post(String url, Map<String, Object> paramMap, Class<T> classType) {
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.post(config.map(paramMap));
            if (!StringUtils.isEmpty(resultJson)) {
                return JsonUtil.toObject(resultJson, classType);
            }
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
        return null;
    }

    public String get(String url, Map<String, Object> paramMap) {
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.get(config.map(paramMap));
            return resultJson;
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    public String post(String url, Map<String, Object> paramMap) {
        try {
            HttpConfig config = HttpConfig.custom().url(url);
            String resultJson = HttpClientUtil.post(config.map(paramMap));
            return resultJson;
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

}
