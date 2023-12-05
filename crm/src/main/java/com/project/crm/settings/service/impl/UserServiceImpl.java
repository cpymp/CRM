package com.project.crm.settings.service.impl;

import com.project.crm.exception.LoginException;
import com.project.crm.settings.dao.UserDao;
import com.project.crm.settings.domain.User;
import com.project.crm.settings.service.UserService;
import com.project.crm.utils.DateTimeUtil;
import com.project.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ClassName: UserServiceImpl
 * Package: com.project.crm.settings.service.impl
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/20 23:09
 * @Version 1.0
 */
public class UserServiceImpl implements UserService {
    UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    public List<User> getAll() {
        List<User> list = userDao.getAll();
        return  list;
    }
    //springMVC可以帮忙写控制器 但是业务层不能使用框架写
    public User login(String loginAccount, String loginPassword, String loginIp) throws LoginException {
        //将接受的账号密码存入map ，传给dao层进行判断
        Map<String ,String > map = new HashMap<String, String>();
        map.put("loginAccount",loginAccount);
        map.put("loginPassword",loginPassword);
        User user = userDao.login(map);

        if (user == null){
            //抛出异常  或者抛出 1代表账户免密错误  2代表账号失效 但是不推荐
            throw new LoginException("账号密码错误");
        }

        //如果成功执行到该处，说明账号密码正确，需要验证其他信息
        String expireTime = user.getExpireTime(); //账号的失效时间
        System.out.println(expireTime+"---------------------------------------");
        String currentTime = DateTimeUtil.getSysTime();//当前系统时间 yyyy-MM-dd HH-mm-ss格式
        if (expireTime.compareTo(currentTime) <0){ //比较时间，大于则正数，小于则负数
            throw new LoginException("账号已失效");
        }

        //判断账号是否被锁定
        String lockState = user.getLockState();
        if ("0".equals(lockState)){
            throw new LoginException("账号已锁定。");
        }



        //判断ip地址
        String allowIps = user.getAllowIps();

//        if (allowIps != null && allowIps != "") 不需要判断ip的的情况下
        if (!allowIps.contains(loginIp)){
            throw new LoginException("ip地址受限");
        }

        return user;
    }

    @Override
    public List<User> getUserList() {
        List<User> userList = userDao.getUserList();

        return userList;
    }

    @Override
    public Map<String, Object> pageList(Map<String, Object> map) {
        Map<String, Object> rMap = new HashMap<String, Object>();
        List<User> userList = userDao.getUserByCondition(map);
        int total =  userDao.getTotalByCondition(map);
        rMap.put("userList",userList);
        rMap.put("total",total);
        return rMap;
    }

    @Override
    public boolean save(User user) {
        boolean isSave = false;
        int count = userDao.save(user);
        if (count > 0 ){
            isSave = true;
        }
        return isSave;
    }

    @Override
    public User getUserById(String id) {
        User user = userDao.getUserById(id);
        return user;
    }

    @Override
    public boolean deleteById(String[] deleteIds) {
        boolean isDelete = false;
        int count = userDao.deleteById(deleteIds);
        if (count == deleteIds.length){
            isDelete = true;
        }
        return isDelete;
    }

    @Override
    public boolean isRepeat(String loginActNo) {
        boolean isRepeat = true;
        int count = userDao.repeat(loginActNo);
        if (count > 0 ){
            isRepeat = false;
        }
        return isRepeat;
    }
}

