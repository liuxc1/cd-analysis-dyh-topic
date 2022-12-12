package ths.project.api.personnelManagement.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.api.personnelManagement.entity.PersonnelManagement;

import java.util.List;

public interface PersonnelManagementMapper extends BaseMapper<PersonnelManagement> {

    List<PersonnelManagement> selectGroupByUserId(String userId);

}

