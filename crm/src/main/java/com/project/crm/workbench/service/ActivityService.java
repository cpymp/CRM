package com.project.crm.workbench.service;

import com.project.crm.vo.PagenationVO;
import com.project.crm.workbench.domain.Activity;
import com.project.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ActivityService
 * Package: com.project.crm.workbench.service
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/22 12:29
 * @Version 1.0
 */
public interface ActivityService {


    boolean save(Activity activity);

    PagenationVO<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] deleteId);

    boolean edit(String editId);

    Map<String, Object> getUserListAndActivity(String id);

    boolean update(Activity activity);

    Activity detal(String id);

    List<ActivityRemark> getRemarkListByActivityId(String activityId);

    boolean deleteRemarkById(String deleteId);

    boolean saveRemark(ActivityRemark activityRemark);

    boolean updateRemark(ActivityRemark activityRemark);

    List<Activity> getActivityByClueId(String clueId);

    List<Activity> getActivityByNameAndNotBount(Map<String, String> map);

    List<Activity> getActivityByName(String activityName);
}
