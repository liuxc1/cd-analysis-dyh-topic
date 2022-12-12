package ths.project.api.personnelManagement.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.jdp.core.datasource.annotation.ChangeDatasource;
import ths.project.api.personnelManagement.entity.PersonnelManagement;
import ths.project.api.personnelManagement.mapper.PersonnelManagementMapper;

import java.util.List;

@Service
public class PersonnelManagementService {

    @Autowired
    private PersonnelManagementMapper personnelManagementMapper;

    @ChangeDatasource("datasource_ou")
    public boolean batchSettingsPersonnelManagement(List<String> userIds) {
        try {
            List<PersonnelManagement> personnelManagements = personnelManagementMapper.selectBatchIds(userIds);
            if (personnelManagements.size() == 0) {
                userIds.forEach(con -> {
                    PersonnelManagement personnelManagement = new PersonnelManagement();
                    personnelManagement.setUserId(con);
                    personnelManagement.setIsMain(0);
                    personnelManagement.setDuty(1);
                    personnelManagementMapper.insert(personnelManagement);
                });
            } else {
                personnelManagements.forEach(con -> {
                    con.setDuty(1);
                    personnelManagementMapper.updateById(con);
                });
            }
        } catch (Exception e) {
            return false;
        }
        return true;
    }

    @ChangeDatasource("datasource_ou")
    public boolean updatePersonnelManagement(PersonnelManagement personnelManagement) {
        try {
            if (personnelManagement.getIsMain() == 1) {
                List<PersonnelManagement> personnelManagements = personnelManagementMapper.selectGroupByUserId(personnelManagement.getUserId());
                personnelManagements.forEach(con -> {
                    con.setIsMain(0);
                    personnelManagementMapper.updateById(con);
                });
            }
            PersonnelManagement personnelManagementOld = personnelManagementMapper.selectById(personnelManagement.getUserId());
            if (personnelManagementOld != null) {
                personnelManagementMapper.updateById(personnelManagement);
            } else {
                personnelManagementMapper.insert(personnelManagement);
            }
        } catch (Exception e) {
            return false;
        }
        return true;
    }
}
