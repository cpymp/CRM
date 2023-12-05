package com.project.crm.workbench.dao;

import com.project.crm.workbench.domain.Clue;
import com.project.crm.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationDao {


    int bound(Map<String,Object> map);

    List<ClueActivityRelation> getclueActivityRelationListByClueId(String clueId);

    int delete(String id);
}
