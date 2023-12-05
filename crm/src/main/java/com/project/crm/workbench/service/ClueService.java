package com.project.crm.workbench.service;

import com.project.crm.workbench.domain.Activity;
import com.project.crm.workbench.domain.Clue;
import com.project.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ClueService
 * Package: com.project.crm.workbench.service
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/26 22:48
 * @Version 1.0
 */
public interface ClueService {

    boolean save(Clue clue);

    Map<String, Object> pageList(Map<String, Object> map);

    Map<String ,Object> getUserListAndClue(String id);

    boolean update(Clue clue);

    boolean delete(String[] deleteIds);

    Clue getClueById(String id);

    boolean unBound(String carId);

    boolean bound(Map<String, Object> map);

    boolean convert(String id, String createBy, Tran t);

//    List<Activity> getActivityByNameAndNotBount(Map<String, String> map);

}
