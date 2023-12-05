package com.project.crm.workbench.service.impl;

import com.project.crm.settings.dao.UserDao;
import com.project.crm.settings.domain.User;
import com.project.crm.utils.SqlSessionUtil;
import com.project.crm.vo.CustomerVO;
import com.project.crm.vo.PagenationVO;
import com.project.crm.workbench.dao.CustomerDao;
import com.project.crm.workbench.dao.CustomerRemarkDao;
import com.project.crm.workbench.domain.Customer;
import com.project.crm.workbench.domain.CustomerRemark;
import com.project.crm.workbench.service.CustomerService;
import com.sun.corba.se.impl.oa.toa.TOA;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ClassName: CustomerServiceImpl
 * Package: com.project.crm.workbench.service.impl
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/27 14:59
 * @Version 1.0
 */
public class CustomerServiceImpl implements CustomerService {

    CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);

    @Override
    public List<String> getCustomerName(String name) {
     List<String >  customerNameList = customerDao.getCustomerNameList(name);



        return customerNameList;
    }

    @Override
    public boolean save(Customer customer) {
        boolean isSave = false;
        int isSaveCount = customerDao.save(customer);

        if (isSaveCount > 0){
            isSave = true;
        }
        return isSave;
    }

    @Override
    public List<User> getUserList() {
        List<User> userList = userDao.getUserList();

        return userList;
    }

    @Override
    public boolean update(Customer customer) {
        boolean isUpdate = false;
        int isUpdateCount = customerDao.update(customer);
        if (isUpdateCount > 0){
            isUpdate = true;
        }
        return isUpdate;
    }

    @Override
    public Customer getCustomerById(String id) {

        Customer customer  = customerDao.getCustomerById(id);
        String owner = customer.getOwner();
        String userName = userDao.getUserNameById(owner);
        customer.setOwner(userName);
        return customer;
    }

    @Override
    public boolean deleteRemarkById(String id) {
        boolean isDelete = false;
        int isDeleteCount = customerRemarkDao.deleteRemarkById(id);
        if (isDeleteCount > 0){
            isDelete = true;
        }

        return isDelete;
    }

    @Override
    public boolean updateRemark(CustomerRemark customerRemark) {
        boolean isUpdateRemark = false;

        int updateCount =  customerRemarkDao.updateRemark(customerRemark);

        if (updateCount > 0){
            isUpdateRemark = true;
        }

        return isUpdateRemark;

    }

    @Override
    public int saveCustomerRemark(CustomerRemark customerRemark) {
        int isSaveRemarkcount =  customerRemarkDao.saveCustomerRemark(customerRemark);
        return isSaveRemarkcount;
    }

    @Override
    public List<CustomerRemark> getRemarkListByCustomerId(String customerId) {
       List<CustomerRemark> customerRemarks =  customerRemarkDao.getRemarkListByCustomerId(customerId);
        return customerRemarks;
    }

    @Override
    public boolean delete(List<String> deleteList) {
        boolean isDelete = false;
        int isDeleteCount = customerDao.delete(deleteList);
        if (isDeleteCount == deleteList.size()){

            isDelete = true;

        }
        return isDelete;
    }

    @Override
    public Map<String, Object> getUserListAndCutomerInfo(String id) {
        List<User> userList = getUserList();
        Customer customer = customerDao.getUserListAndCutomerInfo(id);
        Map<String ,Object> map = new HashMap<String, Object>();
        map.put("userList",userList);
        map.put("customerInfo",customer);
        return map;
    }

    @Override
    public CustomerVO<Customer> pageList(Map<String, Object> map) {
        //获取总的记录条数
        int  total = customerDao.getTotalByCondition(map);
        System.out.println("实现类的total_____________________________------" +total);
        //取得客户信息列表
         List<Customer> list = customerDao.getCustomerByCondition(map);
        System.out.println("实现类的list_____________________________------" +list);

         //封装到VO对象中
       CustomerVO<Customer> customerVO = new CustomerVO<Customer>();
       customerVO.setTotal(total);
       customerVO.setDataList(list);
        return customerVO;
    }
}
