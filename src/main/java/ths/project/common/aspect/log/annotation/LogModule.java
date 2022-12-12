package ths.project.common.aspect.log.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import org.springframework.core.annotation.AliasFor;
/**
 * 日志模块注解。该注解属性值仅用于模块全局属性配置，不能触发切面功能<br>
 * 该注解作用于类上。<br>
 * 该注解可以在运行时候通过反射机制获取。
 * 
 * @author liangdl
 *
 */
@Documented 
@Retention(RetentionPolicy.RUNTIME)
@Inherited
@Target(ElementType.TYPE)
public @interface LogModule {
	/**
	 * 子系统，中文。<br>
	 * 
	 * @return
	 */
	String system() default "";

	/**
	 * 模块，中文<br>
	 * 
	 * @return
	 */
	@AliasFor("value")
	String module() default "";

	/**
	 * 同module属性
	 * 
	 * @return
	 */
	@AliasFor("module")
	String value() default "";
}
