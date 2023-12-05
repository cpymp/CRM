package com.project.crm.workbench.dao;

import com.project.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran tran);

    List<Tran> pageList(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    Tran getTranById(String id);

    int update(Tran tran);

    int delete(String[] deleteArr);

    int changeStage(Tran tran);

    int getTotal();

    List<Map<String, Object>> getDataList();
}
