package ths.project.system.log.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ths.jdp.core.dao.base.Paging;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.system.base.util.BatchSqlSessionUtil;
import ths.project.system.base.util.PageSelectUtil;
import ths.project.system.log.entity.Log;
import ths.project.system.log.mapper.LogMapper;
import ths.project.system.log.vo.LogQueryVo;
import ths.project.system.log.vo.LogVo;

@Service
public class CmdLogService {

	@Autowired
	private LogMapper logMapper;

	/**
	 * 主键生成器
	 */
	@Autowired
	private SnowflakeIdGenerator idGenerator;

	public int saveLog(List<Log> logs) {
		for (int i = 0; i < logs.size(); i++) {
			logs.get(i).setLogId(idGenerator.getUniqueId());
		}
		return BatchSqlSessionUtil.insertBatch(logMapper, logs);
	}

	/**
	 * 获取默认时间
	 * 
	 * @param object
	 * @return
	 */
	public Map<String, Object> getDefaultTime(Object object) {
		return logMapper.getDefaultTime();
	}

	/**
	 * 获取指定时间内 各平台访问次数 响应状态次数
	 * @param logQueryVo
	 * @return
	 */
	public Map<String, List<Map<String, Object>>> getVisitStaList(LogQueryVo logQueryVo) {
		Map<String, List<Map<String, Object>>> map = new HashMap<>();
		// 各平台访问次数
		List<Map<String, Object>> echarts1 = logMapper.getVisitCount(logQueryVo);
		// 响应状态次数
		List<Map<String, Object>> echarts2 = logMapper.getStatusCount(logQueryVo);
		// 各个用户登录次数统计
		List<Map<String, Object>> echarts3 = logMapper.getUserCountList(logQueryVo);
		map.put("echarts1", echarts1);
		map.put("echarts2", echarts2);
		map.put("echarts3", echarts3);
		return map;
	}

	/**
	 * 获取系统访问日志列表
	 * @param logQueryVo 查询条件
	 * @param paging 分页信息
	 * @return
	 */
	public Paging<LogVo> getVisitLogList(LogQueryVo logQueryVo, Paging<LogVo> paging) {
		return PageSelectUtil.selectListPage1(logMapper, paging, LogMapper::getVisitLogList, logQueryVo);
	}

}
