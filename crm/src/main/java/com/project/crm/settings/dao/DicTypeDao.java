package com.project.crm.settings.dao;

import com.project.crm.settings.domain.DicType;

import java.util.List;

/**
 * ClassName: DicTypeDao
 * Package: com.project.crm.settings.dao
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/26 23:43
 * @Version 1.0
 */
public interface DicTypeDao {
    List<DicType> getTypeList();
}
