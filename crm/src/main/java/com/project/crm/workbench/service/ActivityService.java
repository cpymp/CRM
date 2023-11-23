package com.project.crm.workbench.service;

import com.project.crm.vo.PagenationVO;
import com.project.crm.workbench.domain.Activity;

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
}
