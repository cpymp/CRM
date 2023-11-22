package com.project.crm.settings.service;

import com.project.crm.exception.LoginException;
import com.project.crm.settings.domain.User;

import java.util.List;

/**
 * ClassName: UserService
 * Package: com.project.crm.settings.service
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/20 23:09
 * @Version 1.0
 */
public interface UserService {
    List<User> getAll();

    User login(String loginAccount, String loginPassword, String loginIp) throws LoginException;

    List<User> getUserList();
}
