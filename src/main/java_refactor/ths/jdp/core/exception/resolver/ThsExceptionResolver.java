package ths.jdp.core.exception.resolver;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;
import ths.jdp.core.exception.ThsException;
import ths.jdp.util.ExceptionUtil;
import ths.jdp.util.JsonUtil;
import ths.project.common.data.DataResult;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

/**
 * 自定义的异常处理器
 *
 * @author wangjp
 */
public class ThsExceptionResolver extends SimpleMappingExceptionResolver {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private boolean printsTackTracke = false;

    @Override
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler,
                                         Exception ex) {
        // 对于处理逻辑中报错，需要打印异常信息
        logger.error("本次异常请求【" + request.getRequestURI() + "】的参数信息是:【" + getRequestParamsInfo(request) + "】");
        logger.error("", ex);
        // 返回到调用方的错误信息
        if (shouldApplyTo(request, handler)) {
            prepareResponse(ex, response);
            if (handler instanceof HandlerMethod) {
                HandlerMethod hanlderMthod = (HandlerMethod) handler;
                if (isResponseBody(hanlderMthod)) {
                    // 如果返回的是json,则直接返回错误信息
                    DataResult dataResult;
                    if (ex instanceof ThsException) {
                        dataResult = DataResult.failure(ex.getMessage());
                    } else {
                        dataResult = DataResult.failureError();
                    }
                    response(response, JsonUtil.toJson(dataResult));
                    // 返回一个空视图，防止spring的默认异常处理造成repsonsefaild
                    return new ModelAndView();
                } else {
                    ModelAndView result = doResolveException(request, response, handler, ex);
                    if (result != null) {
                        result.addObject("message", ExceptionUtil.getShortMsg(ex));
                    }
                    return result;
                }
            }
        }
        return null;
    }

    public boolean getPrintsTackTracke() {
        return printsTackTracke;
    }

    public void setPrintsTackTracke(boolean printsTackTracke) {
        this.printsTackTracke = printsTackTracke;
    }

    /**
     * 判断是否返回json
     *
     * @param handler 处理器
     * @return 是否直接返回数据
     */
    private boolean isResponseBody(HandlerMethod handler) {
        Method method = handler.getMethod();
        Annotation annotation = method.getAnnotation(ResponseBody.class);
        if (annotation == null) {
            annotation = AnnotationUtils.findAnnotation(handler.getBeanType(), RestController.class);
        }
        if (annotation == null) {
            annotation = AnnotationUtils.findAnnotation(handler.getBeanType(), ResponseBody.class);
        }
        return annotation != null;
    }

    /**
     * 返回错误信息
     *
     * @param message 消息
     */
    private void response(HttpServletResponse response, String message) {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            response.getWriter().write(message);
            response.getWriter().flush();
        } catch (IOException e) {
            logger.error("", e);
        }

    }

    /**
     * 获取本次请求的参数新息
     *
     * @param request 请求
     * @return 参数
     */
    private String getRequestParamsInfo(HttpServletRequest request) {
        Enumeration<String> parameterNames = request.getParameterNames();
        List<String> resultList = new ArrayList<>();
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            resultList.add(paramName + ":" + request.getParameter(paramName));
        }
        return StringUtils.join(resultList, ",");
    }
}
