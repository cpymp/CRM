package com.project.crm.workbench.service;

import com.project.crm.workbench.domain.Clue;

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
}
