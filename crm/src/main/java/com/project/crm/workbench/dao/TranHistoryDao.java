package com.project.crm.workbench.dao;

import com.project.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int save(TranHistory tranHistory);

    List<TranHistory> getHistoryByTranId(String tranId);

    int deleteByTranId(String[] deleteArr);
}
