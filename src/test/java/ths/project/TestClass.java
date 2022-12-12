//package ths.project;
//
//import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
//import com.baomidou.mybatisplus.core.toolkit.Wrappers;
//import org.apache.commons.lang.StringUtils;
//import org.junit.Assert;
//import org.junit.Test;
//import org.junit.runner.RunWith;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.test.context.ContextConfiguration;
//import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
//import org.springframework.test.context.web.WebAppConfiguration;
//import ths.jdp.core.dao.base.Paging;
//import ths.project.analysis.forecast.report.entity.GeneralReport;
//import ths.project.analysis.forecast.report.mapper.GeneralReportMapper;
//import ths.project.common.util.DateUtil;
//import ths.project.system.base.util.PageSelectUtil;
//
//import java.util.Date;
//
//@RunWith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration({"classpath:conf/spring.xml"})
//@WebAppConfiguration
//public class TestClass {
//
//    @Autowired
//    private GeneralReportMapper generalReportMapper;
//
//    @Test
//    public void testAdd() {
//        LambdaQueryWrapper<GeneralReport> queryWrapper = Wrappers.lambdaQuery(GeneralReport.class)
////				.eq(GeneralReport::getAscriptionType, ascriptionType)
////				.eq(StringUtils.isNotBlank(reportRate), GeneralReport::getReportRate, reportRate)
//                .ge(GeneralReport::getReportTime, DateUtil.addMonth(new Date(), -55))
//                .lt(GeneralReport::getReportTime, new Date())
//                .orderByAsc(GeneralReport::getCreateTime);
//        Paging<GeneralReport> pageInfo = PageSelectUtil.selectListPage1(generalReportMapper, new Paging<>(), GeneralReportMapper::selectList, queryWrapper);
//        System.err.println(pageInfo.getTotal());
//    }
//}
