package ths.project.common.servlet.filter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import ths.jdp.core.context.PropertyConfigure;

/**
 * 安全域过滤器，通过判断referer防止CSRF攻击
 */
public class HttpCSRFRefererFilter implements Filter {
	/**
	 * 过滤地址列表
	 */
	private String[] referers = {};

	public HttpCSRFRefererFilter() {
		String refererStr = (String) PropertyConfigure.getProperty("filter.csrf.referers");
		if (StringUtils.isNotBlank(refererStr)) {
			String[] refererArray = refererStr.split(",");
			int length = refererArray.length;
			List<String> list = new ArrayList<>();
			for (int i = 0; i < length; i++) {
				if (StringUtils.isNotBlank(refererArray[i])) {
					list.add(refererArray[i].trim());
				}
			}
			// 如果过滤地址参数不为空，则将处理后的地址添加到过滤列表
			if (list.size() > 0) {
				this.referers = list.toArray(new String[list.size()]);
			}
		}
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		String referer = req.getHeader("Referer");
		// 验证Referer是否在预定规则中
		if (verificationReferer(referer)) {
			chain.doFilter(request, response);
		} else {
			// 如果Referer不在预定规则中，则跳转到报错页面。
			req.setAttribute("message", "CSRF拒绝！当前登录系统禁止访问本地址,请检查。");
			req.getRequestDispatcher("/WEB-INF/jsp/_main/error_500.jsp").forward(req, res);
		}
	}

	/**
	 * 验证Referer是否在预定规则中
	 * 
	 * @param referer
	 *            Referer
	 * @return true:在预定规则中，false：不在预定规则中
	 */
	private boolean verificationReferer(String referer) {
		boolean flag = false;
		// 如果过滤地址为空，或者没有Referer，则直接跳过
		if (referers.length == 0 || StringUtils.isBlank(referer)) {
			flag = true;
		} else {
			for (String ref : referers) {
				// 如果Referer中包含预定过滤地址则跳过
				if (referer.indexOf(ref)>-1) {
					flag = true;
					break;
				}
			}
		}
		return flag;
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void destroy() {
	}

}
