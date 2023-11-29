package com.project.crm.settings.dao;

import com.project.crm.settings.domain.DicValue;

import java.util.List;

/**
 * ClassName: DicValueDao
 * Package: com.project.crm.settings.dao
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/26 23:43
 * @Version 1.0
 */
public interface DicValueDao {
    List<DicValue> getListByCode(String code);
}
