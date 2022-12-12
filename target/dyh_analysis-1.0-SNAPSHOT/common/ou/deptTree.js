/**
 * Created by wangml on 2016/6/21.
 * required:jQuery & jQuery.zTree
 */

/**
 *
 * @param $treeContainer Tree对象的包括HTML元素，jQuery对象
 * @param ajaxDataUrl ajax请求部门List的URL地址（jsonp）
 */
function deptTree($treeContainer,ajaxDataUrl)
{
    this.treeContainer = $treeContainer;
    this.ajaxUrl = ajaxDataUrl;
    this.zTree = null;
    this.setting = {
        data: {
            simpleData: {
                enable: true
            }
        }
    };
    this.loadingIcon = $("<i id=\"loading\" class=\"ace-icon fa fa-spinner fa-spin orange bigger-200\"></i>");
    this.boolAppendLoading = false;
    this.boolShowChildOrg = false;//是否显示子组织
    this.orgid = "root";
    this.treeData = null;//数据
    //树节点点击后触发函数
    this.nodeClickFuncName = "";
}
deptTree.prototype.setShowChildOrg = function (isShow) {
    this.boolShowChildOrg = isShow;
    return this;
}
deptTree.prototype.setNodeClickFuncName = function (func) {
    this.nodeClickFuncName = func;
    return this;
}
deptTree.prototype.loadData = function(orgid,rootid){
	this.rootid = !rootid?"":rootid;
    this.orgid = orgid;
    this.treeContainer.hide();
    if(!this.boolAppendLoading){
        this.treeContainer.before(this.loadingIcon);
        this.boolAppendLoading = true;
    }
    this.loadingIcon.show();
    var _tree = this;
    $.ajax( {
        url:this.ajaxUrl  + '?orgid=' + orgid +'&rootid='+this.rootid,
        type:'get',
        cache:false,
        dataType:'jsonp',
        success:function(data){
            _tree.treeData =data.mapList;
            _tree.render();
        },
        error : function(msg) {
            console.log(msg);
        }
    });
};
deptTree.prototype.render = function(){
    var data = this.treeData;
    if(data == null) return;
    var zNodes =[];var j = 0;
    for(var i = 0 ; i<data.length;i++)
    {
        if(!this.boolShowChildOrg && data[i].ORG_ID != this.orgid &&  (","+data[i].DEPT_PATH+",").indexOf(","+this.rootid+",")<=-1){continue;}
    
        var node = {};
        node.id = data[i].DEPT_ID;
        node.pId = data[i].PARENT != undefined?data[i].PARENT:"";
        node.name = data[i].DEPT_NAME;
        node.iconSkin = data[i].DEPT_TYPE == "1"?"org":"";
        node.id == this.orgid?node.open = true: node.open =false;
        node.click = this.nodeClickFuncName + "('" + node.id + "','" + node.name + "','"  + data[i].DEPT_CODE + "','" +data[i].ORG_ID + "');";
        zNodes[j++] =node;
    }
    //console.log(zNodes);
    zTreeObj = $.fn.zTree.init(this.treeContainer, this.setting, zNodes);
    this.treeContainer.show();
    this.loadingIcon.hide();

    zTreeObj.selectNode(zTreeObj.getNodeByParam("id", this.orgid));
};

