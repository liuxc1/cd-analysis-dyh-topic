package ths.project.system.commdata.mapper;

import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.system.commdata.entity.UpdateLog;
import ths.project.system.commdata.vo.UpdateLogVo;

/**
 * 数据修改-日志记录-持久层
 * @author zl
 *
 */
public interface UpdataLogMapper extends BaseMapper<UpdateLog>{
	List<UpdateLogVo> queryUpdateFieldCount(String ascriptionId);

	List<Map<String, Object>> queryAllTable();

	List<Map<String, Object>> queryAllField(Map<String, Object> paramMap);

}
