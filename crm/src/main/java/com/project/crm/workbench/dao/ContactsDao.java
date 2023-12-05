package com.project.crm.workbench.dao;

import com.project.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsDao {

    int save(Contacts contacts);

//    List<Contacts> getFullName(String name);

    List<Contacts> getContactsByFullName(String name);

    String getIdByName(String contactsId);

    List<Contacts> getContactsByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    Contacts getContactById(String id);

    int update(Contacts con);

    int delete(List<String> deleteList);

}
