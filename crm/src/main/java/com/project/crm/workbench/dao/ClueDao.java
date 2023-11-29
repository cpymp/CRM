package com.project.crm.workbench.dao;

import com.project.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int save(Clue clue);

    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueByCOndition(Map<String, Object> map);

    Clue getClueById(String id);

    int update(Clue clue);

    int delete(String[] deleteIds);

    Clue getClueByIdForDetail(String id);
}
