package com.project.crm.workbench.dao;

import com.project.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ActivityDao
 * Package: com.project.crm.workbench.dao
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/22 12:26
 * @Version 1.0
 */
public interface ActivityDao {
    public int save(Activity activity);

    List<Activity> getActivityByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    int delete(String[] deleteId);

    Activity getById(String id);

    int update(Activity activity);

    Activity detail(String id);

    List<Activity> getActivityByClueId(String clueId);

    List<Activity> getActivityByNameAndNotBount(Map<String, String> map);

    List<Activity> getActivityByName(String activityName);
}
