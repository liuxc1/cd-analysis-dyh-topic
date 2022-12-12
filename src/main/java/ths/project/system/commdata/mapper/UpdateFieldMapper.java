package ths.project.system.commdata.mapper;

import java.util.List;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.system.commdata.entity.UpdateField;

/**
 * 数据修改-实体字段表-持久层
 * @author zl
 *
 */
public interface UpdateFieldMapper extends BaseMapper<UpdateField> {
	List<UpdateField> queryUpdateField(String entityCode);

}
