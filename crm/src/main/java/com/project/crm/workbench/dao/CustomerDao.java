package com.project.crm.workbench.dao;

import com.project.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

    int getTotalByCondition(Map<String, Object> map);

    List<Customer> getCustomerByCondition(Map<String, Object> map);

    int save(Customer customer);

    Customer getUserListAndCutomerInfo(String id);

    int update(Customer customer);

    int delete(List<String> deleteList);

    Customer getCustomerById(String id);

    Customer getCustomerByName(String company);

    List<String> getCustomerNameList(String name);

    Customer getCustomerByNamePrecise(String customerName);

    String getIdByName(String contactsId);
}
