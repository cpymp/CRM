package com.project.crm.workbench.dao;

import com.project.crm.workbench.domain.ActivityRemark;
import com.project.crm.workbench.service.ActivityService;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ActivityRemarkDao
 * Package: com.project.crm.workbench.dao
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/22 13:36
 * @Version 1.0
 */
public interface ActivityRemarkDao {

    int getCountByDeleteId(String[] deleteId);

    int deleteByDeleteId(String[] deleteId);

    List<ActivityRemark> getRemarkListByActivityId(String activityId);

    int deleteById(String deleteId);

   int saveRemark(ActivityRemark activityRemark);

    int updateRemark(ActivityRemark activityRemark);
}
