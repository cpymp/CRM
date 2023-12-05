package com.project.crm.workbench.service;

import com.project.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

/**
 * ClassName: ContactsService
 * Package: com.project.crm.workbench.service
 * Description:
 *
 * @Author cpymp
 * @Create 2023/12/2 13:56
 * @Version 1.0
 */
public interface ContactsService {

    List<Contacts> getContactsByFullName(String name);

    Map<String, Object> pageList(Map<String, Object> map);

    boolean save(Contacts contacts);

    Contacts getContactById(String id);

    boolean update(Contacts con);

    boolean delete(List<String> deleteList);

}
