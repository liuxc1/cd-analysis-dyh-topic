package ths.project.api.personnelManagement.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.api.personnelManagement.entity.PersonnelManagement;
import ths.project.api.personnelManagement.service.PersonnelManagementService;
import ths.project.common.data.DataResult;
import java.util.Arrays;


@RequestMapping("/api/personnelManagement")
@Controller
public class PersonnelManagementController {

    @Autowired
    private PersonnelManagementService personnelManagementService;

    /**
     * 批量修改
     * @Param userIds 用户id，进行批量修改
     * @return
     */
    @RequestMapping("/batchSettingsPersonnelManagement")
    @ResponseBody
    public DataResult batchSettingsPersonnelManagement(@RequestParam String userIds) {
        boolean flag = personnelManagementService.batchSettingsPersonnelManagement(Arrays.asList(userIds.split(",")));
        if (flag) {
            return DataResult.success();
        } else {
            return DataResult.failure();
        }
    }


    /**
     *  修改
     */

    @RequestMapping("/updatePersonnelManagement")
    @ResponseBody
    public DataResult updatePersonnelManagement(@RequestParam String userId ,@RequestParam Integer isMain,@RequestParam Integer duty) {
        PersonnelManagement personnelManagement = new PersonnelManagement(userId,isMain,duty);
        boolean flag = personnelManagementService.updatePersonnelManagement(personnelManagement);
        if (flag) {
            return DataResult.success();
        } else {
            return DataResult.failure();
        }
    }
}
