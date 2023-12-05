package com.project.crm.workbench.service;

import com.project.crm.workbench.domain.Tran;
import com.project.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

/**
 * ClassName: TranService
 * Package: com.project.crm.workbench.service
 * Description:
 *
 * @Author cpymp
 * @Create 2023/12/1 23:55
 * @Version 1.0
 */
public interface TranService {
    boolean save(Tran tran, String customerName);

    Map<String,Object> pageList(Map<String, Object> map);

    Tran getTranById(String id);

    List<TranHistory> getTranHistoryByTranId(String tranId);

    boolean update(Tran tran);

    boolean deleteById(String[] deleteArr);

    boolean changeStage(Tran tran);

    Map<String, Object> getChars();


}
