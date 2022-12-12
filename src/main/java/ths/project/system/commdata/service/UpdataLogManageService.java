package ths.project.system.commdata.service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;

import ths.jdp.core.dao.base.Paging;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.system.base.util.BatchSqlSessionUtil;
import ths.project.system.base.util.PageSelectUtil;
import ths.project.system.commdata.entity.UpdateEntity;
import ths.project.system.commdata.entity.UpdateField;
import ths.project.system.commdata.entity.UpdateLog;
import ths.project.system.commdata.mapper.UpdataLogMapper;
import ths.project.system.commdata.mapper.UpdateEntityMapper;
import ths.project.system.commdata.mapper.UpdateFieldMapper;
import ths.project.system.commdata.vo.UpdateLogVo;

/**
 * 数据修改记录-服务层
 * 
 * @author zl
 *
 */
@Service
public class UpdataLogManageService {

	/**
	 * 数据修改记录-持久层
	 */
	@Autowired
	private UpdataLogMapper updataLogMapper;
	/**
	 * 数据修改-实体配置表-持久层
	 */
	@Autowired
	private UpdateEntityMapper updateEntityMapper;
	/**
	 * 数据修改-实体字段表-持久层
	 */
	@Autowired
	private UpdateFieldMapper updateFieldMapper;
	/**
	 * 主键生成器
	 */
	@Autowired
	private SnowflakeIdGenerator idGenerator;

	/**
	 * 
	 * @param differList
	 * @param userName
	 * @return
	 */
	@Transactional
	public int insertDataUpdateLog(List<UpdateLog> differList, String ascriptionId, String userName,
			String updateTable) {
		// 根据实体编码查询数据修改-实体字段表
		int m = 0;
		if (CollectionUtils.isNotEmpty(differList)) {
			for (int i = 0; i < differList.size(); i++) {
				differList.get(i).setLogId(idGenerator.getUniqueId());
				differList.get(i).setAscriptionId(ascriptionId);
				differList.get(i).setUpdateTable(updateTable);
				differList.get(i).resolveUpdate(userName);
			}
			m = BatchSqlSessionUtil.insertBatch(updataLogMapper, differList);
		}
		return m;
	}

	/**
	 * 查询修改过的字段
	 * 
	 * @param ascriptionId
	 * @return
	 */
	public Map<String, Integer> queryUpdateFieldCount(String ascriptionId) {
		List<UpdateLogVo> differList = updataLogMapper.queryUpdateFieldCount(ascriptionId);
		Map<String, Integer> map = differList.stream()
				.collect(Collectors.toMap(UpdateLogVo::getUpdateField, UpdateLogVo::getUpdateNum));
		return map;
	}

	/**
	 * 查询数据修改记录列表
	 * 
	 * @param updateLog
	 * @return
	 */
	public Paging<UpdateLog> queryDataUpdateLogList(UpdateLog updateLog, Paging<UpdateLog> pageInfo) {
		LambdaQueryWrapper<UpdateLog> wrapper = Wrappers.lambdaQuery(updateLog);
		wrapper.orderByDesc(UpdateLog::getUpdateTime);
		return PageSelectUtil.selectListPage(updataLogMapper, pageInfo, wrapper);
	}

	/**
	 * 查询数据修改记录列表
	 * 
	 * @param updateLog
	 * @param pageInfo
	 * @return
	 */
	public List<UpdateLog> queryDataUpdateLogList(UpdateLog updateLog) {
		LambdaQueryWrapper<UpdateLog> wrapper = Wrappers.lambdaQuery(updateLog);
		wrapper.orderByDesc(UpdateLog::getUpdateTime);
		return updataLogMapper.selectList(wrapper);
	}

	/**
	 * 查询dbo下的系统表
	 * 
	 * @return
	 */
	public List<Map<String, Object>> queryAllTable() {
		return updataLogMapper.queryAllTable();
	}

	/**
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<Map<String, Object>> queryAllField(Map<String, Object> paramMap) {
		return updataLogMapper.queryAllField(paramMap);
	}

	/**
	 * 
	 * @param updateEntityVo
	 * @param updateFieldList
	 * @return
	 */
	@Transactional
	public int saveEntityAndFieldInfo(UpdateEntity updateEntity, List<UpdateField> updateFieldList, String userName) {
		int i = 0;
		String entityId = "";
		// 查询数据库中是否存在改实体的信息
		String entityCode = updateEntity.getEntityCode();
		LambdaQueryWrapper<UpdateEntity> wrapper = Wrappers.lambdaQuery();
		wrapper.eq(UpdateEntity::getEntityCode, entityCode);
		UpdateEntity updateEntityOld = updateEntityMapper.selectOne(wrapper);
		if (updateEntityOld != null) {
			// 修改
			entityId = updateEntityOld.getEntityId();
			updateEntity.resolveUpdate(userName);
			LambdaUpdateWrapper<UpdateEntity> updateWrapper = Wrappers.lambdaUpdate();
			updateWrapper.eq(UpdateEntity::getEntityId, entityId);
			i = updateEntityMapper.update(updateEntity, updateWrapper);
			// 删除旧的字段配置信息
			LambdaQueryWrapper<UpdateField> deWrapper = Wrappers.lambdaQuery();
			deWrapper.eq(UpdateField::getEntityId, entityId);
			updateFieldMapper.delete(deWrapper);
		} else {
			// 新增
			entityId = idGenerator.getUniqueId();
			updateEntity.setEntityId(entityId);
			updateEntity.resolveCreate(userName);
			i = updateEntityMapper.insert(updateEntity);
		}
		for (int j = 0; j < updateFieldList.size(); j++) {
			updateFieldList.get(j).setFieldId(idGenerator.getUniqueId());
			updateFieldList.get(j).setEntityId(entityId);
			updateFieldList.get(j).setSort(j);
			updateFieldList.get(j).resolveCreate(userName);
		}
		if (CollectionUtils.isNotEmpty(updateFieldList)) {
			BatchSqlSessionUtil.insertBatch(updateFieldMapper, updateFieldList);
		}
		return i;
	}
	
	public List<UpdateField> queryUpdateField(String entityCode){
		
		return updateFieldMapper.queryUpdateField(entityCode);
	}
}
