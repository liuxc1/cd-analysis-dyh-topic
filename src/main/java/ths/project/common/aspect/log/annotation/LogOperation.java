package ths.project.common.aspect.log.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import org.springframework.core.annotation.AliasFor;

/**
 * 日志操作注解。该注解属性值优先级高于@LogModule注解<br>
 * 该注解作用于方法上，暂不支持继承。<br>
 * 该注解可以在运行时候通过反射机制获取。
 * 
 * @author liangdl
 *
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface LogOperation {
	/**
	 * 子系统，中文。<br>
	 * 可以使用变量替换，格式：${key}，其中key可以自定义。<br>
	 * 若使用变量替换，则需要将key属性值设置到HttpServletRequest域中。<br>
	 * 例如：<br>
	 * <code>
	 * &#64;Log(system = "${system}")
	 * public String list() {
	 * 	HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
	 * 	request.setAttribute("system", "分析平台");
	 * }
	 * </code>
	 * 
	 * @return
	 */
	String system() default "";

	/**
	 * 模块，中文<br>
	 * 可以使用变量替换，格式：${key}，其中key可以自定义。<br>
	 * 若使用变量替换，则需要将key属性值设置到HttpServletRequest域中。<br>
	 * 例如：<br>
	 * <code>
	 * &#64;Log(module = "${module}")
	 * public String list() {
	 * 	HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
	 * 	request.setAttribute("module", "日报分析报告");
	 * }
	 * </code>
	 * 
	 * @return
	 */
	String module() default "";

	/**
	 * 操作，中文<br>
	 * 可以使用变量替换，格式：${key}，其中key可以自定义。<br>
	 * 若使用变量替换，则需要将key属性值设置到HttpServletRequest域中。<br>
	 * 例如：<br>
	 * <code>
	 * &#64;Log(operation = "${operation}")
	 * public String list() {
	 * 	HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
	 * 	request.setAttribute("operation", "查询");
	 * }
	 * </code>
	 * 
	 * @return
	 */
	@AliasFor("value")
	String operation() default "";

	/**
	 * 同operation属性
	 * 
	 * @return
	 */
	@AliasFor("operation")
	String value() default "";

	/**
	 * 用户名<br>
	 * 可以使用变量替换，格式：${key}，其中key可以自定义。<br>
	 * 若使用变量替换，则需要将key属性值设置到HttpServletRequest域中。<br>
	 * 例如：<br>
	 * <code>
	 * &#64;Log(userName = "${userName}")
	 * public String list() {
	 * 	HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
	 * 	request.setAttribute("userName", "超级管理员");
	 * }
	 * </code>
	 * 
	 * @return
	 */
	String userName() default "";

	/**
	 * 备注<br>
	 * 可以使用变量替换，格式：${key}，其中key可以自定义。<br>
	 * 若使用变量替换，则需要将key属性值设置到HttpServletRequest域中。<br>
	 * 例如：<br>
	 * <code>
	 * &#64;Log(remark = "${remark}")
	 * public String list() {
	 * 	HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
	 * 	request.setAttribute("remark", "备注信息");
	 * }
	 * </code>
	 * 
	 * @return
	 */
	String remark() default "";

	/**
	 * 是否记录参数，默认 true<br>
	 * 
	 * 
	 * @return
	 */
	boolean isLogParam() default false;

	/**
	 * 是否记录结果，默认 false<br>
	 * 
	 * 
	 * @return
	 */
	boolean isLogResult() default false;
}
