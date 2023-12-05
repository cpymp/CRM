package com.project.crm.workbench.service;

import com.project.crm.settings.domain.User;
import com.project.crm.vo.CustomerVO;
import com.project.crm.workbench.domain.Customer;
import com.project.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

/**
 * ClassName: CustomerService
 * Package: com.project.crm.workbench.service.impl
 * Description:
 *
 * @Author cpymp
 * @Create 2023/11/27 14:58
 * @Version 1.0
 */
public interface CustomerService {
    CustomerVO<Customer> pageList(Map<String, Object> map);

    List<User> getUserList();

    boolean save(Customer customer);

    Map<String, Object> getUserListAndCutomerInfo(String id);

    boolean update(Customer customer);

    boolean delete(List<String> deleteList);

    Customer getCustomerById(String id);

    List<CustomerRemark> getRemarkListByCustomerId(String customerId);

    int saveCustomerRemark(CustomerRemark customerRemark);

    boolean updateRemark(CustomerRemark customerRemark);

    boolean deleteRemarkById(String id);

    List<String> getCustomerName(String name);
}
