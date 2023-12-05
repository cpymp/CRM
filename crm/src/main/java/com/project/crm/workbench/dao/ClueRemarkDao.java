package com.project.crm.workbench.dao;

import com.project.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getRemarkByClueId(String clueId);

    int deleteById(String id);
}
