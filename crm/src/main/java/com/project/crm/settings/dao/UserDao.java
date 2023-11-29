package com.project.crm.settings.dao;

import com.project.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

/**
 * ClassName: StudentDao
 * Package: com.project.crm.settings.dao
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/20 23:05
 * @Version 1.0
 */
public interface UserDao {

    List getAll();


    User login(Map<String, String> map);

    List<User> getUserList();

    String getUserNameById(String owner);
}
