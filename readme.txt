1.修改数据库连接
	src/main/resources/datasource.xml
	示例中配置了两个数据源datasouce1 & datasource2; 如不需要多数据源，请删除掉datasource2相关的配置
	
2.修改应用Code 及 统一用户权限平台服务地址

	src/main/resources/conf/context.preperties
	
	#当前应用权限代码
	jdp.app.code=xxx #请设置为你的项目在统一用户权限平台中录入的应用权限代码
	
	#平台组织用户服务地址
	jdp.ou.api.context=http://localhost:8080/ou #请设置为统一用户权限平台的系统访问地址 http://{ip}:{port}/{context}
	
3. 如果项目中用到了OU提供的选择人、部门组件，请修改JS配置，如下

	src/main/webapp/common/ou/config.js
	
	//组织用户管理系统的访问地址，http://{ip}:{port}/{context}
	config.ou_server_url = "http://localhost:8080/ou";

4、公共类
	(1)获取登录用户LoginCache.getLoginUser
	(2)缓存的使用，ths.jdp.core.Cache
	(3)在任意位置拿到ths.jdp.core.web.RequestHelper
	(4)获取Spring管理的对象实例ths.jdp.context.SpringContextHelper
	(5)获取全局配置context.property中的属性值ths.jdp.context.PropertyConfigure
	(6)异常统一抛ths.jdp.exception.ThsException
	
5、代码生成
 	http://192.168.0.186:7777/autocode    用户名/密码均为admin