package com.project.crm.workbench.dao;

import com.project.crm.workbench.domain.Clue;

import java.util.Map;

public interface ClueDao {


    int save(Clue clue);

    int getTotalByCondition(Map<String, Object> map);
}
